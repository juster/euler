;; Chicken Scheme 5
(define *max* 1000000)
(define *lhs* 0)
(define *rhs* (/ 3 7))

(do ((n 1 (+ n 1)))
    ((= n *max*) (print *lhs*))
  (when (not (= n (numerator *rhs*)))
    (let loop ((d (ceiling (/ n *rhs*))))
      (when (<= d *max*)
	(if (> (gcd n d) 1)
	    (loop (+ d 1))
	    (let ((q (/ n d)))
	      (when (> q *lhs*) (set! *lhs* q))))))))
