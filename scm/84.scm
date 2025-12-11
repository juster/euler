;; Chicken Scheme 5
;; Inspired by http://www.tkcs-collins.com/truman/monopoly/monopoly.shtml

(import (chicken sort)
        (chicken time)
        srfi-1      ; lists
        srfi-4      ; homogenous numeric vectors
        srfi-4-comprehensions
        srfi-42     ; eager comprehensions
        srfi-63     ; arrays
        miscmacros) ; inc!

(define *square-names*
  '((go . 0)
    (jail . 10)
    (c1 . 11)
    (e3 . 24)
    (go2jail . 30)
    (h2 . 39)
    ((r 1) . 5)
    ((r 2) . 15)
    ((r 3) . 25)
    ((r 4) . 35)
    ((u 1) . 12)
    ((u 2) . 28)
    ((cc 1) . 2)
    ((cc 2) . 17)
    ((cc 3) . 33)
    ((ch 1) . 7)
    ((ch 2) . 22)
    ((ch 3) . 36)))
(define (square-lookup square)
  (if (integer? square) square (alist-ref square *square-names* equal?)))

(define *square-markov-matrix* (make-array (A:floR64b 0.0) 40 40))

(define (scale-p-list x lst) (map (lambda (pair) (cons (car pair) (* x (cdr pair)))) lst))
(define (merge-pair-into-p-list! pair p-list)
  (or (and-let* ((x (assoc (car pair) p-list)))
        (set-cdr! x (+ (cdr x) (cdr pair)))
        p-list)
      (cons pair p-list)))
(define (compress-p-list! a) (foldr merge-pair-into-p-list! '() a))
(define (append-p-lists! a b) (foldr merge-pair-into-p-list! a b))

(define (apply-p-list! from-i to-p-list matrix)
  (for-each (lambda (to-pair)
              (let* ((to-square (car to-pair))
                     (to-i (if (integer? to-square) to-square
                               (square-lookup to-square))))
              (array-set! matrix (exact->inexact (cdr to-pair)) from-i to-i)))
            to-p-list))

;; Actions
(define (community-chess i) `((,i . 14/16) (go . 1/16) (jail . 1/16)))
(define (chance i)
  (let* ((next-r (list 'r (case i ((7) 2) ((22) 3) ((36) 1))))
         (next-u (list 'u (case i ((7) 1) ((22) 2) ((36) 1))))
         (p-list (cons (cons i 6/16)
                       (map (lambda (square) (cons square 1/16))
                            `(go jail c1 e3 h2 (r 1) ,next-r ,next-r ,next-u)))))
    (append
     p-list
     (scale-p-list 1/16 (let ((j (modulo (- i 3) 40))) (if (= j 33) (community-chess j) (stay j)))))))
(define (stay i) `((,i . 1)))
(define *square-actions* (vector-ec (:range i 40) (stay i)))
(define (square-action-ref square) (vector-ref *square-actions* (square-lookup square)))
(define (square-action-set! square proc)
  (let* ((i (square-lookup square))
         (p-list (list-ec (:list pair (proc i))
                          (cons (square-lookup (car pair)) (cdr pair)))))
    (vector-set! *square-actions* i (compress-p-list! p-list))))

(do-ec (:range n 1 4) (begin (square-action-set! `(cc ,n) community-chess)
                             (square-action-set! `(ch ,n) chance)))
(square-action-set! 'go2jail (constantly '((jail . 1))))

(define (roll-distribution n m)
  (let ((dice (cdr (iota (+ 1 n))))
        (v (make-vector (+ 1 (* n m)) 0))
        (p (expt n (- m))))
    (let loop ((i 1) (rolls dice))
      (if (>= i m)
          (begin
            (do-ec (:list n rolls) (inc! (vector-ref v n) p))
            (vector->list v))
          (loop (add1 i) (append-map (lambda (die-1) (map (lambda (die-2) (+ die-1 die-2)) dice)) rolls))))))

(define (populate-matrix roll-dist)
  (define (land-p-list from-i)
    (fold-ec '()
             (:list roll-p (index roll-n) roll-dist)
             (if (> roll-p 0))
             (let ((land-p-list (square-action-ref (remainder (+ from-i roll-n) 40))))
               (scale-p-list roll-p land-p-list))
             append-p-lists!))
  (let ((go2jail (square-lookup 'go2jail)))
    (do-ec (:range i 40) (not (= i go2jail))
           (let ((p-list (land-p-list i)))
             (begin
               ;; (print `(DBG i: ,i p-list: ,p-list sum: ,(fold-ec 0 (:list pair p-list) (cdr pair) +)))
               (apply-p-list! i p-list *square-markov-matrix*)
               (assert
                (let ((row-sum (fold-ec 0 (:range j 40) (array-ref *square-markov-matrix* i j) +)))
                  ;; (print `(DBG row-sum: ,row-sum))
                  (> 1e-6 (abs (- 1.0 row-sum))))))))))

;; Calculate u = Mv.
(define (*mv u m v)
  (do-ec (:range i (f64vector-length v)) (f64vector-set! u i 0.0))
  (receive (x y) (apply values (array-dimensions m))
    (do-ec (:range i x) (:range j y)
           (inc! (f64vector-ref u j) (* (array-ref m i j) (f64vector-ref v i))))))

(define (eigenvector)
  (let ((u (make-f64vector 40 0.0))
        (v (make-f64vector 40 0.0)))
    (f64vector-set! v 0 1.0)
    (do-ec (:range i 100)
           (begin
             (*mv u *square-markov-matrix* v)
             (do-ec (:f64vector x (index i) u) (f64vector-set! v i x))))
    u))

(time
 (begin
   (populate-matrix (roll-distribution 4 2))
   (let ((ev (eigenvector)))
     (do-ec (:list entry (sort (list-ec (:f64vector x (index i) ev) (cons i x))
                               (lambda (a b) (>= (cdr a) (cdr b)))))
            (print entry)))))
