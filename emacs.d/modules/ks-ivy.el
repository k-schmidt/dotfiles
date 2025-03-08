(use-package counsel
  :ensure t)

(use-package swiper
  :ensure try
  :init (ivy-mode 1)
  :config
  (setq ivy-use-virtual-buffers t)
  (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
  :bind
  ("C-s"      . swiper)
  ("C-c C-r"  . ivy-resume)
  ("<f6>"     . ivy-resume)
  ("M-x"      . counsel-M-x)
  ("C-x C-f"  . counsel-find-file)
  ("C-c g"    . counsel-git)
  ("C-c j"    . counsel-git-grep)
  ("C-c k"    . counsel-ag)
  ("C-x l"    . counsel-locate))


(provide 'ks-ivy)
