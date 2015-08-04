; local installation of org-mode
(require 'org-install)
(require 'org)

;; lets add some magit
;;(require 'magit)
;;(require 'magithub)

;; ruby
;; (require 'ri)
;; (require 'ruby-electric)
;; (require 'rinari)
;; (require 'ruby-compilation)
;; (require 'yaml-mode)

;;nXhtml disabled until well defined
;;(load "~/.emacs.d/vendor/nxhtml/autostart.el")

;; some useful modes
(require 'textile-mode)
(require 'markdown-mode)
;;(require 'haml-mode)

(require 'yasnippet) ;; not yasnippet-bundl
(yas/load-directory "~/.emacs.d/snippets")
(yas-global-mode 1)
;(setq yas/fallback-behavior 'return-nil) ;; customized due a bug of yasnippet with tab2key mode

 
;; Autocompletion!
(require 'auto-complete-config)
;;(add-to-list 'ac-dictionary-directories "/Users/miguel/.emacs.d/vendor//ac-dict")
(ac-config-default)

;(require 'rsense)

;; Emacs lisp python 
;;(elpy-enable)

;; emacs for python
;;(require 'epy-setup)      ;; It will setup other loads, it is required!
;(require 'epy-python)     ;; If you want the python facilities [optional]
;(require 'epy-completion) ;; If you want the autocompletion settings [optional]
;;(require 'epy-editing)    ;; For configurations related to editing [optional]
;;(require 'epy-bindings)   ;; For my suggested keybindings [optional]
;;(require 'epy-nose)       ;; For nose integration
;;(epy-setup-ipython)

;; iPython for coding and testin
;;(require 'python)
(require 'ein)
(require 'ein-notebook) 
(require 'ein-dev)
(setq ein:use-auto-complete-superpack t)


; use the wx backend, for both mayavi and matplotlib
(setq py-python-command-args
      '("--gui=osx" "--pylab=inline" "--colors=Linux"))
(setq-default py-shell-name "ipython")
(setq-default py-which-bufname "IPython")
;;(require 'python-mode)
(setq py-force-py-shell-name-p t)


(require 'jira)


;; (require 'eclim)
;; (global-eclim-mode)
;; ;; add the emacs-eclim source
;; (require 'ac-emacs-eclim-source)
;; (ac-emacs-eclim-config)


(require 'org-crypt)
(org-crypt-use-before-save-magic)
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
;; GPG key to use for encryption
;; Either the Key ID or set to nil to use symmetric encryption.
(setq org-crypt-key "0B800927")


