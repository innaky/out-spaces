(defpackage out-spaces
  (:use :cl)
  (:export :trim))

(in-package :out-spaces)

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
    (concatenate 'string
		 (del-letter #\space lst-chars))))

(defun match? (elem lst)
  (if (equal nil lst)
      nil
      (or (equal elem (car lst))
	  (match? elem (cdr lst)))))

(defun not-space (lst-paths)
  "Return a list of string-filenames without space names."
  (if (equal nil lst-paths)
      nil
      (let ((filename (file-namestring (namestring (car lst-paths))))
	    (head-name (directory-namestring (car lst-paths))))
	(cons (concatenate 'string head-name (without-space filename))
	      (not-space (cdr lst-paths))))))

(defun not-space (lst-paths)
  "Delete the spaces of the filenames"
  (if (equal nil lst-paths)
      nil
      (let ((filename (file-namestring (namestring (car lst-paths))))
	    (head-path (directory-namestring (car lst-paths))))
	(if (match? #\space (string-to-charlst filename))
	    (rename-file (car lst-paths) (concatenate 'string head-path (without-space filename))))
	(not-space (cdr lst-paths)))))

(defun trim (directory-path)
  "Wrapper, capture the `directory-path' and return a list of files, this files are processed
with the function `not-space'."
  (not-space (cl-fad:list-directory directory-path)))
