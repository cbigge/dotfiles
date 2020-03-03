(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package auto-compile
  :config (auto-compile-on-load-mode))

(setq load-prefer-newer t)

; Set indent size
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

; Set default file directory
(setq default-directory "~/")

; Create file's directory if doesn't exist
(add-hook 'before-save-hook
          (lambda ()
            (when buffer-file-name
              (let ((dir (file-name-directory buffer-file-name)))
                (when (and (not (file-exists-p dir))
                           (y-or-n-p (format "Directory %s does not exist. Create it?" dir)))
                  (make-directory dir t))))))

; Turn off start menu
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

; yes/no? -> y/n?
(fset 'yes-or-no-p 'y-or-n-p)

; Always highlight code
(global-font-lock-mode t)

; Show matching parens
(show-paren-mode t)
(setq show-paren-delay 0.0)

; Flash screen rather than ring bell
(setq visible-bell t)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

(global-prettify-symbols-mode t)

(use-package cyberpunk-theme
  :config
  (defun transparency (value)
    (interactive "nTransparency Value 0 - 100 opaque:")
    (set-frame-parameter (selected-frame) 'alpha value))
  (transparency 90))

(use-package minions
  :init (minions-mode)
  :config
  (setq minions-mode-line-lighter "#"
   minions-direct '(flycheck-mode
                    cider-mode))
  (minions-mode 1))

(use-package moody
  :config
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode))


