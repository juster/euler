;; Chicken scheme 5
(import (only srfi-1 third list-copy last-pair))

;; Straight translation of the algorithm in Wikipedia article:
;; https://en.wikipedia.org/wiki/Periodic_continued_fraction#Canonical_form_and_repetend
(define (sqrt-continued-fraction n)
  (call/cc
   (lambda (abort)
     (let ((a0 (do ((m n (- m 1))) ((<= (* m m) n) m))))
       (let loop ((m 0) (d 1) (a a0) (seen '()))
	 (let* ((seen (cons (list m d a) seen))
		(m (- (* d a) m))
		(d (/ (- n (* m m)) d))
		;; if d=0 then n has a rational square root!
		(_ (if (= d 0) (abort #f)))
		(a (floor (/ (+ a0 m) d))))
	   (if (member (list m d a) seen)
	       (reverse (map third seen))
	       (loop m d a seen))))))))

(define (converge series n)
  (let ((series (list-copy series)))
    ;; Create a circular list pointing back to the second element.
    (set-cdr! (last-pair series) (cdr series))
    ;; https://www.17centurymaths.com/contents/euler/introductiontoanalysisvolone/ch18vol1.pdf pp2
    (do ((prev-num 1 num)
	 (num (car series) (+ (* num (car series)) prev-num))
	 (prev-denom 0 denom)
	 (denom 1 (+ (* denom (car series)) prev-denom))
	 (series (cdr series) (cdr series))
	 (n n (- n 1)))
	((<= n 1) (cons num denom)))))

(define (pell-min-solution d)
  ;; https://en.wikipedia.org/wiki/Pell%27s_equation#Fundamental_solution_via_continued_fractions
  (let ((series (sqrt-continued-fraction d)))
    (if (not series) #f
	(converge series
		  (let ((len (length series)))
		    (if (odd? len) (- len 1) (* 2 (- len 1))))))))

(define (solve max-d)
  (let loop ((max-x 0) (d 0) (n 2))
    (let ((x (pell-min-solution n)))
      (if (> n max-d) d
	  (if (and x (> (car x) max-x))
	      (loop (car x) n (+ n 1))
	      (loop max-x d (+ n 1)))))))

(print (solve 1000))
