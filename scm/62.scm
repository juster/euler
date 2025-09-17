(import (chicken sort) srfi-1 srfi-69)

(define (newton-cube-root a)
  (let loop ((x a))
    (let ((y (rationalize (/ (+ (* 2 x) (/ a (* x x))) 3) 0.001)))
      (if (<= (abs (- y x)) 0.01)
	  (inexact->exact (round y))
	  (loop y)))))

(define (generate-cubes min max)
  (map (lambda (i) (number->string (* i i i)))
       (list-tabulate (- max min) (lambda (i) (+ min i)))))

(define (cube-key cube)
  (list->string (sort (string->list cube) char<?)))

(define (solve digits count)
  (define (solve-rec digits return)
    (let ((cube-seen-table (make-hash-table)))
      (for-each
       (lambda (cube)
	 (let* ((key (cube-key cube))
		(perms (cons cube (hash-table-ref/default cube-seen-table key '()))))
	   (hash-table-set! cube-seen-table key perms)))
       (generate-cubes (newton-cube-root (expt 10 digits))
		       (newton-cube-root (expt 10 (+ digits 1)))))
      (let ((matches (filter (compose (cut = count <>) length) (hash-table-values cube-seen-table))))
	(if (null? matches)
	    (solve-rec (+ digits 1) return)
	    (return (map reverse matches))))))
  (call/cc (lambda (cont) (solve-rec digits cont))))

(for-each print (solve 5 5))
