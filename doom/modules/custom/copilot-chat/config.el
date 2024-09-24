;;; custom/copilot-chat/config.el -*- lexical-binding: t; -*-

;;; Code:

(require 'org)
(require 'request)
(require 'auth-source)

(defvar copilot-chat-buffer-name "*Copilot Chat*"
  "Name of the Copilot chat buffer.")

(defvar copilot-chat-input-buffer-name "*Copilot Chat Input*"
  "Name of the Copilot chat input buffer.")

(defvar copilot-chat-window-width 50
  "Width of the Copilot chat sidebar.")

(defvar copilot-chat-input-window-height 8
  "Height of the Copilot chat input window.")

;; To store the OpenAI API key to keychain, run the following command:
;; security add-internet-password -s api.openai.com -a apikey -w YOUR_API_KEY -l "OpenAI API Key"
(defun copilot-chat-get-api-key ()
  "Retrieve the OpenAI API key from the authinfo file."
  (let* ((auth-info (car (auth-source-search
                          :host "api.openai.com"
                          :user "apikey"
                          :require '(:secret))))
         (secret (plist-get auth-info :secret)))
    (if auth-info
        (if (functionp secret)
            (funcall secret)
          secret)
      (error "OpenAI API key not found in authinfo file"))))

(defun copilot-chat-create-or-select-window (buffer-name slot content &optional read-only)
  "Create or select a window for BUFFER-NAME.
SLOT specifies the position of the window.
CONTENT is the initial content to insert into the buffer.
If READ-ONLY is non-nil, the buffer will be read-only."
  (let* ((buffer (get-buffer-create buffer-name))
         (window (get-buffer-window buffer)))

    ;; Set up buffer content if it's empty
    (with-current-buffer buffer
      (unless (eq major-mode 'org-mode)
        (org-mode)
        (erase-buffer)
        (insert content)
        (read-only-mode (if read-only 1 0))))

    ;; Display or create the window
    (unless (and window (window-live-p window))
      (setq window (display-buffer-in-side-window
                    buffer
                    `((side . right)
                      (slot . ,slot)
                      (window-resizable . t)
                      (window-width . ,copilot-chat-window-width))))
      (select-window window))))

(defun copilot-chat-create-chat-window ()
  "Create a sidebar window on right for chat history."
  (interactive)
  (let ((current-time (format-time-string "%Y-%m-%d %H:%M:%S")))
    (copilot-chat-create-or-select-window
     copilot-chat-buffer-name
     0
     (format "* Chat %s\n\n" current-time)
     t)))

(defun copilot-chat-create-input-window ()
  "Create a writable input window below the chat history window."
  (interactive)
  ;; create the input window with a writable buffer
  (copilot-chat-create-or-select-window
   copilot-chat-input-buffer-name
   1
   "")
  ;; set the major mode and key bindings for the input buffer
  (with-current-buffer copilot-chat-input-buffer-name
    (setq-local major-mode 'copilot-chat-input-mode)
    (use-local-map (copy-keymap org-mode-map))
    (local-set-key (kbd "C-c C-c") #'copilot-chat-create-completion))
  ;; set the window height
  (let ((input-window (get-buffer-window copilot-chat-input-buffer-name)))
    (with-selected-window input-window
      (window-resize nil (- 8 (window-height)) nil))))


(defun copilot-chat-kill-window (buffer-name)
  "Kill the window displaying the buffer with the given BUFFER-NAME."
  (let ((window (get-buffer-window buffer-name)))
    (when window
      (delete-window window))))

(defun copilot-chat-kill-chat-window ()
  "Kill the chat window if it exists."
  (copilot-chat-kill-window copilot-chat-buffer-name))

(defun copilot-chat-kill-input-window ()
  "Kill the input window if it exists."
  (copilot-chat-kill-window copilot-chat-input-buffer-name))

(defun copilot-chat-kill-windows ()
  "Kill both the chat and input windows."
  (interactive)
  (copilot-chat-kill-chat-window)
  (copilot-chat-kill-input-window))

(defun copilot-chat-create-windows ()
  "Create both the chat and input windows."
  (interactive)
  (copilot-chat-create-chat-window)
  (copilot-chat-create-input-window))

(defun copilot-chat-send-message ()
  "Send the message from the input buffer to the chat buffer."
  (interactive)
  (let ((input-buffer (get-buffer copilot-chat-input-buffer-name))
        (chat-buffer (get-buffer copilot-chat-buffer-name)))
    (when (and input-buffer chat-buffer)
      (with-current-buffer input-buffer
        (let ((message (buffer-string)))
          (with-current-buffer chat-buffer
            (let ((inhibit-read-only t))
              (goto-char (point-max))
              (insert message "\n")
              (goto-char (point-max)))))
        (with-current-buffer input-buffer
          (erase-buffer))))))


(defun copilot-chat-toggle ()
  "Toggle the Copilot chat sidebar."
  (interactive)
  (let ((chat-window (get-buffer-window copilot-chat-buffer-name))
        (input-window (get-buffer-window copilot-chat-input-buffer-name)))

    (if (or chat-window input-window)
        (progn
          (when chat-window (delete-window chat-window))
          (when input-window (delete-window input-window)))
      (progn (copilot-chat-create-chat-window)
             (copilot-chat-create-input-window)))))

(defun copilot-chat-append-message (message)
  "Append a message to the chat buffer."
  (let ((chat-buffer (get-buffer copilot-chat-buffer-name)))
    (when chat-buffer
      (with-current-buffer chat-buffer
        (let ((inhibit-read-only t))
          (save-excursion
            (goto-char (point-max))
            (insert message)))
        (goto-char (point-max))))))


(defun copilot-chat-send-to-api (message)
  "Send MESSAGE to the ChatGPT API asynchronously."
  (let ((api-url "https://api.openai.com/v1/chat/completions")
        (api-key (copilot-chat-get-api-key)))
    (request api-url
      :type "POST"
      :headers `(("Authorization" . ,(concat "Bearer " api-key))
                 ("Content-Type" . "application/json"))
      :data (json-encode `(("model" . "gpt-4o-mini")
                           ("messages" . [((role . "system") (content . "You are a helpful AI assistant."))
                                          ((role . "user") (content . ,message))])
                           ("stream" . t)))
      :parser 'buffer-string
      :success (cl-function
                (lambda (&key data &allow-other-keys)
                  (copilot-chat-openai-stream-callback data)))
      :error (cl-function
              (lambda (&key error-thrown &allow-other-keys)
                (message "Copilot Chat API Error: %S" error-thrown)))
      :sync nil)))


(defun copilot-chat-openai-stream-callback (data)
  "Process the streamed data from OpenAI API and extract content."
  (run-with-timer
   0 nil
   (lambda ()
     (with-temp-buffer
       (insert data)
       (goto-char (point-min))
       (while (re-search-forward "^data: " nil t)
         (let ((line (buffer-substring-no-properties (point) (line-end-position))))
           (cond
            ((string= line "[DONE]")
             (copilot-chat-finalize-stream)
             (goto-char (point-max)))
            (t
             (copilot-chat-process-content-line line)))))))))


(defun copilot-chat-process-content-line (line)
  "Process a single line of content from the stream."
  (let* ((json-object-type 'hash-table)
         (json-array-type 'list)
         (json-key-type 'string)
         (parsed (condition-case nil
                     (json-read-from-string line)
                   (error nil))))
    (when parsed
      (let* ((choices (gethash "choices" parsed))
             (delta (and choices (gethash "delta" (car choices))))
             (content (and delta (gethash "content" delta))))
        (when content
          (copilot-chat-append-message content)
          (sit-for 0.01))))))


(defun copilot-chat-stream-ended-p ()
  "Check if the last processed line indicates the end of the stream."
  (save-excursion
    (forward-line -1)
    (looking-at "^data: \\[DONE\\]")))

(defun copilot-chat-process-content-line (line)
  "Process a single line of content from the stream."
  (let* ((json-object-type 'hash-table)
         (json-array-type 'list)
         (json-key-type 'string)
         (parsed (condition-case nil
                     (json-read-from-string line)
                   (error nil))))
    (when parsed
      (let* ((choices (gethash "choices" parsed))
             (delta (and choices (gethash "delta" (car choices))))
             (content (and delta (gethash "content" delta))))
        (when content
          (copilot-chat-append-message content)
          (sit-for 0.01))))))


(defun copilot-chat-finalize-stream ()
  "Perform final actions after the stream has ended."
  (copilot-chat-append-message "\n\n")
  (message "Stream ended"))


(defun copilot-chat-get-input-content ()
  "Get the plain text content from the input buffer."
  (let ((input-buffer (get-buffer copilot-chat-input-buffer-name)))
    (when input-buffer
      (with-current-buffer input-buffer
        (buffer-substring-no-properties (point-min) (point-max))))))


(defun copilot-chat-create-completion ()
  "Create a completion for the user's input."
  (interactive)
  (let ((user-message (copilot-chat-get-input-content)))
    (when user-message
      ;; Append user's message to chat buffer
      (copilot-chat-append-message "** You\n\n")
      (copilot-chat-append-message user-message)
      (copilot-chat-append-message "\n\n")
      ;; Append the start of the AI's response to the chat buffer
      (copilot-chat-append-message "** Assistant\n\n")
      ;; Clear the input buffer
      (with-current-buffer (get-buffer copilot-chat-input-buffer-name)
        (erase-buffer))
      ;; Send the user's message to the API
      (copilot-chat-send-to-api user-message))))

(provide 'copilot-chat)

;;; config.el ends here
