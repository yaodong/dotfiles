;;; custom/code/+tailwind.el -*- lexical-binding: t; -*-

(require 'tree-sitter)
(require 'tree-sitter-langs)

(defvar tailwind-classes '()
  "List of Tailwind color-related class names.")

(defvar tailwind-colors
  '((inherit . "inherit")
    (current ."currentColor")
    (transparent . "transparent")
    (black . "#000")
    (white . "#fff")
    (slate . ((50 . "#f8fafc") (100 . "#f1f5f9") (200 . "#e2e8f0") (300 . "#cbd5e1")
              (400 . "#94a3b8") (500 . "#64748b") (600 . "#475569") (700 . "#334155")
              (800 . "#1e293b") (900 . "#0f172a") (950 . "#020617")))
    ))

(defun tailwind-generate-color-classes ()
  "Generate a list of Tailwind color-related class names."
  (let ((classes '())
        (prefixes '("text" "bg" "border")))
    (dolist (color-entry tailwind-colors)
      (let ((color-name (symbol-name (car color-entry)))
            (color-value (cdr color-entry)))
        (cond
         ;; For colors with shades
         ((listp color-value)
          (dolist (shade-entry color-value)
            (let ((shade (car shade-entry)))
              (dolist (prefix prefixes)
                (push (format "%s-%s-%s" prefix color-name shade) classes)))))
         ;; For colors without shades (like black, white, etc.)
         ((stringp color-value)
          (dolist (prefix prefixes)
            (push (format "%s-%s" prefix color-name) classes))))))
    (nreverse classes)))


(defun tailwind-generate-class-names ()
  "Append generated color classes to tailwind-classes in-place."
  (setq tailwind-classes (append tailwind-classes (tailwind-generate-color-classes))))


(defun tailwind-completion-function (string pred action)
  "Completion function for Tailwind CSS class names."
  (pcase action
    ('metadata
     `(metadata (category . tailwind-class)
       (annotation-function . ,(lambda (_) " <Tailwind>"))
       (docsig . ,(lambda (candidate)
                    (format "Tailwind CSS class: %s" candidate)))))
    ('lambda
      (test-completion string tailwind-classes pred))
    ('t
     (all-completions string tailwind-classes pred))
    ('nil
     (try-completion string tailwind-classes pred))))

(defun tailwind-in-css-attr-p ()
  "Check if point is within a CSS attribute value using Tree-sitter."
  (when (tree-sitter-node-at-pos)
    (let* ((node (tree-sitter-node-at-pos))
           (parent (tsc-get-parent node)))
      (message "Node type: %s" (tsc-node-type node))
      (message "Parent node type: %s" (tsc-node-type parent))
      (and (eq (tsc-node-type node) 'block)
           (eq (tsc-node-type parent) 'rule_set)
           (save-excursion
             (re-search-backward ":" (line-beginning-position) t))
           (save-excursion
             (not (re-search-backward ";" (line-beginning-position) t)))))))

(defun tailwind-in-class-attr-p ()
  "Check if point is within a class attribute."
  (let* ((pos (point))
         (attr-beg (web-mode-attribute-beginning-position pos))
         (attr-end (web-mode-attribute-end-position pos))
         (attr-text (buffer-substring-no-properties attr-beg attr-end)))
    (string-prefix-p "class" attr-text)))

(defun tailwind-in-html-p ()
  "Return true if the current mode is HTML mode."
  (or (and (eq major-mode 'web-mode)
           (string= (web-mode-language-at-pos) "html")
           (tailwind-in-class-attr-p))
      (eq major-mode 'html-mode)))

(defun tailwind-in-css-p ()
  "Return true if the current mode is CSS mode."
  (or (and (eq major-mode 'css-mode)
           (tailwind-in-css-attr-p))
      (and (eq major-mode 'web-mode)
           (string= (web-mode-language-at-pos) "css"))))


(defun tailwind-completion-at-point ()
  "Completion at point function for Tailwind CSS class names."
  (let ((bounds (bounds-of-thing-at-point 'symbol)))
    (when (and bounds
               (or (tailwind-in-html-p)
                   (tailwind-in-css-p)))
      (list (car bounds)              ; start
            (cdr bounds)              ; end
            #'tailwind-completion-function
            :exclusive 'no))))

(defun tailwind-completion-hook ()
  "Enable Tailwind CSS class name completion."
  (if (null tailwind-classes)
      (tailwind-generate-class-names))
  (add-hook 'completion-at-point-functions #'tailwind-completion-at-point nil 'local))


(use-package! web-mode
  :config
  (add-hook 'web-mode-hook #'tailwind-completion-hook))

(use-package! css-mode
  :config
  (add-hook 'css-mode-hook #'tailwind-completion-hook))
