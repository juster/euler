;; Straight translation of the algorithm in Wikipedia article:
;; https://en.wikipedia.org/wiki/Periodic_continued_fraction#Canonical_form_and_repetend
(define (continued-fraction-triplets n)
  (call/cc
   (lambda (abort)
     (let ((a0 (do ((m n (- m 1))) ((< (* m m) n) m))))
       (let loop ((m 0) (d 1) (a a0) (seen '()))
	 (let* ((seen (cons (list m d a) seen))
		(m (- (* d a) m))
		(d (/ (- n (* m m)) d))
		;; if d=0 then n has a rational square root!
		(_ (if (= d 0) (abort #f)))
		(a (floor (/ (+ a0 m) d))))
	   (if (member (list m d a) seen) seen
	       (loop m d a seen))))))))

(define (solve max)
  (let loop ((n 2) (count 0))
    (if (> n max) count
	(let ((cont-fraction (continued-fraction-triplets n)))
	  (loop (+ n 1)
		(if (and cont-fraction ; rational square
			 (even? (length cont-fraction)))
		    (+ count 1)
		    count))))))

(print (solve 10000))
