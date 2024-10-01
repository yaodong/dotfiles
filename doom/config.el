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
(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'macchiato) ;; or 'latte, 'macchiato, or 'mocha

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type 'relative)

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

;; Use native full screen
(setq ns-use-native-fullscreen t)
(setq frame-resize-pixelwise t)

;; Too many warning messages
(setq warning-minimum-level :error)

;; format buffer
(global-set-key (kbd "M-s-l") '+format/buffer)
(map! :leader :desc "Toggle Joshu" "oj" #'joshu-toggle)

(defun custom|after-switch-project()
  "Auto refresh projectile cache when switching to a project"
  (if (projectile-project-p)
      (projectile-invalidate-cache nil)))

(add-hook 'after-switch-project-project-hook 'custom|after-switch-project)

;; Switch themes
(defun toggle-catppuccin-flavor ()
  "Toggle between Catppuccin Macchiato and Latte flavors."
  (interactive)
  (if (eq catppuccin-flavor 'macchiato)
      (setq catppuccin-flavor 'latte)
    (setq catppuccin-flavor 'macchiato))
  (catppuccin-reload))

(map! :leader
      :desc "Toggle Catppuccin flavor"
      "h h" #'toggle-catppuccin-flavor)

;; multi-cursor
(use-package! evil-mc
  :after evil
  :config
  (global-set-key (kbd "M-S-<mouse-1>") 'evil-mc-toggle-cursor-on-click))

(use-package! web-mode
  :config
  (define-derived-mode erb-mode web-mode "web[erb]")
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . erb-mode)))

;; UI
(map! :n "C-="    #'doom/reset-font-size
      ;; Buffer-local font resizing
      :n "C-+"    #'text-scale-increase
      :n "C--"    #'text-scale-decrease)

(setq avy-all-windows t)
(tab-bar-mode -1)

(use-package! treemacs
  :config
  (treemacs-follow-mode 1))

;; Accept completion from copilot and fallback to company
(use-package! copilot
  :hook ((prog-mode . copilot-mode))
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

;; Keybindings
(map! :n "s-}" #'+workspace:switch-next
      :n "s-{" #'+workspace:switch-previous
      :n "s-N" #'+workspace:new
      :n "s-]" #'evil-jump-forward
      :n "s-[" #'evil-jump-backward)


;; Jenkinsfile
(use-package! jenkinsfile-mode)

;; Enable eglot-booster
(use-package! eglot-booster
  :after eglot
  :config (eglot-booster-mode))

;; Verb
(use-package org
  :mode ("\\.org\\'" . org-mode)
  :config (define-key org-mode-map (kbd "C-c C-r") verb-command-map))

;;; config.el ends here
