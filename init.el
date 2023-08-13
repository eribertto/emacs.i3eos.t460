;; Begin new init file
;; For use with better-defaults emacs.d

(add-to-list 'load-path "~/GithubRepos/emacs-better-defaults")
;; load the better-defaults.el file
(require 'better-defaults)
;;(add-to-list 'load-path "~/.emacs.d/elisp")
;;(require 'setup-org)
(set-frame-font "IosevkaTerm Nerd Font 26" nil t)
;; IosevkaTerm Nerd Font
;; FiraCode Nerd Font

;; set this first before loading evil or evil-collection
(setq evil-want-keybinding nil)
(auto-save-visited-mode 1)
(require 'package)

;; begin emacs variables definition
(use-package emacs
  :init
  (setq user-full-name "Eriberto Mendez Jr")
  (setq user-mail-address "erimendz@gmail.com")
  (defalias 'yes-or-no-p 'y-or-n-p) ; make it shorter
  (setq indent-tabs-mode nil) ; no tabs
  (setq make-backup-files nil)
  (setq inhibit-startup-message t)
;; setup the visible bell
  (setq visible-bell t)
;; initialize package sources
  (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                           ("org" . "https://orgmode.org/elpa/")
                           ("elpa" . "https://elpa.gnu.org/packages/")))
  (set-charset-priority 'unicode) ; utf8 all throughout
  (setq locale-coding-system 'utf-8
        coding-system-for-read 'utf-8
        coding-system-for-write 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (setq default-process-coding-system '(utf-8-unix . utf-8-unix))
  (electric-pair-mode t)
  ;; less noise when compiling elisp
  (setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))
  (setq native-comp-async-report-warnings-errors nil)
  (setq load-prefer-newer t)
  ;; hide commands in M-x which dont work in the current mode
  (setq read-extended-command-predicate #'command-completion-default-include-p)
  )

(setq site-lisp-dir
(expand-file-name "site-lisp" user-emacs-directory))
(setq settings-dir
(expand-file-name "settings" user-emacs-directory))
;; settings for currently logged-in user
  (setq user-settings-dir
        (concat user-emacs-directory "users/" user-login-name))
;; set up load path e.g.
;; the 2 dirs above will be added to the load-path when emacs looks for elisp codes
(add-to-list 'load-path site-lisp-dir)
(add-to-list 'load-path settings-dir)


;; package initialize
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(unless package-archive-contents
  (package-refresh-contents))

;; use package
(require 'use-package)
(setq use-package-always-ensure t)
;; auto update use-package
(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "09:00"))

;; enable line numbers globally
(global-display-line-numbers-mode t)
;; do NOT display line numbers for some modes
;; including vterm
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		vterm-mode-hook
		treemacs-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))
;; make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; add evil-escape jk
;; https://github.com/syl20bnr/evil-escape
(use-package evil-escape
  :config
  (evil-escape-mode 1)
  (setq-default evil-escape-delay 0.2)
  (setq-default evil-escape-key-sequence "jk"))


;; use evil vim keybindings
(use-package general
  :after evil
  :config
  (general-create-definer em/leader-keys
			   :keymaps '(normal insert visual emacs)
			   :prefix "SPC"
			   :global-prefix "C-SPC")
  (em/leader-keys
   "t" '(:ignore t :which-key "toggles")
   "tt" '(counsel-load-theme :which-key "choose theme")
   "fde" '(lambda () (interactive) (find-file (expand-file-name "~/.emacs.d/Emacs.org")))))

;; set this in advance before loading evil

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  ;; use visual line motions even outside of visual-line-mode-buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))
  
(use-package evil-collection
:after evil
:config
(evil-collection-init))

;; add comment install command-log-mode
(use-package command-log-mode
  :commands command-log-mode)
(use-package doom-themes
  :init (load-theme 'doom-palenight t))

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 12)))

;; load use-package-diminish
(require 'use-package-diminish)
(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line) ;; why repeat of the above?
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  (prescient-persist-mode 1)
  (ivy-prescient-mode 1))

(use-package hydra
  :defer t)
(defhydra hydra-text-scale (:timeout 4)
	  "scale text"
	  ("j" text-scale-increase "in")
	  ("k" text-scale-decrease "out")
	  ("f" nil "finished" :exit t))
(em/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))


;; done install magit see the below link 
;; https://medium.com/helpshift-engineering/configuring-emacs-from-scratch-use-package-c30382297877
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; todo install and setup org-roam
;; https://github.com/org-roam/org-roam
;; https://www.orgroam.com/manual.html
;; or use as ref guide https://www.patrickdelliott.com/emacs.d/#orgb5012a7

;; install vterm after completing the prerequisites

;; (add-hook 'vterm-mode-hook (lambda() (display-line-numbers-mode -1)))
(use-package vterm
  :ensure t)

;; add org-mode setup
;; copied from https://github.com/james-stoup/emacs-org-mode-tutorial#org15e744d
;; 
;; Setup use-package just in case everything isn't already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Enable use-package
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)
(use-package org)

;; Must do this so the agenda knows where to look for my files
(setq org-agenda-files '("~/org"))

;; When a TODO is set to a done state, record a timestamp
(setq org-log-done 'time)

;; Follow the links
(setq org-return-follows-link  t)

;; Associate all org files with org mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

;; Make the indentation look nicer
(add-hook 'org-mode-hook 'org-indent-mode)

;; Remap the change priority keys to use the UP or DOWN key
(define-key org-mode-map (kbd "C-c <up>") 'org-priority-up)
(define-key org-mode-map (kbd "C-c <down>") 'org-priority-down)

;; Shortcuts for storing links, viewing the agenda, and starting a capture
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

;; When you want to change the level of an org item, use SMR
(define-key org-mode-map (kbd "C-c C-g C-r") 'org-shiftmetaright)

;; Hide the markers so you just see bold text as BOLD-TEXT and not *BOLD-TEXT*
(setq org-hide-emphasis-markers t)

;; Wrap the lines in org mode so that things are easier to read
(add-hook 'org-mode-hook 'visual-line-mode)

;; optional org-mode settings
(let* ((variable-tuple
        (cond ((x-list-fonts "ETBembo")         '(:font "ETBembo"))
              ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
              ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
              ((x-list-fonts "Verdana")         '(:font "Verdana"))
              ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
              (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
       (base-font-color     (face-foreground 'default nil 'default))
       (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

  (custom-theme-set-faces
   'user
   `(org-level-8 ((t (,@headline ,@variable-tuple))))
   `(org-level-7 ((t (,@headline ,@variable-tuple))))
   `(org-level-6 ((t (,@headline ,@variable-tuple))))
   `(org-level-5 ((t (,@headline ,@variable-tuple))))
   `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
   `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.2))))
   `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.3))))
   `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.5))))
   `(org-document-title ((t (,@headline ,@variable-tuple :height 1.6 :underline nil))))))
