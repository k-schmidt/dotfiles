(use-package cider
  :ensure t
  :config
  (setq cider-repl-history-file "~/.emacs.d/cider-history")
  (setq cider-repl-use-pretty-printing t)
  (setq cider-repl-use-clojure-font-lock t)
  (setq cider-repl-result-prefix ";; => ")
  (setq cider-repl-wrap-history t)
  (setq cider-repl-history-size 3000)
  (add-hook 'cider-mode-hook #'eldoc-mode)
  (setq cider-show-error-buffer nil))

(use-package clj-refactor
  :ensure t
  :config
  (add-hook 'clojure-mode-hook
            (lambda ()
              (clj-refactor-mode 1)
              (cljr-add-keybindings-with-prefix "C-c RET")))
  (add-hook 'clojure-mode-hook #'yas-minor-mode)
  (setq cljr-auto-sort-ns nil)
  (setq cljr-prefix-notation nil))

(use-package let-alist
  :ensure t)

(use-package flycheck-clojure
  :ensure t
  :config
  (eval-after-load 'flycheck '(flycheck-clojure-setup))
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package hl-sexp
  :ensure t
  :config
  (add-hook 'clojure-mode-hook #'hl-sexp-mode)
  (add-hook 'lisp-mode-hook #'hl-sexp-mode)
  (add-hook 'emacs-lisp-mode-hook #'hl-sexp-mode))

(use-package paredit
  :ensure t
  :config
  (add-hook 'lisp-mode-hook #'paredit-mode)
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
  (add-hook 'clojure-mode-hook #'paredit-mode)
  (add-hook 'cider-repl-mode-hook #'paredit-mode))

(provide 'ks-clojure)
