(global-set-key (kbd "C-c e") 'eshell)

(require 'eshell)
(require 'em-smart)

(setq eshell-where-to-jump 'begin)
(setq eshell-review-quick-commands nil)
(setq eshell-smart-space-goes-to-end t)

(setq eshell-visual-commands
      '("less" "screen" "htop" "top" "bash"))
(setq eshell-visual-subcommands
      '(("git" "log" "diff" "show")))

(use-package eshell-git-prompt
  :config
  (eshell-git-prompt-use-theme 'robbyrussell))

(setq eshell-cmpl-cycle-completions nil)

(provide 'ks-eshell)
