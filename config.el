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
(setq doom-font (font-spec :family "Jetbrains Mono" :size 13 :slant 'normal :weight 'normal)
      doom-font-increment 1)

;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one-light)

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
  (setq heaven-and-hell-themes
        '((light . doom-one-light)
          (dark . doom-nord)))
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
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2))


;; UI
(map! :n "C-="    #'doom/reset-font-size
      ;; Buffer-local font resizing
      :n "C-+"    #'text-scale-increase
      :n "C--"    #'text-scale-decrease)

(setq avy-all-windows t)
(tab-bar-mode -1)
(after! centaur-tabs
  (dolist (item '("*Message" "*Warnings" "*copilot" "*Async" "*Native" "*scratch" "*apheleia" "*lsp" "*compilation"))
    (add-to-list 'centaur-tabs-excluded-prefixes item)))


(use-package! treemacs
  :config
  (treemacs-follow-mode 1))

(map! :n "s-}" #'centaur-tabs-forward
      :n "s-{" #'centaur-tabs-backward)

;; Copilot
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

;; Programming
(use-package! apheleia
  :config
  (add-to-list 'apheleia-mode-alist
               '(ruby-mode rubocop)))

;; Programming - Ruby
(add-hook 'ruby-mode-hook
          (lambda ()
            (flycheck-select-checker 'ruby-rubocop)))


;; org-roam
(use-package! org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-db-location (expand-file-name ".cache/org-roam.db" org-directory))
  :config
  (org-roam-db-autosync-enable))

;; config.el ends here
