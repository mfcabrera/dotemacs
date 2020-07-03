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


;; Mode line configuration
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(require 'doom-themes)
;; (doom-themes-neotree-config)
(doom-themes-org-config)
;; (load-theme 'doom-dracula t)


(defun insert-branch-name ()
  "Insert <p></p> at cursor point."
  (interactive)
  (insert (shell-command-to-string "git branch"))
  (backward-char 4)
  )

(use-package popup-imenu
  :commands popup-imenu
  :bind ("M-i" . popup-imenu))

(set-face-font 'default "Menlo-20")


(defun magit-add-current-branch-to-buffer-and-kill-ring ()
  "Write the current branch at point copy it to the `kill-ring'."
  (interactive)
  (let ((branch (magit-get-current-branch)))
    (if branch
        (progn (kill-new branch)
               (insert branch " "))
      (user-error "There is not current branch"))))


(defun my-text-mode-hook ()
  (local-set-key (kbd "H-b") 'magit-add-current-branch-to-buffer-and-kill-ring))
(add-hook 'text-mode-hook 'my-text-mode-hook)

(my-text-mode-hook)

(defun toggle-window-dedicated ()
  "Control whether or not Emacs is allowed to display another
buffer in current window."
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
         (set-window-dedicated-p window (not (window-dedicated-p window))))
       "%s: Can't touch this!"
     "%s is up for grabs.")
   (current-buffer)))

(global-set-key (kbd "H-p t") 'toggle-window-dedicated)


(defvar dedicated-mode nil
  "Mode variable for dedicated minor mode.")
(make-variable-buffer-local 'dedicated-mode)

(defun dedicated-mode (&optional arg)
  "Dedicated minor mode."
  (interactive "P")
  (setq dedicated-mode (not dedicated-mode))
  (set-window-dedicated-p (selected-window) dedicated-mode)
  (if (not (assq 'dedicated-mode minor-mode-alist))
      (setq minor-mode-alist
            (cons '(dedicated-mode " D")
                  minor-mode-alist))))

(provide 'dedicated)


;; this makes pre-commit hooks to work
;; extracted from https://github.com/magit/magit/issues/3419
(require 'magit)
(setq magit-git-global-arguments (remove "--literal-pathspecs" magit-git-global-arguments))


(setq dash-docs-common-docsets '("Pandas" "Python 3"))
