(use-package org
  :ensure org-plus-contrib
  :init (setq org-agenda-files
          (delq nil
            (mapcar (lambda (x) (and (file-exists-p x) x))
                '("~/Dropbox/Org-Files/taskdiary.org")))
          org-tag-alist '((:startgroup . nil)
                  ("@work"     . ?w)
                  ("@home"     . ?h)
                  (:endgroup   . nil)
                  ("education" . ?r)
                  ("finance"   . ?f)
                  ("phone"     . ?p))
          org-directory "~/Dropbox/Org-Files"
          org-mobile-inbox-for-pull "~/Dropbox/Org-Files/mobile-flagged.org"
          org-mobile-directory "~/Dropbox/Apps/MobileOrg"
          org-todo-keywords '((sequence "BLOCKED(b)" "TODO(t)" "INPROGRESS(i)" "COMPLETED(c)"))
          org-todo-keyword-faces '(("BLOCKED"    . (:foreground "black" :weight bold))
                       ("TODO"       . org-todo)
                       ("INPROGRESS" . (:foreground "orange" :background "yellow" :weight bold))
                       ("COMPLETED"  . org-done))
          org-log-done 'time
          org-capture-templates
          '(("t" "Task Diary" entry
         (file+datetree
          "~/Dropbox/Org-Files/taskdiary.org")
         "* TODO %^{Description} %^g\n %?\n Added: %U")
        ("a" "Appointment" entry
         (file+headline
          "~/Dropbox/Org-Files/taskdiary.org" "Calendar")
         "* APPT %^{Description} %^g\n %?\n Added: %U")
        ("n" "Notes" entry
         (file+datetree "~/Dropbox/Org-Files/taskdiary.org")
         "* %^{Description} %^g %?\n Added: %U")
        ("j" "Journal" entry
         (file+datetree
          "~/Dropbox/Org-Files/journal.org")
         "** %^{Heading}")
        ("l" "Log Time" entry
         (file+datetree
          "~/Dropbox/Org-Files/timelog.org")
         "** %U - %^{Activity}  :TIME:")))
  :bind (("C-c l" . org-store-link)
     ("C-c a" . org-agenda)
     ("C-c c" . org-capture)
     ("C-c b" . org-iswitchb))
  :config
  (add-hook
   'org-mode-hook
   (lambda ()
     (visual-line-mode 1)))
  (use-package org-bullets
    :config
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((dot  .  t))))

(use-package ox-reveal
  :config
  (setq org-reveal-root "file:///home//kyleschmidt/Dropbox/reveal.js-master"))

(provide 'ks-org)
