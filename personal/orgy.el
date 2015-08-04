;; orgy.el  - Personal customization to org-mode

;;helper function for DRYing the creation of paths for org-mode files acrross systems
;;Need to have previously defined the variables *ORG-FILES-PATH* (i.e. in .emacs)

(defun org-files-expand-path (files)
  (mapcar (lambda (d) (concat *ORGFILES-PATH* d)) files))

(defun mike/refile-to (file headline)
    "Move current headline to specified location"
    (let ((pos (save-excursion
                 (find-file file)
                 (org-find-exact-headline-in-buffer headline))))
      (org-refile nil nil (list headline file nil pos))))

(defun mike/move-to-today ()
    "Move current headline to today"
    (interactive)
    (org-mark-ring-push)
    (mike/refile-to "~/Dropbox/Notational Data/TODAY.org.txt" "XXX")
    (org-mark-ring-goto))



;;(setq org-agenda-files  (org-files-expand-path org-files-all)) 
;;(setq org-agenda-files '("~/Dropbox/Notational Data"))
;; recursively find .org files in provided directory<
;; modified from an Emacs Lisp Intro example
(defun find-org-file-recursively (directory &optional filext)
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
	(if (string-match fileregex file-or-dir) ; org files
	    (add-to-list 'org-file-list file-or-dir)))
       ((file-directory-p file-or-dir)
	(dolist (org-file (sa-find-org-file-recursively file-or-dir filext)
			  org-file-list) ; add files found to result
	  (add-to-list 'org-file-list org-file)))))))



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
	(if (string-match fileregex file-or-dir) ; org files
	    (add-to-list 'org-file-list file-or-dir)))
       ((file-directory-p file-or-dir)
	(dolist (org-file (sa-find-org-file-recursively file-or-dir filext)
			  org-file-list) ; add files found to result
	  (add-to-list 'org-file-list org-file)))))))


(setq org-agenda-files
      (append (sa-find-org-file-recursively "~/Dropbox/Notational Data/" "org.txt")
              (sa-find-org-file-recursively "~/Dropbox/Notational Data/" "org")))


(define-key global-map "\C-cr" 'org-capture)


;; Colors and Faces
;; Many of this configuration is pretty old and not used
;; yet I will keep it here for reference if I ever use org-mode
;; as I used to

(setq org-todo-keyword-faces
      '(
        ("WAITING"  . (:foreground "white" :weight bold))
        ("STARTED"  . (:foreground "orange" :weight bold))
        ("DELEGATED"  . (:foreground "orange" :weight bold))
        ("NEXT"  .  org-warning)
        ("DONE"  .  (:foreground "lightgreen" :weight bold))
        ("CANCELED"  . (:foreground "red" :weight bold))
        ))


;; Highlights the current line in agenda buffers
(add-hook 'org-agenda-mode-hook '(lambda () (hl-line-mode 1)))


;; Org Mode Behaviour
;; Avoid tags inheritance for specific tags
(setq org-tags-exclude-from-inheritance '("PROJECT" "CURRENT" "NOTE" "SERVER" "NEXT" "PLANNED" "AREA" "META"))

;; notes for remember
(setq org-default-notes-file  (concat "~/Dropbox/Notational Data/" "Inbox.org.txt" ))

    

;; Misc options for org-mode
(setq org-enforce-todo-dependencies t)
(setq org-agenda-skip-deadline-if-done t)


;;(setq org-agenda-skip-scheduled-if-done t)
(setq org-log-done t)
(transient-mark-mode 1)
(setq org-completion-use-ido t)


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
(setq org-directory *ORGFILES-PATH*)
(define-key global-map "\C-cr" 'org-remember)

;; Keep clocks running
(setq org-remember-clock-out-on-exit nil)

;; C-c C-c stores the note immediately
(setq org-remember-store-without-prompt t)

(setq org-remember-default-headline "MISC")

(setq org-default-notes-file  (concat "~/Dropbox/Notational Data/" "Inbox.org.txt" ))

;; Start clock if a remember buffer includes :CLOCK-IN:
(add-hook 'remember-mode-hook 'my-start-clock-if-needed 'append)

(defun my-start-clock-if-needed ()
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward " *:CLOCK-IN: *" nil t)
      (replace-match "")
      (org-clock-in))))


;; REMEMBER TEMPLATES
(setq org-remember-templates 
      (
       quote (
              ("todo" ?t "* TODO %? \n%U " nil bottom nil)
              ("note" ?n "* %?  :NOTE:  \n%U " nil "NOTES" nil)
              ("idea" ?i "* %?  \n%U  " nil "IDEAS" nil)
              ("soporte" ?s "* SOPORTE %? :SUPPORT:  %u\n:CLOCK-IN:   " nil "SOPORTE" nil)
              ("gasto" ?g "* %U  %?  " "home.org" "GASTOS Y MOVIMIENTOS" nil)
              )
             )
      )

;; REFILE SETUP
; Targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets (quote ((org-agenda-files :maxlevel . 5) (nil :maxlevel . 5))))

; Targets start with the file name - allows creating level 1 tasks
(setq org-refile-use-outline-path (quote file))

; Targets complete in steps so we start with filename, TAB shows the next level of targets etc
(setq org-outline-path-complete-in-steps t)


      
;;Fixme: 
(setq org-stuck-projects
      '("+PROJECT" nil ("NEXT" "PLANNED")
        ))

(setq org-agenda-custom-commands
      '(
        
        ("P" "Project List"
         ( (tags "PROJECT")
           )
         )

       ("Q" "Work Planned Project List"
         ( (tags "PROJECT+CURRENT+PLANNED+@work")
           )
         )
        
        ("X" "Not scheduled"
         ( (todo "TODO"
                 (
                  (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline 'timestamp))
                  )
                 )
           )
         )
              
        ("S" "Server List"
         ( (tags "SERVER")
           )
         )
        
        ("p" "Tareas planeadas"
         ( (tags "PLANNED")
           )
         )

         
        ("w" "Things to do at Work"
         (
          
          (tags-todo "REFILE")
          (agenda "" ((org-agenda-ndays 1)
                      (org-agenda-filter-preset  '("+@work" ))
                      (org-agenda-sorting-strategy
                       (quote ((agenda time-up priority-down tag-up) )))
                      (org-deadline-warning-days 0)                      
                      ))
          )
         
         )

        ("h" "thing TODO at Home"
         (
          (tags "READING")
          (tags-todo "REFILE")
          (agenda "" ((org-agenda-ndays 1)
                      (org-agenda-filter-preset  '("+@home" ))
                      (org-agenda-sorting-strategy
                       (quote ((agenda time-up priority-down tag-up) )))
                      (org-deadline-warning-days 0)                      
                      ))
          
          )
         
         )
        
        
        ("W" "Weekly Review"
         ((agenda "" ((org-agenda-ndays 7))) ;; review upcoming deadlines and appointments
          ;; type "l" in the agenda to review logged items 
          (stuck "") ;; review stuck projects as designated by org-stuck-projects
          (todo "PROJECT") ;; review all projects (assuming you use todo keywords to designate projects)
          (todo "MAYBE") ;; review someday/maybe items
          (todo "WAITING"))) ;; review waiting items        
        
         ("D" "Daily Action List"
          (
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

        ("Y" "Home Planned Project List"
         ( (tags "PROJECT+@home+CURRENT")
           )
         )
        
        
        ("W" "Weekly Plan"
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
               :base-directory "/Users/miguel/Dropbox/Notational Data"
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
   ))





