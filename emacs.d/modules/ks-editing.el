(use-package multiple-cursors
  :commands multiple-cursors-mode
  :bind (("C-S-c C-S-c" . mc/edit-lines)
          ("C-<"         . mc/mark-previous-like-this)
          ("C->"         . mc/mark-next-like-this)
          ("C-c C-<"     . mc/mark-all-like-this)))

(use-package expand-region
  :commands er/expand-region
  :bind ("C-=" . er/expand-region))

(provide 'ks-editing)
