(use-package flymake
  :ensure t)

(use-package flymake-go
  :ensure t)

(use-package go-mode
  :ensure t
  :init
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
  (local-set-key (kbd "M-.") 'godef-jump)
  :config
  (add-hook 'go-mode-hook 'electric-pair-mode)
  (eval-after-load "go-mode"
    '(require 'flymake-go)))

(use-package go-eldoc
  :ensure t
  :defer
  :init
  (add-hook 'go-mode-hook 'go-eldoc-setup))

(setenv "GOPATH" "/home/kyleschmidt/SourceCode/gocode")

(provide 'ks-go)
