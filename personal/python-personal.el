;; Configuration for python development and elpy
;; My recommendation is to configure things like this either via mypy.ini and similar files and
;; .dir-locals variables

(flycheck-add-next-checker 'python-flake8 'python-mypy)

(require 'py-isort)
(setq py-isort-options '("-l 100"  "-m3" "--trailing-comma"))

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

;; add pdb breakpointE
(defun python-add-breakpoint ()
  "Add a Python breakpoint."
  (interactive)
  (newline-and-indent)
  (insert "import pdb; pdb.set_trace()")
  (highlight-lines-matching-regexp "^[ ]*import pdb; pdb.set_trace()"))

(defun mc-pysort-and-black ()
  "sort imports and run black on buffer"
  (interactive)
  (py-isort-buffer)
  (python-black-buffer)
  )


(defun my-python-mode-hook ()
  (setq indent-line-function #'my-python-indent-line)

  (superword-mode)
  (local-set-key "\M-p" 'python-add-breakpoint)
  (local-set-key (kbd "C-c b") 'mc-pysort-and-black)
  (local-set-key [f8] 'company-show-doc-buffer)
  (local-set-key (kbd "C-c v") 'py-isort-buffer)
  (local-set-key (kbd "C-c m i") 'indent-region)
  (local-set-key (kbd "C-c C-u") 'string-inflection-python-style-cycle)
  )

(add-hook 'python-mode-hook #'my-python-mode-hook)
(setq-default tab-width 4)

;; treat my_variable as a single word
(add-hook 'python-mode-hook
          (lambda () (modify-syntax-entry ?_ "w" python-mode-syntax-table)))


(setq elpy-rpc-python-command "/usr/local/anaconda3/bin/python")

(setq flycheck-python-flake8-executable "flake8")

(with-eval-after-load 'flycheck
  (flycheck-pos-tip-mode))


;; source for this config: https://github.com/jorgenschaefer/elpy/issues/1550#issuecomment-547515504
;; this problem appears to be Mac OSX only
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "--simple-prompt -c exec('__import__(\\'readline\\')') -i"
      python-shell-prompt-detect-failure-warning nil
      elpy-shell-echo-output nil
      )

(add-to-list 'elpy-project-ignored-directories "ord_pred_env")


(use-package buftra
  :straight (:host github :repo "humitos/buftra.el"))

(use-package py-autoflake
  :straight (:host github :repo "humitos/py-cmd-buffer.el")
  :hook (python-mode . py-autoflake-enable-on-save)
  :config
  (setq py-autoflake-options '("--expand-star-imports"   "--remove-all-unused-imports")))
