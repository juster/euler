;; Chicken Scheme 5
(import srfi-1)
;; Solve with the given prime upper limit for the first number with a
;; partition count above the given count lower limit.
(define (solve max-prime min-count)
  ;; Sieve of Eratosthenes
  (define *sieve* (make-vector (floor (/ max-prime 2)) #t))
  (do ((i 3 (+ i 2))) ((>= i max-prime))
	(when (vector-ref *sieve* (floor (/ i 2)))
	  (do ((j (+ i i) (+ j i))) ((>= j max-prime))
		(when (> (modulo j 2) 0) (vector-set! *sieve* (floor (/ j 2)) #f)))))
  (define (prime? n)
	(cond ((= n 2) #t)
		  ((= (modulo n 2) 0) #f)
		  (else (vector-ref *sieve* (floor (/ n 2))))))
  ;; Generate polynomial of n terms for the series P(k) = (1 / 1-x).
  ;; Polynomials are lists where the value at index i represents the coefficient of the x^i term.
  (define (poly-generate k n)
	(cons 1 (do ((i n (- i 1)) (acc '() (cons (if (= (modulo i k) 0) 1 0) acc)))
				((= i 0) acc))))
  ;; Increment the coefficient at a given power and extend the polynomial if needed.
  (define (poly-inc power coeff poly)
	(if (> power max-prime) poly
		(let loop ((i power) (poly poly) (acc '()))
		  (cond ((null? poly) (append-reverse acc (reverse (cons coeff (make-list i 0)))))
				((> i 0) (loop (- i 1) (cdr poly) (cons (car poly) acc)))
				(else (append-reverse acc (cons (+ coeff (car poly)) (cdr poly))))))))
  ;; Multiply two polynomials.
  (define (poly-* x y)
	(let outer-foil ((x x) (i 0) (z '()))
	  (if (or (> i max-prime) (null? x)) z
		  (outer-foil
		   (cdr x) (+ i 1)
		   (let inner-foil ((y y) (j 0) (z z))
			 (if (or (> j max-prime) (null? y)) z
				 (inner-foil (cdr y) (+ j 1)
							 (poly-inc (+ i j) (* (car x) (car y)) z))))))))
  (define (sum-prime-term-count n poly)
	(- (list-ref poly n) (if (prime? n) 1 0)))
  (let loop ((i 2) (poly (poly-generate 2 max-prime)))
	(print `(DBG i ,i c ,(sum-prime-term-count i poly) poly ,poly))
	(let ((j (+ i 1)))
	  (cond ((> (sum-prime-term-count i poly) min-count) (print i))
			((> j max-prime) 'fail)
			((not (prime? j)) (loop j poly))
			(else (loop j (poly-* poly (poly-generate j max-prime))))))))
(solve 100 5000)
