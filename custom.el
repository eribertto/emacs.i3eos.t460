(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ignored-local-variable-values
   '((eval add-hook 'after-save-hook
           (lambda nil
             (if
                 (y-or-n-p "Tangle?")
                 (org-babel-tangle)))
           nil t)
     (eval add-hook 'after-save-hook
           (lambda nil
             (if
                 (y-or-n-p "Reload?")
                 (load-file user-init-file)))
           nil t)
     (eval add-hook 'after-save-hook
           (lambda nil
             (if
                 (y-or-n-p "Export?")
                 (org-html-export-to-html)))
           nil t))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
