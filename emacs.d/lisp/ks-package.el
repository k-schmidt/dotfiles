;;; ks-package.el --- Package system configuration

;; Load Modules
(setq ks/available-modules
      '(ks-appearance
        ks-clojure
        ks-complete
        ks-counsel
        ks-dired
        ks-docker
        ks-dot
        ks-editing
        ;;ks-email
        ks-eshell
        ks-flycheck
        ks-go
        ks-haskell
        ks-helm
        ks-help
        ks-html
        ks-hydra
        ks-ido
        ;;ks-ivy
        ks-java
        ks-javascript
        ks-json
        ks-lisp
        ks-magit
        ks-markdown
        ks-mode-line
        ks-navigation
        ks-neo-tree
        ks-org
        ks-project
        ks-python
        ks-restclient
        ks-snippets
        ks-whitespace
        ks-yaml))

(defun ks/load-modules ()
  (interactive)
  (dolist (module ks/available-modules) (require module nil t)))

(provide 'ks-package)
