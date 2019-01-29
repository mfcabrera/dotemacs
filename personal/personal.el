;; personal.el - random bits of elisp

(defun increase-font-size ()
  (set-face-attribute 'default (selected-frame) :height (+ (face-attribute 'default :height) 10)))

(defun decrease-font-size ()
  (set-face-attribute 'default (selected-frame) :height (- (face-attribute 'default :height) 10)))

(defun font-larger ()
  "Increases font size."
  (interactive)
  (increase-font-size))

(defun font-smaller ()
  "Decreases font size."
  (interactive)
  (decrease-font-size))

;; don't clutter the workspace with a bunch of backups
(defvar user-temporary-file-directory
  (concat temporary-file-directory user-login-name "/"))
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))
(setq auto-save-default nil)




(defun sync-classy ()
  (interactive)
  (shrink-window-if-larger-than-buffer)
  (shell-command "cd ~/development ; rsync --exclude 'data'  -az --progress classy  vmx:classy & " ))


(defun sync-embeddings ()
  (interactive)
  (shrink-window-if-larger-than-buffer)
  ;; (shell-command "cd ~/development ; rsync  -az --progress metaprecomp  vmx:metaprecomp & " ))
  (shell-command "cd ~/development ;  rsync -az --progress embeddings-util devbox:  & " )
  (shell-command "cd ~/development ;  rsync -az --progress embeddings-util vmx:  & " )
  )

(defun sync-meta ()
  (interactive)
  (shrink-window-if-larger-than-buffer)
  (shell-command "cd ~/development ; rsync  -az --progress metaprecomp  vmx:metaprecomp & " ))

(defun sync-utiluigi ()
  (interactive)
  (shrink-window-if-larger-than-buffer)
  (shell-command "cd ~/development ; rsync  -az --progress utiluigi  vmx: & " ))

(defun sync-perso ()
  (interactive)
  (shrink-window-if-larger-than-buffer)
  (shell-command "cd ~/development ; rsync --exclude 'data' -az --progress personalization_app  vmx: & " ))


(defun sync-sema ()
  (interactive)
  (shrink-window-if-larger-than-buffer)
  (shell-command "cd ~/development ; rsync  -az --compress-level=9 --progress ty-semantic-api  vmx: & " ))


