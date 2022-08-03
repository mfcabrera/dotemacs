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

(setq doom-font (font-spec :family "Hack" :size (mac-or-linux 18 16) )
      doom-variable-pitch-font (font-spec :family "Fira Sans") ; inherits `doom-font''s :size
      doom-big-font (font-spec :size 20)
      doom-unicode-font (font-spec :size (mac-or-linux 18 16))
      doom-modeline-major-mode-icon t
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

     )
)

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
  (setq org-agenda-files (append (bigui/find-org-file-recursively (concat org-directory "org/")  "org")))
  (add-hook 'org-agenda-mode-hook '(lambda () (hl-line-mode 1)))
  (setq
   org-hide-emphasis-markers t
   calendar-week-start-day 1 ;; start week on monday
   org-default-notes-file  (concat org-directory "org/" "Inbox.org")
   org-default-work-file   (concat org-directory "org/" "work.org")
   org-default-work-files   (list org-default-work-file)
   org-default-learning-file  (concat org-directory "org/" "learning_profdev.org")
   org-startup-folded 't
   org-columns-default-format "%25ITEM %TODO %3PRIORITY %TAGS %Effort"
   org-columns-default-format-for-agenda "%25ITEM %TODO %3PRIORITY %TAGS %Effort"
   org-agenda-inhibit-startup nil
   org-id-locations-file (expand-file-name ".orgids" "~")
   )
  ;; make latex formulas larger
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
  (setq org-capture-templates
      '(("l" "Link" entry
         (file+headline org-default-notes-file "Links")
         "* %a\n %?\n %i" :immediate-finish 1)
        ("t" "Todo" entry (file+headline  org-default-notes-file "TASKS")
         "* TODO %?\n SCHEDULED: %t\n  %i\n")
        ("w" "Todo - Work" entry (file+headline  org-default-work-file "Misc Tasks")
         "* TODO %?\n SCHEDULED: %t\n  %i\n")
        ("v" "Talk to Watch" entry (file+headline  org-default-learning-file "Talks and Conference Video Queue")
         "* %a\n %i  " :immediate-finish 1)
        ("p" "Paper / Article to read" entry (file+headline  org-default-learning-file "Paper Queue")
         "* %a\n %i  " :immediate-finish 1)
        ("T" "Todo (with link)" entry (file+headline  org-default-notes-file "TASKS")
         "* TODO %?\n SCHEDULED: %t\n  %a\n %i\n")
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
        ("b" "Idea forBlog" entry (file+headline (concat org-directory "blog-ideas.org.txt") "Ideas")
         "* %?\n %i")
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
  )

  (setq org-todo-keywords
        '((sequence "TODO" "IN-PROGRESS" "|"  "DONE" )))
  (setq org-tags-exclude-from-inheritance '("PROJECT" "CURRENT" "project" "current" "NOTE" "SERVER" "NEXT" "PLANNED" "AREA" "META" "NEXT" "crypt" "desparche" "writing" "reading" "area"))
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
         ((tags-todo "+dailies+SCHEDULED<=\"<today>\"")
          (tags "+learning+current-@work")
          (tags "reading")
          (tags "writing")
           (agenda "" ((org-agenda-span '3)
                       (org-agenda-sorting-strategy
                        (quote ((agenda time-up priority-down tag-up))))
                       (org-deadline-warning-days 3)))
           (tags-todo "REFILE")
           (tags "next/TODO|WAITING|STARTED"
                      ((org-agenda-sorting-strategy '(priority-down)))
                      )
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
  (setq-default org-download-image-dir (concat cloud-drive-dir  "org-images/"))
  (setq org-download-screenshot-method (mac-or-linux "/usr/sbin/screencapture -i %s"  "gnome-screenshot"))
  (setq org-download-method 'Directory)
  :hook
  (dired-mode . org-download-enable)
  )


;; ORG-ROAM
(use-package! org-roam
  :config
  (setq org-roam-directory org-directory
        org-roam-graph-exclude-matcher '("private" "repeaters" "dailies")
        org-roam-node-display-template "${doom-hierarchy:*} ${tags:45}"
        )
  (map! :leader
        :prefix "n"
        :desc "org-roam-node-find" "f" #'org-roam-node-find ;originnaly mapped to find-file-in-notes
        :desc "org-roam-node-insert" "i" #'org-roam-node-insert ;; originally not mapped
  )
  (setq org-roam-capture-templates '(
                                  ("d" "default" plain "%?"
                                   :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                                      "#+title: ${title}\n")
                                   :unnarrowed t)
                                  ("c" "concept" plain "%?"
                                   :target (file+head "concepts/${slug}.org"
                                                      "#+title: ${title}\n")
                                   :unnarrowed t)

                                ("r" "ref" plain "%?" :target
                                 (file+head "references/${slug}.org"
                                            "#+title: ${title}")
                                 :unnarrowed t)))

)


;; org-journal - disabling for now using org-roam dailies
;; (after! org-journal
;;   :config
;;   ((setq var )
;;    ;org-journal-file-header  "#+title: Monthly Journal\n#+STARTUP: folded"
;;    org-journal-file-format "%Y-%m.org"
;;    org-journal-dir "~/Dropbox/Notational Data/journal/"
;;    org-journal-date-format "%A, %d %B %Y"
;;    org-journal-enable-agenda-integration t
;;    org-journal-file-type 'monthly
;;  )
;; )
;; (defun org-journal-save-entry-and-exit()
;;   "Simple convenience function.
;;   Saves the buffer of the current day's entry and kills the window
;;   Similar to org-capture like behavior"
;;   (interactive)
;;   (save-buffer)
;;   (kill-buffer-and-window))
;(define-key org-journal-mode-map (kbd "C-x C-s") 'org-journal-save-entry-and-exit)

;;;;;;;;;
;; org-ref and related packages
;;;;;;;;;

(after! org-ref
  :config
  (setq
   reftex-default-bibliography (concat cloud-drive-dir "bibliography/references.bib")
   org-ref-bibliography-notes (concat cloud-drive-dir "bibliography/biblio-notes.org")
   org-ref-default-bibliography '((concat cloud-drive-dir "bibliography/references.bib"))
   org-ref-pdf-directory (concat cloud-drive-dir "bibliography/bibtex-pdfs/")
   bibtex-completion-library-path (concat cloud-drive-dir "bibliography/bibtex-pdfs")
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
(use-package! org-fancy-priorities
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")))

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

(use-package! conda
  :config
  (setq conda-anaconda-home (mac-or-linux "/usr/local/Caskroom/miniconda/base" "~/anaconda3/")

   )
  )

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
(add-hook 'python-mode-hook 'conda-env-autoactivate-mode)
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


;; Shadowenv for shopify stuff
;;
;;
(use-package! shadowenv
  :if (memq window-system '(mac ns))
  :hook (after-init . shadowenv-global-mode)
)

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
