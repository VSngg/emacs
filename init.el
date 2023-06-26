(defvar vs/indent-width 4) ; change this value to your preferred width
(setq frame-title-format '("Yay-Evil") ; Yayyyyy Evil!
      ring-bell-function 'ignore       ; minimize distraction
      frame-resize-pixelwise t
      default-directory "~/")

(tool-bar-mode -1)
(menu-bar-mode -1)
;; better scrolling experience
(setq scroll-margin 10
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

(global-display-line-numbers-mode 1)
(global-visual-line-mode t)
;; Always use spaces for indentation
(setq-default indent-tabs-mode nil
            tab-width vs/indent-width)

;; Omit default startup screen
(setq inhibit-startup-screen t)

(use-package delsel
  :ensure nil
  :config (delete-selection-mode +1))

(use-package scroll-bar
  :ensure nil
  :config (scroll-bar-mode -1))

(use-package simple
  :ensure nil
  :config (column-number-mode +1))

(use-package files
  :ensure nil
  :config
  (setq confirm-kill-processes nil
        create-lockfiles nil ; don't create .# files (crashes 'npm start')
        make-backup-files nil))

(use-package autorevert
  :ensure nil
  :config
  (global-auto-revert-mode +1)
  (setq auto-revert-interval 2
        auto-revert-check-vc-info t
        global-auto-revert-non-file-buffers t
        auto-revert-verbose nil))

(use-package eldoc
  :ensure nil
  :diminish eldoc-mode
  :config
  (setq eldoc-idle-delay 0.4))

;; C, C++, and Java
(use-package cc-vars
  :ensure nil
  :config
  (setq-default c-basic-offset vs/indent-width)
  (setq c-default-style '((java-mode . "java")
                          (awk-mode . "awk")
                          (other . "k&r"))))

;; Python (both v2 and v3)
(use-package python
  :ensure nil
  :config (setq python-indent-offset vs/indent-width))

(use-package mwheel
  :ensure nil
  :config (setq mouse-wheel-scroll-amount '(2 ((shift) . 1))
                mouse-wheel-progressive-speed nil))

(use-package paren
  :ensure nil
  :init (setq show-paren-delay 0)
  :config (show-paren-mode +1))

