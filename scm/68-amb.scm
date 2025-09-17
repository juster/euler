;; Chicken Scheme 5
;; Going clockwise outer ring is a b c d e, inner ring is f g h i j.
(import (chicken string) amb amb-extras srfi-1)

(define (diff a b) (lset-difference = a b))

(define (solve-3gon-10-problem)
  (print
   (amb-find
    (let* ((set '(10 9 8 7 6 5 4 3 2 1))
	   (a (amb1 set))
	   (b (amb1 (diff set (list a))))
	   (c (amb1 (diff set (list a b))))
	   (d (amb1 (diff set (list a b c))))
	   (e (amb1 (diff set (list a b c d)))))
      (required (< a b) (< a c) (< a d) (< a e))
      (let* ((f (amb1 (diff set (list a b c d e))))
	     (g (amb1 (diff set (list a b c d e f))))
	     (h (amb1 (diff set (list a b c d e f g))))
	     (i (amb1 (diff set (list a b c d e f g h))))
	     (j (amb1 (diff set (list a b c d e f g h i))))
	     (sum (+ a f g)))
	(required
	 (= sum (+ b g h)) (= sum (+ c h i))
	 (= sum (+ d i j)) (= sum (+ e j f)))
	(conc a f g b g h c h i d i j e j f))))))

(define (solve-3gon-6-problem)
  (print
   (amb-find
    (let* ((set '(6 5 4 3 2 1))
	   (a (amb1 set))
	   (b (amb1 set))
	   (c (amb1 set))
	   (d (amb1 set))
	   (e (amb1 set))
	   (f (amb1 set)))
      (required
       (distinct? (list a b c d e f))
       (< a b)
       (< a c)
       (= (+ a d e) (+ b e f))
       (= (+ b e f) (+ c f d)))
      (list a d e b e f c f d)))))

(solve-3gon-10-problem)
