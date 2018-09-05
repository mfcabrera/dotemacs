; local installation of org-mode
(require 'org-install)
(require 'org)
(require 'org-capture)
(require 'org-protocol)




(require 'markdown-mode)
;;(require 'haml-mode)

(require 'yasnippet)

(setq yas-snippet-dirs (append yas-snippet-dirs
			       '("~/development_personal/dotemacs/snippets/")))

(yas-global-mode 1)
;(setq yas/fallback-behavior 'return-nil) ;; customized due a bug of yasnippet with tab2key mode

;; Emacs lisp python
(elpy-enable)


(require 'org-crypt)
(org-crypt-use-before-save-magic)
(setq org-crypt-key "mfcabrera@gmail.com")

;; Helm mode configuration
(helm-mode 1)
(require 'prelude-helm-everywhere)
;; So that Org-Refile works properly
(setq org-completion-use-ido nil)
(setq org-outline-path-complete-in-steps nil)

;; OB-IPYTHON things
;(require 'ob-ipython)
(setq org-confirm-babel-evaluate nil)   ;don't prompt me to confirm everytime I want to evaluate a block
;;; display/update images in the buffer after I evaluate

(require 'ox-freemind)
(require 'ox-html)


;; require extra modules
(require 'prelude-company)
(require 'prelude-js)

;; require checks
(require 'flycheck-demjsonlint)
(require 'flycheck-mypy)
(eval-after-load 'flymake '(require 'flymake-mypy))


(require 'browse-at-remote)
