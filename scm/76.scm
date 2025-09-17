;; Chicken Scheme 5
(import srfi-1)
(define (solve limit)
  ;; Increment a coefficient at the nth power and extend the polynomial if needed.
  (define (poly-inc power coeff poly)
	(if (> power limit) poly ; do nothing if beyond limit
		(let loop ((i power) (poly poly) (acc '()))
		  (cond ((null? poly) (append-reverse acc (reverse (cons coeff (make-list i 0)))))
				((> i 0) (loop (- i 1) (cdr poly) (cons (car poly) acc)))
				(else (append-reverse acc (cons (+ coeff (car poly)) (cdr poly))))))))
  ;; Multiply two polynomials.
  (define (poly-* x y)
	(let outer-foil ((x x) (i 0) (z '()))
	  (if (or (> i limit) (null? x)) z
		  (outer-foil
		   (cdr x) (+ i 1)
		   (let inner-foil ((y y) (j 0) (z z))
			 (if (or (> j limit) (null? y)) z
				 (inner-foil (cdr y) (+ j 1)
							 (poly-inc (+ i j) (* (car x) (car y)) z))))))))
  ;; Generate polynomial of up to limit terms for the series P(n) = (1 / 1-x) at n.
  (define (poly-generate n)
	(cons 1 (do ((i limit (- i 1)) (acc '() (cons (if (= (modulo i n) 0) 1 0) acc)))
				((= i 0) acc))))
  ;; Multiply all polynomials in Euler's series together, up to the limit.
  ;; c of the c*x^n term in the product (where n=limit) is the solution.
  (do ((i 1 (+ i 1)) (poly (poly-generate 1) (poly-* poly (poly-generate (+ i 1)))))
	  ((= i limit)
	   (print poly)
	   (print (- (list-ref poly limit) 1)))))
(solve 100)
