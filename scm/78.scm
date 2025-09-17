;; Chicken Scheme 5
(import srfi-1)
;; Search up to the given upper limit for the first number.
(define (solve max-n check-proc)
  ;; Generate polynomial of n terms for the series P(k) = (1 / 1-x).
  ;; Polynomials are lists where the value at index i represents the coefficient of the x^i term.
  (define (poly-generate k n)
	(cons 1 (do ((i n (- i 1)) (acc '() (cons (if (= (modulo i k) 0) 1 0) acc)))
				((= i 0) acc))))
  ;; Increment the coefficient at a given power and extend the polynomial if needed.
  (define (poly-inc power coeff poly)
	(if (> power max-n) poly
		(let loop ((i power) (poly poly) (acc '()))
		  (cond ((null? poly) (append-reverse acc (reverse (cons coeff (make-list i 0)))))
				((> i 0) (loop (- i 1) (cdr poly) (cons (car poly) acc)))
				(else (append-reverse acc (cons (+ coeff (car poly)) (cdr poly))))))))
  ;; Multiply two polynomials.
  (define (poly-* x y)
	(let outer-foil ((x x) (i 0) (z '()))
	  (if (or (> i max-n) (null? x)) z
		  (outer-foil
		   (cdr x) (+ i 1)
		   (let inner-foil ((y y) (j 0) (z z))
			 (if (or (> j max-n) (null? y)) z
				 (inner-foil (cdr y) (+ j 1)
							 (poly-inc (+ i j) (* (car x) (car y)) z))))))))
  (let loop ((i 1) (poly (poly-generate 1 max-n)))
	(print `(DBG i ,i c ,(list-ref poly i) poly ,poly))
	(let ((j (+ i 1)))
	  (cond ((check-proc (list-ref poly i)) i)
			((> j max-n) 'fail)
			;; ((not (prime? j)) (loop j poly))
			(else (loop j (poly-* poly (poly-generate j max-n))))))))
(print (solve 200 (lambda (n) (= 0 (modulo n 1e6)))))
