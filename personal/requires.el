; local installation of org-mode
(require 'org-install)
(require 'org)
(require 'org-capture)
(require 'org-protocol)

(add-hook 'org-mode-hook (lambda ()
                           (define-key org-mode-map (kbd "C-c n g") 'org-mac-grab-link)))

(setq org-agenda-overriding-columns-format "%10TODO  %60ITEM  %1PRIORITY %6EFFORT 20%TAGS")


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


;  org-download
(require 'org-download)
(setq-default org-download-image-dir "~/Dropbox/org-images/")
(setq org-download-screenshot-method "/usr/sbin/screencapture -i %s")

;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

;; org-roam
(require 'org-roam)

(define-key org-roam-mode-map (kbd "C-c n l") #'org-roam)
(define-key org-roam-mode-map (kbd "C-c n f") #'org-roam-find-file)
;; (define-key org-roam-mode-map (kbd "C-c n j") #'org-roam-jump-to-index)
;;
(define-key org-roam-mode-map (kbd "C-c n b") #'org-roam-switch-to-buffer)
;; (define-key org-roam-mode-map (kbd "C-c n g") #'bigui/org-roam-create-and-open-graph)
(define-key org-mode-map (kbd "C-c n i") #'org-roam-insert)
(define-key org-mode-map (kbd "C-c n l") #'org-roam)
(define-key org-mode-map (kbd "C-c n f") #'org-roam-find-file)
(define-key org-mode-map (kbd "C-c n c") #'org-ref-helm-insert-cite-link)

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

;;;;;;;;;
;; org-ref and related packages
;;;;;;;;;

(require 'org-ref)
(setq reftex-default-bibliography '("~/Dropbox/references.bibtext"))

(setq org-ref-bibliography-notes "~/Dropbox/Notational Data/biblio-notes.org"
      org-ref-default-bibliography '("~/Dropbox/bibliography/references.bib")
      org-ref-pdf-directory "~/Dropbox/bibliography/bibtex-pdfs/"
      org-ref-get-pdf-filename-function #'org-ref-get-mendeley-filename
      )


(setq bibtex-completion-bibliography "~/Dropbox/bibliography/references.bib"
      bibtex-completion-library-path "~/Users/mcabrera/Library/Application Support/Mendeley Desktop/Downloaded/"
      bibtex-completion-notes-path "~/Dropbox/Notational Data/helm-bibtex-notes.org")


;; open pdf with system pdf viewer (works on mac)
(setq bibtex-completion-pdf-open-function
      (lambda (fpath)
        (start-process "open" "*open*" "open" fpath)))


;; If you installed via MELPA
(require 'org-roam-bibtex)
(add-hook 'after-init-hook #'org-roam-bibtex-mode)
(define-key org-roam-bibtex-mode-map (kbd "C-c n a") #'orb-note-actions)


;; org-roam-server
(require 'org-roam-server)
(setq org-roam-server-host "127.0.0.1"
      org-roam-server-port 8080
      org-roam-server-export-inline-images t
      org-roam-server-authenticate nil
      org-roam-server-network-poll t
      org-roam-server-network-arrows nil
      org-roam-server-network-label-truncate t
      org-roam-server-network-label-truncate-length 60
      org-roam-server-network-label-wrap-length 20)


(require 'org-journal)
(setq
 org-journal-date-prefix "#+TITLE: "
 org-journal-file-format "%Y-%m-%d.org"
 org-journal-dir "~/Dropbox/Notational Data/journal/"
 org-journal-date-format "%A, %d %B %Y"
 org-journal-enable-agenda-integration t
 )
(global-set-key (kbd "C-c C-j") nil)
(global-set-key (kbd "C-c n j")  #'org-journal-new-entry)
