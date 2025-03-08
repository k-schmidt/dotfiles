;; Snippets Modules

(use-package s)

(use-package yasnippet
  :config (yas-global-mode 1)
  :diminish yas-minor-mode)

(add-hook 'term-mode-hook (lambda()
        (setq yas-dont-activate t)))

(global-set-key [remap dabbrev-expand] 'hippie-expand)

(provide 'ks-snippets)
