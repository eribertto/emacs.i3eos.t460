;; This buffer is for text tair-mode and evil-escape
(electric-pair-mode)
(evil-escape-mode)

;; test adjust-parens
(use-package adjust-parens)
(adjust-parens-mode)
(add-hook 'emacs-lisp-mode-hook #'adjust-parens-mode)
;; this binds two keys in Lisp Mode
(local-set-key (kbd "TAB") 'lisp-indent-adjust-parens)
(local-set-key (kbd "<backtab>") 'lisp-dedent-adjust-parens)
;; note: consider saving these to an elisp file for reference
;; save it inside emacs.d dir

;; eval this
(setq site-lisp-dir
      (expand-file-name "site-lisp" user-emacs-directory))
(setq settings-dir
      (expand-file-name "settings" user-emacs-directory))

;; set up load path e.g.
;; the 2 dirs above will be added to the load-path when emacs looks for elisp codes
(add-to-list 'load-path site-lisp-dir)
(add-to-list 'load-path settings-dir)
;; settings for currently logged-in user
(setq user-settings-dir
      (concat user-emacs-directory "users/" user-login-name))
;; (module-file-suffix) function not available, but try anyway installing vterm in this emacs config
;; success installing vterm package!
