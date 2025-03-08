(use-package markdown-mode
  :commands markdown-mode
  :mode (("\\.markdown$" . markdown-mode)
         ("\\.md$"       . markdown-mode)))

(provide 'ks-markdown)
