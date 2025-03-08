;; Windows/Systems Management Defaults

(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Turn off welcome screen
(setq inhibit-startup-message t)

;; Move back-ups to temp directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Global Line Numbers
(global-linum-mode t)

;; Unify the emacs kill ring and the clipboad
(setq x-select-enable-clipboard t)

(provide 'ks-wm)