;;(global-set-key (kbd "C-c C-, ") 'sync-meta)
;(global-set-key (kbd "C-c C-, ") 'sync-classy)

(defun ty-hadoop ()
  (interactive)
  (browse-url "https://vm1.trustyou.com:5030"))

;(global-set-key (kbd "C-c C-t h") 'ty-hadoop)


(defun sync-sentency ()
  (interactive)
  (shrink-window-if-larger-than-buffer)
  (shell-command "cd ~/development ; rsync --exclude='lib/stanford-ner' --exclude=files  -az --progress sentency  vmx:sentency & " ))
;;(global-set-key (kbd "C-c C-y ") 'sync-sentency)





(defun my-insert-quote ()
  (interactive)
  (if (region-active-p)
      (insert-pair 1 ?\' ?\')
    (insert "''")
    (backward-char)))

(global-set-key (kbd "M-¡") 'my-insert-quote)


(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(when (and window-system (eq system-type 'darwin))
  ;; When started from Emacs.app or similar, ensure $PATH
  ;; is the same the user would see in Terminal.app
  (set-exec-path-from-shell-PATH))


;; Copyright (c) 2014 Alexey Kutepov a.k.a. rexim


(defun straight-string (s)
  (mapconcat (lambda (x) x) (split-string s) " "))

(defun extract-title-from-html (html)
  (let ((start (string-match "<title>" html))
        (end (string-match "</title>" html))
        (chars-to-skip (length "<title>")))
    (if (and start end (< start end))
        (substring html (+ start chars-to-skip) end)
      nil)))


(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives
             '("elpy" . "http://jorgenschaefer.github.io/packages/"))

(defvar org-reveal-root "file:////Users/miguel/development/reveal.js")
(setq  whitespace-line-column  100)

(setq prelude-guru nil)

;; Auto package installation
(prelude-require-packages '(ox-reveal org-jira org-gcal magit gnuplot elpy json-mode org-mac-link pig-mode))



;; Doopla
(defun doopla ()
  (interactive)
  (with-output-to-temp-buffer "*doopla*"
    (shell-command "doopla 2>/dev/null  &" "*doopla*" "*Messages*")
    (pop-to-buffer "*doopla*")))


(require 'ansi-color)

(defadvice display-message-or-buffer (before ansi-color activate)
  "Process ANSI color codes in shell output."
  (let ((buf (ad-get-arg 0)))
    (and (bufferp buf)
         (string= (buffer-name buf) "*doopla*")
         (with-current-buffer buf
           (ansi-color-apply-on-region (point-min) (point-max))))))


(setq tab-width 4)

(setq neo-smart-open nil)

(setq langtool-language-tool-jar "/Users/miguel/bin/LanguageTool-3.5/languagetool-commandline.jar")


;Non-nil means `display-buffer' should reuse frames. If the buffer
;in question is already displayed in a frame, ; raise that frame.

(setq-default display-buffer-reuse-frames t)


(require 'editorconfig)
(editorconfig-mode 1)

(use-package highlight-symbol
             :diminish highlight-symbol-mode
             :commands highlight-symbol
             :bind ("s-h" . highlight-symbol))

(defun insert-branch-name ()
  "Insert <p></p> at cursor point."
  (interactive)
  (insert (shell-command-to-string "git branch"))
  (backward-char 4)
  )

(use-package popup-imenu
  :commands popup-imenu
  :bind ("M-i" . popup-imenu))

(use-package org-trello
  :init
  (custom-set-variables '(org-trello-files '(
                                             "/Users/miguel/Dropbox/Notational Data/TODO-Casa-Berling.org.txt"))
                        '(org-trello-current-prefix-keybinding "C-c x")
                        )
  )

(set-default-font
 "-*-Consolas-normal-normal-normal-*-17-*-*-*-m-0-iso10646-1"
 )


;(set-variable 'flycheck-python-mypy-executable "/Users/mcabrera/anaconda3/bin/mypy")
(set-variable 'flycheck-python-mypy-args '("--ignore-missing-imports" "--check-untyped-defs" "--strict-optional"))

(flycheck-add-next-checker 'python-flake8 'python-mypy)


(require 'py-isort)
;;(add-hook 'before-save-hook 'py-isort-before-save)

;; This functon is to being able to properly edit Sphinx docs becuse indentation rules with
;; Python are too strict
;; Based on the following links:
;; https://stackoverflow.com/questions/69934/set-4-space-indent-in-emacs-in-text-mode
;; https://emacs.stackexchange.com/questions/13249/indention-and-tabs-in-fundamental-mode
;; https://emacs.stackexchange.com/questions/31685/how-to-fix-multiline-string-indentation-in-python-mode
;; https://emacs.stackexchange.com/questions/26435/how-can-i-disable-indentation-rules-within-docstrings-in-python-mode/29415#29415

;; Keep underscores within a word boundary


(defun my-python-indent-line ()
  (if (eq (car (python-indent-context)) :inside-docstring)
      (insert-tab)
    (python-indent-line)))

(defun my-python-mode-hook ()
  (setq indent-line-function #'my-python-indent-line)
  (local-set-key [f8] 'company-show-doc-buffer)
  )
(add-hook 'python-mode-hook #'my-python-mode-hook)
(setq-default tab-width 4)

;; treat my_variable as a single word
(add-hook 'python-mode-hook
          (lambda () (modify-syntax-entry ?_ "w" python-mode-syntax-table)))


(setq elpy-rpc-python-command "/Users/mcabrera/anaconda3/bin/python")

;; (setq python-python-command "/Users/mcabrera/anaconda3/bin/python")

(setq flycheck-python-flake8-executable "/Users/mcabrera/anaconda3/bin/flake8")

(with-eval-after-load 'flycheck
  (flycheck-pos-tip-mode))

(defun magit-add-current-branch-to-buffer-and-kill-ring ()
  "Write the current branch at point copy it to the `kill-ring'."
  (interactive)
  (let ((branch (magit-get-current-branch)))
    (if branch
        (progn (kill-new branch)
               (insert branch))
      (user-error "There is not current branch"))))


(defun my-text-mode-hook ()
  (local-set-key (kbd "H-b") 'magit-add-current-branch-to-buffer-and-kill-ring)

)
(add-hook 'text-mode-hook 'my-text-mode-hook)

(my-text-mode-hook)
;;;; Fonts with ligatures support
;;;; Install from: https://github.com/tonsky/FiraCode
;; (set-language-environment "UTF-8")
;; (set-default-coding-systems 'utf-8)

;; (when (window-system)
;;   (set-default-font "Fira Code"))
;; (let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
;;                (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
;;                (36 . ".\\(?:>\\)")
;;                (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
;;                (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
;;                (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
;;                (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
;;                (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
;;               (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
;;                (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
;;                (48 . ".\\(?:x[a-zA-Z]\\)")
;;                (58 . ".\\(?:::\\|[:=]\\)")
;;                (59 . ".\\(?:;;\\|;\\)")
;;                (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
;;                (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
;;                (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
;;                (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
;;                (91 . ".\\(?:]\\)")
;;                (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
;;                (94 . ".\\(?:=\\)")
;;                (119 . ".\\(?:ww\\)")
;;                (123 . ".\\(?:-\\)")
;;                (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
;;                (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
;;                )
;;              ))
;;   (dolist (char-regexp alist)
;;     (set-char-table-range composition-function-table (car char-regexp)
;;                           `([,(cdr char-regexp) 0 font-shape-gstring]))))
