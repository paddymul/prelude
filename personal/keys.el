;;;  package -- summary

;;; Commentary:


(print emacs-version)

(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)
(setq prelude-super-keybindings nil)


;;; Code:
(prin1 "keys.el")
(global-set-key (kbd "s-'") 'shell)
(global-set-key (kbd "s-0") 'other-window-kill-window)
(global-set-key (kbd "s-9") 'other-window-kill-buffer)

(global-set-key (kbd "s-w") (lambda ()
                              (interactive)
                              (delete-window))) ;; back one


;(global-unset-key (kbd "s-o"))
(global-set-key (kbd "s-o") (lambda ()
                              (interactive)
                              (other-window -1))) ;; back one
(global-set-key (kbd "C-M-o") (lambda ()
                              (interactive)
                              (other-window -1))) ;; back one

(global-set-key (kbd "s-O") (lambda ()
                              (interactive)
                              (other-window 1))) ;; forward one

;;;;;window movement keys
(defun _paddy-enlarge-window-horizontal ()
  "Make the current window shorter."
  (interactive)
  (enlarge-window 1 1))

(defun _paddy-shrink-window-horizontal ()
  "Make the current window narrower."
  (interactive)
  (shrink-window 1 1))

(global-unset-key (kbd "M-`") )


;; want to move all of these window bindings to "M-s-???"
(global-set-key (kbd "s-P") 'enlarge-window)
(global-set-key (kbd "s-p") 'windmove-up)
(global-set-key (kbd "s-N") 'shrink-window)
(global-set-key (kbd "s-n") 'windmove-down)
(global-set-key (kbd "s-F") '_paddy-enlarge-window-horizontal)
(global-set-key (kbd "s-f") 'windmove-right)
(global-set-key (kbd "s-B") '_paddy-shrink-window-horizontal)

(global-set-key (kbd "s-w") 'delete-window)
(global-set-key (kbd "s-o") 'other-window)


(global-set-key (kbd "s-r") 'rgrep)
(global-set-key (kbd "s-g") 'magit-status)
(global-set-key (kbd "s-w") 'delete-window)
(global-set-key (kbd "s-=") 'balance-windows)
(global-set-key (kbd "s-b") 'ivy-switch-buffer)


; want a function that rotates the case of word, not important, rarely use this
(global-set-key (kbd "M-L") 'downcase-word)

(global-set-key (kbd "C-S-k") 'paddy-kill-from-begining-of-line)
(global-set-key (kbd "C-s-f") 'paddy-put-buffer-filename-in-killring)
(global-set-key (kbd "s-C-x C-k") 'copy-region-as-kill)
(global-set-key (kbd "s-M-f") 'find-file-at-point)
(global-set-key (kbd "C-x C-M-f") 'find-file-other-window)

(global-set-key (kbd "M-[")  'xref-find-definitions)
(global-set-key (kbd "M-]")  'xref-find-references)


;; (defadvice kill-region (before slick-cut activate compile)
;;   "When called interactively with no active region, kill a single line instead."
;;   (interactive
;;    (if mark-active (list (region-beginning) (region-end))
;;      (list (line-beginning-position)
;;            (line-beginning-position 2)))))

;; (defadvice kill-region (before slick-cut activate compile)
;;   "When called interactively with no active region, kill a single line instead."
;;   (interactive
;;    (if buffer-read-only
;;        (call-interactively 'copy-region-as-kill )
;;      ad-do-it
;;      )))


(provide 'keys)
;;; keys.el ends here
