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

; make completion buffers disappear after 30 seconds.
(add-hook 'completion-setup-hook
  (lambda () (run-at-time 30 nil
    (lambda () (delete-windows-on "*Completions*")))))

(defun my-flymake-show-help ()
  (when (get-char-property (point) 'flymake-overlay)
   (let ((help (get-char-property (point) 'help-echo)))
    (if help (message "%s" help)))))

(add-hook 'post-command-hook 'my-flymake-show-help)


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


;; Don't use tabs ANY MORE!
(set-variable 'py-indent-tabs-mode t)

(add-hook 'python-mode-hook
      (lambda ()
        (setq indent-tabs-mode t)
        (setq tab-width 4)
        (setq python-indent 4)))

;; (add-hook 'python-mode-hook
;;  (lambda () (setq indent-tabs-mode t)))


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

(defun prepare-cliplink-title (title)
  (let ((replace-table '(("\\[" . "{")
                         ("\\]" . "}")
                         ("&mdash;" . "—")))
        (max-length 77)
        (result (straight-string title)))
    (dolist (x replace-table)
      (setq result (replace-regexp-in-string (car x) (cdr x) result)))
    (when (> (length result) max-length)
      (setq result (concat (substring result 0 max-length) "...")))
    result))

(defun perform-cliplink (buffer url content)
  (let* ((decoded-content (decode-coding-string content 'utf-8))
         (title (prepare-cliplink-title
                 (extract-title-from-html decoded-content))))
    (with-current-buffer buffer
      (insert (format "[[%s][%s]]" url title)))))

(defun cliplink ()
  (interactive)
  (let ((dest-buffer (current-buffer))
        (url (substring-no-properties (current-kill 0))))
    (url-retrieve
     url
     `(lambda (s)
        (perform-cliplink ,dest-buffer ,url
                          (buffer-string))))))

(global-set-key (kbd "C-x p i") 'cliplink)
