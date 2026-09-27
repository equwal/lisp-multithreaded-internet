;;; guix.scm --- Guix package for multi.  Build with: guix build -f guix.scm
;;; Install with: guix package -f guix.scm
(use-modules (guix packages) (guix gexp) (guix build-system asdf)
             ((guix licenses) #:prefix license:)
             (gnu packages lisp) (gnu packages lisp-xyz) (gnu packages lisp-check))

(define %source-dir (dirname (current-filename)))

(define-public sbcl-multi
  (package
    (name "sbcl-multi")
    (version "0.0.2")
    (source (local-file %source-dir "multi-checkout"
                        #:recursive? #t
                        #:select? (lambda (file stat)
                                    (not (or (string-suffix? ".fasl" file)
                                             (string-contains file "/.git"))))))
    (build-system asdf-build-system/sbcl)
    (arguments (list #:asd-systems ''("multi")))
    (inputs (list
                  sbcl-drakma
                  sbcl-bordeaux-threads))
    (synopsis "Multithreaded internet for Common Lisp (SSL supported)")
    (description "Multithreaded internet for Common Lisp (SSL supported).")
    (home-page "https://github.com/equwal/lisp-multithreaded-internet")
    (license license:gpl3)))

(define-public cl-multi
  (sbcl-package->cl-source-package sbcl-multi))

sbcl-multi
