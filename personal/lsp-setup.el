(require 'package)



;;;; disabled existing code from prelude-lsp 
;; (require 'lsp-ui)

;; (define-key lsp-ui-mode-map (kbd "C-c C-l .") 'lsp-ui-peek-find-definitions)
;; (define-key lsp-ui-mode-map (kbd "C-c C-l ?") 'lsp-ui-peek-find-references)
;; (define-key lsp-ui-mode-map (kbd "C-c C-l r") 'lsp-rename)
;; (define-key lsp-ui-mode-map (kbd "C-c C-l x") 'lsp-workspace-restart)
;; (define-key lsp-ui-mode-map (kbd "C-c C-l w") 'lsp-ui-peek-find-workspace-symbol)
;; (define-key lsp-ui-mode-map (kbd "C-c C-l i") 'lsp-ui-peek-find-implementation)
;; (define-key lsp-ui-mode-map (kbd "C-c C-l d") 'lsp-describe-thing-at-point)
;; (define-key lsp-ui-mode-map (kbd "C-c C-l e") 'lsp-execute-code-action)

;; (setq lsp-ui-sideline-enable t)
;; (setq lsp-ui-doc-enable t)
;; (setq lsp-ui-peek-enable t)
;; (setq lsp-ui-peek-always-show t)


;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
(helm-mode)
(require 'helm-xref)

;(require 'dap-pyt)
;; (dap-register-debug-template
;;  "My App"
;;  (list :type "python"
;;        :args "-i"
;;        :cwd nil
;;        :env '(("DEBUG" . "1"))
;;        :target-module (expand-file-name "~/src/myapp/.env/bin/myapp")
;;        :request "launch"
;;        :name "My App"))




(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)

(which-key-mode)


(use-package dap-mode
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  :custom
  (lsp-enable-dap-auto-configure nil)
  :config
  
  :commands
  dap-debug
  :config
  ;; Set up Node debugging
  (require 'dap-python)
  (setq dap-python-debugger 'debugpy)
  (dap-ui-mode 1)

)

(use-package lsp-python-ms
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                         (require 'lsp-python-ms)
                         (require 'dap-python)
                         (lsp))))


(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast


;; (add-hook 'c-mode-hook 'lsp)
;; (add-hook 'c++-mode-hook 'lsp)
;; (add-hook 'typescript-mode 'lsp)
;; (add-hook 'javascript-mode 'lsp)

                                        ;(add-hook 'prog-mode-hook #'lsp)
;; (add-hook 'python-mode
;;           (lambda ()
;;             (require 'lsp-python-ms)
;;             (lsp)))


;making room for M-l to be lsp basemap
;(global-unset-key (kbd "M-l"))


(defun pm/lsp-mode-setup ()

  
  (lsp-headerline-breadcrumb-mode)                 ;this seems to have a huge performance gain
  (setq lsp-log-io nil)
  )



(require 'lsp-ui-imenu)


;figure out wider larger which mdoe for lsp mode
(use-package lsp-mode
;  :straight t
  :commands (lsp lsp-deferred)
  :hook
  (lsp-mode . pm/lsp-mode-setup)
  ((python-mode . lsp))
  ((typescript-mode js2-mode web-mode) . lsp)
  :init
  (setq lsp-keymap-prefix (kbd "M-l"))
 )

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :commands lsp-ui-mode
  :config
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)

  (setq lsp-ui-doc-position 'bottom)

)


(use-package typescript-mode
  :mode "\\.ts\\'"
  :config
  (setq typescript-indent-level 2))

;; (defun dw/set-js-indentation ()
;;   (setq js-indent-level 2)
;;   (setq evil-shift-width js-indent-level)
;;   (setq-default tab-width 2))

(use-package js2-mode
  :mode "\\.jsx?\\'"
  :config
  ;; Use js2-mode for Node scripts
  (add-to-list 'magic-mode-alist '("#!/usr/bin/env node" . js2-mode))

  ;; Don't use built-in syntax checking
  (setq js2-mode-show-strict-warnings nil)

  ;; Set up proper indentation in JavaScript and JSON files
  (add-hook 'js2-mode-hook #'dw/set-js-indentation)
  (add-hook 'json-mode-hook #'dw/set-js-indentation))


;; (use-package apheleia
;;   :config
;;   (apheleia-global-mode +1))

(use-package prettier-js
  ;; :hook ((js2-mode . prettier-js-mode)
  ;;        (typescript-mode . prettier-js-mode))
  :config
  (setq prettier-js-show-errors nil))





(require 'use-package)





(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (require 'dap-chrome)
  (yas-global-mode))


;(setq lsp-log-io 't )

;setting company-idle-delay to 1.5 makes it much less likel that slow
;company-mode completions will delay my typing
;(setq company-idle-delay .75)
(setq company-idle-delay 0)

