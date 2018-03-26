# lisp-multithreaded-internet
Multithreaded internet for Common Lisp. SSL supported.
# Installation

clone into `~/common-lisp` or your ASDF directory for your system

install quicklisp (see the quicklisp website)

execute:

```
> (ql:quickload :bordeaux-threads)
> (ql:quickload :drakma)
> (ql:quickload :uiop)
> (load "FIND LOCATION OF code/multi-internet.asd AND PUT IT HERE")
> (asdf:load-system :multi)
```
To download websites using multithreading, execute:
```
> (multi::multiuri "uri1" "uri2" "uri3"...)
```
For example:
```
> (multi::multiuri "https://google.com" "https://yahoo.com")
```
Will download the google homepage and yahoo simultaneously, returning them as strings in a list.