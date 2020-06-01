# Out-Spaces

* Rename the filenames of a directory, deleting spaces and joining the name. 
* Adding prefix or sufix for the filenames of a directory.
* Adding prefix or sufix using a filter for file type of a directory.

## Usage

### Out spaces

* First (list the files)

```bash
$ > ls /home/innaky/test
'a a a' 'a er' 'b c c' 'qe gy rb sw rtrt'
```

* Apply "Trim"

```lisp
CL-USER> (ql:quickload :out-spaces)
CL-USER> (out-spaces:trim "/home/innaky/test")
```

* Check changes

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
* Apply Prefix action

```lisp
CL-USER> (ql:quickload :out-spaces)
CL-USER> (out-spaces:psfix "pf" "prefix-test-" "/home/innaky/test")
```

* Check change

```bash
$ > ls /home/innaky/test
prefix-test-foo.lisp prefix-test-bar.png
```

* Apply Sufix action

```lisp
CL-USER> (out-spaces:psfix "sf" "--sufix" "/home/innaky/test")
```

* Check changes

```bash
$ > ls /home/innaky/test
foo--sufix.lisp bar--sufix.png
```

### Filter Prefix or Sufix

* First (list the files)

```bash
$ > ls /home/innaky/test
a.lisp a.jpg file.lisp hello world.lisp pic.png doc.pdf
```
* Apply Filtered prefix

```lisp
CL-USER> (out-spaces:psfix-filter "pf" "test-" "/home/innaky/test" "lisp")
```

* Check changes

```bash
$ > ls /home/innaky/test
test-a.lisp a.jpg test-file.lisp test-hello world.lisp pic.png doc.pdf
```

## Installation

Using quicklisp copy in your *local-projects*

* steps

```bash
$ > cd ~/quicklisp/local-projects
git clone https://github.com/innaky/out-spaces.git
```

## Reference

* (trim *directory-path*) 
This function take a directory path. Return a joining filenames (without spaces).

* (add-psfix *["pf"|"sf"]* *str-fix* *directory-path*)
This function take the string *pf* for prefix or *sf* for sufix, an string for add in the filename and a directory-path
Return the string-fix added in all filenames of a directory.

* (psfix-filter *["pf"|"sf"]* *str-fix* *directory-path* *file-extension*)
This function take an file-extension and apply the prefix or sufix change in this files.
This function run only with explicit filename extension, is a soft filter

## Author

* Innaky (innaky@protonmail.com)

## Copyright

Copyright (c) 2020 Innaky (innaky@protonmail.com)

## License

Licensed under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.html) License.
