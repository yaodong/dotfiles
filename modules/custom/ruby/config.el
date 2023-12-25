;;; custom/ruby/config.el -*- lexical-binding: t; -*-


(defun custom|ruby-setup-flycheck ()
  "Use ruby-standard as the default checker for ruby-mode."
  (flycheck-select-checker 'ruby-standard))

(use-package! ruby-mode
  :config
  (add-hook 'ruby-mode-hook #'custom|ruby-setup-flycheck))

;; Explicitly set the ruby and erb formatters
(use-package! apheleia
  :config
  ;; https://github.com/standardrb/standard
  (add-to-list 'apheleia-formatters
               '(ruby-standard . ("standardrb" "--stdin" filepath "--fix" "--stderr" "--format" "quiet" "--fail-level" "fatal")))
  (add-to-list 'apheleia-mode-alist
               '(ruby-mode . ruby-standard))
  ;; https://github.com/nebulab/erb-formatter
  (add-to-list 'apheleia-formatters
               '(erb-format . ("erb-format" "--stdin" "--print-width" "120" "--stdin-filename" filepath)))
  (add-to-list 'apheleia-mode-alist
               '(erb-mode . erb-format)))
