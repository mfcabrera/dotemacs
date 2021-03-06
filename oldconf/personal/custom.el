(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-tab ((t (:background "gray24")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#3F3F3F" "#CC9393" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(compilation-environment (quote ("LC_ALL=en_GB.UTF-8" "LANG=en_GB.UTF-8")))
 '(custom-safe-themes
   (quote
    ("2cdc13ef8c76a22daa0f46370011f54e79bae00d5736340a5ddfe656a767fddf" "912cac216b96560654f4f15a3a4d8ba47d9c604cbc3b04801e465fb67a0234f0" "a4a50fc0a65a7730f532fc242675d36cf3c6bf79db6755d202b0ce4da31b2a37" "46164cd89c34c34ab089dcd18ec5880c0a943472c116bb9d5bb870c802718966" "816bacf37139d6204b761fea0d25f7f2f43b94affa14aa4598bce46157c160c2" "dcdd1471fde79899ae47152d090e3551b889edf4b46f00df36d653adc2bf550d" "b0fd04a1b4b614840073a82a53e88fe2abc3d731462d6fde4e541807825af342" "274fa62b00d732d093fc3f120aca1b31a6bb484492f31081c1814a858e25c72e" "9064ab6b5358e8a21f1bed8d3e859a2ce2ef77b4f22ccbdcf810935e53cb1b18" "190a9882bef28d7e944aa610aa68fe1ee34ecea6127239178c7ac848754992df" "233bb646e100bda00c0af26afe7ab563ef118b9d685f1ac3ca5387856674285d" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "368a431ffe40f7cf99829f6df995b81e4e1540862a7628157cc19026079c5cf0" "ff7625ad8aa2615eae96d6b4469fcc7d3d20b2e1ebc63b761a349bebbb9d23cb" "f5eb916f6bd4e743206913e6f28051249de8ccfd070eae47b5bde31ee813d55f" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(elpy-test-nose-runner-command (quote ("nosetests" "-s" "-v")))
 '(elpy-test-pytest-runner-command (quote ("py.test" "-s" "-c" "/dev/null" "-v")))
 '(elpy-test-runner (quote elpy-test-pytest-runner))
 '(fci-rule-color "#383838")
 '(jdee-db-active-breakpoint-face-colors (cons "#1E2029" "#bd93f9"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#1E2029" "#50fa7b"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#1E2029" "#565761"))
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(org-agenda-files
   (quote
    ("/Users/mcabrera/Dropbox/Notational Data/org/work.org" "/Users/mcabrera/Dropbox/Notational Data/org/work-jira.org" "/Users/mcabrera/Dropbox/Notational Data/org/trips_vacations.org" "/Users/mcabrera/Dropbox/Notational Data/org/schedule.org" "/Users/mcabrera/Dropbox/Notational Data/org/repeaters.org" "/Users/mcabrera/Dropbox/Notational Data/org/refile.org" "/Users/mcabrera/Dropbox/Notational Data/org/personal.org" "/Users/mcabrera/Dropbox/Notational Data/org/personal-branding-writing.org" "/Users/mcabrera/Dropbox/Notational Data/org/next.org" "/Users/mcabrera/Dropbox/Notational Data/org/neural-art.org" "/Users/mcabrera/Dropbox/Notational Data/org/mobile/InboxCel.org" "/Users/mcabrera/Dropbox/Notational Data/org/learning_profdev.org" "/Users/mcabrera/Dropbox/Notational Data/org/house.org" "/Users/mcabrera/Dropbox/Notational Data/org/health-sports.org" "/Users/mcabrera/Dropbox/Notational Data/org/foss-comm.org" "/Users/mcabrera/Dropbox/Notational Data/org/financial.org" "/Users/mcabrera/Dropbox/Notational Data/org/family.org" "/Users/mcabrera/Dropbox/Notational Data/org/TechnicalPersonalProjects.org" "/Users/mcabrera/Dropbox/Notational Data/org/ResolutonObjectives2019.org" "/Users/mcabrera/Dropbox/Notational Data/org/ResolutionObjectives2020.org" "/Users/mcabrera/Dropbox/Notational Data/org/Inbox.org" "/Users/mcabrera/Dropbox/Notational Data/org/DailyJournal.org" "/Users/mcabrera/Dropbox/Notational Data/org/CreativeProjects.org")))
 '(package-selected-packages
   (quote
    (org-journal org-ref helm-bibtex org-roam-bibtex org-roam-server org-present org-plus-contrib modus-operandi-theme org-roam dracula-theme org-download all-the-icons zop-to-char zenburn-theme yasnippet-snippets yaml-mode workgroups which-key web-mode w3m volatile-highlights vkill use-package undo-tree textile-mode swiper super-save string-inflection sphinx-doc sparql-mode smex smartrep smartparens smart-mode-line semi scala-mode sbt-mode restclient rainbow-mode rainbow-delimiters python-black pylint pyenv-mode py-isort projectile-ripgrep powerline popup-imenu pig-mode ox-reveal ov org-mac-link org-jira org-gcal operate-on-number ob-ipython nvm nodejs-repl neotree move-text mmm-mako markdown-toc markdown-preview-mode markdown-mode+ langtool key-chord kanban json-rpc json-mode js3-mode js2-refactor js2-highlight-vars js-comint jinja2-mode ipython-shell-send imenu-anywhere iedit ido-completing-read+ htmlize hl-todo highlight-symbol helm-tramp helm-swoop helm-rg helm-pydoc helm-projectile helm-org-rifle helm-make helm-flyspell helm-flymake helm-descbinds helm-dash helm-c-yasnippet helm-ag guru-mode groovy-mode grizzl gradle-mode google-maps god-mode gnuplot gitignore-mode github-pullrequest gitconfig-mode git-timemachine git gist geiser flycheck-pyflakes flycheck-pos-tip flycheck-demjsonlint find-file-in-project expand-region exec-path-from-shell eslint-fix elpy elisp-slime-nav editorconfig-domain-specific edit-indirect easy-kill dot-mode doom-themes doom-modeline dockerfile-mode discover-my-major diminish diff-hl deft dedicated cython-mode ctags csv-mode crux conda company-tern company-auctex company-anaconda cdlatex calfw-org calfw-gcal calfw browse-kill-ring browse-at-remote beacon auto-org-md anzu angry-police-captain ace-window)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(safe-local-variable-values
   (quote
    ((flycheck-mypy\.ini . /Users/mcabrera/development_personal/hooqu/tox\.ini)
     (pyvenv-activate . /Users/mcabrera/development/order_prediction/ord_pred_env)
     (pyvenv-workon . /Users/mcabrera/development/order_prediction/ord_pred_env))))
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3"))
