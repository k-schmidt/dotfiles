;; Kyle's Emacs Config


;; Initialize the package system first of all
(package-initialize)

;; Skip the default splash screen
(setq inhibit-startup-message t)

;; Figure out the path to our .emacs.d by getting the path part of the
;; current file (`init.el`).
(setq dotfiles-dir (file-name-directory
            (or (buffer-file-name) (file-chase-links load-file-name))))

;; Lisp library packages
(add-to-list 'load-path (concat dotfiles-dir "lisp"))

;; Modules
(add-to-list 'load-path (concat dotfiles-dir "modules"))

;; `(online?)` is a function that tries to detect whether you are online.
;; We want to refresh our package list on Emacs start if we are.

(require 'cl)
(defun online? ()
  (if (and (functionp 'network-interface-list)
           (network-interface-list))
      (some (lambda (iface) (unless (equal "lo" (car iface))
                              (member 'up (first (last (network-interface-info
                                                        (car iface)))))))
            (network-interface-list))
    t))

;; Package Manager
(setq package-user-dir (concat dotfiles-dir "elpa"))
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org"   . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("gnu"   . "http://elpa.gnu.org/packages/") t)

;; Get the package manager going
(package-initialize)

;; Only fetch packages when we are online
(when (online?)
  (unless package-archive-contents (package-refresh-contents)))

;; `Paradox` - enhanced interface for package management
(when (not (package-installed-p 'paradox))
  (package-install 'paradox))

(when (not (package-installed-p 'use-package))
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(setq custom-file (concat dotfiles-dir "ks-custom.el"))
(load custom-file 'noerror)

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;; Load the Lisp Emacs fundamentals.
(require 'ks-wm)
(require 'ks-em)
(require 'ks-lib)
(require 'ks-package)

(ks/load-modules)

;; Load executables
(executable-find "mysql")
