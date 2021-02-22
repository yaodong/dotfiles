;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Yaodong Zhao"
      user-mail-address "emacs@yaodong.org")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Monaco" :size 13 :weight 'semi-light))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(use-package! disable-mouse
  :config
  (global-disable-mouse-mode))

(use-package! org
  :custom
  (org-directory "~/Documents/Organize")
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (scala . t)))
  (setq org-capture-templates
        '(("n" "Notes" entry (file "~/Documents/Organize/Captures.org")
           "* %?\n%i\n")
          ("t" "Tasks" entry (file "~/Documents/Organize/Captures.org")
           "* TODO %?\n%i\n"))))

(use-package! ob-ammonite
  :after org
  :config
  (defalias 'org-babel-execute:scala 'org-babel-execute:amm))

(use-package! org-journal
  :after org
  :bind ("C-c n j" . org-journal-new-entry)
  :custom
  (org-journal-dir "~/Documents/Journal")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-enable-agenda-integration t))

(use-package! deft
  :after org
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/Documents/Deft"))

(use-package! zetteldeft
  :after deft
  :custom
  (zetteldeft-id-format "%y%m%d%H%M")
  (zetteldeft-id-regex "[0-9]\\{10\\}")
  :config
  (zetteldeft-set-classic-keybindings))

;; Switch workspace
(global-set-key (kbd "s-{") '+workspace/switch-left)
(global-set-key (kbd "s-}") '+workspace/switch-right)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 (custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ))
