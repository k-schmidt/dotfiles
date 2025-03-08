(use-package f)
(use-package s)

(defun ks/exec (command)
  "Run a shell command and return its output as a string, whitespace trimmed."
  (s-trim (shell-command-to-string command)))

(defun ks/exec-with-rc (command &rest args)
  "Run a shell command and return a list containing two values: its return
code and its whitespace trimmed output."
  (with-temp-buffer
    (list (apply 'call-process command nil (current-buffer) nil args)
          (s-trim (buffer-string)))))

(defun ks/is-exec (command)
  "Returns true if `command' is an executable on the system search path."
  (f-executable? (s-trim (shell-command-to-string (s-concat "which " command)))))

(defun ks/resolve-exec (command)
  "If `command' is an executable on the system search path, return its absolute path.
Otherwise, return nil."
  (-let [path (s-trim (shell-command-to-string (s-concat "which " command)))]
    (when (f-executable? path) path)))

(defun ks/exec-if-exec (command args)
  "If `command' satisfies `ks/is-exec', run it with `args' and return its
output as per `ks/exec'. Otherwise, return nil."
  (when (ks/is-exec command) (ks/exec (s-concat command " " args))))

(defun ks/create-directory (directory-name)
  "Create a directory if it does not exist"
  (unless (file-exists-p directory-name)
    (make-directory directory-name)))

(provide 'ks-lib)
