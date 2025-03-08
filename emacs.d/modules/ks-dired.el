(require 'dired)
(require 'dired-x)

(when (eq system-type 'darwin)
  (require 'ls-lisp)
  (setq ls-lisp-use-insert-directory-program nil))

(setq dired-listing-switches "-lXGh --group-directories-first")
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

(provide 'ks-dired)
