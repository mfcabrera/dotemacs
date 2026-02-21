;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Miguel Cabrera"
      user-mail-address "mfcabrera@gmail.com")

;; utility macro to return something based on the current system running
(defmacro mac-or-linux (value-for-mac value-for-linux)
  (cond
   ((eq system-type 'darwin) value-for-mac)
   ((member system-type '(gnu gnu/linux gnu/kfreebsd)) value-for-linux)
   )
)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;
;; doom-variable-pitch-font (font-spec :family "sans" :size 13))
;;
;;
;;

(setq doom-font (font-spec :family "Hack" :size (mac-or-linux 16 16) )
      doom-variable-pitch-font (font-spec :family "Fira Sans") ; inherits `doom-font''s :size
      doom-big-font (font-spec :size 20)
      doom-unicode-font (font-spec :size (mac-or-linux 18 16))
      doom-modeline-major-mode-icon t
      global-auto-revert-mode t
      )

;; Persist Emacs’ initial frame position, dimensions and/or full-screen state across sessions
;; add to ~/.doom.d/config.el
(when-let (dims (doom-store-get 'last-frame-size))
  (cl-destructuring-bind ((left . top) width height fullscreen) dims
    (setq initial-frame-alist
          (append initial-frame-alist
                  `((left . ,left)
                    (top . ,top)
                    (width . ,width)
                    (height . ,height)
                    (fullscreen . ,fullscreen))))))

