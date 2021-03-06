;;(global-set-key (kbd "M-x") 'helm-M-x)

(global-set-key "\M-g" 'goto-line)

(global-set-key "\M-4" 'query-replace)
(global-set-key [f3] 'shell)
(global-set-key [f2] 'fill-paragraph)
(global-set-key [f5] 'compile)
(global-set-key [f6] 'kill-buffer)


;; Git
(global-set-key [(control x)(control g)] 'git-status)

;; Change font size
(global-set-key [(s -)] 'font-smaller)
(global-set-key [(s \+)] 'font-larger)


;; Mac OS Fixes - Spanish Keyboard
;(global-set-key (kbd "M-ç") "}")
(global-set-key (kbd "M-ñ") "~")

(global-set-key [(meta \+)] "]")
(global-set-key (kbd "M-ç") "}")
(global-set-key (kbd "M-º") "\\")
;; (global-set-key "\M-<" "\\")
(global-set-key (kbd "M-¡") "\\")
(global-set-key "\M-3" "#")
(global-set-key "\M-2" "@")
(global-set-key "\M-1" "|")
(global-set-key [end] 'end-of-line )
(global-set-key [home] 'beginning-of-line )
;;(global-set-key (kbd "M-<tab>")  "\\")
;;(global-set-key (kbd "M-s-\\") 'indent-region)
(global-set-key (kbd "M-/") 'comment-region)

;; English Keyboard changes
(global-set-key (kbd "±") "|")
(global-set-key (kbd "§") "\\")
;(global-set-key (kbd "\\") 'newline)


;; Use regexp search by default
(global-set-key "\C-s" 'isearch-forward-regexp)
(global-set-key "\C-r" 'isearch-backward-regexp)
(global-set-key "\C-\M-s" 'isearch-forward)
(global-set-key "\C-\M-r" 'isearch-backward)

;; Some Ruby bindings
;; (define-key ruby-mode-map (kbd "C-c C-l") 'rinari-find-controller)
;; (define-key ruby-mode-map (kbd "C-c C-m") 'rinari-find-model)
;; (define-key ruby-mode-map (kbd "C-c C-t") 'rinari-find-test)
;; (define-key ruby-mode-map (kbd "C-c C-s") 'inf-ruby)
;; (define-key ruby-mode-map (kbd "C-c C-r") 'ruby-send-region)
;; (define-key ruby-mode-map [f5] 'ruby-run-w/compilation)

;; Shift+direction
(windmove-default-keybindings)


;; Spelling
(global-set-key "\C-c\C-w" 'ispell-word)


;; Org Mode
(define-key global-map "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-switchb)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key (kbd "<f12>") 'org-agenda)
;; (global-set-key "\C-ct" 'mike/move-to-today)


;; Helm Mode - I want to complete wit Tab and stuff
(require 'helm)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-j")  'helm-select-action) ; list actions using C-z


;; neotree
;;(global-set-key [f8] 'neotree-toggle)

;; Projectile cool stuff
(define-key projectile-mode-map [?\s-d] 'projectile-find-dir)
(define-key projectile-mode-map [?\s-p] 'projectile-switch-project)
(define-key projectile-mode-map [?\s-f] 'projectile-find-file)
(define-key projectile-mode-map [?\s-g] 'helm-do-grep-ag)


(define-key projectile-mode-map [?\H-g] 'magit-status)

(global-set-key  [?\H-y] 'helm-yas-complete)

(global-set-key [f8] 'neotree-toggle)

(global-set-key  [?\H-d] 'sp-delete-symbol)


(global-set-key   [C-M-tab]  'indent-region)
