;;; custom/ruby/config.el -*- lexical-binding: t; -*-

;; https://github.com/doomemacs/doomemacs/issues/5858
(add-to-list 'lsp-language-id-configuration '(".*\\.erb$" . "html"))

(defun custom|ruby-setup-flycheck ()
  "Use ruby-standard as the default checker for ruby-mode."
  (flycheck-select-checker 'ruby-rubocop))

(use-package! ruby-mode
  :config
  (add-hook 'ruby-mode-hook #'custom|ruby-setup-flycheck)
  :hook ((ruby-mode . lsp)))

;; Load the snippets
(after! minitest
  (minitest-install-snippets))

;; Explicitly set the ruby and erb formatters
(use-package! apheleia
  :config
  ;; ;; https://github.com/standardrb/standard
  ;; (add-to-list 'apheleia-formatters
  ;;              '(ruby-standard . ("standardrb" "--stdin" filepath "--fix" "--stderr" "--format" "quiet" "--fail-level" "fatal")))
  (add-to-list 'apheleia-mode-alist
               '(ruby-mode . rubocop))

  ;; https://github.com/nebulab/erb-formatter
  (add-to-list 'apheleia-formatters
               '(erb-format . ("erb-format" "--stdin" "--print-width" "999" "--stdin-filename" filepath)))
  (add-to-list 'apheleia-mode-alist
               '(erb-mode . erb-format)))
