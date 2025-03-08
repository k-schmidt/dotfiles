(use-package winner
  :init
  (winner-mode))

(require 'windmove)

(defun hydra-move-splitter-left (arg)
  "Move window splitter left."
  (interactive "p")
  (if (let ((windmove-wrap-around))
    (windmove-find-other-window 'right))
      (shrink-window-horizontally arg)
    (enlarge-window-horizontally arg)))

(defun hydra-move-splitter-right (arg)
  "Move window splitter right."
  (interactive "p")
  (if (let ((windmove-wrap-around))
    (windmove-find-other-window 'right))
      (enlarge-window-horizontally arg)
    (shrink-window-horizontally arg)))

(defun hydra-move-splitter-up (arg)
  "Move window splitter up."
  (interactive "p")
  (if (let ((windmove-wrap-around))
    (windmove-find-other-window 'up))
      (enlarge-window arg)
    (shrink-window arg)))

(defun hydra-move-splitter-down (arg)
  "Move window splitter down."
  (interactive "p")
  (if (let ((windmove-wrap-around))
    (windmove-find-other-window 'up))
      (shrink-window arg)
    (enlarge-window arg)))

(use-package hydra
  :config
  (defhydra hydra-zoom (global-map "<f2>")
    "zoom"
    ("i" text-scale-increase "in")
    ("o" text-scale-decrease "out"))

  (global-set-key (kbd "C-,")
                  (defhydra hydra-vi (:pre (set-cursor-color "#40e0d0")
                                           :post (set-cursor-color "#ffffff"))
                    ("l" forward-char)
                    ("h" backward-char)
                    ("j" next-line)
                    ("k" previous-line)
                    ("q" nil "quit")))
  (global-set-key (kbd "C-.")
                  (defhydra hydra-window-stuff (:hint nil)
                                "
          Split: _v_ert  _s_:horz
         Delete: _c_lose  _o_nly
  Switch Window: _h_:left  _j_:down  _k_:up  _l_:right
        Buffers: _p_revious  _n_ext  _b_:select  _f_ind-file  _F_projectile
         Winner: _u_ndo  _r_edo
         Resize: _H_:splitter left  _J_:splitter down  _K_:splitter up  _L_:splitter right
           Move: _a_:up  _z_:down  _i_menu"


                                ("z" scroll-up-line)
                                ("a" scroll-down-line)
                                ("i" helm-imenu)

                                ("u" winner-undo)
                                ("r" winner-redo)

                                ("h" windmove-left)
                                ("j" windmove-down)
                                ("k" windmove-up)
                                ("l" windmove-right)

                                ("p" previous-buffer)
                                ("n" next-buffer)
                                ("b" ido-switch-buffer)
                                ("f" helm-find-files)
                                ("F" helm-projectile)

                                ("s" split-window-below)
                                ("v" split-window-right)

                                ("c" delete-window)
                                ("o" delete-other-windows)

                                ("H" hydra-move-splitter-left)
                                ("J" hydra-move-splitter-down)
                                ("K" hydra-move-splitter-up)
                                ("L" hydra-move-splitter-right)

                                ("q" nil)))
  (global-set-key (kbd "M-c")
                  (defhydra multiple-cursors-hydra (:hint nil)
                    "
     ^Up^            ^Down^        ^Other^
----------------------------------------------
[_p_]   Next    [_n_]   Next    [_l_] Edit lines
[_P_]   Skip    [_N_]   Skip    [_a_] Mark all
[_M-p_] Unmark  [_M-n_] Unmark  [_r_] Mark by regexp
^ ^             ^ ^             [_q_] Quit
"
       ("l" mc/edit-lines :exit t)
       ("a" mc/mark-all-like-this :exit t)
       ("n" mc/mark-next-like-this)
       ("N" mc/skip-to-next-like-this)
       ("M-n" mc/unmark-next-like-this)
       ("p" mc/mark-previous-like-this)
       ("P" mc/skip-to-previous-like-this)
       ("M-p" mc/unmark-previous-like-this)
       ("r" mc/mark-all-in-region-regexp :exit t)
       ("q" nil))))

(provide 'ks-hydra)
