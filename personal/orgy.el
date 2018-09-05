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


 ;; (defun mike/move-to-today ()
 ;;    "Move current headline to today"
 ;;    (interactive)
 ;;    (org-mark-ring-push)
 ;;    (mike/refile-to "~/Dropbox/Notational Data/TODAY.org.txt" "XXX")
;;    (org-mark-ring-goto))


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

(setq org-agenda-files
      (append (sa-find-org-file-recursively "~/Dropbox/Notational Data/org/" "org")

              '("~/Dropbox/Notational Data/org/Inbox.org.txt" "~/Dropbox/Notational Data/org/learning.org.txt"
                "~/Dropbox/Notational Data/org/DayliesWeeklies.org.txt"
                "~/Dropbox/Notational Data/org/CreativeProjects.org.txt"
                "~/Dropbox/Notational Data/org/TalkIdeas.org.txt"
                "~/Dropbox/Notational Data/org/TechnicalPersonalProjects.org.txt"
                "~/Dropbox/Notational Data/org/WeightLoss.org.txt"
                "~/Dropbox/Notational Data/org/blog-ideas.org.txt"
                "~/Dropbox/Notational Data/org/LearningPath - DS.org.txt"
                "~/Dropbox/Notational Data/org/MorningRoutine.org.txt"
                "~/Dropbox/Notational Data/org/work.org.txt"
                "~/Dropbox/Notational Data/org/ResolutionObjectives2018.org.txt"

                )
              ))

(setq WORK-FILES  (append   '("~/Dropbox/Notational Data/org/work.org.txt")  )  )


(define-key global-map "\C-cc" 'org-capture)
;; notes for capture

(setq org-default-notes-file  (concat "~/Dropbox/Notational Data/org/" "Inbox.org.txt" ))
(setq org-default-work-file  (concat "~/Dropbox/Notational Data/org/" "work.org.txt" ))


(setq org-capture-templates
      '(("l" "Link" entry
         (file+headline org-default-notes-file "Links")
         "* %a\n %?\n %i" :immediate-finish 1)
        ("t" "Todo" entry (file+headline  org-default-notes-file "TASKS")
         "* TODO %?\n SCHEDULED:%t\n  %i\n")
        ("w" "Todo - Work" entry (file+headline  org-default-work-file "Misc Tasks")
         "* TODO %?\n SCHEDULED:%t\n  %i\n")
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

(setq org-default-notes-file  (concat "~/Dropbox/Notational Data/org/" "Inbox.org.txt" ))

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

        ("K" "Server List"
         ( (tags "SERVER")
           )
         )

        ("p" "Tareas planeadas"
         ( (tags "PLANNED")
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

        ("h" "thing TODO at Home"
         ((tags-todo "+dailies+SCHEDULED<=\"<today>\"")
          (tags "+learning+current-@work")
          (tags "reading")
          (tags "writing")
           (agenda "" ((org-agenda-span 'day)
                       (org-agenda-sorting-strategy
                        (quote ((agenda time-up priority-down tag-up))))
                       (org-deadline-warning-days 0)))
           (tags-todo "REFILE")
           (tags "PROJECT-@work+current")
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

        ("F" "Weekly Review"
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
   (sh . t)
   (gnuplot . t)
   (dot . t)
   ))



;; Set to the location of your Org files on your local system
(setq org-directory "~/Dropbox/Notational Data/org")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Dropbox/Notational Data/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/Aplicaciones/MobileOrg")

(require 'calfw-org)


;; Some function to parse custom rss

(defun org-feed-parse-rss-sputnik (buffer)
  "Parse BUFFER for RSS feed entries.
Returns a list of entries, with each entry a property list,
containing the properties `:guid' and `:item-full-text'."
  (let ((case-fold-search t)
	entries beg end item guid entry)
    (with-current-buffer buffer
      (widen)
      (goto-char (point-min))
      (while (re-search-forward "<entry\\>.*?>" nil t)
	(setq beg (point)
	      end (and (re-search-forward "</entry>" nil t)
		       (match-beginning 0)))
	(setq item (buffer-substring beg end)
	      guid (if (string-match "<id\\>.*?>\\(.*?\\)</id>" item)
		       (org-match-string-no-properties 1 item)))
	(setq entry (list :guid guid :item-full-text item))
	(push entry entries)
	(widen)
	(goto-char end))
      (nreverse entries))))


(defun org-feed-parse-atom-entry-sputik (entry)
  "Parse the `:item-full-text' as a sexp and create new properties."
  (let ((xml (car (read-from-string (plist-get entry :item-full-text)))))
    ;; Get first <link href='foo'/>.
    (setq entry (plist-put entry :link
			   (xml-get-attribute
			    (car (xml-get-children xml 'link))
			    'href)))
    ;; Add <title/> as :title.
    (setq entry (plist-put entry :title
			   (xml-substitute-special
			    (car (xml-node-children
				  (car (xml-get-children xml 'title)))))))
    (setq entry (plist-put entry :summary
			   (xml-substitute-special
			    (car (xml-node-children
				  (car (xml-get-children xml 'summary)))))))

    (let* ((content (car (xml-get-children xml 'content)))
	   (type (xml-get-attribute-or-nil content 'type)))
      (when content
	(cond
	 ((string= type "text")
	  ;; We like plain text.
	  (setq entry (plist-put entry :description
				 (xml-substitute-special
				  (car (xml-node-children content))))))
	 ((string= type "html")
	  ;; TODO: convert HTML to Org markup.
	  (setq entry (plist-put entry :description
				 (xml-substitute-special
				  (car (xml-node-children content))))))
	 ((string= type "xhtml")
	  ;; TODO: convert XHTML to Org markup.
	  (setq entry (plist-put entry :description
				 (prin1-to-string
				  (xml-node-children content)))))
	 (t
	  (setq entry (plist-put entry :description
				 (prin1-to-string
				  (xml-node-children content))))))))
    entry))

(defcustom org-feed-save-after-adding t
  "Non-nil means save buffer after adding new feed items."
  :group 'org-feed
  :type 'boolean)

(setq org-feed-alist
      '(
        ("Data Tau"
         "http://www.datatau.com/rss"
         "~/Dropbox/Notational Data/tech-feed.org.txt" "DataTau")

        ("Sputnik"
       "http://www.sputnik-kino.com/program.rss"
       "~/Dropbox/Notational Data/kino-feed.org.txt" "Sputnik Kino" :parse-entry org-feed-parse-atom-entry-sputik
       :template  "\n* %h %summary \n  %U\n %link \n %description\n\n"
       :parse-feed org-feed-parse-atom-feed)

       ("News YC"
       "http://news.ycombinator.com/rss"
       "~/Dropbox/Notational Data/tech-feed.org.txt" "News YC")

      ))

;(defun org-summary-todo (n-done n-not-done)
;  \"Switch entry to DONE when all subentries are done, to TODO otherwise.\"
;  (let (org-log-done org-log-states)   ; turn off logging
;    (org-todo (if (= n-not-done 0) \"DONE\" \"TODO\"))))

;(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)


;;(setq org-src-fontify-natively t)
