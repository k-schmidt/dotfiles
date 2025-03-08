(use-package haskell-mode
  :config
  (add-hook 'haskell-mode-hook 'haskell-doc-mode)
  (add-hook 'haskell-mode-hook 'haskell-indentation-mode)
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  (add-hook 'haskell-mode-hook 'haskell-decl-scan-mode)
  (add-hook 'haskell-mode-hook 'company-mode)
  (setq haskell-process-type 'stack-ghci)
  (setq haskell-process-path-ghci "stack")
  (setq haskell-process-args-ghci "ghci"))

(use-package flycheck-haskell
  :config
  (eval-after-load 'flycheck
    '(add-hook 'flycheck-mode-hook #'flycheck-haskell-setup)))

(provide 'ks-haskell)
