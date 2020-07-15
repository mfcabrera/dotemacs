;; orgy.el  - Personal customization to org-mode

;;helper function for DRYing the creation of paths for org-mode files acrross systems
;;Need to have previously defined the variables *ORG-FILES-PATH* (i.e. in .emacs)

;; Log into a drawer instead of flodding
(setq org-log-into-drawer t)

(defun mike/refile-to (file headline)
    "Move current headline to specified location"
    (let ((pos (save-excursion
                 (find-file file)
                 (org-find-exact-headline-in-buffer headline))))
      (org-refile nil nil (list headline file nil pos))))

(setq org-stuck-projects
      '("+PROJECT+current/-DONE" ("NEXT" "TODO") ("someday")  "SCHEDULED:\\|DEADLINE:" ))

;; recursively find .org files in provided directory
;; modified from an Emacs Lisp Intro example
(defun sa-find-org-file-recursively (directory &optional filext)
  "Return .org and .org_archive files recursively from DIRECTORY.
If FILEXT is provided, return files with extension FILEXT instead."
  ;; FIXME: interactively prompting for directory and file extension
  (let* (org-file-list
	 (case-fold-search t)		; filesystems are case sensitive
	 (file-name-regex "^[^.#].*")	; exclude .*
	 (filext (if filext filext "org$\\\|org_archive"))
	 (fileregex (format "%s\\.\\(%s$\\)" file-name-regex filext))
	 (cur-dir-list (directory-files directory t file-name-regex)))
    ;; loop over directory listing
    (dolist (file-or-dir cur-dir-list org-file-list) ; returns org-file-list
      (cond
       ((file-regular-p file-or-dir) ; regular files
	(if (and  (string-match fileregex file-or-dir) (not (string-match "blog.org.txt" file-or-dir))) ; org files but not blog entries
	    (add-to-list 'org-file-list file-or-dir))
        )
       ((file-directory-p file-or-dir)
	(dolist (org-file (sa-find-org-file-recursively file-or-dir filext)
			  org-file-list) ; add files found to result
	  (add-to-list 'org-file-list org-file)))))))

(setq org-agenda-files (append (sa-find-org-file-recursively "~/Dropbox/Notational Data/org/" "org")))

(setq WORK-FILES  (append   '("~/Dropbox/Notational Data/org/work.org" "~/Dropbox/Notational Data/org/work-jira.org"  )  )  )


(define-key global-map "\C-cc" 'org-capture)
;; notes for capture

(setq org-default-notes-file  (concat "~/Dropbox/Notational Data/org/" "Inbox.org" ))
(setq org-default-work-file  (concat "~/Dropbox/Notational Data/org/" "work.org" ))
(setq org-default-learning-file  (concat "~/Dropbox/Notational Data/org/" "learning.org" ))

(setq  org-columns-default-format "%25ITEM %TODO %3PRIORITY %TAGS Effort")


(setq org-capture-templates
      '(("l" "Link" entry
         (file+headline org-default-notes-file "Links")
         "* %a\n %?\n %i" :immediate-finish 1)
        ("t" "Todo" entry (file+headline  org-default-notes-file "TASKS")
         "* TODO %?\n SCHEDULED:%t\n  %i\n")
        ("w" "Todo - Work" entry (file+headline  org-default-work-file "Misc Tasks")
         "* TODO %?\n SCHEDULED:%t\n  %i\n")
        ("v" "Talk to Watch" entry (file+headline  org-default-learning-file "VideoQueue")
         "* %?\n %i\n")
        ("T" "Todo (with link)" entry (file+headline  org-default-notes-file "TASKS")
         "* TODO %?\n SCHEDULED:%t\n  %a\n %i\n")
        ("m" "Task from Email" entry
         (file+headline org-default-notes-file "Emails")
         "* TODO  %a  :email: \n
           SCHEDULED:%t\n
           [[message://%l][Email]]
         " :immediate-finish 1)
        ("x" "Work task from Email" entry
         (file+headline org-default-work-file "Emails")
         "* TODO  %a  :email: \n
           SCHEDULED:%t\n
           [[message://%l][Email]]
         " :immediate-finish 1)
        ("b" "Idea forBlog" entry (file+headline "~/Dropbox/Notational Data/blog-ideas.org.txt" "Ideas")
         "* %?\n %i")
        )
      )

(add-to-list 'org-modules 'org-habit)
(add-to-list 'org-modules 'org-checklist)

;; Colors and Faces
;; Many of this configuration is pretty old and not used
;; yet I will keep it here for reference if I ever use org-mode
;; as I used to

(setq org-todo-keyword-faces
      '(
        ("WAITING"  . (:foreground "white" :weight bold))
        ("STARTED"  . (:foreground "orange" :weight bold))
        ("IN-PROGRESS"  . (:foreground "orange" :weight bold))
        ("NEXT-WEEK"  . (:foreground "white" :weight bold))
        ("THIS-WEEK"  . (:foreground "yellow" :weight bold))
        ("PARTIAL"  . (:foreground "orange" :weight bold))
        ("NEXT"  .  org-warning)
        ("DONE"  .  (:foreground "lightgreen" :weight bold))
        ("COMPLETED"  .  (:foreground "lightgreen" :weight bold))
        ("CANCELED"  . (:foreground "red" :weight bold))
        ("FAILED"  . (:foreground "red" :weight bold))
        ))


(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "|"  "DONE" )))
;; Highlights the current line in agenda buffers
(add-hook 'org-agenda-mode-hook '(lambda () (hl-line-mode 1)))


;; Org Mode Behaviour
;; Avoid tags inheritance for specific tags
(setq org-tags-exclude-from-inheritance '("PROJECT" "CURRENT" "project" "current" "NOTE" "SERVER" "NEXT" "PLANNED" "AREA" "META" "NEXT" "crypt" "desparche" "writing" "reading"))




;; Misc options for org-mode
(setq org-enforce-todo-dependencies t)
(setq org-agenda-skip-deadline-if-done t)


;;(setq org-agenda-skip-scheduled-if-done t)
(setq org-log-done t)
(transient-mark-mode 1)
;;(setq org-completion-use-ido t)


;; Clocking time related functions. more to come
(setq org-clock-into-drawer t)
(setq org-clock-out-when-done t)
;;(setq org-clock-in-switch-to-state "STARTED")
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
(setq org-clock-history-length 35)


;; Functions for  hooks

(defun my-org-mode-ask-effort ()
  "Ask for an effort estimate when clocking in."
  (unless (org-entry-get (point) "Effort")
      (let ((effort
           (completing-read
            "Effort: "
            (org-entry-get-multivalued-property (point) "Effort"))))
      (unless (equal effort "")
        (org-set-property "Effort" effort)))))

(defun my-org-mode-ask-deadline ()
  "Ask for an deadline when changin a task to WAITING"
  (unless (org-entry-get (point) "Effort")
    (let ((effort
           (completing-read
            "Effort: "
            (org-entry-get-multivalued-property (point) "Effort"))))
      (unless (equal effort "")
        (org-set-property "Effort" effort)))))

;;
;; REMEMBER SETUP
;;
;;(org-remember-insinuate)
(define-key global-map "\C-cr" 'org-remember)

;; Keep clocks running
(setq org-remember-clock-out-on-exit nil)

;; C-c C-c stores the note immediately
(setq org-remember-store-without-prompt t)

(setq org-remember-default-headline "MISC")

;; Start clock if a remember buffer includes :CLOCK-IN:
(add-hook 'remember-mode-hook 'my-start-clock-if-needed 'append)

(defun my-start-clock-if-needed ()
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward " *:CLOCK-IN: *" nil t)
      (replace-match "")
      (org-clock-in))))


;; REFILE SETUP
; Targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets (quote ((org-agenda-files :maxlevel . 5) (nil :maxlevel . 5))))

; Targets start with the file name - allows creating level 1 tasks
(setq org-refile-use-outline-path (quote file))

; Targets complete in steps so we start with filename, TAB shows the next level of targets etc
(setq org-outline-path-complete-in-steps t)


(setq org-agenda-custom-commands
      '(

        ("P" "Current Project List"
         ( (tags "PROJECT+current")
           )
         )

       ("Q" "Work current Project List"
         ( (tags "PROJECT+current+@work")
           )
         )

        ("X" "Not scheduled"
         ( (todo "TODO"
                 (
                  (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline 'timestamp 'regexp ":desparche:"
                                                                      ))
                  )
                 )
           )
         )

        ("w" "Things to do at Work"
         (
          (tags  "PROJECT+current+@work")
          (tags  "reading+@work")
          (tags-todo  "+@work+type=\"Bug\""  )
          (agenda "Work" ((org-agenda-span 'day)

                      (org-agenda-files WORK-FILES)
                      (org-agenda-sorting-strategy
                       (quote ((agenda time-up priority-down tag-up) )))
                      (org-deadline-warning-days 0)
                      ))
          (tags-todo "email+@work")
          )

         )

        ("h" "Personal things / Home"
         ((tags-todo "+dailies+SCHEDULED<=\"<today>\"")
          (tags "+learning+current-@work")
          (tags "reading")
          (tags "writing")
           (agenda "" ((org-agenda-span 'day)
                       (org-agenda-sorting-strategy
                        (quote ((agenda time-up priority-down tag-up))))
                       (org-deadline-warning-days 0)))
           (tags-todo "REFILE")
           (tags-todo "next")
           (tags "PROJECT-@work+current")
           (tags "Q2")
           (tags "Q1")
           )

          ((org-agenda-tag-filter-preset '("-@work")) )
          )
        ("R" "Currently Learning/Studying"
         ((tags "@learning+PROJECT+current-@work"))

         )

        ("W" "Weekly Review"
         ((agenda "" ((org-agenda-ndays 7))) ;; review upcoming deadlines and appointments
          ;; type "l" in the agenda to review logged items
          (stuck "") ;; review stuck projects as designated by org-stuck-projects
          (tags "PROJECT") ;; review all projects (assuming you use todo keywords to designate projects)
          (todo "someday") ;; review someday/maybe items
          (todo "WAITING"))
         ((org-agenda-tag-filter-preset '("-@work")) )
         ) ;; review waiting items

        ("F" "Weekly Review (Work)"
         ((agenda ""  ((org-agenda-ndays 7))) ;; review upcoming deadlines and appointments
          ;; type "l" in the agenda to review logged items
          (stuck "") ;; review stuck projects as designated by org-stuck-projects
          (todo "PROJECT") ;; review all projects (assuming you use todo keywords to designate projects)
          (todo "someday") ;; review someday/maybe items
          (todo "WAITING"))
         ((org-agenda-tag-filter-preset '("+@work")) )
         ) ;; review waiting items

         ("D" "Daily Action List"
          (
           (tags-todo "email")
           (tags-todo "+dailies+SCHEDULED<=\"<today>\"")
           (agenda "" ((org-agenda-ndays 1)
                       (org-agenda-sorting-strategy
                        (quote ((agenda time-up priority-down tag-up) )))
                       (org-deadline-warning-days 0)
                       ))))



        ("E" "Errands review"
         ((agenda "" (
                      (org-agenda-ndays 5)          ;; agenda will start in week view
                      (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp "ERRANDS" ))

                      )


                  )
          (tags "ERRANDS")
          )
         )
        ;; limits agenda view to timestamped items
        ;; ...other commands here

        ("Y" "Personal Project List"
         ( (tags "PROJECT-@work+current")
           )
         )


        ("L" "Weekly Plan"
         ( (agenda)
           (todo "TODO")
           (tags "PROJECT")

           )
         )
        )

      )


;;TODO Create variables based on the enviroment (Windows, Linux...etc)
;; IMPORANT this is for generating the blog
(setq org-publish-mf "/Users/miguel/Dropbox/blog-stuff/mfcabrera.com/")
(setq org-publish-mf-blog "/Users/miguel/Dropbox/blog-stuff/mfcabrera.com/")

;;(require 'org-publish)

(setq org-publish-project-alist
    '(
        ("mf" :components ("mf-org"
                                 "mf-img"))
       ("mf-org"
               :base-directory "/Users/miguel/Dropbox/Notational Data/blog-entries/"
               :recursive t
               :base-extension "blog.org.txt"
               :publishing-directory "/Users/miguel/Dropbox/blog-stuff/mfcabrera.com/_posts"
               :site-root "http://mfcabrera.com"
               :jekyll-sanitize-permalinks t
               :publishing-function org-html-publish-to-html
               :section-numbers nil
               :headline-levels 4
               :table-of-contents nil
               :auto-index nil
               :auto-preamble nil
               :body-only t
               :auto-postamble nil)

      ("mf-img"
               :base-directory "/Users/miguel/Dropbox/blog-stuff/source/"
               :recursive t
               :exclude "^publish"
               :base-extension "jpg\\|gif\\|png\\|jpeg"
               :publishing-directory "/Users/miguel/Dropbox/blog-stuff/mfcabrera.com/files/images"

               :publishing-function org-publish-attachment)



      ))



(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (emacs-lisp . t)
   (python . t)
   (shell . t)
   (gnuplot . t)
   (dot . t)
   (ipython . t)
   ))


;; Set to the location of your Org files on your local system
(setq org-directory "~/Dropbox/Notational Data/org")
;; Set to the name of the file where new notes will be stored
;; (require 'calfw-org)

(defun mfcabrera/org-agenda-process-inbox-item ()
  "Process a single item in the org-agenda."
  (org-with-wide-buffer
   (org-agenda-set-tags)
   (org-agenda-priority)
   (org-agenda-refile nil nil t)))



;; org-roam configuration

(setq org-roam-directory  "~/Dropbox/Notational Data/")
(setq org-roam-link-title-format "R:%s")
(setq org-roam-index-file "index.org")
(setq org-roam-graph-exclude-matcher '("private" "dailies" "repeaters"))
(setq org-roam-completion-system 'helm)
(require 'org-roam-protocol)

(setq org-roam-capture-templates '(
                                   ("d" "default"
                                    plain #'org-roam-capture--get-point
                                    "%?" :file-name "%<%Y%m%d%H%M%S>-${slug}"
                                    :head "#+title: ${title}  "
                                    :unnarrowed t)

                                   ("p" "private" plain (function org-roam-capture--get-point)
                                    "%?"
                                    :file-name "private/${slug}"
                                    :head "#+title: ${title}\n"
                                    :unnarrowed t)

                                   ("c" "concept" plain (function org-roam--capture-get-point)
                                    "%?"
                                    :file-name "concepts/${slug}"
                                    :head " #+title: ${title}\n - tags :: "
                                    :unnarrowed t))


      )


(setq org-roam-capture-ref-templates
      '(("r" "reference" plain (function org-roam-capture--get-point)
         "%?"
         :file-name "references/${slug}"
         :head "#+title: ${title}
#+roam_key: ${ref}
#+roam_tags: website
- source :: ${ref}"
         :unnarrowed t)))

(setq orb-templates
      '(("r" "reference" plain (function org-roam-capture--get-point)
         "%?"
         :file-name "references/${citekey}"
         :head "#+title: ${title}
#+roam_key: ${ref}
#+roam_tags: ${type}
- source :: ${ref}"
         :unnarrowed t)))


;; This is for og to display larger equations
;; source https://stackoverflow.com/questions/11272236/how-to-make-formule-bigger-in-org-mode-of-emacs
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
