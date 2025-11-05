;; Chicken Scheme 5
(import srfi-1 srfi-4)

(define *limit* 100000)
(define *cache* (make-vector *limit* 0))
(vector-set! *cache* 0 1)
(vector-set! *cache* 1 1)

(define (pentagonal n) (/ (- (* 3 n n) n) 2))

(define *generalized-pentagonals*
  (do ((v (make-vector *limit*))
	   (i 0 (+ i 1))
	   (n 1 (if (> n 0) (- n) (+ 1 (- n)))))
	  ((>= i *limit*) v)
	(vector-set! v i (pentagonal n))))

(define p
  (let ((ops (circular-list + -)))
	(lambda (n)
	  (let loop ((sum 0) (i 0) (ops ops))
		(let* ((x (- n (vector-ref *generalized-pentagonals* i)))
			   (y (- n (vector-ref *generalized-pentagonals* (+ i 1)))))
		  (cond ((>= y 0)
				 (loop ((car ops) sum
						(vector-ref *cache* x)
						(vector-ref *cache* y))
					   (+ i 2)
					   (cdr ops)))
				((< x 0) sum)
				(else ((car ops) sum (vector-ref *cache* x)))))))))

(define (solve)
  (let loop ((n 2))
	;; modulo returns a number with the sign of its second operand
	(let ((x (modulo (p n) 1000000)))
	  (if (= x 0)
		  (print n)
		  (begin
			(vector-set! *cache* n x)
			(loop (+ n 1)))))))

(solve)
