;; Chicken Scheme 5
(import miscmacros)

(define (each-perimeter f max-p)
  ;; It is easier to solve for m when given max p.
  (let ((max-m (floor (sqrt (/ max-p 2)))))
	(do ((m 2 (+ m 1)))
		((> m max-m))
	  ;; If m is odd, n must be even. If m is even, n can be even or odd.
	  (let ((d (if (odd? m) 2 1)))
		(do ((n d (+ n d)))
			((>= n m))
		  (when (= 1 (gcd m n))
			(let ((p (* 2 m (+ m n))))
			  (let loop ((x p))
				(when (<= x max-p)
				  (f x)
				  (loop (+ x p)))))))))))

(let* ((max-perimeter 1500000)
       (seen (make-vector (+ max-perimeter 1) 0)))
  (each-perimeter (lambda (p) (inc! (vector-ref seen p))) max-perimeter)
  (let count-loop ((i 0) (count 0))
    (if (> i max-perimeter)
		(print count)
		(count-loop (+ i 1) (if (= 1 (vector-ref seen i)) (+ count 1) count)))))
