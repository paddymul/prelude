;;;  me -- My base customizations

;;; Commentary:



;;; Code:


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
;(require 'prelude-editor)
(setq prelude-guru nil)
(provide 'me)
;;; me.el ends here
(add-hook 'prelude-prog-mode-hook (lambda () (smartparens-mode -1)) t)
(add-hook 'shell-mode-hook (lambda () (turn-off-show-smartparens-mode)) t)
