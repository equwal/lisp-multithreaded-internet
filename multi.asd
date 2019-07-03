(defsystem :multi
  :description "Multithreaded internet"
  :version "0.0.2"
  :author "Spenser Truex <web@spensertruex.com>"
  :license "GNU GPL v3"
  :depends-on (:drakma :uiop :bordeaux-threads)
  :serial t
  :components ((:file "packages")
	             (:file "multithreading")))
