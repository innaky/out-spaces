# Out-Spaces

* Rename the filenames of a directory, deleting spaces and joining the name. 
* Adding prefix or sufix for the filenames of a directory.


## Usage

### Out spaces

* First:

```bash
$ > ls /home/innaky/test
'a a a' 'a er' 'b c c' 'qe gy rb sw rtrt'
```

* Second

```lisp
CL-USER> (ql:quickload :out-spaces)
CL-USER> (out-spaces:trim "/home/innaky/test")
```

* Check

```bash
$ > ls /home/innaky/test
aaa aer bcc qegyrbswrtrt
```

### Prefix - Sufix filename

* List files

```bash
$ > ls /home/innaky/test
foo.lisp bar.png
```
* Prefix action

```lisp
CL-USER> (ql:quickload :out-spaces)
CL-USER> (out-spaces:psfix "pf" "prefix-test-" "/home/innaky/test")
```

* Check change

```bash
$ > ls /home/innaky/test
prefix-test-foo.lisp prefix-test-bar.png
```

* Sufix action

```lisp
CL-USER> (out-spaces:psfix "sf" "--sufix" "/home/innaky/test")
```

* Check changes

```bash
$ > ls /home/innaky/test
foo--sufix.lisp bar--sufix.png
```

## Installation

Using quicklisp copy in your *local-projects*

* steps

```bash
$ > cd ~/quicklisp/local-projects
git clone https://github.com/innaky/out-spaces.git
```

## Author

* Innaky (innaky@protonmail.com)

## Copyright

Copyright (c) 2020 Innaky (innaky@protonmail.com)

## License

Licensed under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.html) License.
