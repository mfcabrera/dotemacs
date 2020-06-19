;; bigui.el - utility personal library of functions for emacs


(defun bigui/org-roam-create-and-open-graph ()
  "for some reason the normal one was not working so I rewrote my own"
  (interactive)
  (org-roam-graph--build nil #'(lambda (x) (bigui/open-default x)))
  )

(defun bigui/open-default (file-name)
  "Open file-name in default external program."
  (shell-command (concat
                  (cond
                   ((eq system-type 'darwin) "open")
                   ((member system-type '(gnu gnu/linux gnu/kfreebsd)) "xdg-open")
                   (t (read-shell-command "Open current file with: ")))
                  " "
                  (shell-quote-argument file-name)))
)
;; and the code is [PAF-45](https://newyorkerfashion.atlassian.net/browse/PAF-45)

(defun bigui/md-insert-jira-links ()
  (interactive)
  (progn
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "[:space:]*\\(PAF-[0-9]+\\)[[:space:]]+" nil t)
        (replace-match  "[\\1](https://newyorkerfashion.atlassian.net/browse/\\1)" t nil nil 1))
      (goto-char (point-min))
      (while (re-search-forward "[:space:]*\\(OQPDS-[0-9]+\\)[[:space:]]+" nil t)
        (replace-match  "[\\1](https://newyorkerfashion.atlassian.net/browse/\\1)" t nil nil 1))

      )
    )
 )
