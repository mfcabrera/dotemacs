

# My Emacs configuration #

Here I am adding my configuration for Emacs. I had an old configuration but
it was really disorganized and it has a lot of old stuff that I did not used
and it only made my configuration sluggish.

Another reason for changing it was that I got tired of downloading stuff and
manually doing everyhing - so this time I tried to use `elpa/el-get/package.el`
combination to avoid managing everything by myself.
So far It has worked quite right and all the packages I have installed so far
use this repository. In fact my .emacs file only add the repositories and a
minimal configuration. It looks something like this:


    (require 'package)
    (add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
    ;; include ELPA if it exists
      (if (file-exists-p "~/.emacs.d/elpa/package.el")
    (load (expand-file-name "~/.emacs.d/elpa/package.el")))

    ;; include el-get with more packages
    (require 'package)
    (setq package-archives (cons '("tromey" . "http://tromey.com/elpa/") package-archives))
    (package-initialize)
    (add-to-list 'load-path "~/.emacs.d/el-get/el-get")
    (require 'el-get)

    (add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
    (package-initialize)


    (defvar *ORGFILES-PATH* "~/Dropbox/Personal/org/"
    "Path for orgfiles")

    (defun my-load-init-file ()
    (let ( (initfile (expand-file-name "~/.emacs.d/init.el" )))
     (load initfile))
    )
  
    (my-load-init-file)`

So the first thing to be done it is to download `el-get` and add it to the
parth. After that everything can be installed/upadted with `package.el`

## What is here ##

I based my configuration initally some years ago on my friend Federico
Builes, so a lot of stuff still remain. For this new version of my conf I
based a lot on the
[Emacs Started Kit](https://github.com/technomancy/emacs-starter-kit)  with
the Ruby module (so I got some good defaults).

Here is the list of packages installed so far - some of the were installed by
starter-kit or are dependencies. I will let them here as reference.


    ac-math            20130226.... installed  Auto-complete sources for input of mathematical symbols and latex tags [github]
    auto-complete      20130503.... installed  Auto Completion for GNU Emacs [github]
    auto-complete-c... 20120612.... installed  Auto Completion source for clang for GNU Emacs [github]
    auto-complete-c... 20130526.... installed  Auto Completion source for clang for GNU Emacs [github]
    bash-completion    20130526.544 installed  BASH completion for the shell buffer [github]
    browse-url-dwim    20121205.... installed  Context-sensitive external browse URL or Internet search [github]
    cl-lib             0.3          installed  Properly prefixed CL functions and macros
    deft               20130409.... installed  quickly browse, filter, and edit plain text notes [git]
    ein                20130605.143 installed  Emacs IPython Notebook [github]
    elpy               20130603.... installed  Emacs Lisp Python Environment [github]
    find-file-in-pr... 20120716.... installed  Find files in a project quickly. [github]
    fuzzy              20120323.... installed  Fuzzy Matching [github]
    gh                 20130526.... installed  A GitHub library for Emacs [github]
    git-commit         0.1          installed  Major mode for editing git commit messages
    github-theme       0.0.3        installed  Github color theme for GNU Emacs 24
    gitignore-mode     20130506.924 installed  Major mode for editing .gitignore files [github]
    haml-mode          20130130.... installed  Major mode for editing Haml files [github]
    highlight-inden... 20130106.41  installed  Minor modes for highlighting indentation [github]
    idle-highlight-... 20120920.... installed  highlight the word the point is on [github]
    ido-ubiquitous     20121214.... installed  Use ido (nearly) everywhere. [github]
    idomenu            20111122.... installed  imenu tag selection a la ido [wiki]
    iedit              20130605.... installed  Edit multiple regions in the same way simultaneously. [github]
    inf-ruby           20130603.311 installed  Run a ruby process in a buffer [github]
    list-utils         20121205.... installed  List-manipulation utility functions [github]
    logito             20120225.... installed  logging library for Emacs [github]
    magit              20130604.... installed  Control Git from Emacs. [github]
    magit-commit-tr... 20130518.0   installed  Advice for magit-log-edit-commit [github]
    magit-gh-pulls     20130405.... installed  GitHub pull requests extension for Magit [github]
    magit-push-remote  20130531.304 installed  push remote support for Magit [github]
    magithub           20121130.... installed  Magit extensions for using GitHub [github]
    markdown-mode      20130328.918 installed  Emacs Major mode for Markdown-formatted text files [git]
    markdown-mode+     20120829.710 installed  extra functions for markdown-mode [github]
    nose               20110804.819 installed  Easy Python test running in Emacs [hg]
    org-mac-iCal       20130310.... installed  Imports events from iCal.app to the Emacs diary [git]
    org-mac-link-gr... 20130514.... installed  Grab links and url from various mac [git]
    osx-browse         20121205.... installed  Web browsing helpers for OS X [github]
    osx-location       20130303.... installed  Watch and respond to changes in geographical location on OS X [github]
    osx-plist          20101130.... installed  Apple plist file parser [github]
    paredit            20130407.... installed  minor mode for editing parentheses [git]
    pcache             20120408.... installed  persistent caching for Emacs [github]
    popup              20130324.... installed  Visual Popup User Interface [github]
    request            20130526.... installed  Compatible layer for URL request in Emacs [github]
    smex               20130421.... installed  M-x interface with Ido-style fuzzy matching. [github]
    starter-kit        20121025.... installed  Saner defaults and goodies. [github]
    starter-kit-ruby   20120128.... installed  Saner defaults and goodies for Ruby [github]
    string-utils       20121108.... installed  String-manipulation utilities [github]
    textile-mode       20120721.... installed  Textile markup editing major mode [github]
    virtualenv         20120930.... installed  Virtualenv for Python [github]
    websocket          20130508.... installed  Emacs WebSocket client and server [github]
    yasnippet          20130505.... installed  Yet another snippet extension for Emacs. [github]


