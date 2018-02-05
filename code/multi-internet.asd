(defpackage :multi
  (:use :cl :cl-user :asdf))
(in-package :multi)
(defsystem :multi
  :description "Multithreaded internet"
  :version "0"
  :author "Spenser Truex <spensertruexonline@gmail.com>"
  :license "Free"
  :depends-on (:drakma :cl-json :bordeaux-threads)
  :serial t
  :components ((:file "packages")
	       (:file "multithreading")))
