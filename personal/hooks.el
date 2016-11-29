;; Python Mode Hooks

;; I have to use tab (company policy)
(set-variable 'py-indent-tabs-mode t)

(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 4)
            (setq python-indent-offset 4)))

;; Setup sphinx-doc-mode (automatically generate docstrings)
(add-hook 'python-mode-hook (lambda ()
                              (require 'sphinx-doc)
                              (sphinx-doc-mode t)))

;; Term mode tab compltion has issues with yasnippets
(add-hook 'term-mode-hook (lambda () (yas-minor-mode -1)))


;; make completion buffers disappear after 30 seconds.
(add-hook 'completion-setup-hook
          (lambda () (run-at-time 30 nil
                                  (lambda () (delete-windows-on "*Completions*")))))


;; Show flymake help when cursors is on problematic like
(defun my-flymake-show-help ()
  (when (get-char-property (point) 'flymake-overlay)
    (let ((help (get-char-property (point) 'help-echo)))
      (if help (message "%s" help)))))
(add-hook 'post-command-hook 'my-flymake-show-help)
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)


;;(setq projectile-switch-project-action 'neotree-projectile-action)
