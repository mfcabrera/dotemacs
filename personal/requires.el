; local installation of org-mode
(require 'org-install)
(require 'org)


(require 'markdown-mode)
;;(require 'haml-mode)

(require 'yasnippet) ;; not yasnippet-bundl
;;(yas/load-directory "~/development/dotemacs/snippets/python-mode")
nil
;;(yas/load-directory "~/development/dotemacs/snippets/org-mode")

(setq yas-snippet-dirs (append yas-snippet-dirs
			       '("~/development/dotemacs/snippets/")))

(yas-global-mode 1)
;(setq yas/fallback-behavior 'return-nil) ;; customized due a bug of yasnippet with tab2key mode

;; Emacs lisp python
(elpy-enable)


(require 'org-crypt)
(org-crypt-use-before-save-magic)
(setq org-crypt-key "mfcabrera@gmail.com")


;; (setq org-tags-exclude-from-inheritance (quote ("crypt")))
