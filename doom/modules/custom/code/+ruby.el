;;; custom/code/+ruby.el -*- lexical-binding: t; -*-


(defun custom|ruby-setup-flycheck ()
  "Use ruby-standard as the default checker for ruby-mode."
  (flycheck-select-checker 'ruby-rubocop))

(use-package! ruby-mode
  :config
  (add-hook 'ruby-mode-hook #'custom|ruby-setup-flycheck))

(use-package! web-mode
  :config
  (define-derived-mode erb-mode web-mode "web[erb]")
  (add-to-list 'auto-mode-alist '("\\.html\\.erb\\'" . erb-mode)))

;; Load the snippets
(after! minitest
  (minitest-install-snippets))


;; Explicitly set the ruby and erb formatters
(use-package! apheleia
  :config
  ;; https://github.com/rubocop/rubocop
  (add-to-list 'apheleia-mode-alist
               '(ruby-mode . rubocop))

  ;; https://github.com/nebulab/erb-formatter
  (add-to-list 'apheleia-formatters
               '(erb-format . ("erb-format" "--stdin" "--print-width" "999" "--stdin-filename" filepath)))
  (add-to-list 'apheleia-mode-alist
               '(erb-mode . erb-format)))
