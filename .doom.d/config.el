;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Miguel Cabrera"
      user-mail-address "mfcabrera@gmail.com")

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
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/Notational Data/")

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


(when (and window-system (eq system-type 'darwin))
  ;; When started from Emacs.app or similar, ensure $PATH
  ;; is the same the user would see in Terminal.app
  (bigui/set-exec-path-from-shell-PATH))


;; utility macro to return something based on the current system running
(defmacro mac-or-linux (value-for-mac value-for-linux)
  (cond
   ((eq system-type 'darwin) value-for-mac)
   ((member system-type '(gnu gnu/linux gnu/kfreebsd)) value-for-linux)
   )
)

;; Misc Options - many of the preferred options are set in the default doom
;; Emacs config
(setq
 ispell-dictionary "english"
 standard-indent 8
 visible-bell t
 )

;; UTF-8 support
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8-unix)

(setq NOTES-DIRECTORY org-directory)

;; Deft  Notes configuration
(use-package! deft
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

     )
)

;; Configure custom snippets
(use-package! yasnippet
  :config
  (setq
   yas-snippet-dirs (append yas-snippet-dirs '("~/dotemacs/snippets/"))
   yas-global-mode t
   )
)


;; Python related stuff
(setq ANACONDA-PYTHON (mac-or-linux "/usr/local/anaconda3/bin/python" "~/anaconda3/bin/python"))

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

(use-package! flycheck
  :config
  (flycheck-add-next-checker 'python-flake8 'python-mypy)
)

; UI MISC STUFF
(use-package! all-the-icons
  :config
  (setq neo-theme (if window-system 'icons 'nerd))
)

;; ORG MODE
;; your life in plain text
;;
(after! org
  (setq org-agenda-files (append (bigui/find-org-file-recursively "~/Dropbox/Notational Data/org/" "org")))
  (add-hook 'org-agenda-mode-hook '(lambda () (hl-line-mode 1)))
  (setq
   calendar-week-start-day 1 ;; start week on monday
   org-default-notes-file  (concat org-directory "org/" "Inbox.org")
   org-default-work-file   (concat org-directory "org/" "work.org")
   org-default-work-files   (list org-default-work-file)
   org-default-learning-file  (concat org-directory "org/" "learning_profdev.org")
   org-columns-default-format "%25ITEM %TODO %3PRIORITY %TAGS Effort"
   )
  ;; make latex formulas larger
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
  (setq org-capture-templates
      '(("l" "Link" entry
         (file+headline org-default-notes-file "Links")
         "* %a\n %?\n %i" :immediate-finish 1)
        ("t" "Todo" entry (file+headline  org-default-notes-file "TASKS")
         "* TODO %?\n SCHEDULED:%t\n  %i\n")
        ("w" "Todo - Work" entry (file+headline  org-default-work-file "Misc Tasks")
         "* TODO %?\n SCHEDULED:%t\n  %i\n")
        ("v" "Talk to Watch" entry (file+headline  org-default-learning-file "Talks and Conference Video Queue")
         "* %a\n %i  " :immediate-finish 1)
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
  )

  (setq org-todo-keywords
        '((sequence "TODO" "IN-PROGRESS" "|"  "DONE" )))
  (setq org-tags-exclude-from-inheritance '("PROJECT" "CURRENT" "project" "current" "NOTE" "SERVER" "NEXT" "PLANNED" "AREA" "META" "NEXT" "crypt" "desparche" "writing" "reading"))
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
   org-outline-path-complete-in-steps t ; Targets complete in steps so we start with filename, TAB shows the next level of targets etc
   )


  ;; Custom commands!
  ;;
  (setq org-agenda-start-day nil )
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
                      (org-agenda-files org-default-work-files)
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
           (tags "Q4")
           (tags "Q3")
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

  ;; org-babel configuration

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


)


;; org-additional packages

(use-package! org-download
  :config
  (setq-default org-download-image-dir "~/Dropbox/org-images/")
  (setq org-download-screenshot-method (mac-or-linux "/usr/sbin/screencapture -i %s"  "gnome-screenshot"))
  :hook
  (dired-mode . org-download-enable)
)

;; ORG-ROAM
(use-package! org-roam
  :commands (org-roam-insert org-roam-find-file org-roam-switch-to-buffer org-roam)
  :hook
  (after-init . org-roam-mode)
  :init
  ;; some of this is already setup by org-roam plugin
  (map! :leader
        :prefix "n"
        :desc "org-roam" "l" #'org-roam
        :desc "org-roam-insert" "i" #'org-roam-insert
        :desc "org-roam-switch-to-buffer" "b" #'org-roam-switch-to-buffer
        :desc "org-roam-find-file" "f" #'org-roam-find-file
        :desc "org-roam-insert" "i" #'org-roam-insert
        :desc "org-roam-capture" "c" #'org-roam-capture)
  (setq org-roam-directory org-directory
        org-roam-db-gc-threshold most-positive-fixnum
        org-roam-graph-exclude-matcher '("private" "repeaters" "dailies")
        org-roam-tag-sources '(prop last-directory)
        org-id-link-to-org-use-id t
        org-roam-index-file "index.org"
        org-roam-link-title-format "R:%s")
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
         :unnarrowed t))))

(use-package! org-roam-protocol
  :after org-protocol)

(use-package! org-roam-server)


;; org-journal
(use-package! org-journal
  :config
  (setq

   org-journal-file-header  "#+TITLE: Monthly Journal\n#+STARTUP: folded"
   org-journal-file-format "%Y-%m.org"
   org-journal-dir "~/Dropbox/Notational Data/journal/"
   org-journal-date-format "%A, %d %B %Y"
   org-journal-enable-agenda-integration t
   org-journal-file-type 'monthly
 )
)
(defun org-journal-save-entry-and-exit()
  "Simple convenience function.
  Saves the buffer of the current day's entry and kills the window
  Similar to org-capture like behavior"
  (interactive)
  (save-buffer)
  (kill-buffer-and-window))
(define-key org-journal-mode-map (kbd "C-x C-s") 'org-journal-save-entry-and-exit)

;;;;;;;;;
;; org-ref and related packages
;;;;;;;;;

(use-package! org-ref
  :config
  (setq
   reftex-default-bibliography '("~/Dropbox/references.bibtext")
   org-ref-bibliography-notes "~/Dropbox/Notational Data/biblio-notes.org"
   org-ref-default-bibliography '("~/Dropbox/bibliography/references.bib")
   org-ref-pdf-directory "~/Dropbox/bibliography/bibtex-pdfs/"
   org-ref-get-pdf-filename-function #'org-ref-get-mendeley-filename
   bibtex-completion-bibliography "~/Dropbox/bibliography/references.bib"
   bibtex-completion-library-path "~/Users/mcabrera/Library/Application Support/Mendeley Desktop/Downloaded/"
   bibtex-completion-notes-path "~/Dropbox/Notational Data/helm-bibtex-notes.org"

   )
  )
(setq bibtex-completion-pdf-open-function
  (lambda (fpath)
    (start-process "open" "*open*" "open" fpath)))


;; org-roam-bibtext
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
(use-package! org-fancy-priorities
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")))


;; Editorconfig
(use-package! editorconfig
  :config
  (editorconfig-mode 1)
)

;; this makes pre-commit hooks to work
;; extracted from https://github.com/magit/magit/issues/3419
(use-package! magit
  :config
  (setq magit-git-global-arguments (remove "--literal-pathspecs" magit-git-global-arguments))
)

(use-package! dash-docs
  :config
  (setq dash-docs-common-docsets '("Pandas" "Python 3"))
)