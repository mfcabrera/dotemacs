;; don't use tabs
;;(setq-default indent-tabs-mode nil)

; interpret and use ansi color codes in shell output windows
(ansi-color-for-comint-mode-on)

;; hide all the chrome.
(setq inhibit-startup-message t)
(menu-bar-mode 1)
;;(tool-bar-mode nil)
;(scroll-bar-mode nil)

;; this is me
(setq user-mail-address "mfcabrera@gmail.com")
(setq user-full-name "Miguel Cabrera")

;; personal preferences
;;(setq stack-trace-on-error t) ;; ecb workaround
(mouse-wheel-mode t)
(line-number-mode 1)
(global-linum-mode t)
(column-number-mode 1)
(global-font-lock-mode t)
(show-paren-mode 1)
(prefer-coding-system 'utf-8)
;; I want to be  misterioso
;;(load-theme "zenburn")
;;(color-theme-zenburn)
;; personal variables
(setq case-fold-search t
      search-highlight t
      query-replace-highlight t
      default-fill-column 77
      c-tab-always-indent "other"
      make-backup-files nil
      ispell-dictionary "english"
      standard-indent 8
      transient-mark-mode t
      visible-bell t
      show-paren-delay 0)
(delete-selection-mode 1)

(setq c-default-style "linux"
          c-basic-offset 4)

;; nice parentheses
(show-paren-mode t)
(setq show-paren-style 'expression)

;; we want ido
;;(ido-mode t)

;; (ido-ubiquitous t)
;; (setq
;;       ido-enable-prefix nil
;;       ido-auto-merge-work-directories-length 0
;;       ido-create-new-buffer 'always
;;       ido-use-filename-at-point nil
;;       ido-use-virtual-buffers t
;;       ido-handle-duplicate-virtual-buffers 2
;;       ido-max-prospects 20)
;; (setq ido-everywhere t)


;; use y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

(server-start)

;; use a nice font by default
(set-default-font "-apple-Monaco-medium-normal-normal-*-14-*-*-*-m-0-fontset-auto1")
;;(set-default-font "-apple-inconsolata-medium-r-normal--0-0-0-0-m-0-iso10646-1")
;;(set-default-font "-unknown-DejaVu Sans Mono-normal-normal-normal-*-15-*-*-*-m-0-iso10646-1")
;;(set-face-attribute 'default (selected-frame) :height 180)



;; tramp setup
(require 'tramp)
(setq tramp-default-method "scp")

;;(add-to-list 'load-path "~/.emacs.d/vendor")
;; add all the directories in .emacs.d/vendor/ to the path
;;(let* ((files (directory-files "~/.emacs.d/vendor" t "[^\.+]")))
 ;; (mapcar (lambda (d) (add-to-list 'load-path d)) files))

;;add org-mode to the path
;;(add-to-list 'load-path "~/.emacs.d/vendor/org-mode/lisp")
;;(add-to-list 'load-path "~/.emacs.d/vendor/org-mode/contrib/lisp")

;; Lets start loading file by file
(add-to-list 'load-path "~/.emacs.d/personal")
;; load everything else
(load "requires")
(load "bindings")
(load "personal")
(load "orgy")
(load "modes")



;; deft setup
(when (require 'deft nil 'noerror)
  (setq
   deft-extensions '("txt" "tex" "org" "org.txt" "md" "blog.org.txt" "text" "notes.org.txt")
   deft-directory "~/Dropbox/Notational Data/"
   deft-text-mode 'org-mode
   deft-use-filename-as-title t
   deft-auto-save-interval 240
   )
  (global-set-key (kbd "<C-f9>") 'deft)







  ;; python setplist

  (when (executable-find "ipython")
    (setq python-shell-interpreter "ipython")))
