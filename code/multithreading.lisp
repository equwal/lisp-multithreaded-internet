(in-package :multi)
(defmacro collect (var-and-list &body body)
	(let ((collector (gensym)))
	  `(let ((,collector nil))
	     (dolist (,(car var-and-list) ,(car (cdr var-and-list)))
		(setf ,collector (cons (progn ,@body) ,collector)))
	     (reverse ,collector))))
(defun to-string (object)
  "Cast the object to a string, in its lisp-readable form."
  (with-open-stream (s (make-string-output-stream))
    (princ object s)
    (get-output-stream-string s)))
(defun to-string-downcase (object)
  (string-downcase (to-string object)))
(defun string-in-string (string)
  (concatenate 'string
	       "\\\""
	       string
	       "\\\""))
(defun swap (pair)
  (cons (cdr pair) (car pair)))
(defun toplevel-dir ()
  (directory-namestring (asdf:component-pathname (asdf:find-component
						  (asdf:find-system :multi)
						  "multithreading"))))
(defun get-file-in-toplevel (name type)
  (namestring (merge-pathnames (toplevel-dir)
			       (make-pathname :name name :type type))))
(defmacro make-stream (string &optional (start 0) end)
  `(make-string-input-stream ,string ,start ,end))
(defun drakma-no-octets (url)
  (let ((result (drakma:http-request url)))
    (if (stringp result)
	result
	(drakma::octets-to-string result))))
(defun number-only (item)
  (if (stringp item)
      (read (make-stream item))
      item ;Kraken does weird stuff, requires this.
))
(defmacro mvbind (vars value-form &body body)
  `(multiple-value-bind ,vars
       ,value-form
     ,@body))
(defun remove-nil (func &rest args)
  (apply func (remove-if #'null args)))
(defun ascii (char)
  (elt (flexi-streams:string-to-octets (string char)) 0))
(defun >> (number)
  (mvbind (a) (floor (/ number 2)) a))
(defun digit-to-string (number)
  (cdr (assoc number (pairlis '(0 1 2 3 4 5 6 7 8 9)
			      '("0" "1" "2" "3" "4" "5" "6" "7" "8" "9")))))
(defun hex (number-from-0-to-15)
  (let ((result (cdr (assoc number-from-0-to-15
			    (pairlis '(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
				     '(0 1 2 3 4 5 6 7 8 9 a b c d e f))))))
    (cond ((numberp result) (digit-to-string result))
	  ((symbolp result) (symbol-name result)))))
(defun hexstring (byte)
  (let ((modified-byte byte))
    (concatenate 'string
		 (hex (dotimes (x 4 modified-byte)
			(setf modified-byte (>> modified-byte))))
		 (hex (logand byte 15)))))
(defun octets-to-hexstring (octets &optional (start-string ""))
  (if (= 0 (length octets))
      start-string
      (octets-to-hexstring (subseq octets 1 (length octets))
			   (concatenate 'string
					start-string
					(hexstring (elt octets 0))))))
(uiop:chdir (toplevel-dir))
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
#|(defmacro let-pseudoglobal (bindings &body body)
  "Looks like a global, but isn't! Acts like a let. Required for threading."
  `(let (,@(collect (bind bindings)
		   (list (car bind) '(gensym))))))|#
(defun multiuri (urilist)
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

(defmacro time-in-seconds (&body body)
  (let ((time (gensym)))
    `(let ((,time (get-internal-run-time)))
       (progn ,@body)
       (float (/ (- (get-internal-run-time) ,time)
		 internal-time-units-per-second)))))


#|(loop repeat 3
	    do (sleep 3)
	    collect (cons (time-in-seconds (ticker-multi))
			  (time-in-seconds (ticker))))|#
