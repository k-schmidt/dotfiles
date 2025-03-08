;;(require 'nvm)
;;(nvm-use (caar (last (nvm--installed-versions))))

(use-package web-mode
  :mode (
         ("\\.html?\\'"     . web-mode)
         ("\\.phtml\\'"     . web-mode)
         ("\\.tpl\\.php\\'" . web-mode)
         ("\\.[agj]sp\\'"   . web-mode)
         ("\\.as[cp]x\\'"   . web-mode)
         ("\\.erb\\'"       . web-mode)
         ("\\.mustache\\'"  . web-mode)
         ("\\.djhtml\\'"    . web-mode))
  :config
  (setq-default web-mode-enable-current-element-highlight t)
  (bind-keys :map web-mode-map
             ("C-c C-r" . 'mc/mark-sgml-tag-pair))
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2))

(use-package rainbow-mode
  :config
  (dolist (mode '(css-mode less-css-mode html-mode web-mode))
    (add-hook (intern (concat (symbol-name mode) "-hook"))
              (lambda () (rainbow-mode))))
  :diminish rainbow-mode)

(provide 'ks-html)