(defun save-frame-dimensions ()
  (doom-store-put 'last-frame-size
                  (list (frame-position)
                        (frame-width)
                        (frame-height)
                        (frame-parameter nil 'fullscreen))))

(add-hook 'kill-emacs-hook #'save-frame-dimensions)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)
(setq doom-tokyo-night-brighter-comments t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads! Chaged this to a
;; real path instead of a symbolic link as it was making roam not to work
;; properly
(setq cloud-drive-dir   (mac-or-linux "~/PersonalDrive/"  "~/GDrive/"))
(setq org-directory   (mac-or-linux "~/PersonalDrive/org-notes/"  "~/GDrive/org-notes/"))

;; Variable display-buffer-base-action. It’s a list functions to control the
;; display-buffer function, which Org-roam also uses (not directly but
;; internally). It seems to be the more recent way replacing pop-up-windows
;; above. It’s a list ordered by preference, and I set it to this. With this, my
;; Org-roam buffer behaves as you would like it to (replacing an existing “main”
;; window, not popping up a new window). I don’t know if Doom has any influence
;; on it.
(setq display-buffer-base-action  '((display-buffer-reuse-window display-buffer-use-some-window)))


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(load! "bigui.el") ; personal functions


;; Misc Options - many of the preferred options are set in the default doom
;; Emacs config
(setq
 ispell-dictionary "english"
 standard-indent 8
 visible-bell t
 show-paren-style 'expression ;; show the whole expression
 ;; The default hi-yellow was not very visible to me to I remmoved from the list
 hi-lock-face-defaults  '("hi-pink" "hi-green" "hi-blue" "hi-salmon" "hi-aquamarine" "hi-black-b" "hi-blue-b" "hi-red-b" "hi-green-b" "hi-black-hb")
)

(setq NOTES-DIRECTORY org-directory)


;; Deft  Notes configuration
(after! deft
   :config
     (setq
      deft-extensions '("org" "txt" "org.txt" "md" "blog.org.txt")
      deft-directory NOTES-DIRECTORY
      deft-text-mode 'org-mode
      deft-use-filter-string-for-filename t
      deft-use-filename-as-title t
      deft-auto-save-interval 240
      deft-recursive t
      deft-default-extension "org"
      deft-org-mode-title-prefix t
      deft-markdown-mode-title-level t
      deft-file-naming-rules '((noslash . "-")
                               (nospace . "-")
                               (case-fn . downcase))
      deft-strip-summary-regexp
      (concat "\\("
	  "^:.+:.*\n" ; any line with a :SOMETHING:
	  "\\|^#\\+.*\n" ; anyline starting with a #+
	  "\\|^\\*.+.*\n" ; anyline where an asterisk starts the line
	  "\\)")

     )
)

(advice-add 'deft-parse-title :override
    (lambda (file contents)
      (if deft-use-filename-as-title
	  (deft-base-filename file)
	(let* ((case-fold-search 't)
	       (begin (string-match "title: " contents))
	       (end-of-begin (match-end 0))
	       (end (string-match "\n" contents begin)))
	  (if begin
	      (substring contents end-of-begin end)
	    (format "%s" file))))))

;; Configure custom snippets
(after! yasnippet
  :config
  (setq
   yas-snippet-dirs (append yas-snippet-dirs '("~/devsetup/dotemacs/snippets"))
   yas-global-mode t
   )
)



;; Python related stuff
;; (setq ANACONDA-PYTHON (mac-or-linux "/opt/homebrew/Caskroom/miniconda/base/bin/python" "~/anaconda3/bin/python"))
;; (use-package! elpy
;;   :init
;;   (elpy-enable)
;;   (  )
;;   :config
;;   (setq
;;    elpy-test-nose-runner-command (quote ("nosetests" "-s" "-v"))
;;    elpy-test-pytest-runner-command (quote ("py.test" "-s" "-c" "/dev/null" "-v"))
;;    elpy-test-runner (quote elpy-test-pytest-runner)
;;    elpy-rpc-python-command ANACONDA-PYTHON
;;    )
;;   )


(after! flycheck
  :config
  (flycheck-add-next-checker 'python-flake8 'python-mypy)
)

; UI MISC STUFF
(after! all-the-icons
  :config
  (setq neo-theme (if window-system 'icons 'nerd))
)

;; ORG MODE
;; your life in plain text
;;
(after! org
  (setq org-agenda-files (append
                          (bigui/find-org-file-recursively (concat org-directory "inbox/") "org")
                          (bigui/find-org-file-recursively (concat org-directory "projects/") "org")
                          (bigui/find-org-file-recursively (concat org-directory "areas/") "org")
                          ))
  (add-hook 'org-agenda-mode-hook '(lambda () (hl-line-mode 1)))
  (add-hook 'auto-save-hook 'org-save-all-org-buffers)
  (add-hook 'org-agenda-mode-hook 'org-fancy-priorities-mode)
  (setq
   org-hide-emphasis-markers t
   calendar-week-start-day 1 ;; start week on monday
   org-default-notes-file  (concat org-directory "inbox/" "Inbox.org")
   org-default-work-file   (concat org-directory "areas/" "work.org")
   org-default-work-files   (list org-default-work-file)
   org-default-learning-file  (concat org-directory "areas/" "learning_profdev.org")
   org-startup-folded 't
   org-columns-default-format "%25ITEM %TODO %3PRIORITY %TAGS %Effort"
   org-columns-default-format-for-agenda "%25ITEM %TODO %3PRIORITY %TAGS %Effort"
   org-agenda-inhibit-startup nil
   org-id-locations-file (expand-file-name ".orgids" "~")
   )
  ;; make latex formulas larger
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
  (setq org-capture-templates
      '(("t" "Todo" entry (file+headline  org-default-notes-file "TASKS")
         "* TODO %?\n SCHEDULED: %t\n  %i\n")
        ("w" "Todo - Work" entry (file+headline  org-default-work-file "Misc Tasks")
         "* TODO %?\n SCHEDULED: %t\n  %i\n")
        ("p" "Paper / Article / Video to read" entry (file+headline  org-default-learning-file "Reading Backlog")
         "* %a\n %i  " :immediate-finish 1)
        ("T" "Todo (with link)" entry (file+headline  org-default-notes-file "TASKS")
         "* TODO %?\n SCHEDULED: %t\n  %a\n %i\n")
        ;; Email capture templates - disabled (no longer using email integration)
        ;; ("m" "Task from Email" entry
        ;;  (file+headline org-default-notes-file "Emails")
        ;;  "* TODO  %a  :email: \n
        ;;    SCHEDULED:%t\n
        ;;    [[message://%l][Email]]
        ;;  " :immediate-finish 1)
        ;; ("x" "Work task from Email" entry
        ;;  (file+headline org-default-work-file "Emails")
        ;;  "* TODO  %a  :email: \n
        ;;    SCHEDULED:%t\n
        ;;    [[message://%l][Email]]
        ;;  " :immediate-finish 1)
        ("b" "Idea forBlog" entry (file+headline (concat org-directory "blog-ideas.org.txt") "Ideas")
         "* %?\n %i")
        )
      )
  (setq org-tag-alist '(
                      (:startgroup . nil)
                      ("@work" . ?w)
                      ("@home" . ?h)
                      (:endgroup . nil)
                      ("PROJECT" . ?p)
                      ("current" . ?c)
                      ("next" . ?n)
                      ("reading" . ?r)
                      ("errands" . ?e)
                      ("chore" . ?o)
                      ("learning" . ?l)
                      ("viernes" . ?v)
                      )
        )


  (add-to-list 'org-modules 'org-habit)
  (add-to-list 'org-modules 'org-checklist)
  ;; (add-to-list 'org-modules 'mac-link)

  ;; some custom faces
  (setq org-todo-keyword-faces
      '(
        ("WAITING"  . (:foreground "white" :weight bold))
        ("STARTED"  . (:foreground "orange" :weight bold))
        ("IN-PROGRESS"  . (:foreground "orange" :weight bold))
        ("PARTIAL"  . (:foreground "orange" :weight bold))
        ("NEXT"  .  org-warning)
        ("COMPLETED"  . org-done)
        ("CANCELED"  . (:foreground "red" :weight bold))
        ("FAILED"  . (:foreground "red" :weight bold))
        )

    ;; 4 priorities (HIGH, MEDIUM, NORMAL, LOW)
    org-priority-highest ?A
    org-priority-default ?C
    org-priority-lowest  ?D
  )

  (setq org-todo-keywords
        '((sequence "TODO" "STARTED" "|"  "DONE" )))
  (setq org-tags-exclude-from-inheritance '("PROJECT" "CURRENT" "project" "current" "parked2026" "NOTE" "SERVER" "NEXT" "PLANNED" "AREA" "META" "NEXT" "crypt" "desparche" "writing" "reading" "area" "chores"))
  (setq org-enforce-todo-dependencies t)
  (setq org-agenda-skip-deadline-if-done t)

  (setq
   org-log-done t
   org-log-into-drawer t ;; do not clutter
   )


  ;; Clocking time related functions. not used much these days
  (setq
   org-clock-into-drawer t ;; do not clutter
   org-clock-out-when-done t
   org-clock-persist t
   org-clock-history-length 35)

  ;; REFILE SETUP
  ;; Targets include this file and any file contributing to the agenda - up to 5 levels deep
  (setq
   org-refile-targets (quote ((org-agenda-files :maxlevel . 5) (nil :maxlevel . 5)))
   org-refile-use-outline-path (quote file) ; Targets start with the file name - allows creating level 1 tasks
  ;; this makes ivy works properly on refile
   ;; https://github.com/abo-abo/swiper/issues/1254
   org-outline-path-complete-in-steps nil ; was t before
   org-goto-interface 'outline-path-completion

   )

;; fix problem with
(setq org-modern-fold-stars
      '(("▶" . "▼")
        ("▷" . "▽")
        ("▸" . "▾")
        ("▹" . "▿")
        ("▸" . "▾")))

  ;; Custom commands!
  ;;
  (setq org-agenda-start-day nil )
  (setq org-agenda-custom-commands
      '(

        ("P" "Current Project List"
         ((tags "PROJECT+current" ))
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
          (tags  "linear/TODO|STARTED" ((org-agenda-overriding-header "Linear Issues")))
          (tags  "linear+PROJECT" ((org-agenda-overriding-header "Linear Projects")))
          (tags  "next+@work/TODO|WAITING")
          (tags  "reading+@work")
          (agenda "Work" ((org-agenda-span '3)
                      (org-agenda-files org-default-work-files)
                      (org-agenda-sorting-strategy
                       (quote ((agenda time-up priority-down tag-up) )))
                      (org-deadline-warning-days 3)
                      ))
;;          (tags-todo "email+@work")
          )

         )

        ("h" "Personal things / Home"
         (
          ;; ((org-super-agenda-groups 'nil))
          (tags-todo "+dailies+SCHEDULED<=\"<today>\""  )
          (tags "+learning+current-@work")
          (tags "reading" ((org-super-agenda-groups 'nil)) )
          (tags "writing" ((org-super-agenda-groups 'nil)) )
           (agenda "" (
                       (org-agenda-span '3)
                       (org-agenda-sorting-strategy
                       (quote ((agenda time-up priority-down tag-up))))
                       (org-deadline-warning-days 3)
                       (org-super-agenda-groups '((:auto-category t)))
                       )

                   )
           (tags-todo "REFILE")
           (tags "next/TODO|WAITING|STARTED"
                      ((org-agenda-sorting-strategy '(priority-down)))
                      )
           (tags "PROJECT-@work+current" ((org-super-agenda-groups 'nil)))
           (tags "PROJECT-@work+parked2026" ((org-super-agenda-groups 'nil)))
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
)

;; org-additional packages

(use-package! org-download
  :config
  (setq org-download-image-dir (concat cloud-drive-dir  "org-images/"))
  ;; (setq org-download-screenshot-method (mac-or-linux "/usr/sbin/screencapture -i %s"  "gnome-screenshot"))
  (setq org-download-method 'directory)
  :hook
  (dired-mode . org-download-enable)
  )


;; ORG-ROAM
(use-package! org-roam
  :config
  (setq org-roam-directory org-directory
        org-roam-graph-exclude-matcher '("private" "repeaters" "dailies")
        )
  (map! :leader
        :prefix "n"
        :desc "org-roam-node-find" "f" #'org-roam-node-find ;originnaly mapped to find-file-in-notes
        :desc "org-roam-node-insert" "i" #'org-roam-node-insert ;; originally not mapped
  )
  (setq org-roam-capture-templates '(
                                  ("d" "default" plain "%?"
                                   :target (file+head "resources/zettelkasten/%<%Y%m%d%H%M%S>-${slug}.org"
                                                      "#+title: ${title}\n")
                                   :unnarrowed t)
                                  ("c" "concept" plain "%?"
                                   :target (file+head "resources/concepts/${slug}.org"
                                                      "#+title: ${title}\n")
                                   :unnarrowed t)
                                  ("k" "education notes" plain "%?"
                                   :target (file+head "resources/courses/${slug}.org"
                                                      "#+title: ${title}\n #+ROAM_REFS: {url} ")
                                   :unnarrowed t)

                                  ("b" "book notes" plain "%?"
                                   :target (file+head "resources/books/${slug}.org"
                                                      "#+title: ${title}\n #+ROAM_REFS: {url} ")
                                   :unnarrowed t)
                                  ("l" "blog post or idea" plain "%?"
                                   :target (file+head "projects/blog/${slug}.org"
                                                      "#+title: ${title}\n #+ROAM_REFS: {url} ")
                                   :unnarrowed t)


                                ("r" "ref" plain "%?" :target
                                 (file+head "resources/references/${slug}.org"
                                            "#+title: ${title}")
                                 :unnarrowed t)

                                ("m" "meeting note" plain
                                 "* Attendees\n%?\n\n* Agenda\n\n* Discussion\n\n* Action Items\n- [ ] \n\n* Follow-up\n"
                                 :target (file+head "resources/zettelkasten/%<%Y%m%d%H%M%S>-meeting-${slug}.org"
                                                    "#+title: Meeting: ${title}\n#+filetags: :meeting:\n#+date: %<%Y-%m-%d>\n")
                                 :unnarrowed t)

                                ("t" "talk/conference" plain
                                 "* Speaker\n%?\n\n* Key Takeaways\n- \n\n* Notes\n\n* Resources\n"
                                 :target (file+head "resources/talks/%<%Y%m%d>-${slug}.org"
                                                    "#+title: ${title}\n#+filetags: :talk:\n#+date: %<%Y-%m-%d>\n#+roam_refs: \n")
                                 :unnarrowed t)))

)

(defun my/org-roam-capture-inbox ()
  (interactive)
  (org-roam-capture- :node (org-roam-node-create)
                     :templates '(("i" "inbox" plain "** %?" :target (file+olp "inbox/Inbox.org" ("Misc Notes") )
                                 ))))

(global-set-key (kbd "C-c n b") #'my/org-roam-capture-inbox)


;; org-journal
(defun org-journal-save-entry-and-exit()
  "Simple convenience function.
  Saves the buffer of the current day's entry and kills the window
  Similar to org-capture like behavior"
  (interactive)
  (save-buffer)
  (kill-buffer-and-window))

(after! org-journal
  :config
  (setq
   ;org-journal-file-header  "#+title: Monthly Journal\n#+STARTUP: folded"
   org-journal-file-format "%Y-%m.org"
   org-journal-dir "~/PersonalDrive/org-notes/archive/journal/"
   org-journal-date-format "%A, %d %B %Y"
   org-journal-enable-agenda-integration t
   org-journal-file-type 'monthly
 )
  (define-key org-journal-mode-map (kbd "C-x C-s") 'org-journal-save-entry-and-exit)
)


;;;;;;;;;
;; org-ref and related packages
;; ;;;;;;;;;

(after! org-ref
  :config
  (setq
   reftex-default-bibliography (concat cloud-drive-dir "bibliography/references.bib")
   org-ref-bibliography-notes (concat cloud-drive-dir "bibliography/biblio-notes.org")
   org-ref-default-bibliography '((concat cloud-drive-dir "bibliography/references.bib"))
   org-ref-pdf-directory (concat cloud-drive-dir "bibliography/bibtex-pdfs/")
   bibtex-completion-library-path (concat cloud-drive-dir "bibliography/bibtex-pdfs/")
   bibtex-completion-bibliography (concat cloud-drive-dir "bibliography/references.bib")
   org-ref-get-pdf-filename-function #'org-ref-get-mendeley-filename
   ; bibtex-completion-notes-path "~/Dropbox/Notational Data/helm-bibtex-notes.org"
   ;; org-ref-bib-html "<h2 class='org-ref-bib'>References</h2>\n"
   )
  )
;; (setq bibtex-completion-pdf-open-function
;;  (lambda (fpath)
;;    (start-process "open" "*open*" "open" fpath)))


;; ;; org-roam-bibtext
(use-package! org-roam-bibtex
    :after org-roam
    :hook (org-roam-mode . org-roam-bibtex-mode)
    :config
    (setq orb-templates
        '(("r" "reference" plain (function org-roam-capture--get-point)
           "%?"
           :file-name "references/${citekey}"
           :head "#+title: ${title}
  #+roam_key: ${ref}
  #+roam_tags: ${type}
  - source :: ${ref}"
           :unnarrowed t)))
)


;; fancy priorities
;; inspired by https://github.com/JordanFaust/doom-config/blob/e6e0d7964bc6494d2740d5530456d87fabfa8c7c/snippets/%2Borg/base.el#L105
;; (use-package! org-fancy-priorities
;;   :hook
;;   (org-mode . org-fancy-priorities-mode)
;;   (org-agenda-mode . org-fancy-priorities-mode)
;;   :config
;;   (setq org-fancy-priorities-list
;;         `((?A . ,(propertize (format " %s [HIGH]" (nerd-icons-faicon "nf-fa-exclamation_circle" :v-adjust -0.01))))
;;           (?B . ,(propertize (format " %s [MEDIUM]" (nerd-icons-faicon "nf-fa-arrow_circle_up" :v-adjust -0.01))))
;;           (?C . ,(propertize (format " %s [NORMAL]" (nerd-icons-faicon "nf-fa-arrow_circle_down" :v-adjust -0.01))))
;;           (?D . ,(propertize (format " %s [LOW]" (nerd-icons-faicon "nf-fa-circle_question" :v-adjust -0.01))))))
;; )




;; this makes pre-commit hooks to work
;; extracted from https://github.com/magit/magit/issues/3419
(use-package! magit
  :config
  (setq magit-git-global-arguments (remove "--literal-pathspecs" magit-git-global-arguments))
)

;; (use-package! dash-docs
;;   :config
;;   (setq dash-docs-common-docsets '("Pandas" "Python 3"))
;; )


;; Conda configuration
;;
(use-package conda
  :ensure t
  :init
  ;; Set the path to your Conda installation
  (setq conda-anaconda-home "/opt/homebrew/Caskroom/miniconda/base")
  ;; Set the home directory for Conda environments
  (setq conda-env-home-directory "/opt/homebrew/Caskroom/miniconda/base")
  ;; Automatically activate the base environment when opening a Python file
  (setq conda-env-autoactivate-mode t)
  :config
  ;; Initialize Conda for shell and eshell
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell))

;; Optionally, set the default Conda environment
(setq conda-env-default-location "/opt/homebrew/Caskroom/miniconda/base/envs")



;; Completion configuration
;
;;
;; TODO: Think about this configuration
;; (use-package! company
;;   :after lsp-mode
;;   :hook (lsp-mode . company-mode)
;;   :bind (:map company-active-map
;;          ("<tab>" . company-complete-selection))
;;         (:map lsp-mode-map
;;          ("<tab>" . company-indent-or-complete-common))
;;   :custom
;;   (company-minimum-prefix-length 1)
;;   (company-idle-delay 0.0))

;; (use-package! company-box
;;   :hook (company-mode . company-box-mode))

;; Rainbow delimiters
(use-package! rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


(after! python
(add-hook 'python-mode-hook 'pyvenv-mode)
)


(use-package! py-isort
  :config
  (setq py-isort-options '("-l 100"  "-m3" "--trailing-comma")
        )
  )

(use-package! python-black
  :after python)

(after! lsp-mode
  :config
  (
   setq lsp-headerline-breadcrumb-enable t
        lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols)
  )
  )

(use-package! lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :hook (lsp-mode . lsp-ui-doc-mode)
  :config
  (setq lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-show-code-action t
        lsp-ui-doc-use-childframe nil
  )
  :custom
  (lsp-ui-doc-position 'bottom)

)

(use-package! lsp-treemacs
  :after lsp)

(use-package! windmove
  ;; :defer 4
  :config
  ;; use command key on Mac
  (windmove-default-keybindings 'super)
  ;; wrap around at edges
  (setq windmove-wrap-around t))

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t)
)

;; Super agenda
;;
;;
(use-package! org-super-agenda
  :after org-agenda
  :config
  ;;  (setq org-super-agenda-groups 'nil)
  (setq org-super-agenda-groups '((:auto-parent t)))
  (org-super-agenda-mode))

(use-package! org-mouse
  :after org

  )

(setq sql-connection-alist
      '((starrocks-dev (sql-product 'mysql)
                  (sql-port 9030)
                  (sql-server "8i6r5noyy.cloud-app.celerdata.com")
                  (sql-user (bigui/read-1pw-secret "op://zmafg6a6xyu23mneangibytpha/development starrocks/username"))
                  (sql-database "layer")
                  (sql-password (bigui/read-1pw-secret "op://zmafg6a6xyu23mneangibytpha/development starrocks/password"))
        ))
)


(use-package! gptel

:config
(setq gptel-default-mode 'org-mode)
;; Configure OpenAI backend with GPT-5 models
(add-hook 'gptel-post-response-functions 'gptel-end-of-response)
(setq gptel-directives
      '((default . "You are a large language model living in Emacs and a helpful assistant. Respond concisely. You have tools available")

        ;; Code & Development
        (code-review . "You are a senior software engineer doing code review. Focus on bugs, performance, readability, and best practices. Be specific and constructive.")
        (debug . "Help debug this code. Analyze the error, identify likely causes, and suggest specific fixes with explanations.")
        (optimize . "Analyze this code for performance improvements. Suggest optimizations with benchmarking considerations and trade-offs.")
        (architect . "Think like a software architect. Consider design patterns, scalability, maintainability, and system design principles.")

        ;; Writing & Documentation
        (technical-writer . "Write clear, precise technical documentation. Use examples, proper structure, and consider the audience's technical level.")
        (editor . "Edit this text for clarity, conciseness, and flow. Fix grammar and suggest improvements while preserving meaning.")
        (readme . "Help create or improve README files. Include clear setup instructions, usage examples, and proper formatting.")

        ;; Learning & Research
        (teacher . "Explain concepts step-by-step with examples. Start simple, build complexity gradually, and check understanding.")
        (researcher . "Provide thorough research with multiple perspectives. Include sources, analyze trade-offs, and highlight key insights.")
        (eli5 . "Explain like I'm 5, but for technical topics. Use analogies and simple language without losing accuracy.")

        ;; Productivity & Analysis
        (analyzer . "Break down complex problems systematically. Identify patterns, root causes, and actionable solutions.")
        (planner . "Help organize and plan projects. Consider dependencies, timelines, resources, and potential roadblocks.")
        (summarizer . "Create concise summaries highlighting key points, decisions, and action items.")

        ;; Specialized
        (emacs-helper . "You're an Emacs expert. Provide elisp solutions, package recommendations, and workflow optimizations.")
        (shell-guru . "Help with command-line tasks, shell scripting, and Unix tools. Provide working examples and explain options.")
        (git-assistant . "Help with Git workflows, resolving conflicts, and repository management. Suggest commands and best practices."))
)

)
(require 'gptel-integrations)


;; let's star using avy
;;
(use-package! avy
    :bind
  (("C-c :" . avy-goto-char);; Jump to a specific character
   ("C-c '" . avy-goto-char-timer) ;;
   ("M-g f" . avy-goto-line)         ;; Jump to a specific line
   ("M-g w" . avy-goto-word-1)


   ))     ;; Jump to a word starting with a char
(setq debug-on-error t)


;; (use-package ellama
;;   :init
;;   (setopt ellama-language "English")
;;   (require 'llm-ollama)
;;   (setopt ellama-provider
;; 		  (make-llm-ollama
;; 		   :chat-model "codellama" :embedding-model "codellama")))
;;


(use-package! mcp
  :ensure t
  :after gptel
  :custom
  (mcp-hub-servers
   `(
     ;; Filesystem MCP
     ("filesystem" . (:command "npx"
                        :args ("-y" "@modelcontextprotocol/server-filesystem"
                               "/Users/mfcabrera/Desktop"
                               "/Users/mfcabrera/Downloads"
                               "/Users/mfcabrera/PersonalDrive")))

     ;; Memory MCP
     ("memory" . (:command "npx"
                    :args ("-y" "@modelcontextprotocol/server-memory")
                    :env (:MEMORY_FILE_PATH "/Users/mfcabrera/PersonalDrive/memory.json")))

     ;; Google Calendar MCP
     ("google-calendar" . (:command "npx"
                              :args ("@cocal/google-calendar-mcp")
                              :env (:GOOGLE_OAUTH_CREDENTIALS "/Users/mfcabrera/PersonalDrive/secrets.json")))

     ;; Linear MCP
     ("linear" . (:command "npx"
                    :args ("-y" "mcp-remote" "https://mcp.linear.app/sse")))
     ))
  :config
  (require 'mcp-hub)
  :hook
  (after-init . mcp-hub-start-all-server))

(use-package! llm-tool-collection)
(mapcar (apply-partially #'apply #'gptel-make-tool)
        (llm-tool-collection-get-all))



;; Install Khoj client using Straight.el
(use-package! khoj
  :after org
  :bind ("C-c k" . 'khoj)
  :config (setq khoj-api-key "kk-5nEhLbGN_VERn2ZtT7zV8hXZ3zDjpASl42FAFfii0do"
                khoj-server-url "https://app.khoj.dev"
                khoj-org-directories '("/Users/mfcabrera/PersonalDrive/org-notes/inbox"
                                       "/Users/mfcabrera/PersonalDrive/org-notes/projects"
                                       "/Users/mfcabrera/PersonalDrive/org-notes/areas"
                                       "/Users/mfcabrera/PersonalDrive/org-notes/resources")
                khoj-org-files '("~/docs/todo.org" "~/docs/work.org")))





;; (use-package! claude-code
;;   :after transient
;;   :config
;;   (claude-code-mode)
;;   (map! :leader
;;         (:prefix ("c" . "claude")
;;          :desc "Claude Command Map" "c" #'claude-code-transient)))


(use-package! claude-code-ide
  :bind ("C-c C-'" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  (claude-code-ide-emacs-tools-setup) ; Optionally enable Emacs MCP tools
  (setq claude-code-ide-enable-mcp-server t)

  ;; ============================================================
  ;; Agenda MCP Tools for Claude Code
  ;; ============================================================
  (defun my/mcp-agenda-view (key)
    "Generate agenda view KEY and return as string."
    (require 'org-agenda)
    (let ((org-agenda-buffer-name "*MCP-Agenda*")
          (org-agenda-sticky nil))
      (org-agenda nil key)
      (with-current-buffer org-agenda-buffer-name
        (let ((content (buffer-string)))
          (kill-buffer)
          content))))

  (defun my/mcp-agenda-home ()
    "Return home agenda as string."
    (my/mcp-agenda-view "h"))

  (defun my/mcp-agenda-work ()
    "Return work agenda as string."
    (my/mcp-agenda-view "w"))

  (defun my/mcp-agenda-daily ()
    "Return daily agenda as string."
    (my/mcp-agenda-view "D"))

  ;; Register as MCP tools
  (add-to-list 'claude-code-ide-mcp-server-tools
               (claude-code-ide-make-tool
                :name "getAgendaHome"
                :function #'my/mcp-agenda-home
                :description "Get personal/home org-agenda view (excludes work items)"
                :args nil))

  (add-to-list 'claude-code-ide-mcp-server-tools
               (claude-code-ide-make-tool
                :name "getAgendaWork"
                :function #'my/mcp-agenda-work
                :description "Get work org-agenda view (Linear issues, work projects, next actions)"
                :args nil))

  (add-to-list 'claude-code-ide-mcp-server-tools
               (claude-code-ide-make-tool
                :name "getAgendaDaily"
                :function #'my/mcp-agenda-daily
                :description "Get daily action list (emails, dailies, today only)"
                :args nil))

  ;; Khoj semantic search MCP tool
  (defun my/mcp-khoj-search (query)
    "Search org-notes via Khoj semantic search.
Returns search results as a formatted string."
    (require 'khoj)
    ;; url-build-query-string expects ((key value) ...) not ((key . value) ...)
    (let* ((params `((q ,query)
                     (t "org")
                     (n 10)
                     (r "true")))
           (response (khoj--call-api "/api/search" "GET" params)))
      (if response
          (mapconcat
           (lambda (item)
             (let ((entry (alist-get 'entry item))
                   (file (alist-get 'file item))
                   (score (alist-get 'score item)))
               (format "## %s (score: %.2f)\n%s\n"
                       (or file "unknown")
                       (or score 0)
                       (or entry ""))))
           response
           "\n---\n")
        "No results found")))

  (add-to-list 'claude-code-ide-mcp-server-tools
               (claude-code-ide-make-tool
                :name "khojSearch"
                :function #'my/mcp-khoj-search
                :description "Semantic search over org-notes using Khoj AI. Use for finding related notes, concepts, or answering questions about the knowledge base."
                :args '((:name "query"
                         :type string
                         :description "Natural language search query")))))

;; Disable Ctrl + Mouse Wheel from zooming
(global-unset-key (kbd "C-<mouse-4>"))  ;; Unbind zoom-in (scroll-up)
(global-unset-key (kbd "C-<mouse-5>"))  ;; Unbind zoom-out (scroll-down)
(global-unset-key (kbd "C-<wheel-up>"))  ;; Alternative binding for some systems
(global-unset-key (kbd "C-<wheel-down>"))  ;; Alternative binding for some systems