;; Set fonts
(defun vs/set-default-font ()
  (interactive)
  (set-face-attribute 'default nil :family "Iosevka Nerd Font Mono")
  (set-face-attribute 'default nil
                      :height 160
                      :weight 'normal)
  (set-face-attribute 'mode-line nil
                      :height 130)
  (set-face-attribute 'mode-line-inactive nil
                      :height 130)
  (set-face-attribute 'fixed-pitch nil
                      :height 150
                      :weight 'medium))
(setq initial-frame-alist '((fullscreen . maximized)))
(add-to-list 'default-frame-alist '(font . "Iosevka Nerd Font Mono-16"))
(vs/set-default-font)

(use-package ediff
  :ensure nil
  :config
  (setq ediff-window-setup-function #'ediff-setup-windows-plain)
  (setq ediff-split-window-function #'split-window-horizontally))

(use-package elec-pair
  :ensure nil
  :hook (prog-mode . electric-pair-mode))

(use-package whitespace
  :ensure nil
  :hook (before-save . whitespace-cleanup))

(use-package dired
  :ensure nil
  :config
  (setq delete-by-moving-to-trash t)
  (eval-after-load "dired"
    #'(lambda ()
        (put 'dired-find-alternate-file 'disabled nil)
        (define-key dired-mode-map (kbd "RET") #'dired-find-alternate-file))))

(use-package cus-edit
  :ensure nil
  :config
  (setq custom-file (concat user-emacs-directory "to-be-dumped.el")))

(add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes/"))
(load-theme 'modus-vivendi t) ; an orginal theme created by me.

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo
        dashboard-banner-logo-title "Yay Evil!"
        dashboard-items nil
        dashboard-set-footer nil))

(use-package highlight-numbers
  :hook (prog-mode . highlight-numbers-mode))

(use-package highlight-escape-sequences
  :hook (prog-mode . hes-mode))

(use-package evil
  :diminish undo-tree-mode
  :init
  (setq evil-want-C-u-scroll t
        evil-want-keybinding nil
        evil-shift-width vs/indent-width)
  :hook (after-init . evil-mode)
  :config
  (with-eval-after-load 'evil-maps ; avoid conflict with company tooltip selection
    (define-key evil-insert-state-map (kbd "C-n") nil)
    (define-key evil-insert-state-map (kbd "C-p") nil)))

(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-company-use-tng nil)
  (evil-collection-init))

(use-package evil-commentary
  :after evil
  :diminish
  :config (evil-commentary-mode +1))

(use-package magit
  :bind ("C-x g" . magit-status)
  :config (add-hook 'with-editor-mode-hook #'evil-insert-state))

(use-package ido
  :config
  (ido-mode +1)
  (setq ido-everywhere t
        ido-enable-flex-matching t))

(use-package ido-vertical-mode
  :config
  (ido-vertical-mode +1)
  (setq ido-vertical-define-keys 'C-n-C-p-up-and-down))

(use-package ido-completing-read+ :config (ido-ubiquitous-mode +1))

(use-package flx-ido :config (flx-ido-mode +1))

(use-package company
  :diminish company-mode
  :hook (prog-mode . company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.1
        company-selection-wrap-around t
        company-tooltip-align-annotations t
        company-frontends '(company-pseudo-tooltip-frontend ; show tooltip even for single candidate
                            company-echo-metadata-frontend))
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))

(use-package flycheck :config (global-flycheck-mode 0))

(use-package org
  :hook ((org-mode . visual-line-mode)
         (org-mode . org-indent-mode)))

(use-package org-bullets :hook (org-mode . org-bullets-mode))

(use-package markdown-mode
  :hook (markdown-mode . visual-line-mode))

(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'"   . web-mode)
         ("\\.jsx?\\'"  . web-mode)
         ("\\.tsx?\\'"  . web-mode)
         ("\\.json\\'"  . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2) ; HTML
  (setq web-mode-css-indent-offset 2)    ; CSS
  (setq web-mode-code-indent-offset 2)   ; JS/JSX/TS/TSX
  (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'"))))

(use-package diminish
  :demand t)

(use-package general
    :config
    (general-evil-setup)

    (general-nmap
      "gn" 'next-buffer
      "gp" 'previous-buffer)

    ;; set up 'SPC' as the global leader key
    (general-create-definer vs/leader-keys
        :states '(normal insert visual emacs)
        :keymaps 'override
        :prefix "SPC" ;; set leader
        :global-prefix "M-SPC") ;; access leader in insert mode

    (vs/leader-keys
        "b"  '(:ignore t                  :wk "buffer")
        "bb" '(switch-to-buffer           :wk "Switch buffer")
        "bk" '(kill-this-buffer           :wk "Kill this buffer")
        "bn" '(next-buffer                :wk "Next buffer")
        "bp" '(previous-buffer            :wk "Previous buffer")
        "br" '(revert-buffer              :wk "Reload buffer")
        "bs" '(switch-to-scratch-and-back :wk "Switch to scratch buffer")

        "e"  '(:ignore t                :wk "open")
        "ee" '(dired                    :wk "Open dired")
        "es" '(dired-other-window       :wk "Open dired in split")
        "ec" '((lambda()
                 (interactive)
                 (find-file user-init-file))
               :wk "Open init.el")
        "eb" '(eval-buffer              :wk "Eval buffer")
        "er" '(eval-region              :wk "Eval region")

        "a"  '(align-regexp :wk "Align by regexp")
        "f"  '(find-file    :wk "Find file")
        "c"  '(compile      :wk "Compile")

        "h"   '(:ignore t         :wk "Help")
        "h f" '(describe-function :wk "Describe function")
        "h v" '(describe-variable :wk "Describe variable")
        "h r" '(reload-init-file  :wk "Reload emacs config")

        "u"  '(:ignore t       :wk "capitalize")
        "uu" '(upcase-word     :wk "Uppercase word")
        "uc" '(capitalize-word :wk "Capitilize word")
        "ul" '(downcase-word   :wk "Downcase word")
        ))

(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode +1)
  (setq which-key-side-window-location 'bottom
                which-key-sort-order
                #'which-key-key-order-alpha
                which-key-sort-uppercase-first nil
                which-key-add-column-padding 1
                which-key-max-display-columns nil
                which-key-min-display-lines 6
                which-key-side-window-slot -10
                which-key-side-window-max-height 0.25
                which-key-idle-delay 0.8
                which-key-max-description-length 25
                which-key-allow-imprecise-window-fit t
                which-key-separator " → " ))
(use-package good-scroll :config (good-scroll-mode 1))

(when (eq system-type 'windows-nt)
  (setq scroll-margin 0)
  (setq explicit-shell-file-name "c:/Users/user/bin/w64devkit/bin/sh.exe")
  (setq shell-file-name explicit-shell-file-name)
  (add-to-list 'exec-path "C:/Users/user/bin/w64devkit/bin"))

;; Reload configuration
(defun reload-init-file ()
  (interactive)
  (load-file user-init-file)
  (load-file user-init-file))
;; Switch to scratch buffer and back
(defun switch-to-scratch-and-back ()
    "Toggle between *scratch* buffer and the current buffer.
     If the *scratch* buffer does not exist, create it."
    (interactive)
    (let ((scratch-buffer-name (get-buffer-create "*scratch*")))
        (if (equal (current-buffer) scratch-buffer-name)
            (switch-to-buffer (other-buffer))
            (switch-to-buffer scratch-buffer-name (lisp-interaction-mode)))))
