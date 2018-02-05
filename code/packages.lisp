(defpackage :multi-internet-package-loading
  (:use :cl :cl-user :asdf)
  (:export :defpackage-multi))
(in-package :multi-internet-package-loading)
(defpackage :multi
  (:use :cl :bordeaux-threads :asdf :cl-user)
  (:shadowing-import-from :bordeaux-threads
			  make-thread
			  make-lock
			  join-thread
			  thread-yield
			  make-condition-variable
			  condition-wait
			  condition-notify
			  all-threads
			  thread-alive-p
			  destroy-thread
			  interrupt-thread
			  join-thread)
  (:export :getpage))
