(require 'ks-package)

(use-package company
  :demand t
  :commands company-mode
  :config
  (global-company-mode)
  (setq company-global-modes '(not term-mode))
  (setq company-minimum-prefix-length 2
        company-selection-wrap-around t
        company-show-numbers t
        company-tooltip-align-annotations t
        company-require-match nil
        company-dabbrev-downcase nil
        company-dabbrev-ignore-case nil)
  (setq company-transformers '(company-sort-by-occurrence))

  (use-package company-quickhelp
    :config
    (setq company-quickhelp-delay 1)
    (company-quickhelp-mode 1))

  (use-package company-jedi
    :config
    (defun ks/python-mode-hook ()
      (add-to-list 'company-backends 'company-jedi))

    (add-hook 'python-mode-hook 'ks/python-mode-hook)
    (with-eval-after-load "python"
      (define-key python-mode-map (kbd "C-c .") 'jedi:goto-definition)))

  (use-package company-try-hard
    :commands company-try-hard
    :bind ("C-\\" . company-try-hard)
    :config
    (bind-keys :map company-active-map
               ("C-\\" . company-try-hard)))
  :diminish company-mode)

(provide 'ks-complete)
