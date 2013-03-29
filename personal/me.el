(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)

(defun insert-line-number ()
  (interactive)
  (insert (number-to-string (line-number-at-pos)))

  )


;; You know, like Readline.

(global-set-key (kbd "C-w") 'backward-kill-word)

(global-set-key (kbd "C-x C-k") 'kill-region)

;; hack paddy personal stuff
(require 'term)
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


(defun buffer-exists (buff-name)
  (find buff-name (mapcar 'buffer-name (buffer-list)) :test 'equal))

(defun shell-with-name (shell-name)
  "we only want to run this if both buffers exist"
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
  (interactive "s what do you want to name your new shell? ")
  (shell-with-name shell-name))

(defun new-shell ()
  (interactive)
  (if (string-equal (buffer-name) "*shell*")
      (command-execute 'prompt-for-shell-name)
    (shell)))

(global-unset-key (kbd "s-'"))
(global-set-key (kbd "s-;") 'new-shell)
(setq prelude-guru nil)

