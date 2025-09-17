;; Chicken Scheme 5
(import srfi-1 miscmacros)

(define (phi n)
  (let ((relatively-prime 0))
    (do ((i 1 (+ i 1)))
	((= i n))
      (when (= 1 (gcd n i))
	(inc! relatively-prime)))
    relatively-prime))

(define *max* (inexact->exact 1e6))
(define *table* (make-vector (+ *max* 1) 0))

(do ((i 2 (+ i 1)))
    ((> i *max*))
  (let loop ((j (+ i i)) (x 1))
    (when (<= j *max*)
      (let ((y (vector-ref *table* j)))
	;; (print `(i ,i j ,j x ,x y ,y))
	(loop (+ j i)
	      (if (= y 0)
		  (begin
		    (vector-set! *table* j x)
		    (+ x 1))
		  (begin
		    (vector-set! *table* j (+ x y))
		    x)))))))

(let ((max-ratio 0) (max-n 0))
  (do ((n 2 (+ n 1)))
      ((> n *max*))
    (let* ((φ (- n 1 (vector-ref *table* n)))
	   (ratio (if (= φ 0) 0 (/ n φ)))) ; 12 is neat
      ;; (print (list n (vector-ref *table* n) φ))
      (when (> ratio max-ratio)
	;; (print (list n φ))
	(set! max-ratio ratio)
	(set! max-n n))))
  (print max-n))
