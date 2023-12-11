;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. CPI configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Yaodong Zhao"
      user-mail-address "emacs@yaodong.dev")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
(setq doom-font (font-spec :family "Jetbrains Mono" :size 14 :slant 'normal :weight 'normal)
      doom-font-increment 1)

;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org"
      org-journal-file-format "%Y-%m-%d.org"
      org-journal-time-prefix "** TODO ")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; Themes
(use-package! heaven-and-hell
  :config
  (setq heaven-and-hell-theme-type 'dark)
  (setq heaven-and-hell-themes
        '((light . doom-solarized-light)
          (dark . doom-gruvbox)))
  (setq heaven-and-hell-load-theme-no-confirm t)
  :hook (after-init . heaven-and-hell-init-hook)
  :bind (:map doom-leader-map
              ("h h" . heaven-and-hell-toggle-theme)))

;; Handy Temp Buffer
(defun user/create-temp-buffer ()
  "Create a temp buffer named *temp*."
  (interactive)
  (switch-to-buffer (get-buffer-create "*temp*"))
  (setq buffer-file-name nil) ;; makes sure the buffer is not associated with any file on disk
  (set-buffer-modified-p nil) ;; makes sure the buffer is not "modified"
  (org-mode))

(map! :leader
      :desc "Open temp buffer"
      "o t" #'user/create-temp-buffer)


;; File Modes

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))

(use-package! web-mode
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  :config
  (define-derived-mode erb-mode web-mode "web[erb]")
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . erb-mode)))

(use-package! css-mode
  :custom
  (css-indent-offset 2)
  :config
  (remove-hook! '(css-mode-hook sass-mode-hook stylus-mode-hook)
    #'rainbow-mode))


;; UI
(map! :n "C-="    #'doom/reset-font-size
      ;; Buffer-local font resizing
      :n "C-+"    #'text-scale-increase
      :n "C--"    #'text-scale-decrease)

(setq avy-all-windows t)
(tab-bar-mode -1)
(after! centaur-tabs
  (dolist (item '("*Message" "*Warnings" "*copilot" "*Async"
                  "*Native" "*scratch" "*apheleia" "*lsp"
                  "*compilation" "*pyright"))
    (add-to-list 'centaur-tabs-excluded-prefixes item)))


(use-package! treemacs
  :config
  (treemacs-follow-mode 1))

;; Keybindings
(map! :n "s-}" #'centaur-tabs-forward
      :n "s-{" #'centaur-tabs-backward
      :n "s-]" #'evil-jump-forward
      :n "s-[" #'evil-jump-backward)

;; Copilot
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))



;; Programming / Formatting
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



;; Programming - Ruby
(add-hook 'ruby-mode-hook
          (lambda ()
            (flycheck-select-checker 'ruby-standard)))


;; Programming - Tailwindcss
(use-package! lsp-tailwindcss
  :init
  (setq lsp-tailwindcss-add-on-mode t)
  (setq lsp-tailwindcss-major-modes '(html-mode css-mode web-mode))
  :config
  (add-to-list 'lsp-language-id-configuration '(".*\\.erb$" . "html")))

(use-package! lsp-mode
  :config
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]tmp\\'"))

;; Open dired when switching project
;; (setq projectile-switch-project-action #'projectile-dired)

;; org-roam
;; (use-package! org-roam
;;   :init
;;   (setq org-roam-v2-ack t)
;;   :custom
;;   (org-roam-db-location (expand-file-name ".cache/org-roam.db" org-directory))
;;   :config
;;   (org-roam-db-autosync-enable)
;;   (which-key-add-key-based-replacements "C-c n" "org-roam")
;;   :bind
;;   (("C-c n n" . org-roam-capture)
;;    ("C-c n l" . org-roam-buffer-toggle)
;;    ("C-c n i" . org-roam-node-insert)
;;    ("C-c n f" . org-roam-node-find)
;;    ("C-c n t" . org-roam-dailies-goto-today)
;;    ("C-c n c" . org-roam-dailies-capture-today)
;;    ("C-c n T" . org-roam-dailies-capture-tomorrow)
;;    ("C-c n y" . org-roam-dailies-capture-yesterday)))

;; config.el ends here
