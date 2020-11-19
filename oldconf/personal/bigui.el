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

;; deprecated
(defun bigui/md--insert-jira-links ()
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


(defun bigui/jira-links-md-formatter (key baseurl)
  (format "[%s](%s%s)" key baseurl key)
  )

(defun bigui/jira-links-org-formatter (key baseurl)
  (org-link-make-string (format "%s%s" baseurl key) key)
  )


(defun bigui/insert-jira-links (formatter)
  (progn
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "[:space:]*\\(PAF-[0-9]+\\)[[:space:]]+" nil t)
        (replace-match  (funcall formatter "\\1" "https://newyorkerfashion.atlassian.net/browse/" ) t nil nil 1))
      (goto-char (point-min))
      (while (re-search-forward "[:space:]*\\(OQPDS-[0-9]+\\)[[:space:]]+" nil t)
        (replace-match  (funcall formatter "\\1" "https://newyorkerfashion.atlassian.net/browse/" ) t nil nil 1))

      )
    )
 )


(defun bigui/insert-jira-links-markdown ()
 (interactive)
  (progn
    (bigui/insert-jira-links #'bigui/jira-links-md-formatter)
   )
  )

(defun bigui/insert-jira-links-org ()
  (interactive)
  (progn
    (bigui/insert-jira-links #'bigui/jira-links-org-formatter)
    )
  )


(defun bigui/markdown-convert-region-to-org ()
  "Convert the current region content from markdown to orgmode format replacing the region contents"
  (interactive)
  (shell-command-on-region (region-beginning) (region-end)
                           "pandoc -f markdown -t org "  (current-buffer) t)
  )
