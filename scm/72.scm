;; Chicken Scheme 5
(define *max* 1000000)
(define *table* (make-vector (+ *max* 1) 0))

(define (fill-totients)
  (do ((i 2 (+ i 1)))
      ((> i *max*))
    (set! (vector-ref *table* i) i))
  (do ((p 2 (+ p 1)))
      ((> p *max*))
    ;; find all prime factors
    (when (= (vector-ref *table* p) p)
      ;; untouched entries are prime, have totient = p-1
      (set! (vector-ref *table* p) (- p 1))
      (do ((i (+ p p) (+ i p)))
	  ((> i *max*))
	;; for each prime factor p, multiply product (which starts at v[n]=n) by (1 - 1/p)
	(let ((x (vector-ref *table* i)))
	  (set! (vector-ref *table* i) (* x (- 1 (/ 1 p))))))))
  (set! (vector-ref *table* 1) 1))

(fill-totients)
(print (foldl + -1 (vector->list *table*)))
