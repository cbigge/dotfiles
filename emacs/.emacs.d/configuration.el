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

                                        ; Always highlight code
(global-font-lock-mode t)

                                        ; Show matching parens
(show-paren-mode t)
(setq show-paren-delay 0.0)

                                        ; Flash screen rather than ring bell
(setq visible-bell t)

(add-to-list 'load-path "~/.emacs.d/resources/")

(setq evil-want-abbrev-expand-on-insert-exit nil)
(setq evil-want-keybinding nil)

(use-package evil
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil)

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package evil-org
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda () (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(set-window-scroll-bars (minibuffer-window) nil nil)

(setq frame-title-format '((:eval (projectile-project-name))))

(global-prettify-symbols-mode t)

(use-package dracula-theme
  :config
  (defun transparency (value)
    (interactive "nTransparency Value 0 - 100 opaque:")
    (set-frame-parameter (selected-frame) 'alpha value))
  (transparency 90))

(setq ring-bell-function 'ignore)
(global-hl-line-mode)

(use-package minions
  :init (minions-mode)
  :config
  (setq minions-mode-line-lighter ""
        minions-mode-line-delimiters '("" . ""))
  (minions-mode 1))

(use-package moody
  :config
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode))

(use-package diff-hl
  :config
  (add-hook 'prog-mode-hook 'turn-on-diff-hl-mode)
  (add-hook 'vc-dir-mode-hook 'turn-on-diff-hl-mode))

(use-package deadgrep
  :config (evil-collection-deadgrep-setup))

(use-package company)
(add-hook 'after-init-hook 'global-company-mode)
(global-set-key (kbd "M-/") 'company-complete-common)

(use-package dumb-jump
  :config
  (define-key evil-normal-state-map (kbd "M-.") 'dumb-jump-go)
  (setq dumb-jump-selector 'ivy))

(use-package let-alist)
(use-package flycheck)

(use-package magit
  :bind
  ("C-x g" . magit-status)

  :config
  (use-package evil-magit)
  (use-package with-editor)
  (setq magit-push-always-verify nil)
  (setq git-commit-summary-max-length 50)

  (with-eval-after-load 'magit-remote
    (magit-define-popup-action 'magit-push-popup ?P
                               'magit-push-implicitly--desc
                               'magit-push-implicitly ?p t))

  (add-hook 'with-editor-mode-hook 'evil-insert-state))

(use-package git-timemachine)

(use-package projectile
  :bind
  ("C-c v" . deadgrep)

  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

  (define-key evil-normal-state-map (kbd "C-p") 'projectile-find-file)
  (evil-define-key 'motion ag-mode-map (kbd "C-p") 'projectile-find-file)

  (setq projectile-completion-system 'ivy)
  (setq projectile-switch-project-action 'projectile-dired)
  (setq projectile-require-project-root nil))

(use-package undo-tree)

(setq-default tab-width 4)

(use-package subword
  :config (global-subword-mode 1))

(setq compliation-scroll-output t)

(use-package web-mode)
(add-hook 'web-mode-hook
          (lambda ()
            (rainbow-mode)
            (setq web-mode-markup-indent-offset 4)))
(add-to-list 'auto-mode-alist '("\\.gohtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))

(use-package css-mode
  :config
  (setq css-indent-offset 4))
(use-package scss-mode
  :config
  (setq scss-compile-at-save nil))
(use-package less-css-mode)

(use-package coffee-mode)
(setq js-indent-level 4)
(add-hook 'coffee-mode-hook
          (lambda ()
            (yas-minor-mode 1)
            (setq coffee-tab-width 4)))

(use-package go-mode)
(use-package go-errcheck)
(use-package company-go)
(setenv "GOPATH" "/home/chris/Projects/go")
(setenv "PATH" (concat (getenv "PATH") ":" "/home/chris/Projects/go/bin"))
(add-to-list 'exec-path "/home/chris/Projects/go/bin")
(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)
(add-hook 'go-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends)
                 '(company-go))
            (company-mode)
            (if (not (string-match "go" compile-command))
                (set (make-local-variable 'compile-command)
                     "go build -v && go test -v && go vet"))
            (flycheck-mode)))

(use-package rust-mode
  :config
  (setenv "PATH" (concat (getenv "PATH") ":" "/home/chris/.cargo/bin"))
  (setq rust-format-on-save t))

(use-package paredit)
(use-package rainbow-delimiters)
(add-hook 'emacs-lisp-mode-hook
          (lambda()
            (setq show-paren-style 'expression)
            (paredit-mode)
            (rainbow-delimiters-mode)))
(use-package eldoc
  :config
  (add-hook 'emacs-lisp-mode-hook 'eldoc-mode))

(add-hook 'sh-mode-hook
          (lambda ()
            (setq sh-basic-offset 4
                  sh-indentation 4)))

(use-package multi-term)
(global-set-key (kbd "C-c t") 'multi-term)
(setq multi-term-program-switches "--login")
(evil-set-initial-state 'term-mode 'emacs)
(defun term-paste (&optional strin)
  (interactive)
  (process-send-string
   (get-buffer-process (current-buffer))
   (if string string (current-kill 0))))
(add-hook 'term-mode-hook
          (lambda ()
            (goto-address-mode)
            (define-key term-raw-map (kbd "C-y") 'term-paste)
            (define-key term-raw-map (kbd "<mouse-2>") 'term-paste)
            (define-key term-raw-map (kbd "M-o") 'other-window)
            (setq yas-dont-activate t)))

(use-package org
  :ensure org-plus-contrib
  :config
  (require 'org-tempo)
  (add-hook 'org-mode-hook
            '(lambda ()
               (setq mailcap-mime-data '())
               (mailcap-parse-mailcap "~/.mailcap")
               (setq org-file-apps
                     '((remote . emacs)
                       (system . mailcap)
                       (t . mailcap))))))
(setq inital-major-mode 'org-mode)

(use-package org-bullets
  :init
  (add-hook 'org-mode-hook 'org-bullets-mode))
(setq org-ellipsis "⤵")
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-src-window-setup 'current-window)
(add-to-list 'org-structure-template-alist
             '("el" . "src emacs-lisp"))

(setq org-directory "~/Documents/org")
(defun org-file-path (filename)
  "Return the absolute address of an org file, given its relative name."
  (concat (file-name-as-directory org-directory) filename))

(setq org-inbox-file "~/inbox.org")
(setq org-index-file (org-file-path "index.org"))
(setq org-archive-location
      (concat (org-file-path "archive.org") "::* from %s"))

(defun copy-tasks-from-inbox ()
  (when (file-exists-p org-inbox-file)
    (save-excursion
      (find-file org-index-file)
      (goto-char (point-max))
      (insert-file-contents org-inbox-file)
      (delete-file org-inbox-file))))
(setq org-agenda-files (list org-index-file
                             (org-file-path "recurring-events.org")
                             (org-file-path "work.org")))

(defun mark-done-and-archive ()
  "Mark the state of an org-mode item as DONE and archive it."
  (interactive)
  (orgtodo 'done)
  (org-archive-subtree))

(define-key org-mode-map (kbd "C-c C-x C-s") 'mark-done-and-archive)
(setq org-log-done 'time)
(setq org-enforce-todo-dependencies t)
(setq org-enforce-todo-checkbox-dependencies t)
(setq org-agenda-span 14)
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-prefix-format '((agenda . " %i %?-12t% s")
                                 (todo . " %i ")
                                 (tags . " %i ")
                                 (search . " %i ")))
(require 'org-habit)
(defun org-skip-subtree-if-priority (priority)
  "Skip an agenda subtree if it has a priority of PRIORITY.

        PRIORITY may be one of the characters ?A, ?B, or ?C."
  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
        (pri-value (* 1000 (- org-lowest-priority priority)))
        (pri-current (org-get-priority (thing-at-point 'line t))))
    (if (- pri-value pri-current)
        subtree-end
      nil)))

(defun org-skip-subtree-if-habit ()
  "Skip an agenda entry if it has a STYLE property equal to \"habit\"."
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (string= (org-entry-get nil "STYLE") "habit")
        subtree-end
      nil)))

(setq org-agenda-custom-commands
      '(("p" "Personal agenda"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if
                                             'todo '("DONE" "PENDING" "BLOCKED")))
                 (org-agenda-overriding-header "Today's high-priority tasks:")))
          (agenda "")
          (todo "TODO"
                ((org-agenda-skip-function '(or (org-skip-subtree-if-priority ?A)
                                                (org-skip-subtree-if-habit)))
                 (org-agenda-overriding-header "Other tasks:")))
          (todo "PENDING"
                ((org-agenda-skip-function '(org-skip-subtree-if-priority ?A))
                 (org-agenda-overriding-header "Waiting to hear about these:")))))))
(defun dashboard ()
  (interactive)
  (copy-tasks-from-inbox)
  (org-agenda nil "p"))
(global-set-key (kbd "C-c d") 'dashboard)

(setq org-capture-templates
      '(("b" "Blog idea"
         entry
         (file "~/documents/notes/blog-ideas.org")
         "* %?\n")

        ("c" "Contact"
         entry
         (file "~/Documents/org/contacts.org")
         "* %(org-contacts-template-name)
:PROPERTIES:
:ADDRESS: %^{123 Fake St., City, ST 12345}
:PHONE: %^{555-555-5555}
:EMAIL: %(org-contacts-template-email)
:NOTE: %^{note}
:END:")

        ("e" "Email" entry
         (file+headline org-index-file "Inbox")
         "* TODO %?\n\n%a\n\n")

        ("f" "Finished book"
         table-line (file "~/Documents/books-read.org")
         "| %^{Title} | %^{Author} | %u |")

        ("r" "Reading"
         checkitem
         (file (org-file-path "to-read.org")))

        ("s" "Subscribe to an RSS feed"
         plain
         (file "~/documents/rss-feeds.org")
         "*** [[%^{Feed URL}][%^{Feed name}]]")

        ("t" "Todo"
         entry
         (file+headline org-index-file "Inbox")
         "* TODO %?\n")))

(add-hook 'org-capture-mode-hook 'evil-insert-state)
(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

(defun open-index-file ()
  "Open master org TODO list."
  (interactive)
  (copy-tasks-from-inbox)
  (find-file org-index-file)
  (flycheck-mode -1)
  (end-of-buffer))

(global-set-key (kbd "C-c i") 'open-index-file)

(defun org-capture-todo ()
  (interactive)
  (org-capture :keys "t"))

(global-set-key (kbd "M-n") 'org-capture-todo)
(add-hook 'gfm-mode-hook
          (lambda () (local-set-key (kbd "M-n") 'org-capture-todo)))

(require 'ox-md)
(require 'ox-beamer)
(use-package ox-twbs)
(use-package gnuplot)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (dot . t)
   (gnuplot . t)))
(setq org-confirm-babel-evaluate nil)
(use-package htmlize)
(use-package graphviz-dot-mode)
(add-to-list 'org-src-lang-modes '("dot" . graphviz-dot))
(setq org-export-with-smart-quotes t)
(setq org-html-postamble nil)
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")
(setenv "BROWSER" "firefox")
(setq org-latex-pdf-process
      '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-latex-listings 'minted)

(use-package flyspell
  :config
  (add-hook 'text-mode-hook 'turn-on-auto-fill)
  (add-hook 'gfm-mode-hook 'flyspell-mode)
  (add-hook 'org-mode-hook 'flyspell-mode)
  (add-hook 'git-commit-mode-hook 'flyspell-mode))

(use-package dired-hide-dotfiles
  :config
  (dired-hide-dotfiles-mode)
  (define-key dired-mode-map "." dired-hide-dotfiles-mode))
(setq-default dired-listing-switches "lhvA")
(setq dired-clean-up-buffers-too t)
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'top)
(use-package async
  :config
  (dired-async-mode 1))
(evil-define-key 'normal dired-mode-map (kbd "j") 'dired-next-line)
(evil-define-key 'normal dired-mode-map (kbd "k") 'dired-previous-line)

(defun visit-emacs-config ()
  (interactive)
  (find-file "~/.dotfiles/emacs/.emacs.d/configuration.org"))
(global-set-key (kbd "C-c e") 'visit-emacs-config)

(use-package helpful)
(global-set-key (kbd "C-h f") #'helpful-callable)
(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)
(evil-define-key 'normal helpful-mode-map (kbd "q") 'quit-window)
(save-place-mode t)
(use-package which-key
  :config (which-key-mode))
(use-package yasnippet)
(setq yas-snippet-dirs '("~/.dotfiles/emacs/.emacs.d/snippets/text-mode"))
(yas-global-mode 1)
(setq yas/indent-line nil)
(use-package counsel
  :bind
  ("M-x" . 'counsel-M-x)
  ("C-s" . 'swiper)

  :config
  (use-package flx)
  (use-package smex)

  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (t . ivy--regex-fuzzy))))
(defun split-window-below-and-switch ()
  "Split the window horizontally, then switch to the new pane."
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))

(defun split-window-right-and-switch ()
  "Split the window vertically, then switch to the new pane."
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))

(global-set-key (kbd "C-x 2") 'split-window-below-and-switch)
(global-set-key (kbd "C-x 3") 'split-window-right-and-switch)
(use-package wgrep)

(eval-after-load 'grep
  '(define-key grep-mode-map
     (kbd "C-x C-q") 'wgrep-change-to-wgrep-mode))

(eval-after-load 'wgrep
  '(define-key grep-mode-map
     (kbd "C-c C-c") 'wgrep-finish-edit))

(setq wgrep-auto-save-buffer t)
(projectile-global-mode)
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "M-o") 'other-window)
