;;; custom/copilot-chat/config.el -*- lexical-binding: t; -*-

;;; Code:

(require 'org)
(require 'openai)
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
(defun get-openai-api-key ()
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
  (let ((chat-buffer (get-buffer copilot-chat-buffer-name))
        (input-buffer (get-buffer copilot-chat-input-buffer-name))
        (chat-window (get-buffer-window copilot-chat-buffer-name))
        (input-window (get-buffer-window copilot-chat-input-buffer-name)))

    (if (or chat-window input-window)
        (progn
          (when chat-window (delete-window chat-window))
          (when input-window (delete-window input-window)))
      (progn (copilot-chat-create-chat-window)
             (copilot-chat-create-input-window)))))

(defun copilot-chat-append-message (role message)
  "Append a message with ROLE to the chat buffer."
  (let ((chat-buffer (get-buffer copilot-chat-buffer-name)))
    (when chat-buffer
      (with-current-buffer chat-buffer
        (let ((inhibit-read-only t))
          (goto-char (point-max))
          (insert (format "%s: %s\n" role message))
          (goto-char (point-max)))))))

(defun copilot-chat-send-to-api (message)
  "Send MESSAGE to the ChatGPT API and return the response."
  (let ((api-url "https://api.openai.com/v1/chat/completions")
        (api-key (get-openai-api-key))
        (response ""))
    (request api-url
      :type "POST"
      :headers `(("Authorization" . ,(concat "Bearer " api-key))
                 ("Content-Type" . "application/json"))
      :data (json-encode `(("model" . "gpt-4o-mini")
                           ("messages" . [((role . "system") (content . "You are a helpful AI assistant."))])
                           ("messages" . [((role . "user") (content . ,message))])
                           ("max_tokens" . 150)))
      :parser 'json-read
      :success (cl-function
                (lambda (&key data &allow-other-keys)
                  (message "Raw API Response: %S" data)
                  (setq response (alist-get 'content (alist-get 'message (aref (alist-get 'choices data) 0))))
                  (message "Copilot Chat Response: %s" response)))
      :error (cl-function
              (lambda (&key error-thrown &allow-other-keys)
                (message "Copilot Chat API Error: %S" error-thrown)))
      :sync t)
    response))

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
      (message "User Message: %s" user-message)
      ;; Append user's message to chat buffer
      (copilot-chat-append-message "User" user-message)
      ;; Send message to ChatGPT API and get the response
      (let ((response (copilot-chat-send-to-api user-message)))
        ;; Append API's response to chat buffer
        (message "ChatGPT Response: %s" response)
        (copilot-chat-append-message "ChatGPT" response))
      ;; Clear the input buffer
      (with-current-buffer (get-buffer copilot-chat-input-buffer-name)
        (erase-buffer)))))


(provide 'copilot-chat)

;;; config.el ends here
