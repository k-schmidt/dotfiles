;; Editing Management Defaults

;; Unicode FTW
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")
(setq current-language-environment "UTF-8")

;; Turn on font-locking globally
(global-font-lock-mode t)

;; Cursor-style setting functions
(defun set-cursor-type (cursor)
  "Modify the cursor to the specified type"
  (interactive "Cursor type (bar, box, etc.): ")
  (modify-frame-parameters
   (selected-frame)
   (list (cons 'cursor-type (intern cursor)))))

(defun set-bar-cursor ()
  "Change the cursor to a bar rather than the (default) box"
  (interactive)
  (set-cursor-type "bar"))

(defun set-box-cursor ()
  "Change the cursor to a box (the default style)"
  (interactive)
  (set-cursor-type "box"))

(set-box-cursor)

;; Stop blinking cursor
(blink-cursor-mode 0)

;; Set default major-mode
(setq-default major-mode 'text-mode)

;; Recognize single spaces at end of sentence
(setq sentence-end-double-space nil)

;; Tab indentation
(set-default 'indent-tabs-mode nil)

;; Always indent after a newline.
(define-key global-map (kbd "RET") 'newline-and-indent)

(setq mode-require-final-newline nil)
(setq require-final-newline nil)

(setq-default tab-width 4)

;; Python indent defaults
(setq-default py-indent-offset 2)

(provide 'ks-em)
