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

;; add pdb breakpointE
(defun python-add-breakpoint ()
  "Add a Python breakpoint."
  (interactive)
  (newline-and-indent)
  (insert "import pdb; pdb.set_trace()")
  (highlight-lines-matching-regexp "^[ ]*import pdb; pdb.set_trace()"))

(defun my-python-mode-hook ()
  (setq indent-line-function #'my-python-indent-line)
  (local-set-key [f8] 'company-show-doc-buffer)
  (superword-mode)
  (local-set-key "\M-p" 'python-add-breakpoint)
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



(setq
 python-shell-interpreter "ipython"
 python-shell-interpreter "ipython"
 python-shell-interpreter-args ""
 python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
 python-shell-completion-setup-code
 "from IPython.core.completerlib import module_completion"
 python-shell-completion-module-string-code
 "';'.join(module_completion('''%s'''))\n"
 python-shell-completion-string-code
 "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

;; Not working
;; (setq python-shell-interpreter "jupyter"
;;       python-shell-interpreter-args "console --simple-prompt"
;;       python-shell-prompt-detect-failure-warning nil)
;; (add-to-list 'python-shell-completion-native-disabled-interpreters
;;              "jupyter")


(add-to-list 'elpy-project-ignored-directories "ord_pred_env")
