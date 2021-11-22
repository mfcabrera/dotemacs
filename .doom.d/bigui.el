;;;; bigui.el -- utility personal library of functions for emacs

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


(defun bigui/find-org-file-recursively (directory &optional filext)
  "Return .org and .org_archive files recursively from DIRECTORY.
If FILEXT is provided, return files with extension FILEXT instead."
  ;; FIXME: interactively prompting for directory and file extension
  (let* (org-file-list
	 (case-fold-search t)		; filesystems are case sensitive
	 (file-name-regex "^[^.#].*")	; exclude .*
	 (filext (if filext filext "org$\\\|org_archive"))
	 (fileregex (format "%s\\.\\(%s$\\)" file-name-regex filext))
	 (cur-dir-list (directory-files directory t file-name-regex)))
    ;; loop over directory listing
    (dolist (file-or-dir cur-dir-list org-file-list) ; returns org-file-list
      (cond
       ((file-regular-p file-or-dir) ; regular files
	(if (and  (string-match fileregex file-or-dir) (not (string-match "blog.org.txt" file-or-dir))) ; org files but not blog entries
	    (add-to-list 'org-file-list file-or-dir))
        )
       ((file-directory-p file-or-dir)
	(dolist (org-file (bigui/find-org-file-recursively file-or-dir filext)
			  org-file-list) ; add files found to result
	  (add-to-list 'org-file-list org-file)))))))

;; extract the path from terminal (MAC OSX fix)
(defun bigui/set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))



(defun bigui/magit-add-current-branch-to-buffer-and-kill-ring ()
  "Write the current branch at point copy it to the `kill-ring'."
  (interactive)
  (let ((branch (magit-get-current-branch)))
    (if branch
        (progn (kill-new branch)
               (insert branch " "))
      (user-error "There is not current branch"))))

;;;###autoload
(defun bigui/nikola ()
  "Runs a nikola command. Or run the passed command if no command was selected"
  (declare (interactive-only compile))
  (interactive)
  (let* ((prefix "/usr/local/Caskroom/miniconda/base/envs/nikola/bin/nikola ")
         (list (mapcar (lambda (str)
                        (concat prefix str))
                      '("build" "clean" "deploy")))
        (cmd (completing-read "nikola command: " list  nil nil prefix 'compile-history)))
    (compile cmd t)))
