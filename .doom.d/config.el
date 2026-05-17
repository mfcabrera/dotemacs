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

;; Local-machine overrides. `local.el' is gitignored — set machine-specific
;; toggles like `bigui/enable-org-roam-ui' here.
(defvar bigui/enable-org-roam-ui t
  "When non-nil, enable the org-roam-ui graph viewer and its websocket dep.")
(let ((local-file (expand-file-name "local.el" doom-user-dir)))
  (when (file-exists-p local-file)
    (load! "local.el")))


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
        ;; Reading Inbox capture — drops into inbox/Inbox.org "Reading Inbox"
        ;; with structured properties. Triaged Sundays into areas/reading-list.org.
        ("r" "Reading Inbox (article/video/repo)" entry
         (file+headline org-default-notes-file "Reading Inbox")
         "* %^{Title}
:PROPERTIES:
:CAPTURED: %U
:EFFORT:   %^{Effort estimate (e.g. 0:20)|0:20}
:URL:      %^{URL|%x}
:SOURCE:   %^{Source (LinkedIn/X/colleague/blog/etc.)}
:TYPE:     %^{Type|article|video|repo|paper|tweet|book}
:END:

Why I want this: %?

%i" :empty-lines 1)
        ;; Legacy capture: keeps backwards compatibility with old "p" muscle memory.
        ;; Also lands in Reading Inbox so triage flow stays single-source.
        ("p" "Paper / Article / Video to read (legacy → Reading Inbox)" entry
         (file+headline org-default-notes-file "Reading Inbox")
         "* %a
:PROPERTIES:
:CAPTURED: %U
:EFFORT:   0:20
:END:

%i  " :immediate-finish 1)
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
                      ("today" . ?t)
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
        '((sequence "TODO(t)" "STARTED(s)" "WAITING(w)" "|" "DONE(d)" "CANCELED(c)")))
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

  ;; ----------------------------------------------------------------
  ;; Stalled-project detector.
  ;; Skips a :PROJECT:current: heading from the agenda view when its
  ;; subtree contains at least one actionable descendant:
  ;;   - TODO/STARTED with :next: or :today: tag, OR
  ;;   - any heading with SCHEDULED within the next 7 days.
  ;; Returns nil to KEEP the heading (i.e., it IS stalled), or the
  ;; position to skip-to in order to HIDE it.
  ;; ----------------------------------------------------------------
  (defun my/org-agenda-skip-if-project-actionable ()
    "Skip project headlines that have any actionable descendant.
Used by \"Stalled current projects\" agenda command (key 'S').

A project is *actionable* (and thus hidden) when ANY of:
  - subtree contains a TODO/STARTED heading (any tag), OR
  - subtree contains SCHEDULED within next 7 days, OR
  - the project heading itself is in WAITING state (legitimately blocked).

Returns nil to keep (= stalled), or position to skip-to (= actionable)."
    (let* ((entry-end (save-excursion (org-end-of-subtree t t)))
           (project-level (org-current-level))
           (project-todo (org-get-todo-state))
           (now (current-time))
           (cutoff (time-add now (days-to-time 7)))
           (back-cutoff (time-subtract now (days-to-time 2)))
           (actionable nil))
      ;; WAITING at project level = legitimately blocked, not stalled
      (when (member project-todo '("WAITING"))
        (setq actionable t))
      (save-excursion
        (forward-line 1)
        (while (and (not actionable) (< (point) entry-end))
          (when (and (looking-at org-heading-regexp)
                     (> (org-current-level) project-level))
            (let ((todo (org-get-todo-state))
                  (sched (org-get-scheduled-time (point))))
              (when (member todo '("TODO" "STARTED"))
                (setq actionable t))
              (when (and sched
                         (time-less-p sched cutoff)
                         (time-less-p back-cutoff sched))
                (setq actionable t))))
          (forward-line 1)))
      (when actionable entry-end)))

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
         ((tags "learning+current"))

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



        ("n" "Stale :next: pool (not in scratchpad)"
         ;; All :next: items not currently tagged :today:
         ;; Use this for weekly triage of the backlog pool — what's been sitting too long?
         ((tags "next-today/TODO|STARTED"
                ((org-agenda-overriding-header "Stale :next: pool — items not in today's scratchpad")
                 (org-agenda-sorting-strategy '(priority-down tag-up))
                 (org-super-agenda-groups
                  '((:name "Work" :tag "@work")
                    (:name "Personal" :and (:not (:tag "@work")))))))))

        ("N" "Stale :next: pool (Work only)"
         ((tags "next-today+@work/TODO|STARTED"
                ((org-agenda-overriding-header "Stale :next: pool (Work) — not in today's scratchpad")
                 (org-agenda-sorting-strategy '(priority-down tag-up))))))

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

        ;; ============================================================
        ;; Stalled current projects
        ;; A :PROJECT:current: heading is "stalled" when its subtree has
        ;; no descendant TODO/STARTED tagged :next: or :today: AND
        ;; no future SCHEDULED within 7 days.
        ;; ============================================================
        ("S" "Stalled current projects (no :next:/:today:/SCHEDULED)"
         ((tags "PROJECT+current-1on1"
                ((org-agenda-overriding-header "Stalled :PROJECT:current: — needs a next action")
                 (org-agenda-skip-function
                  '(my/org-agenda-skip-if-project-actionable))
                 (org-super-agenda-groups
                  '((:name "Work" :tag "@work")
                    (:name "Personal" :and (:not (:tag "@work"))))))))
         )


        ("L" "Weekly Plan"
         ( (agenda)
           (todo "TODO")
           (tags "PROJECT")

           )
         )

        ;; ============================================================
        ;; Reading workflow agendas
        ;; Doctrine: resources/zettelkasten/20260506100000-reading-workflow.org
        ;; Implementation: areas/reading-list.org
        ;; ============================================================
        ("r" . "Reading agendas")

        ("ra" "Reading — Active + full queue"
         ((tags "current+reading"
                ((org-agenda-overriding-header "📚 Active Reads")))
          (tags "queue+quick"
                ((org-agenda-overriding-header "⚡ Quick Queue (≤30 min)")
                 (org-agenda-sorting-strategy '(priority-down effort-up))))
          (tags "queue+medium"
                ((org-agenda-overriding-header "📖 Medium Queue (30 min – 3h)")
                 (org-agenda-sorting-strategy '(priority-down effort-up))))
          (tags "queue+deep"
                ((org-agenda-overriding-header "📕 Deep Queue (>3h)")
                 (org-agenda-sorting-strategy '(priority-down))))
          (tags "reading+capture"
                ((org-agenda-overriding-header "📥 Reading Inbox (needs triage)")))))

        ("r3" "Reading — Quick (≤30 min)"
         ((tags "queue+quick"
                ((org-agenda-overriding-header "⚡ Quick reads — pick one (≤30 min)")
                 (org-agenda-sorting-strategy '(priority-down effort-up))))))

        ("r6" "Reading — Up to 60 min"
         ((tags "queue+quick|queue+medium"
                ((org-agenda-overriding-header "📖 Reads up to 60 min")
                 (org-agenda-sorting-strategy '(effort-up priority-down))
                 (org-agenda-skip-function
                  '(org-agenda-skip-entry-if 'todo '("DONE" "PARKED" "DROPPED")))))))

        ("rd" "Reading — Deep (books / courses)"
         ((tags "queue+deep"
                ((org-agenda-overriding-header "📕 Deep queue — books & courses")
                 (org-agenda-sorting-strategy '(priority-down))))
          (tags "current+reading"
                ((org-agenda-overriding-header "📖 Currently active deep reads")))))

        ("ri" "Reading Inbox — needs triage"
         ((tags "reading+capture"
                ((org-agenda-overriding-header "📥 Reading Inbox — Sunday triage (15 min)")))))
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

;; org-web-tools: web clipper for LLM Knowledge Base pipeline
;; Captures URL content as .org into resources/raw/ for later LLM ingest
(use-package! org-web-tools
  :commands (org-web-tools-read-url-as-org
             org-web-tools-insert-link-for-url
             org-web-tools-insert-web-page-as-entry))

(defun my/org-web-tools-capture-to-raw (url)
  "Capture URL content to resources/raw/ as an org file for the LLM wiki pipeline."
  (interactive "sURL: ")
  (require 'org-web-tools)
  (setq url (string-trim url))
  (let* ((timestamp (format-time-string "%Y%m%d%H%M%S"))
         (content (org-web-tools--url-as-readable-org url))
         (raw-title (if (string-match "^\\*+ \\(.+\\)$" content)
                        (match-string 1 content)
                      "untitled"))
         ;; Strip org link markup [[url][title]] → title, and trailing :tags:
         (title (if (string-match "\\[\\[.+\\]\\[\\(.+?\\)\\]\\]" raw-title)
                    (match-string 1 raw-title)
                  raw-title))
         (title (replace-regexp-in-string "\\s-*:[a-zA-Z:]+:\\s-*$" "" title))
         (slug (replace-regexp-in-string "[^a-zA-Z0-9]+" "-" (downcase title)))
         (slug (string-trim slug "-" "-"))
         (slug (if (> (length slug) 60) (substring slug 0 60) slug))
         (filename (format "%s-%s.org" timestamp slug))
         (filepath (expand-file-name filename
                     (expand-file-name "resources/raw" org-roam-directory)))
         (uuid (string-trim (shell-command-to-string "python3 -c \"import uuid; print(str(uuid.uuid4()))\""))))
    (with-temp-file filepath
      (insert (format ":PROPERTIES:\n:ID:       %s\n:END:\n" uuid))
      (insert (format "#+title: %s\n" title))
      (insert "#+filetags: :raw:\n")
      (insert (format "#+date: %s\n" (format-time-string "[%Y-%m-%d %a]")))
      (insert (format "#+roam_refs: %s\n\n" url))
      (insert "* Source Content\n")
      (insert (replace-regexp-in-string "^\\*" "**" content))
      (insert "\n"))
    (message "Captured to %s" filepath)
    filepath))

(map! :leader
      (:prefix ("n" . "notes")
       :desc "Capture URL to raw/" "w" #'my/org-web-tools-capture-to-raw))

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

(when bigui/enable-org-roam-ui
  (use-package! websocket
    :after org-roam)

  (use-package! org-roam-ui
    :after org-roam
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t)))

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
  (setq claude-code-ide-mcp-server-port 19200)
  (setq claude-code-ide-enable-mcp-server t)
  (claude-code-ide-mcp-server-ensure-server)

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

  
  ;; Revert org buffers MCP tool
  (defun my/mcp-revert-org-buffers ()
    "Revert all org-mode buffers that are visiting files.
Returns a summary of reverted buffers."
    (let ((reverted '()))
      (dolist (buf (buffer-list))
        (when (and (buffer-file-name buf)
                   (string-suffix-p ".org" (buffer-file-name buf))
                   (file-exists-p (buffer-file-name buf)))
          (with-current-buffer buf
            (revert-buffer t t t)
            (push (buffer-name buf) reverted))))
      (if reverted
          (format "Reverted %d org buffer(s): %s"
                  (length reverted)
                  (string-join reverted ", "))
        "No org buffers to revert.")))

  (add-to-list 'claude-code-ide-mcp-server-tools
               (claude-code-ide-make-tool
                :name "revertOrgBuffers"
                :function #'my/mcp-revert-org-buffers
                :description "Revert all open org-mode buffers to their on-disk state. Call this after editing org files externally."
                :args nil))

  ;; Org-roam database sync
  (defun my/mcp-org-roam-db-sync ()
    "Sync the org-roam database. Call after creating new org files with :ID: properties."
    (require 'org-roam)
    (org-roam-db-sync)
    "org-roam database synced successfully.")

  (add-to-list 'claude-code-ide-mcp-server-tools
               (claude-code-ide-make-tool
                :name "orgRoamDbSync"
                :function #'my/mcp-org-roam-db-sync
                :description "Sync the org-roam SQLite database. Call this after creating or modifying org files with :ID: properties so that org-roam links resolve correctly."
                :args nil))

  ;; Open file in Emacs (never replace the claude-code-ide terminal window)
  (defun my/mcp-open-file (file-path)
    "Open FILE-PATH in another window, preserving the claude-code terminal."
    (if (file-exists-p file-path)
        (progn
          (find-file-other-window file-path)
          (format "Opened %s" file-path))
      (format "Error: file not found: %s" file-path)))

  (add-to-list 'claude-code-ide-mcp-server-tools
               (claude-code-ide-make-tool
                :name "openFileInEmacs"
                :function #'my/mcp-open-file
                :description "Open a file in Emacs. Useful for triggering org-roam indexing of new files, or navigating the user to a specific file."
                :args '((:name "file_path" :type string :description "Absolute path to the file to open"))))

  ;; Org-roam find node by title (search)
  (defun my/mcp-org-roam-find-node (query)
    "Search org-roam nodes matching QUERY and return top results."
    (require 'org-roam)
    (let* ((nodes (org-roam-node-list))
           (matches (seq-filter
                     (lambda (node)
                       (string-match-p (regexp-quote query)
                                       (org-roam-node-title node)))
                     nodes))
           (results (seq-take matches 10)))
      (if results
          (mapconcat
           (lambda (node)
             (format "- %s [id:%s] (%s)"
                     (org-roam-node-title node)
                     (org-roam-node-id node)
                     (org-roam-node-file node)))
           results "\n")
        (format "No nodes found matching '%s'" query))))

  (add-to-list 'claude-code-ide-mcp-server-tools
               (claude-code-ide-make-tool
                :name "orgRoamSearch"
                :function #'my/mcp-org-roam-find-node
                :description "Search org-roam nodes by title. Returns matching node titles, IDs, and file paths. Useful for finding existing notes before creating links."
                :args '((:name "query" :type string :description "Search string to match against node titles"))))

  ;; Org-agenda redo (refresh all agenda views)
  (defun my/mcp-org-agenda-redo ()
    "Refresh all open org-agenda buffers."
    (let ((count 0))
      (dolist (buf (buffer-list))
        (when (and (buffer-live-p buf)
                   (with-current-buffer buf
                     (derived-mode-p 'org-agenda-mode)))
          (with-current-buffer buf
            (org-agenda-redo t)
            (setq count (1+ count)))))
      (if (> count 0)
          (format "Refreshed %d agenda buffer(s)." count)
        "No open agenda buffers found.")))

  (add-to-list 'claude-code-ide-mcp-server-tools
               (claude-code-ide-make-tool
                :name "orgAgendaRefresh"
                :function #'my/mcp-org-agenda-redo
                :description "Refresh all open org-agenda buffers. Call after modifying scheduled/deadline timestamps or TODO states."
                :args nil))

  ;; ----------------------------------------------------------------
  ;; Generic agenda runner — lets Claude call any custom command by key.
  ;; Pair this with listAgendaCommands so Claude can discover what's
  ;; available instead of asking. Both functions are the source of truth
  ;; for "what does my org actually say?" — preferred over file grepping
  ;; because they respect tag inheritance, archive skip, skip-functions,
  ;; repeaters, etc.
  ;; ----------------------------------------------------------------
  (defun my/mcp-run-agenda-command (key)
    "Run org-agenda custom command KEY and return the buffer as a string.
KEY is the dispatcher key as registered in `org-agenda-custom-commands'
(e.g., \"S\" for stalled projects, \"n\" for stale :next: pool)."
    (require 'org-agenda)
    (let ((org-agenda-buffer-name "*MCP-Agenda*")
          (org-agenda-sticky nil)
          (org-agenda-window-setup 'current-window))
      (condition-case err
          (progn
            (org-agenda nil key)
            (with-current-buffer org-agenda-buffer-name
              (let ((content (buffer-string)))
                (kill-buffer)
                content)))
        (error (format "Error running agenda command '%s': %s"
                       key (error-message-string err))))))

  (add-to-list 'claude-code-ide-mcp-server-tools
               (claude-code-ide-make-tool
                :name "runAgendaCommand"
                :function #'my/mcp-run-agenda-command
                :description "Run any org-agenda custom command by its dispatcher key and return the rendered view as text. Examples: 'S' = Stalled current projects, 'n' = Stale :next: pool, 'R' = Currently Learning, 'h' = Personal/Home, 'w' = Work. Use listAgendaCommands to discover keys. Prefer this over grepping org files — the agenda respects tag inheritance, archives, skip-functions, and repeaters."
                :args '((:name "key" :type string :description "Dispatcher key (e.g., 'S', 'n', 'R', 'h', 'w', 'D')"))))

  (defun my/mcp-list-agenda-commands ()
    "Return all org-agenda custom commands as a readable list.
Handles three shapes:
  (key . \"Prefix label\")           — prefix key
  (key \"Label\" type matcher …)     — flat command
  (key \"Label\" ((type matcher …))) — block command"
    (require 'org-agenda)
    (if (null org-agenda-custom-commands)
        "No org-agenda-custom-commands defined."
      (mapconcat
       (lambda (cmd)
         (let ((key (car cmd))
               (rest (cdr cmd)))
           (cond
            ;; Prefix key: (key . "Label")
            ((stringp rest)
             (format "  %s  [prefix]  %s" key rest))
            ;; Standard command: (key "Label" ...)
            ((and (listp rest) (stringp (car rest)))
             (let* ((label (car rest))
                    (body (cdr rest))
                    (first (car body))
                    (kind (cond
                           ((null first) "?")
                           ((symbolp first) (symbol-name first))
                           ((consp first)
                            (let ((sub (car first)))
                              (cond
                               ((symbolp sub) (symbol-name sub))
                               (t "block"))))
                           (t "?")))
                    (matcher (cond
                              ((and (consp first) (stringp (cadr first)))
                               (cadr first))
                              ((stringp (cadr body))
                               (cadr body))
                              (t ""))))
               (format "  %s  [%s]  %s%s"
                       key kind label
                       (if (and matcher (not (string-empty-p matcher)))
                           (format "  →  %s" matcher)
                         ""))))
            (t (format "  %s  [unknown shape]" key)))))
       org-agenda-custom-commands
       "\n")))

  (add-to-list 'claude-code-ide-mcp-server-tools
               (claude-code-ide-make-tool
                :name "listAgendaCommands"
                :function #'my/mcp-list-agenda-commands
                :description "List all org-agenda custom commands available via C-c a. Returns key, type, label, and tag matcher (when applicable). Call this before runAgendaCommand to discover what's available."
                :args nil))

  (defun my/mcp-run-agenda-tags-matcher (match)
    "Run an ad-hoc org-agenda tags search with MATCH and return the result.
MATCH is an org tag/property matcher string (e.g.,
\"learning+current\", \"PROJECT+current-@work\",
\"next-today/TODO|STARTED\")."
    (require 'org-agenda)
    (let ((org-agenda-buffer-name "*MCP-Agenda-Match*")
          (org-agenda-sticky nil)
          (org-agenda-window-setup 'current-window))
      (condition-case err
          (progn
            (org-tags-view nil match)
            (with-current-buffer org-agenda-buffer-name
              (let ((content (buffer-string)))
                (kill-buffer)
                content)))
        (error (format "Error running tags matcher '%s': %s"
                       match (error-message-string err))))))

  (add-to-list 'claude-code-ide-mcp-server-tools
               (claude-code-ide-make-tool
                :name "runAgendaTagsMatcher"
                :function #'my/mcp-run-agenda-tags-matcher
                :description "Run an ad-hoc org-agenda tag/property matcher and return the result. Use for slices not saved as custom commands. Examples: 'learning+current', 'PROJECT+current-@work', 'next-today/TODO|STARTED'. Syntax: org-mode tag matcher (see (org)Matching tags and properties). Prefer runAgendaCommand for saved views."
                :args '((:name "match" :type string :description "Org tag/property matcher (e.g., 'learning+current')"))))

  (defun my/mcp-get-org-agenda-files ()
    "Return the list of files org-agenda considers in-scope."
    (require 'org-agenda)
    (let ((files (org-agenda-files)))
      (if files
          (mapconcat #'identity files "\n")
        "No agenda files configured.")))

  (add-to-list 'claude-code-ide-mcp-server-tools
               (claude-code-ide-make-tool
                :name "getOrgAgendaFiles"
                :function #'my/mcp-get-org-agenda-files
                :description "Return the list of files org-agenda considers in-scope. Use this to know which files agenda queries cover before grepping or analyzing the second brain."
                :args nil))

  ;; ----------------------------------------------------------------
  ;; runOrgQuery — typed tag/property query that returns JSON instead of a
  ;; rendered agenda buffer. Eliminates buffer-text parsing fragility.
  ;; ----------------------------------------------------------------
  (defun my/mcp--time-iso (time)
    "Format a TIME as ISO 8601 date string, or nil."
    (when time (format-time-string "%Y-%m-%d" time)))

  (defun my/mcp--headline-to-plist (fields)
    "At a headline, return a plist with the requested FIELDS.
FIELDS is a list of strings: title, todo, tags, scheduled, deadline,
priority, category, level, file, line, body, id, properties, effort."
    (let* ((comps (org-heading-components))
           (level (nth 0 comps))
           (todo (nth 2 comps))
           (priority (nth 3 comps))
           (title (nth 4 comps))
           (tags (org-get-tags nil nil))
           (sched (org-get-scheduled-time (point)))
           (dl (org-get-deadline-time (point)))
           (file (buffer-file-name))
           (line (line-number-at-pos))
           (cat (org-get-category))
           (id (org-entry-get nil "ID"))
           (effort (org-entry-get nil "Effort"))
           (result '()))
      (dolist (f fields)
        (pcase f
          ("title" (push (cons "title" (or title "")) result))
          ("todo"  (push (cons "todo" (or todo nil)) result))
          ("tags"  (push (cons "tags" (vconcat tags)) result))
          ("scheduled" (push (cons "scheduled" (or (my/mcp--time-iso sched) nil)) result))
          ("deadline"  (push (cons "deadline" (or (my/mcp--time-iso dl) nil)) result))
          ("priority"  (push (cons "priority" (if priority (char-to-string priority) nil)) result))
          ("category"  (push (cons "category" (or cat "")) result))
          ("level"     (push (cons "level" level) result))
          ("file"      (push (cons "file" (or file "")) result))
          ("line"      (push (cons "line" line) result))
          ("id"        (push (cons "id" (or id nil)) result))
          ("effort"    (push (cons "effort" (or effort nil)) result))
          ("body"
           (let ((body (save-excursion
                         (org-end-of-meta-data t)
                         (buffer-substring-no-properties
                          (point)
                          (or (save-excursion (outline-next-heading) (point))
                              (point-max))))))
             (push (cons "body" (string-trim body)) result)))
          ("properties"
           (push (cons "properties"
                       (or (org-entry-properties) nil))
                 result))))
      (nreverse result)))

  (defun my/mcp-run-org-query (query-json)
    "Run a typed org query and return JSON.
QUERY-JSON is a JSON object with:
  type    : \"tags\" | \"tags-todo\" | \"todo\"  (required)
  match   : org tag/property matcher string (required for tags*)
  todo    : org TODO regex (for type=\"todo\")
  fields  : list of field names to include (default: title, todo, tags, scheduled, file, line)
  limit   : max results (default 100)
  files   : list of files (default: org-agenda-files)"
    (require 'org)
    (require 'org-agenda)
    (require 'json)
    (let* ((q (json-parse-string query-json :object-type 'alist :array-type 'list))
           (qtype (alist-get 'type q))
           (match (alist-get 'match q))
           (todo-re (alist-get 'todo q))
           (fields (or (alist-get 'fields q)
                       '("title" "todo" "tags" "scheduled" "file" "line")))
           (limit (or (alist-get 'limit q) 100))
           (files (or (alist-get 'files q) (org-agenda-files)))
           (results '())
           (count 0))
      (condition-case err
          (progn
            (cond
             ((member qtype '("tags" "tags-todo"))
              (org-map-entries
               (lambda ()
                 (when (< count limit)
                   (push (my/mcp--headline-to-plist fields) results)
                   (setq count (1+ count))))
               match
               files
               (when (string= qtype "tags-todo") 'todo)))
             ((string= qtype "todo")
              (dolist (file files)
                (with-current-buffer (find-file-noselect file)
                  (org-map-entries
                   (lambda ()
                     (when (and (< count limit)
                                (or (null todo-re)
                                    (string-match-p todo-re (or (org-get-todo-state) ""))))
                       (push (my/mcp--headline-to-plist fields) results)
                       (setq count (1+ count))))
                   nil 'file))))
             (t (error "Unknown query type: %s" qtype)))
            (json-encode (nreverse results)))
        (error (format "{\"error\": \"%s\"}" (error-message-string err))))))

  (add-to-list 'claude-code-ide-mcp-server-tools
               (claude-code-ide-make-tool
                :name "runOrgQuery"
                :function #'my/mcp-run-org-query
                :description "Run a typed org-mode query and return structured JSON. Eliminates the need to parse rendered agenda text. Query is a JSON object: {type: 'tags'|'tags-todo'|'todo', match: '<matcher>', fields: [...], limit: N, files: [...]}. Example: {\"type\":\"tags-todo\",\"match\":\"PROJECT+current\",\"fields\":[\"title\",\"todo\",\"tags\",\"file\",\"scheduled\"],\"limit\":50}. Available fields: title, todo, tags, scheduled, deadline, priority, category, level, file, line, body, id, properties, effort."
                :args '((:name "query_json" :type string :description "JSON object describing the query"))))

  ;; ----------------------------------------------------------------
  ;; structuredOrgEdit — typed mutations on org headings.
  ;; Each operation is auditable, idempotent-where-possible, and
  ;; reverts buffers from disk after writing so Emacs stays in sync.
  ;;
  ;; Operations:
  ;;   markDone     : set state to DONE + CLOSED timestamp
  ;;   markCancel   : set state to CANCELED + CLOSED timestamp
  ;;   markTodo     : set state to TODO
  ;;   markStarted  : set state to STARTED
  ;;   setSchedule  : SCHEDULED: <date>   (target gets/replaces schedule)
  ;;   clearSchedule: remove SCHEDULED line
  ;;   setDeadline  : DEADLINE: <date>
  ;;   addTag       : add tag if not present
  ;;   removeTag    : remove tag if present
  ;;   setPriority  : set [#A|B|C] cookie (or remove with "")
  ;;   setProperty  : set :KEY: value in property drawer
  ;;
  ;; Target is identified by ID (preferred) or file+line.
  ;; ----------------------------------------------------------------
  (defun my/mcp--find-target (target)
    "Move point to TARGET headline. Returns t on success, nil otherwise.
TARGET is an alist: ((id . \"uuid\")) or ((file . \"path\") (line . N))
or ((file . \"path\") (title . \"exact title\"))."
    (let ((id (alist-get 'id target))
          (file (alist-get 'file target))
          (line (alist-get 'line target))
          (title (alist-get 'title target))
          (subtitle (alist-get 'subtitle target)))
      (cond
       ;; ID + subtitle: jump to ID, then descend into subtree to find subtitle.
       ;; Use this when the scratchpad has [[id:project-id]] but you want
       ;; to mutate a specific TODO under that project.
       ((and id subtitle)
        (let ((loc (org-id-find id 'marker)))
          (when loc
            (set-buffer (marker-buffer loc))
            (goto-char loc)
            (org-back-to-heading t)
            (let* ((parent-level (org-current-level))
                   (subtree-end (save-excursion (org-end-of-subtree t t)))
                   (found nil))
              (forward-line 1)
              (while (and (not found) (< (point) subtree-end))
                (when (and (looking-at org-heading-regexp)
                           (> (org-current-level) parent-level)
                           (string-match-p
                            (regexp-quote subtitle)
                            (or (org-get-heading t t t t) "")))
                  (setq found t))
                (unless found (forward-line 1)))
              found))))
       ;; ID only: jump to the heading bearing that ID.
       (id
        (let ((loc (org-id-find id 'marker)))
          (when loc
            (set-buffer (marker-buffer loc))
            (goto-char loc)
            t)))
       ((and file line)
        (when (file-exists-p file)
          (set-buffer (find-file-noselect file))
          (goto-char (point-min))
          (forward-line (1- line))
          (org-back-to-heading t)
          t))
       ((and file title)
        (when (file-exists-p file)
          (set-buffer (find-file-noselect file))
          (goto-char (point-min))
          (when (re-search-forward
                 (format "^\\*+\\s-+\\(?:[A-Z]+ \\)?\\(?:\\[#[ABCD]\\] \\)?%s"
                         (regexp-quote title))
                 nil t)
            (org-back-to-heading t)
            t))))))

  (defun my/mcp--save-and-revert ()
    "Save current buffer, then revert all org buffers from disk."
    (save-buffer)
    (dolist (buf (buffer-list))
      (when (and (buffer-file-name buf)
                 (string-suffix-p ".org" (buffer-file-name buf))
                 (not (eq buf (current-buffer)))
                 (file-exists-p (buffer-file-name buf)))
        (with-current-buffer buf
          (when (not (buffer-modified-p))
            (revert-buffer t t t))))))

  (defun my/mcp-structured-org-edit (edit-json)
    "Apply a typed mutation to an org heading. EDIT-JSON is:
  {
    op: <operation name>,
    target: {id: \"uuid\"} | {file: \"...\", line: N} | {file: \"...\", title: \"...\"},
    value: <op-specific>   // e.g. \"<2026-05-20 Tue>\" for setSchedule, \"A\" for setPriority
  }"
    (require 'org)
    (require 'json)
    (let* ((edit (json-parse-string edit-json :object-type 'alist :array-type 'list))
           (op (alist-get 'op edit))
           (target (alist-get 'target edit))
           (value (alist-get 'value edit)))
      (condition-case err
          (save-excursion
            (unless (my/mcp--find-target target)
              (error "Target not found: %S" target))
            (let ((before-state (org-get-todo-state))
                  (heading (substring-no-properties (org-get-heading t t t t))))
              (pcase op
                ("markDone"     (org-todo "DONE"))
                ("markCancel"   (org-todo "CANCELED"))
                ("markTodo"     (org-todo "TODO"))
                ("markStarted"  (org-todo "STARTED"))
                ("setSchedule"  (org-schedule nil value))
                ("clearSchedule" (org-schedule '(4)))   ;; C-u prefix = remove
                ("setDeadline"  (org-deadline nil value))
                ("clearDeadline" (org-deadline '(4)))
                ("addTag"
                 (let ((tags (org-get-tags nil t)))
                   (unless (member value tags)
                     (org-set-tags (append tags (list value))))))
                ("removeTag"
                 (org-set-tags (delete value (org-get-tags nil t))))
                ("setPriority"
                 (cond
                  ((or (null value) (string-empty-p value))
                   (org-priority ?\s))
                  (t (org-priority (string-to-char value)))))
                ("setProperty"
                 (let ((kv (split-string value "=" t)))
                   (unless (= 2 (length kv))
                     (error "setProperty value must be 'KEY=VALUE', got: %s" value))
                   (org-set-property (car kv) (cadr kv))))
                (_ (error "Unknown op: %s" op)))
              (my/mcp--save-and-revert)
              (json-encode
               `(("ok" . t)
                 ("op" . ,op)
                 ("heading" . ,heading)
                 ("before_state" . ,(or before-state nil))
                 ("after_state" . ,(or (org-get-todo-state) nil))
                 ("file" . ,(buffer-file-name))
                 ("line" . ,(line-number-at-pos))))))
        (error (json-encode
                `(("ok" . :json-false)
                  ("op" . ,op)
                  ("error" . ,(error-message-string err))))))))

  (add-to-list 'claude-code-ide-mcp-server-tools
               (claude-code-ide-make-tool
                :name "structuredOrgEdit"
                :function #'my/mcp-structured-org-edit
                :description "Apply a typed mutation to a single org heading. Auditable, idempotent. JSON: {op, target, value}. Ops: markDone, markCancel, markTodo, markStarted, setSchedule, clearSchedule, setDeadline, clearDeadline, addTag, removeTag, setPriority, setProperty. Target shapes (try in order): (1) {id:'uuid', subtitle:'substring'} — jump to ID, then descend to child whose heading contains 'subtitle'. Use this when a scratchpad link [[id:...]] points to a project but you want to mutate a specific TODO under it. (2) {id:'uuid'} — heading that owns this ID. (3) {file:'path', line:N} — heading at/before this line. (4) {file:'path', title:'exact match'} — first heading matching title in file. Example: {\"op\":\"markDone\",\"target\":{\"id\":\"abc-123\",\"subtitle\":\"Configurar pago\"}}. For setSchedule, value is org timestamp like '<2026-05-20 Tue>'. For setProperty, value is 'KEY=VALUE'. Returns JSON with ok, before/after state, and file:line."
                :args '((:name "edit_json" :type string :description "JSON object describing the edit"))))

  ;; Anki: push notes from a specific org file to Anki via AnkiConnect
  (defun my/mcp-anki-push-notes (file-path)
    "Push all anki-editor notes in FILE-PATH to Anki.
Requires Anki desktop to be running with AnkiConnect plugin."
    (require 'anki-editor)
    (let ((buf (find-file-noselect file-path)))
      (with-current-buffer buf
        (let ((count 0))
          (org-map-entries
           (lambda ()
             (when (org-entry-get nil "ANKI_NOTE_TYPE")
               (setq count (1+ count))))
           nil 'file)
          (anki-editor-push-notes)
          (format "Pushed %d Anki note(s) from %s" count file-path)))))

  (add-to-list 'claude-code-ide-mcp-server-tools
               (claude-code-ide-make-tool
                :name "ankiPushNotes"
                :function #'my/mcp-anki-push-notes
                :description "Push anki-editor notes from an org file to Anki via AnkiConnect. Requires Anki desktop to be running with AnkiConnect plugin."
                :args '((:name "file_path" :type string :description "Absolute path to the org file containing Anki cards")))))

;; Disable Ctrl + Mouse Wheel from zooming
(global-unset-key (kbd "C-<mouse-4>"))  ;; Unbind zoom-in (scroll-up)
(global-unset-key (kbd "C-<mouse-5>"))  ;; Unbind zoom-out (scroll-down)
(global-unset-key (kbd "C-<wheel-up>"))  ;; Alternative binding for some systems
(global-unset-key (kbd "C-<wheel-down>"))  ;; Alternative binding for some systems

