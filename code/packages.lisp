(in-package :cl-user)
(defpackage :multi
  (:use :cl)
  (:import-from :bordeaux-threads
			  :make-thread
			  :make-lock
			  :join-thread)
  (:export :uri))
