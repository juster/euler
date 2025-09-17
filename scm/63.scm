(import (chicken time))

(define digits (compose string-length number->string))
(define (solve)
  (let loop ((n 1) (i 1) (acc '()))
    (let* ((x (expt i n)) (y (digits x)))
	   ;; (digits (floor (+ 1 (/ (log x) (log 10))))))
      (cond ((> n 100) acc)
	    ((> y n) (loop (+ n 1) 1 acc))
	    ((= y n) (loop n (+ i 1) (cons (list i n x) acc)))
	    (else (loop n (+ i 1) acc))))))


(let ((powerful (time (solve))))
  (print powerful)
  (print (length powerful)))

(import miscmacros)
(print
 (let ((count 0) (digits (compose string-length number->string)))
   (do ((i 1 (add1 i))) ((= i 10) count) ; digits(10^n) = n+1
     (do ((n 1 (add1 n)) (x i (* x i))) ((= n 100))
       (if (= (digits x) n) (inc! count))))))
