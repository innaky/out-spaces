(defpackage out-spaces
  (:use :cl)
  (:export :trim
	   :generic-trim
	   :add-psfix
	   :psfix-filter
	   :replace-letter))

(in-package :out-spaces)

(defmacro cc-s (&rest strs)
  `(concatenate 'string ,@strs))

(defun string-to-charlst (long-str &optional (position 0))
  "The input is a string the output a list of characters, run from character 0
for default or for any other character, minor to length string."
  (if (not (numberp position))
      (format t "~A is not type numb~%" position)
      (if (or (>= position (length long-str)) (< position 0))
	  nil
	  (let ((end (length long-str)))
	    (if (equal position end)
		nil
		(cons (char long-str position)
		      (string-to-charlst long-str (+ 1 position))))))))

(defun del-letter (letter char-lst)
  "`letter' is a char, `char-lst' is a list of chars, this function return a list of chars without the `letter'."
  (cond ((equal char-lst nil) nil)
	((char= letter (car char-lst)) (del-letter letter (cdr char-lst)))
	(t (cons (car char-lst) (del-letter letter (cdr char-lst))))))

(defun without-char (str char)
  "Delete any `char' for `str'."
  (let ((lst-chars (string-to-charlst str)))
    (cc-s (del-letter char lst-chars))))

(defun without-space (str)
  "Delete the #\space character for `str'."
  (let ((lst-chars (string-to-charlst str)))
    (cc-s (del-letter #\space lst-chars))))

(defun match? (elem lst)
  (if (equal nil lst)
      nil
      (or (equal elem (car lst))
	  (match? elem (cdr lst)))))

(defun replace-atom (new old lst)
  "Replace `old' by `new' if exists inside `lst'. If not exists the `old' element return the
same `lst'."
  (cond ((equal nil lst) nil
	 (t (cond ((equal (car lst) old) (cons new (cdr lst)))
		  (t (cons (car lst) (replace-atom new old (cdr lst)))))))))

(defun replace-char (new old lst-paths)
  "Replace the `new' by `old' in the filename of a directory. If `old' match in the filename `new' 
is added, else return the same filename. The file extensions are not changed."
  (if (equal nil lst-paths)
      nil
      (let ((filename (file-namestring (namestring (car lst-paths))))
	    (head-path (directory-namestring (car lst-paths))))
	(if (match? old (string-to-charlst filename))
	    (rename-file (car lst-paths)
			 (cc-s head-path
			       (replace-atom new old (string-to-charlst filename)))))
	(replace-char new old (cdr lst-paths)))))
							      
(defun not-char (char lst-paths)
  "Delete the match `char' of the filenames."
  (if (equal nil lst-paths)
      nil
      (let ((filename (file-namestring (namestring (car lst-paths))))
	    (head-path (directory-namestring (car lst-paths))))
	(if (match? char (string-to-charlst filename))
	    (rename-file (car lst-paths) (cc-s head-path (without-char filename char))))
	(not-char char (cdr lst-paths)))))

(defun not-space (lst-paths)
  "Delete the spaces of the filenames"
  (if (equal nil lst-paths)
      nil
      (let ((filename (file-namestring (namestring (car lst-paths))))
	    (head-path (directory-namestring (car lst-paths))))
	(if (match? #\space (string-to-charlst filename))
	    (rename-file (car lst-paths) (cc-s head-path (without-space filename))))
	(not-space (cdr lst-paths)))))

(defun replace-letter (new-letter to-replace directory-path)
  "This function is a wrapper over the function `replace-char'. `directory-path' build
the list of files for `replace-char'."
  (replace-char new-letter to-replace (cl-fad:list-directory directory-path)))

(defun generic-trim (char directory-path)
  "Wrapper function, use a `char' and a `directory-path' and delete the `char' matching."
  (not-char char (cl-fad:list-directory directory-path)))

(defun trim (directory-path)
  "Wrapper, capture the `directory-path' and return a list of files, this files are processed
with the function `not-space'."
  (not-space (cl-fad:list-directory directory-path)))

(defun psfix (fix str-fix lst-paths)
  "Take the string \"pf\" for activate the prefix logic or the string \"sf\" for the sufix logic,
the parameter `str-fix' is the string sufix or prefix and `lst-paths' is a list of files."
  (if (equal nil lst-paths)
      nil
      (let ((base-filename (pathname-name (namestring (car lst-paths))))
	    (head-path (directory-namestring (car lst-paths))))
	(cond ((equal fix "pf") (rename-file (car lst-paths) (cc-s head-path str-fix base-filename)))
	      ((equal fix "sf") (rename-file (car lst-paths) (cc-s head-path base-filename str-fix))))
	(psfix fix str-fix (cdr lst-paths)))))

(defun ext-filter (lst-paths ext)
  "The input is a list of filenames and a file extension.
The output is a list of files with teh file extension.
Not implement regex only plain file extension
Ex: \"lisp\" for lisp filenames."
  (if (equal nil lst-paths)
      nil
      (if (equal (pathname-type (pathname (namestring (car lst-paths)))) ext)
	  (cons (car lst-paths)
		(ext-filter (cdr lst-paths) ext))
	  (ext-filter (cdr lst-paths) ext))))

(defun psfix-filter (fix str-fix directory-path ext)
  "Extend the functionality of `psfix', this function is a wrapper and apply the
filter filename."
  (psfix fix str-fix
	 (ext-filter (cl-fad:list-directory directory-path) ext)))

(defun add-psfix (fix str-fix directory-path)
  "This function is a wrapper of `psfix'"
  (psfix fix str-fix (cl-fad:list-directory directory-path)))
