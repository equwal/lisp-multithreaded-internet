(in-package :multi)
;;; Work on DEFGLOBAL global lexical variables for SBCL, it is requested! Let-pseudoglobals was on the right track, but it looks like the compiler must be modified.
(defmacro collect (var-and-list &body body)
  (let ((collector (gensym)))
    `(let ((,collector nil))
       (dolist (,(car var-and-list) ,(car (cdr var-and-list)))
	 (setf ,collector (cons (progn ,@body) ,collector)))
       (reverse ,collector))))
(defun drakma-no-octets (url)
  (let ((result (drakma:http-request url)))
    (if (stringp result)
	result
	(drakma::octets-to-string result))))

(defmacro mvbind (vars value-form &body body)
  `(multiple-value-bind ,vars
       ,value-form
     ,@body))
(uiop::chdir (toplevel-dir))
(defvar *log-file* (get-file-in-toplevel "log" "txt"))
(defun log-result (code-result)
  (with-open-file (s *log-file*
		     :if-does-not-exist :create
		     :if-exists :append
		     :direction :output)
    (princ code-result s)))
(defun getpage (uri)
  "Uri should be 'http(s)://domainname.blah.toplevel/blah/blah/blah'"
  (drakma-no-octets uri))
(defun multiuri (&rest urilist)
  (let ((lock (gensym))
	(list (gensym))
	(uri (gensym)))
    (setf lock (make-lock))		;a gensym
    (setf list nil)
    (let ((thread-list (collect (var urilist)
			 (setf uri var)
			 (make-thread (lambda ()
					(let ((result (getpage uri)))
					  (with-lock-held (lock)
					    (setf list (cons result list)))))
				      :name uri))))
      (dolist (thread thread-list list)
	(join-thread thread)))))
