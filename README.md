# lisp-multithreaded-internet
Multithreaded internet for Common Lisp. SSL supported.
# Installation

clone into `~/common-lisp` or your ASDF directory for your system

install quicklisp

execute:

```
> (ql:quickload :bordeaux-threads)
> (ql:quickload :drakma)
> (asdf:load-system :multi)
```
To download websites using multithreading, execute:
```
> (multi::multiuri "uri1" "uri2" "uri3"...)
```
For example:
```
> (multi::multiuri "https://google.com")
```
Will download the google homepage.
