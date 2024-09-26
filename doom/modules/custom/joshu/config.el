;;; custom/joshu/config.el -*- lexical-binding: t; -*-

;;; Code:

(require 'request)
(require 'auth-source)

(defvar joshu-chat-buffer-name "*Joshu*"
  "Name of the Copilot chat buffer.")

(defvar joshu-input-buffer-name "*Joshu Input*"
  "Name of the Copilot chat input buffer.")

(defvar joshu-window-width 50
  "Width of the Copilot chat sidebar.")

(defvar joshu-message-window-height 8
  "Height of the Copilot chat input window.")

(defun joshu-mode-setup ()
  "Disable line numbers."
  (display-line-numbers-mode -1))

(define-derived-mode joshu-mode markdown-mode "Joshu"
  "Major mode for the Joshu chat buffer."
  (add-hook 'joshu-mode-hook 'joshu-mode-setup))

;; To store the OpenAI API key to keychain, run the following command:
;; security add-internet-password -s api.openai.com -a apikey -w YOUR_API_KEY -l "OpenAI API Key"
(defun joshu-get-api-key ()
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

(defun joshu-create-or-select-window (buffer-name slot content &optional read-only)
  "Create or select a window for BUFFER-NAME.
SLOT specifies the position of the window.
CONTENT is the initial content to insert into the buffer.
If READ-ONLY is non-nil, the buffer will be read-only."
  (let* ((buffer (get-buffer-create buffer-name))
         (window (get-buffer-window buffer)))

    ;; Set up buffer content if it's empty
    (with-current-buffer buffer
      (unless (eq major-mode 'joshu-mode)
        (joshu-mode)
        (erase-buffer)
        (insert content)
        (read-only-mode (if read-only 1 0)))
      (setq indicate-empty-lines nil)
      (setq indicate-unused-lines nil))

    ;; Display or create the window
    (unless (and window (window-live-p window))
      (setq window (display-buffer-in-side-window
                    buffer
                    `((side . right)
                      (slot . ,slot)
                      (window-resizable . t)
                      (window-width . ,joshu-window-width))))
      ;; The window cannot be selected by commands that select other windows.
      (set-window-parameter window 'no-other-window t)
      ;; The window cannot be deleted by commands that delete other windows.
      (set-window-parameter window 'no-delete-other-windows t)
      ;; The window can be resized from the side.
      (set-window-parameter window 'window-side-resize t)
      (set-window-dedicated-p window t)
      (select-window window))))

(defun joshu-create-chat-window ()
  "Create a sidebar window on right for chat history."
  (interactive)
  (let ((current-time (format-time-string "%Y-%m-%d %H:%M:%S")))
    (joshu-create-or-select-window
     joshu-chat-buffer-name
     0
     (format "# Chat %s\n\n" current-time)
     t)))

(defun joshu-create-message-window ()
  "Create a writable input window below the chat history window."
  (interactive)
  ;; create the input window with a writable buffer
  (joshu-create-or-select-window
   joshu-input-buffer-name
   1
   "")
  ;; set the major mode and key bindings for the input buffer
  (with-current-buffer joshu-input-buffer-name
    ;; user can use key bindings to send the message
    (local-set-key (kbd "C-c C-c") #'joshu-create-completion))
  ;; set the window height
  (let ((message-window (get-buffer-window joshu-input-buffer-name)))
    (with-selected-window message-window
      (window-resize nil (- 8 (window-height)) nil))))


(defun joshu-kill-window (buffer-name)
  "Kill the window displaying the buffer with the given BUFFER-NAME."
  (let ((window (get-buffer-window buffer-name)))
    (when window
      (delete-window window))))

(defun joshu-kill-windows ()
  "Kill both the chat and input windows."
  (interactive)
  (joshu-kill-window joshu-chat-buffer-name)
  (joshu-kill-window joshu-input-buffer-name))

(defun joshu-create-windows ()
  "Create both the chat and input windows."
  (interactive)
  (joshu-create-chat-window)
  (joshu-create-message-window))

(defun joshu-send-message ()
  "Send the message from the input buffer to the chat buffer."
  (interactive)
  (let ((input-buffer (get-buffer joshu-input-buffer-name))
        (chat-buffer (get-buffer joshu-chat-buffer-name)))
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


(defun joshu-toggle ()
  "Toggle the Copilot chat sidebar."
  (interactive)
  (let ((chat-window (get-buffer-window joshu-chat-buffer-name))
        (message-window (get-buffer-window joshu-input-buffer-name)))

    (if (or chat-window message-window)
        (progn
          (when chat-window (delete-window chat-window))
          (when message-window (delete-window message-window)))
      (progn (joshu-create-chat-window)
             (joshu-create-message-window)))))

(defun joshu-append-message (message)
  "Append a message to the chat buffer."
  (let ((chat-buffer (get-buffer joshu-chat-buffer-name)))
    (when chat-buffer
      (with-current-buffer chat-buffer
        (let ((inhibit-read-only t))
          (save-excursion
            (goto-char (point-max))
            (insert message)))
        (goto-char (point-max))))))


(defun joshu-send-to-api (message)
  "Send MESSAGE to the ChatGPT API asynchronously."
  (let ((api-url "https://api.openai.com/v1/chat/completions")
        (api-key (joshu-get-api-key)))
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
                  (joshu-openai-stream-callback data)))
      :error (cl-function
              (lambda (&key error-thrown &allow-other-keys)
                (message "Copilot Chat API Error: %S" error-thrown)))
      :sync nil)))


(defun joshu-openai-stream-callback (data)
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
             (joshu-finalize-stream)
             (goto-char (point-max)))
            (t
             (joshu-process-content-line line)))))))))


(defun joshu-process-content-line (line)
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
          (joshu-append-message content)
          (sit-for 0.01))))))


(defun joshu-stream-ended-p ()
  "Check if the last processed line indicates the end of the stream."
  (save-excursion
    (forward-line -1)
    (looking-at "^data: \\[DONE\\]")))


(defun joshu-finalize-stream ()
  "Perform final actions after the stream has ended."
  (joshu-append-message "\n\n")
  (message "Stream ended"))


(defun joshu-get-input-content ()
  "Get the plain text content from the input buffer."
  (let ((input-buffer (get-buffer joshu-input-buffer-name)))
    (when input-buffer
      (with-current-buffer input-buffer
        (buffer-substring-no-properties (point-min) (point-max))))))


(defun joshu-create-completion ()
  "Create a completion for the user's input."
  (interactive)
  (let ((user-message (joshu-get-input-content)))
    (when user-message
      ;; Append user's message to chat buffer
      (joshu-append-message "## You\n\n")
      (joshu-append-message user-message)
      (joshu-append-message "\n\n")
      ;; Append the start of the AI's response to the chat buffer
      (joshu-append-message "## Assistant\n\n")
      ;; Clear the input buffer
      (with-current-buffer (get-buffer joshu-input-buffer-name)
        (erase-buffer))
      ;; Send the user's message to the API
      (joshu-send-to-api user-message))))

(provide 'joshu)

;;; config.el ends here
