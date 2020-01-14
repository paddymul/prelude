;;;  me -- My base customizations

;;; Commentary:



;;; Code:

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)


(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)

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


(defun buffer-exists (buff-name)
  "Determine whether or not a buffer with BUFF-NAME exists."
  (find buff-name (mapcar 'buffer-name (buffer-list)) :test 'equal))

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

(add-to-list 'display-buffer-alist
             '("^\\*shell\\*$" . (display-buffer-same-window))

             )
(add-to-list 'display-buffer-alist
             '(".*el$" . (display-buffer-same-window))
             )
(add-to-list 'display-buffer-alist
             '("^\\*help\\*$" . (display-buffer-use-some-window)))


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
(global-unset-key (kbd "C-c C-z"))

(defun interrupting-flymake-start-syntax-check (base-function)
  (when (and (boundp 'flymake-syntax-check-process) (process-live-p flymake-syntax-check-process))
    (setq flymake-check-was-interrupted t)
    (flymake-kill-process flymake-syntax-check-process))
  (funcall base-function)
  (let ((proc (car flymake-processes)))
    (set-process-query-on-exit-flag proc nil)
    (set (make-local-variable 'flymake-syntax-check-process) proc)
    (setq flymake-check-was-interrupted t)
    (setq flymake-is-running nil)))
(advice-add 'flymake-start-syntax-check :around #'interrupting-flymake-start-syntax-check)

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




(setq prelude-guru nil)


; disable ido0mode for write file
(define-key (cdr ido-minor-mode-map-entry) [remap write-file] nil)


;;; me.el ends here
(put 'smex 'shell 'ido 'ignore)
(defadvice ido-read-buffer (around ido-read-buffer-possibly-ignore activate)
  "Check to see if use wanted to avoid using ido"
  (if (eq (get this-command 'ido) 'ignore)
      (let ((read-buffer-function nil))
        (run-hook-with-args 'ido-before-fallback-functions 'read-buffer)
        (setq ad-return-value (apply 'read-buffer (ad-get-args 0))))
    ad-do-it))



(provide 'me)
;;; me.el ends here
(add-hook 'prelude-prog-mode-hook (lambda () (smartparens-mode -1)) t)
(add-hook 'shell-mode-hook (lambda () (turn-off-show-smartparens-mode)) t)
