(use-package avy
  :demand t
  :bind (("C-;" . avy-goto-word-1)
         ("C-:" . avy-goto-char))
  :config
  (with-eval-after-load "isearch"
    (define-key isearch-mode-map (kbd "C-;") 'avy-isearch)))

;; Smart home key
(defun smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line."
  (interactive "^")
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (= oldpos (point))
         (beginning-of-line))))
(global-set-key (kbd "C-a") 'smart-beginning-of-line)

(global-subword-mode 1)

(use-package ace-window
  :bind (("C-x o"     . ace-window)
         ("C-x C-o"   . ace-swap-window))
  :config (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package anzu
  :demand t
  :config
  (global-anzu-mode 1)
  :bind (("C-%"   . anzu-query-replace-at-cursor)
         ("M-%"   . anzu-query-replace)
         ("C-M-%" . anzu-query-replace-regexp))
  :diminish anzu-mode)

(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(global-set-key (kbd "C-c b") 'switch-to-previous-buffer)

(provide 'ks-navigation)
