(defpackage out-spaces
  (:use :cl)
  (:export :trim
	   :add-psfix))

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

(defun without-space (str)
  "Delete the #\space character for `str'."
  (let ((lst-chars (string-to-charlst str)))
    (cc-s (del-letter #\space lst-chars))))

(defun match? (elem lst)
  (if (equal nil lst)
      nil
      (or (equal elem (car lst))
	  (match? elem (cdr lst)))))
		 
(defun not-space (lst-paths)
  "Delete the spaces of the filenames"
  (if (equal nil lst-paths)
      nil
      (let ((filename (file-namestring (namestring (car lst-paths))))
	    (head-path (directory-namestring (car lst-paths))))
	(if (match? #\space (string-to-charlst filename))
	    (rename-file (car lst-paths) (cc-s head-path (without-space filename))))
	(not-space (cdr lst-paths)))))

(defun trim (directory-path)
  "Wrapper, capture the `directory-path' and return a list of files, this files are processed
with the function `not-space'."
  (not-space (cl-fad:list-directory directory-path)))

(defun psfix (fix str-fix lst-paths)
  (if (equal nil lst-paths)
      nil
      (let ((base-filename (pathname-name (namestring (car lst-paths))))
	    (head-path (directory-namestring (car lst-paths))))
	(cond ((equal fix "pf") (rename-file (car lst-paths) (cc-s head-path str-fix base-filename)))
	      ((equal fix "sf") (rename-file (car lst-paths) (cc-s head-path base-filename str-fix))))
	(psfix fix str-fix (cdr lst-paths)))))

(defun add-psfix (fix str-fix directory-path)
  (psfix fix str-fix (cl-fad:list-directory directory-path)))
