(use-package helm
  :config
  (require 'helm-config)
  (require 'helm)
  (helm-mode 1)
  (with-eval-after-load "ks-project"
    (use-package helm-projectile
      :bind (("C-c C-f"  . helm-projectile-find-file-dwim)
             ("C-x C-g"  . helm-projectile-grep))
      :config (helm-projectile-on)))
  (require 'projectile)
  (add-to-list 'projectile-globally-ignored-directories "venv")
  (add-to-list 'projectile-globally-ignored-directories "__pycache__")
  (use-package helm-pydoc
    :config
    (with-eval-after-load "python"
      (define-key python-mode-map (kbd "C-c C-d") 'helm-pydoc)))
  (helm-autoresize-mode 1)
  (bind-key "<tab>" #'helm-execute-persistent-action helm-map)
  (bind-key "C-i" #'helm-execute-persistent-action helm-map)
  (bind-key "C-z" #'helm-select-action helm-map)
  (bind-key "C-c C-l" #'helm-minibuffer-history minibuffer-local-map)
  :bind (("C-x C-f" . helm-find-files)
     ("C-h a"   . helm-apropos)
     ("C-x b"   . helm-buffers-list)
     ("M-i"     . helm-imenu)
     ("M-y"     . helm-show-kill-ring)
     ("C-c h o" . helm-occur)
     ("C-h SPC" . helm-all-mark-rings)
     ("C-c h x" . helm-register)
     ("C-c h g" . helm-google-suggest))
  :diminish helm-mode
  :init
  (setq
   helm-display-header-line nil
   helm-autoresize-min-height 10
   helm-autoresize-max-height 35
   helm-split-window-in-side-p t

   helm-buffers-fuzzy-matching t
   helm-recentf-fuzzy-match t
   helm-semantic-fuzzy-match t
   helm-imenu-fuzzy-match t
   helm-locate-fuzzy-match t
   helm-apropos-fuzzy-match t
   helm-lisp-fuzzy-completion t)

  (when (executable-find "curl")
    (setq helm-google-suggest-use-curl-p t)))

(use-package swiper-helm
  :bind (("C-s" . swiper-helm)
         ("C-r" . swiper-helm)))

(use-package helm-tramp
  :config
  (setq tramp-default-method "ssh")
  (defalias 'exit-tramp 'tramp-cleanup-all-buffers)
  (define-key global-map (kbd "C-c s") 'helm-tramp))

(use-package helm-flx
  :demand t
  :config
  (with-eval-after-load "helm"
    (require 'helm-flx)
    (helm-flx-mode 1)))

(provide 'ks-helm)
