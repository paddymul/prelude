;;;  me -- My base customizations

;;; Commentary:



;;; Code:

(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)



(setq prelude-super-keybindings nil)

(defun insert-line-number ()
  "Insert the current line number into the text."
  (interactive)
  (insert (number-to-string (line-number-at-pos))))


;; You know, like Readline.

(global-set-key (kbd "C-w") 'backward-kill-word)

(global-set-key (kbd "C-x C-k") 'kill-region)

;; hack paddy personal stuff
(require 'term)
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)



(setq display-buffer-fallback-action
      '((  display-buffer-in-previous-window
           display-buffer-reuse-window
         
           display-buffer-use-some-window
           display-buffer--maybe-same-window  ;FIXME: why isn't this redundant?
           display-buffer--maybe-pop-up-frame-or-window
           ;; If all else fails, pop up a new frame.
           display-buffer-pop-up-frame))

      )



;; (defun my-org-mode-hook ()
;;   (let ((oldmap (cdr (assoc 'prelude-mode minor-mode-map-alist)))
;;         (newmap (make-sparse-keymap)))
;;     (set-keymap-parent newmap oldmap)
;;     (define-key newmap (kbd "C-c +") nil)
;;     (define-key newmap (kbd "C-c -") nil)
;;     (make-local-variable 'minor-mode-overriding-map-alist)
;;     (push `(prelude-mode . ,newmap) minor-mode-overriding-map-alist))
;;   )


;; (add-hook 'org-mode-hook 'my-org-mode-hook)


(defun my-smerge-hook ()
  (define-key smerge-mode-map (kbd "C-s n") 'smerge-next)

  ;; (let ((oldmap (cdr (assoc 'smerge-mode minor-mode-map-alist)))
  ;;       (newmap (make-sparse-keymap)))
  ;;   (set-keymap-parent newmap oldmap)
  ;;   (define-key newmap (kbd "C-s n") smerge-next)
  ;;   ;(define-key newmap (kbd "C-s n") nil)
  ;;   ;(define-key newmap (kbd "C-c -") nil)
  ;;   (make-local-variable 'minor-mode-overriding-map-alist)
  ;;   (push `(smerge-mode . ,newmap) minor-mode-overriding-map-alist))

)

(when window-system
  (set-frame-position (selected-frame) 0 0)
  (set-frame-size (selected-frame) 180 100))
(add-hook 'smerge-mode-hook  'my-smerge-hook)




;; `smerge-mode' Minor Mode Bindings:
;; key             binding
;; ---             -------

;; C-c             Prefix Command

;; C-c ^           Prefix Command

;; C-c ^ RET       smerge-keep-current
;; C-c ^ =         Prefix Command
;; C-c ^ C         smerge-combine-with-next
;; C-c ^ E         smerge-ediff
;; C-c ^ R         smerge-refine
;; C-c ^ a         smerge-keep-all
;; C-c ^ b         smerge-keep-base
;; C-c ^ l         smerge-keep-lower
;; C-c ^ m         smerge-keep-upper
;; C-c ^ n         smerge-next
;; C-c ^ o         smerge-keep-lower
;; C-c ^ p         smerge-prev
;; C-c ^ r         smerge-resolve
;; C-c ^ u         smerge-keep-upper

;; C-c ^ = <       smerge-diff-base-upper
;; C-c ^ = =       smerge-diff-upper-lower
;; C-c ^ = >       smerge-diff-base-lower



(defun buffer-exists (buff-name)
  "Determine whether or not a buffer with BUFF-NAME exists."
  (seq-position  (mapcar 'buffer-name (buffer-list))  buff-name))
  ;(find buff-name (mapcar 'buffer-name (buffer-list)) :test 'equal))

(defun shell-with-name (shell-name)
  "Rename current shell to temp, then open a new shell and name it SHELL-NAME."
  (if (and (buffer-exists "*shell*")
           (not (buffer-exists shell-name)))
      (progn
        (switch-to-buffer "*shell*")
        (rename-buffer "temp-shell-*******")
        (shell)
        (rename-buffer shell-name)
        (switch-to-buffer "temp-shell-*******")
        (rename-buffer "*shell*")
        (switch-to-buffer shell-name))))

(defun prompt-for-shell-name (shell-name)
  "Start a shell with SHELL-NAME."
  (interactive "s what do you want to name your new shell? ")
  (shell-with-name shell-name))

(defun new-shell ()
  "Open a new shell with prompting."
  (interactive)
  (if (string-equal (buffer-name) "*shell*")
      (command-execute 'prompt-for-shell-name)
    (shell)))

(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
        ;; This would override `fill-column' if it's an integer.
        (emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))

(global-unset-key (kbd "s-'"))
(global-set-key (kbd "s-;") 'new-shell)

(global-unset-key (kbd "C-z"))





;(global-unset-key (kbd "s-o"))
(global-unset-key (kbd "C-c C-z"))
;(require 'prelude-editor)


                                        ;from stuff removed via merge


;; add the ability to copy and cut the current line, without marking it
;; (defadvice kill-ring-save (before smart-copy activate compile)
;;   "When called interactively with no active region, copy a single line instead."
;;   (interactive
;;    (if mark-active (list (region-beginning) (region-end))
;;      (message "Copied line")
;;      (list (line-beginning-position)
;;            (line-end-position)))))

;; (defadvice kill-region (before smart-cut activate compile)
;;   "When called interactively with no active region, kill a single line instead."
;;   (interactive
;;    (if mark-active (list (region-beginning) (region-end))
;;      (list (line-beginning-position)
;;            (line-beginning-position 2)))))
(defun other-window-kill-window ()
  "Kill the buffer in the other window"
  (interactive)
  ;; Window selection is used because point goes to a different window
  ;; if more than 2 windows are present
  (let ((win-curr (selected-window))
        (win-other (next-window)))
    (select-window win-other)
    (delete-window)
    (select-window win-curr)))

(defun other-window-kill-buffer ()
  "Kill the buffer in the other window"
  (interactive)
  ;; Window selection is used because point goes to a different window
  ;; if more than 2 windows are present
  (let ((win-curr (selected-window))
        (win-other (next-window)))
    (select-window win-other)
    (kill-this-buffer)
    (select-window win-curr)))


(setq prelude-guru nil)
(provide 'me)
;;; me.el ends here
(add-hook 'prelude-prog-mode-hook (lambda () (smartparens-mode -1)) t)
(add-hook 'shell-mode-hook (lambda () (turn-off-show-smartparens-mode)) t)
