;; Chicken Scheme 5
(import srfi-1 iset)

(define *table-size* 1000000)
(define table-ref
  (getter-with-setter
   (lambda (table row col)
     (bit-vector-ref table (+ (* *table-size* (- row 1)) (- col 1))))
   (lambda (table row col x)
     (bit-vector-set! table (+ (* *table-size* (- row 1)) (- col 1)) x))))
(define (table-row tbl row)
  (let ((i (* *table-size* (- row 1))))
    (subvector tbl i (+ *table-size* i))))

(define *table* (make-bit-vector (* *table-size* *table-size*) #t))

(do ((i 2 (+ i 1)))
    ((= i *table-size*))
  (do ((j i (+ j i)))
      ((>= j *table-size*))
    (do ((k i (+ k i)))
	((>= k j))
      (set! (table-ref *table* j k) #f))))

;; (do ((i 2 (+ i 1)))
;;     ((> i *table-size*))
;;   (print i " " (table-row *table* i)))

(let loop ((n 2) (max 0) (max-n 0))
  (if (> n *table-size*) (print max-n)
      (let ((r (/ n (count (lambda (m) (table-ref *table* n m))
			   (cdr (iota n))))))
	;; (print (cons n r))
	(if (> r max)
	    (loop (+ n 1) r n)
	    (loop (+ n 1) max max-n)))))
