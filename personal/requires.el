; local installation of org-mode
(require 'org-install)
(require 'org)
(require 'org-capture)
(require 'org-protocol)


(require 'markdown-mode)
(require 'yasnippet)

(setq yas-snippet-dirs (append yas-snippet-dirs
			       '("~/development_personal/dotemacs/snippets/")))

(yas-global-mode 1)

;; Emacs lisp python
(elpy-enable)


(require 'org-crypt)
(org-crypt-use-before-save-magic)
(setq org-crypt-key "mfcabrera@gmail.com")

;; Helm mode configuration
(helm-mode 1)
(require 'prelude-helm-everywhere)
;; So that Org-Refile works properly and helm is used
(setq org-completion-use-ido nil)
(setq org-outline-path-complete-in-steps nil)

;; OB-IPYTHON things
;(require 'ob-ipython)
(setq org-confirm-babel-evaluate nil)   ;don't prompt me to confirm everytime I want to evaluate a block
;;; display/update images in the buffer after I evaluate

;; require extra modules
(require 'prelude-company)
(require 'prelude-js)

;; require checks
(require 'flycheck-demjsonlint)
(require 'browse-at-remote)

;; all the icons and neotree integration
(require 'all-the-icons)
(setq neo-theme (if window-system 'icons 'nerd)) ; 'classic, 'nerd, 'ascii, 'arrow

(eval-after-load "prelude-mode"
  '(define-key prelude-mode-map (kbd "C-c n") nil))



(require 'org-download)
(setq-default org-download-image-dir "~/Dropbox/org-images/")
(setq org-download-screenshot-method "/usr/sbin/screencapture -i %s")

;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)


(require 'org-roam)

(define-key org-roam-mode-map (kbd "C-c n l") #'org-roam)
(define-key org-roam-mode-map (kbd "C-c n f") #'org-roam-find-file)
(define-key org-roam-mode-map (kbd "C-c n j") #'org-roam-jump-to-index)
(define-key org-roam-mode-map (kbd "C-c n b") #'org-roam-switch-to-buffer)
(define-key org-roam-mode-map (kbd "C-c n g") #'bigui/org-roam-create-and-open-graph)
(define-key org-mode-map (kbd "C-c n i") #'org-roam-insert)
(define-key org-mode-map (kbd "C-c n l") #'org-roam)
(define-key org-mode-map (kbd "C-c n f") #'org-roam-find-file)

(org-roam-mode +1)


(require 'org-jira)
(setq jiralib-url "https://newyorkerfashion.atlassian.net/")
;; (setq jiralib-url "https://newyorkerfashion.atlassian.net/jira/software")


(setq org-jira-custom-jqls
      '(
        (:jql " assignee = 5a0a8201b473181bae3dc2fe and status = Doing " ;; currently working on jira
                 :limit 10
              :filename "~/Dropbox/Notational Data/org/work-jira")

        ))
