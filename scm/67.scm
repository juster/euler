;; Chicken scheme 5
(import (chicken io) (chicken string) (only srfi-1 append-reverse))

(define (make-triangle . args)
  (list->vector args))

;; row and col are both 0-offset
(define (triangle-index row col)
  (if (> col row) (error "invalid column")
      ;; calculate E sum of 1...row for all previous rows
      (+ (inexact->exact (/ (* (+ row) (+ row 1)) 2))
	 col)))

(define triangle-ref
  (getter-with-setter
   (lambda (triangle row col)
     (vector-ref triangle (triangle-index row col)))
   (lambda (triangle row col n)
     (vector-set! triangle (triangle-index row col) n))))

;; invert the equation of the E sum of 1...n = (n*(n+1))/2 to solve for n
(define (triangle-height triangle)
  (let ((x (* 2 (vector-length triangle))))
    (do ((n (floor (sqrt x)) (- n 1)))
	((= x (* n (+ n 1))) n)
      (if (<= n 0) (error "internal")))))

(define (maximum-path! triangle)
  (define (maximum-path-row! triangle row)
    (do ((col 0 (+ col 1)))
	((> col row))
      (set! (triangle-ref triangle row col)
	    (+ (triangle-ref triangle row col)
	       (max (triangle-ref triangle (+ row 1) col)
		    (triangle-ref triangle (+ row 1) (+ col 1)))))))
  (do ((row (- (triangle-height triangle) 2) (- row 1)))
      ((< row 0) (triangle-ref triangle 0 0))
    (maximum-path-row! triangle row)))

(define (read-triangle path)
  (with-input-from-file path
    (lambda ()
      (let loop ((acc '()))
	(let ((line (read-line)))
	  (if (eof-object? line)
	      (list->vector (reverse acc))
	      (loop (append-reverse (map string->number (string-split line)) acc))))))))

(define (solve path)
  (let ((triangle (read-triangle path)))
    (maximum-path! triangle)))

(print (solve "0067_triangle.txt"))
