(use-package smtpmail-multi
  :config
  (setq smtpmail-multi-accounts
        '((personal . ("kyle.a.schmidt@gmail.com"
                       "smtp.gmail.com"
                       587
                       "kyle.a.schmidt@gmail.com"
                       starttls
                       nil nil nil))
          (kepler   . ("kschmidt@keplergrp.com"
                       "smtp.gmail.com"
                       587
                       "kschmidt@keplergrp.com"
                       starttls
                       nil nil nil))))
  (setq smtpmail-multi-associations
        '(("kyle.a.schmidt@gmail.com" personal)
          ("kschmidt@keplergrp.com" kepler)))
  (setq smtpmail-multi-default-account '(personal))
  (setq message-send-mail-function 'smtpmail-multi-send-it)
  (setq smtpmail-debug-info t)
  (setq smtpmail-debug-verbose t))

(use-package mu4e
  :load-path "/usr/local/share/emacs/site-lisp/mu4e"
  :bind ("C-x m" . mu4e)
  :init
  :config
  (require 'org-mu4e)
  (setq mu4e-contexts
        `(,(make-mu4e-context
            :name "personal"
            :match-func (lambda (msg)
                          (when msg
                            (mu4e-message-contact-field-matches msg
                                                                :to "kyle.a.schmidt@gmail.com")))
            :enter-func (lambda () (mu4e-message "Entering Personal context"))
            :leave-func (lambda () (progn (mu4e-clear-caches)
                                          (mu4e-message "Leaving Personal context")))
            :vars '((mu4e-maildir . "~/Dropbox/mail/personal")
                    (mu4e-mu-home . "~/.mu/personal")
                    (mu4e-get-mail-command . "offlineimap -a personal")
                    (user-mail-address . "kyle.a.schmidt@gmail.com")
                    (user-full-name     . "Kyle Schmidt")))
          ,(make-mu4e-context
            :name "kepler"
            :match-func (lambda (msg)
                          (when msg
                            (mu4e-message-contact-field-matches msg
                                                                :to "kschmidt@keplergrp.com")))
            :enter-func (lambda () (mu4e-message "Entering Kepler context"))
            :leave-func (lambda () (progn (mu4e-clear-caches)
                                          (mu4e-message "Leaving Kepler context")))
            :vars '((mu4e-maildir . "~/Dropbox/mail/kepler")
                    (mu4e-mu-home . "~/.mu/kepler")
                    (mu4e-get-mail-command . "offlineimap -a kepler")
                    (user-mail-address . "kschmidt@keplergrp.com")
                    (user-full-name    . "Kyle Schmidt")))))

  (setq mu4e-sent-messages-behavior 'delete)
  (setq mu4e-html2text-command 'ks/html-message)
  (setq mu4e-update-interval 180)
  (add-hook 'message-send-hook 'mml-secure-message-sign-pgpmime)
  (setq org-mu4e-link-query-in-headers-mode nil)

  (add-hook 'mu4e-compose-mode-hook
            (defun my-setup-epa-hook ()
              (epa-mail-mode)))

  (add-hook 'mu4e-view-mode-hook
            (defun my-view-mode-hook ()
              (epa-mail-mode)))

  (defun ks/html-message ()
    (let ((dom (libxml-parse-html-region (point-min) (point-max))))
      (erase-buffer)
      (shr-insert-document dom)
      (goto-char (point-min)))))

(provide 'ks-email)
