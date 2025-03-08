(use-package projectile
  :demand t
  :commands projectile-global-mode
  :config
  (projectile-global-mode)
  :bind ("C-c C-f" . projectile-find-file)
  :diminish projectile-mode)

(use-package ibuffer-projectile
  :bind ("C-x C-b"  . ibuffer)
  :config
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-projectile-set-filter-groups)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic)))))

(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config (setq dumb-jump-selector 'helm)
  :ensure)

(provide 'ks-project)
