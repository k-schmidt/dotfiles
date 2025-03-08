;; Help for easy on the fly documentation

(use-package which-key
  :commands which-key-mode
  :demand t
  :config
  (which-key-mode)
  (setq-default which-key-idle-delay 2.0)
  (setq-default which-key-special-keys nil)
  :bind ("C-h C-k" . which-key-show-top-level)
  :diminish which-key-mode)

(use-package discover-my-major
  :commands (discover-my-major discover-my-mode)
  :bind ("C-h C-m" . discover-my-major))

(provide 'ks-help)
