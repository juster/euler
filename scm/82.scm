(import (chicken io) (chicken string) (chicken time) (chicken format)
        foof-loop
        srfi-1
        srfi-17         ; setter proc for array-ref is needed for inc!
        srfi-25)        ; multi-dimensional arrays

(set! (setter array-ref) array-set!)
(define-constant *dim* 80)
(define (array-shape arr) ; why is this not in srfi-25???
  (loop ((for dim (up-from 0 (to (array-rank arr))))
         (for shape (appending (list (array-start arr dim) (array-end arr dim)))))
        => shape))

(define (above arr x y) (array-ref arr x (- y 1)))
(define (below arr x y) (array-ref arr x (+ y 1)))
(define (right arr x y) (array-ref arr (+ x 1) y))

(define (shortest-path cost)
  (let* ((cost-shape (array-shape cost))
         (path (make-array (apply shape cost-shape) +inf.0))
         (x-min 0) (x-max (- (second cost-shape) 1))
         (y-min 1) (y-max (- (fourth cost-shape) 1)))
    ;; Copy the right-most column because there is no movement after reaching it.
    (loop ((for y (up-from y-min (to y-max))))
          (set! (array-ref path (sub1 x-max) y) (array-ref cost (sub1 x-max) y)))
    ;; Start one column to the left of the right-most column and work to the left.
    (loop ((for x (down-from (sub1 x-max) (to 0))))
          ;; Perform 2 sweeps for each column.
          ;; 1. Check if moving down from above is cheaper than moving to the right.
          (loop ((for y (up-from y-min (to y-max))))
                (set! (array-ref path x y) (+ (array-ref cost x y) (min (right path x y) (above path x y)))))
          ;; 2. Check if moving up from below is cheaper than moving to the right or down from above.
          (loop ((for y (down-from y-max (to y-min))))
                (let ((up-from-below (+ (array-ref cost x y) (below path x y))))
                  (if (< up-from-below (array-ref path x y)) (set! (array-ref path x y) up-from-below)))))
    (cond-expand (debug (print 'OUTPUT) (dump-array path)) (else))
    (inexact->exact
     (loop ((for y (up-from y-min (to y-max)))
            (for answer (minimizing (array-ref path x-min y)))) => answer))))

(cond-expand
  (debug
   (define (dump-array arr)
     (let ((arr-shape (array-shape arr)))
       (loop ((for y (up-from 0 (to (fourth arr-shape)))))
             (print (loop ((for x (up-from 0 (to (second arr-shape))))
                           (for row (listing (array-ref arr x y))))
                          => row)))))
   (define (share-transpose arr)
     (define (transpose-index x y) (values y x))
     (define (reverse-shape lst acc)
       (if (null? lst)
           (apply append acc)
           (receive (dim rest) (split-at lst 2)
             (reverse-shape rest (cons dim acc)))))
     (share-array arr (apply shape (reverse-shape (array-shape arr) '())) transpose-index))
   (define test-matrix
     (share-transpose
      (array (shape 0 7 0 6)
             +inf.0 +inf.0 +inf.0 +inf.0 +inf.0 +inf.0
             131  673  234  103  18 +inf.0
             201  96  342  965  150 +inf.0
             630  803  746  422  111 +inf.0
             537  699  497  121  956 +inf.0
             805  732  524  37  331 +inf.0
             +inf.0 +inf.0 +inf.0 +inf.0 +inf.0 +inf.0
             )))
   (print 'INPUT)
   (dump-array test-matrix)
   (print (shortest-path test-matrix)))
  (else
   (define (load-matrix path)
     (let ((matrix (make-array (shape 0 (+ *dim* 1) 0 (+ *dim* 2)) +inf.0)))
       (with-input-from-file path
         (lambda ()
           (loop ((for y (up-from 0 (to *dim*))))
                 (let ((columns (map string->number (string-split (read-line) ","))))
                   (assert (= *dim* (length columns)) (format "row ~A has ~A columns" (+ y 1) (length columns)))
                   (loop ((for col (in-list columns))
                          (for x (up-from 0 (to (length columns)))))
                         (set! (array-ref matrix x y) col))))
           (assert (eof-object? (read-line)) (format "more than ~A rows found" *dim*))))
       matrix))
   (define (solve) (apply print `("Answer: " ,(shortest-path (load-matrix "0082_matrix.txt")))))
   (time (solve))))
