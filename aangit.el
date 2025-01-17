;;; aangit.el --- Quickly scaffold new Angular apps with Aangit

;;; Commentary:
;; Author: Steven Edwards <steven@stephenwithav.io>
;; URL: https://github.com/stephenwithav/aangit
;; Keywords: angular
;; Version: 0.1
;; Package-Requires: ((emacs "28.1") (transient "0.4"))
;;
;; Switching back and forth between the cli (e.g., for ng generate commands) and
;; emacs is annoying.  This package hopes to alleviate that.

;;; Code:

(require 'transient)

(transient-define-suffix aangit-menu--ng-new (&optional args)
  "Quickly scaffolds new Angular app in cwd."
  :description "ng new"
  (interactive (list (transient-args transient-current-command)))
  (let ((dir (car (last (string-split (car (dired-read-dir-and-switches "")) "/"))))
        (cliargs (string-join args " ")))
    (if (eq dir "")
        (message "missing project name")
      (progn
        (shell-command (format "ng new --defaults %s %s" dir cliargs))
        (dired dir)
        (delete-other-windows)
        (aangit-menu--generate-submenu)))))

(transient-define-argument aangit-menu--new-project-style ()
  :description "Style"
  :class transient-option
  :key "-y"
  :argument "--style="
  :choices '("css" "scss" "sass" "less"))

(transient-define-argument aangit-menu--new-component-style ()
  :description "Style"
  :class transient-option
  :key "-y"
  :argument "--style="
  :choices '("css" "scss" "sass" "less" "none"))

(transient-define-prefix aangit-menu--new-project ()
  :value '("--standalone" "--routing" "--style=css")
  ["Switches"
   ("-s" "Standalone" "--standalone" :class transient-switch)
   ("-r" "Routing" "--routing" :class transient-switch)
   ("-i" "Inline Style" "--inline-style" :class transient-switch)
   ("-t" "Inline Template" "--inline-template" :class transient-switch)
   (aangit-menu--new-project-style)
   ]
  ["Commands"
   ("n" "new" aangit-menu--ng-new)])

(defun aangit-menu--unimplemented ()
  "Placeholder for future defuns."
  (interactive)
  (message "not yet implemented"))

(transient-define-suffix aangit-menu--ng-generate-component-command (&optional args)
  :description "ng generate component"
  (interactive (list (transient-args transient-current-command)))
  (let ((component (read-string "component name: ")))
   (if (eq component "")
      (message "missing component name")
    (shell-command (format "ng generate component %s --defaults %s" component (string-join args " "))))))

(transient-define-prefix aangit-menu--generate-component-submenu ()
  ["generate component"
   ("-s" "Standalone" "--standalone" :class transient-switch)
   ("-i" "Inline Style" "--inline-style" :class transient-switch)
   ("-t" "Inline Template" "--inline-template" :class transient-switch)
   (aangit-menu--new-component-style)
   ]
  ["Commands"
   ("n" "new" aangit-menu--ng-generate-component-command)])

(transient-define-suffix aangit-menu--ng-generate-service-command (&optional args)
  :description "ng generate service"
  (interactive (list (transient-args transient-current-command)))
  (let ((service (read-string "service name: ")))
   (if (eq service "")
      (message "missing service name")
    (shell-command (format "ng generate service %s" service)))))

(transient-define-prefix aangit-menu--generate-interface-submenu ()
  ["Interfaces"
   ("n" "new" aangit-menu--ng-generate-interface-command)])

(transient-define-prefix aangit-menu--generate-service-submenu ()
  ["service"
   ("n" "new" aangit-menu--ng-generate-service-command)])

(transient-define-prefix aangit-menu--generate-submenu ()
  :value '("--defaults")
  ["Generate what?"
   ;; ("a" "Application shell" aangit-menu--unimplemented)
   ;; ("A" "application in projects" aangit-menu--unimplemented)
   ;; ("C" "Class" aangit-menu--unimplemented)
   ("c" "Component" aangit-menu--generate-component-submenu)
   ;; ("o" "Configuration file" aangit-menu--unimplemented)
   ;; ("d" "Directive" aangit-menu--unimplemented)
   ;; ("e" "Enums" aangit-menu--unimplemented)
   ;; ("g" "Guard" aangit-menu--unimplemented)
   ;; ("I" "Interceptor" aangit-menu--unimplemented)
   ("i" "Interface" aangit-menu--generate-interface-submenu)
   ;; ("l" "Library" aangit-menu--unimplemented)
   ;; ("m" "Module" aangit-menu--unimplemented)
   ;; ("p" "Pipe" aangit-menu--unimplemented)
   ;; ("r" "Resolver" aangit-menu--unimplemented)
   ("s" "Service" aangit-menu--generate-service-submenu)
   ;; ("S" "Service Worker" aangit-menu--unimplemented)
   ;; ("w" "Web Worker" aangit-menu--unimplemented)
   ])

(transient-define-prefix aangit-menu ()
  [["ng"
    ("n" "new" aangit-menu--new-project)
    ("g" "generate" aangit-menu--generate-submenu)
    ]])


(provide 'aangit)

(provide 'aangit)

;;; aangit.el ends here
