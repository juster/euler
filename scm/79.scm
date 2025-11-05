(import (only (chicken io) read-line)
		(only (chicken sort) topological-sort)
		(only (chicken string) conc)
		(only srfi-1 first second lset-union!))

(define (insert-hint hint graph)
  (if (null? (cdr hint)) graph
	  (let ((pair (assoc (first hint) graph))
			(next (list (second hint))))
		(insert-hint (cdr hint)
					 (if pair (begin (set-cdr! pair (lset-union! = (cdr pair) next)) graph)
						 (cons (cons (first hint) next) graph))))))

(define (string->digits str)
  (map (lambda (ch) (- (char->integer ch) (char->integer #\0))) (string->list str)))

(define (digits->string digits)
  (apply conc (map (lambda (d) (integer->char (+ d (char->integer #\0)))) digits)))

(define (solve path)
  (with-input-from-file path
	(lambda ()
	  (let loop ((graph '()))
		(let ((line (read-line)))
		  (if (eof-object? line)
			  (print `(Answer: ,(digits->string (topological-sort graph =))))
			  (let ((hint (string->digits line)))
				(loop (insert-hint hint graph)))))))))

(solve "0079_keylog.txt")
