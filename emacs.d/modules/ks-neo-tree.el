(use-package neotree
  :config
  (global-set-key [f5] 'ks/neotree-project-dir)
  (setq neo-theme 'arrow)
  ;; 'icons
  (setq neo-smart-open t)
  (setq neo-hidden-regexp-list '("^\\." "\\.cs\\.meta$" "\\.pyc$" "~$" "^#.*#$" "\\.elc$" "__pycache__" "venv")))

(defun ks/neotree-project-dir ()
  "Open NeoTree using the git root."
  (interactive)
  (let ((project-dir (projectile-project-root))
        (file-name (buffer-file-name)))
    (neotree-toggle)
    (if project-dir
        (if (neo-global--window-exists-p)
            (progn
              (neotree-dir project-dir)
              (neotree-find file-name)))
      (message "Could not find git project root."))))


(provide 'ks-neo-tree)
