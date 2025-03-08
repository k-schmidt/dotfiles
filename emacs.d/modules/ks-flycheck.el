(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t)
  :config
  (add-hook 'find-file-hook
            (lambda ()
              (when (not (equal 'emacs-lisp-mode major-mode))
                (flycheck-mode)))))

(global-set-key (kbd "M-n") 'next-error)
(global-set-key (kbd "M-p") 'previous-error)

(provide 'ks-flycheck)
