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


(global-set-key (kbd "C-c C-, ") 'sync-meta)
;(global-set-key (kbd "C-c C-, ") 'sync-classy)

(defun ty-hadoop ()
  (interactive)
  (browse-url "https://vm1.trustyou.com:5030"))

(global-set-key (kbd "C-c C-t h") 'ty-hadoop)


(defun sync-sentency ()
  (interactive)
  (shrink-window-if-larger-than-buffer)
  (shell-command "cd ~/development ; rsync --exclude='lib/stanford-ner' --exclude=files  -az --progress sentency  vmx:sentency & " ))
(global-set-key (kbd "C-c C-y ") 'sync-sentency)





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
