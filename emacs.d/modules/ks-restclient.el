(use-package restclient
  :mode (("\\.http$" . restclient-mode))
  :config
  (with-eval-after-load "ks-helm"
    (use-package restclient-helm))
  (add-to-list 'company-backends 'company-restclient))

(provide 'ks-restclient)
