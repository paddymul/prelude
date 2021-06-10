(require 'package)
;(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

;; (setq package-selected-packages
;;       '(
;;         lsp-mode yasnippet lsp-treemacs helm-lsp
;;                  projectile hydra flycheck company avy
;;                  which-key helm-xref dap-mode  json-mode))

;; (when (cl-find-if-not #'package-installed-p package-selected-packages)
;;   (package-refresh-contents)
;;   (mapc #'package-install package-selected-packages))

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
;; (add-hook 'c-mode-hook 'lsp)
;; (add-hook 'c++-mode-hook 'lsp)
(add-hook 'prog-mode-hook #'lsp)
;; (add-hook 'python-mode
;;           (lambda ()
;;             (require 'lsp-python-ms)
;;             (lsp)))


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

(use-package lsp-mode
  :hook
  ((python-mode . lsp)) )
(use-package lsp-ui
   :commands lsp-ui-mode)


(require 'use-package)





(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (require 'dap-chrome)
  (yas-global-mode))
