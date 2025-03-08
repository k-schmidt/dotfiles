;; Whitespace cleanup with ethan-wspace

(use-package ethan-wspace
  :demand t
  :commands global-ethan-wspace-mode
  :config (global-ethan-wspace-mode 1)
  :bind ("C-c w" . ethan-wspace-clean-all)
  :diminish ethan-wspace-mode)

(provide 'ks-whitespace)
