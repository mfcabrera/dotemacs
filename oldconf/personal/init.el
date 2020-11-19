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

;; use y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

(server-start)

;; tramp setup
(require 'tramp)
(setq tramp-default-method "scp")

;; Lets start loading file by file
(add-to-list 'load-path "~/.emacs.d/personal")
;; load everything else
(load "bigui")
(load "requires")
(load "bindings")
(load "personal")
(load "orgy")
(load "modes")
(load "python-personal")



;; UTF-8 support
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8-unix)



;; deft setup
(when (require 'deft nil 'noerror)
  (setq
   deft-extensions '("org" "txt" "org.txt" "md" "blog.org.txt")
   deft-directory "~/Dropbox/Notational Data/"
   deft-text-mode 'org-mode
   deft-use-filter-string-for-filename t
   deft-use-filename-as-title t
   deft-auto-save-interval 240
   deft-recursive t
   deft-default-extension "org"
   deft-org-mode-title-prefix t
   deft-markdown-mode-title-level t

   )
  (global-set-key (kbd "<C-f9>") 'deft))

;; temporary for deft
(defun org-open-file-with-emacs (path)
  "Temp replacement function"
  (org-open-file path t)
  )



(setq deft-file-naming-rules
      '((noslash . "-")
        (nospace . "-")
        (case-fn . downcase)))

  ;; python setplist

(load-theme 'doom-dracula)