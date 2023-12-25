;;; private/css/config.el -*- lexical-binding: t; -*-

;; Use stylelint as the default checker for css-mode
(defun custom|css-setup-stylelint ()
  "Custom setup for css-mode."
  (flycheck-select-checker 'css-stylelint))

;; Correctly highlight @apply rules
(defvar custom|css-apply-syntax-highlighting
  '(("\\(@apply\\)\\s-+\\([^;\n]+\\(;\\)?\\)"
     ;; Highlight @apply as a keyword
     (1 font-lock-keyword-face)
     ;; Highlight the class names as variables
     (2 (lambda (limit)
          (while (re-search-forward "\\_<\\(\\S-+\\)\\_>" limit t)
            (put-text-property (match-beginning 1) (match-end 1) 'font-lock-face 'font-lock-variable-name-face)))
        prepend nil))))

(defun custom|css-apply-highlighting-hook ()
  (font-lock-add-keywords nil custom|css-apply-syntax-highlighting))

(use-package! css-mode
  :config
  (add-hook 'css-mode-hook #'custom|css-setup-stylelint)
  (add-hook 'css-mode-hook #'custom|css-apply-highlighting-hook))
