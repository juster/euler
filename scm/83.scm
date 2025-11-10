(import (chicken io) (chicken string) (chicken time) (chicken format)
        srfi-1          ; lists
        srfi-42         ; eager list comprehensions
        srfi-63         ; multidimensional integer arrays
        hash-trie
        heap)

(define-constant *max* (expt 2 31))

;;------------------------------------------------------------------------------

(define (neighbors xy dims)
  (let-values (((x y) (apply values xy))
               ((max-x max-y) (apply values dims)))
    (append (if (> x 0) (list (list (sub1 x) y)) '())
            (if (< (add1 x) max-x) (list (list (add1 x) y)) '())
            (if (> y 0) (list (list x (sub1 y))) '())
            (if (< (add1 y) max-y) (list (list x (add1 y))) '()))))

(define xy-hash-trie-type
  (make-hash-trie-type equal? (lambda (xy) (exact-integer-hash (+ (* 100 (first xy)) (second xy))))))

;; Dijkstra
(define (shortest-path cost)
  (let* ((dimensions (array-dimensions cost))
         (distance (apply make-array (A:fixN32b *max*) dimensions))
         (xy-distance (lambda (xy) (apply array-ref distance xy)))
         (heap (make-min-heap xy-distance (make-vector (* (first dimensions) (second dimensions))))))
    (array-set! distance (array-ref cost 0 0) 0 0)
    (heap-push! heap (list 0 0))
    (let loop ((xy (heap-pop! heap))
               (seen (make-hash-trie xy-hash-trie-type)))
      (cond ((not xy)
             (dump-array 'OUTPUT distance)
             (apply array-ref distance (map sub1 dimensions)))
            ((hash-trie/member? seen xy)
             (print `(*DBG* already seen: ,xy))
             (loop (heap-pop! heap) seen))
            (else
             (let ((dist-from (xy-distance xy)))
               (cond-expand (devtest (print `(*DBG* xy ,xy dist-from ,dist-from))) (else))
               (do-ec (:list next-door (neighbors xy dimensions))
                      (if (not (hash-trie/member? seen next-door)))
                      (let ((dist-to (+ dist-from (apply array-ref cost next-door))))
                        (when (< dist-to (xy-distance next-door))
                          (apply array-set! distance dist-to next-door)
                          (heap-push! heap next-door))))
               (loop (heap-pop! heap) (hash-trie/insert seen xy '()))))))))

(cond-expand
  (devtest
   (define (dump-array message arr)
     (print message)
     (let ((dims (array-dimensions arr)))
       (do-ec (:range y (second dims))
              (print (list-ec (:range x (first dims)) (array-ref arr x y))))))
   (define test-matrix
     (make-shared-array
      (list->array 2 (A:fixN32b)
                   (list
                    (list 131 673 234 103 18)
                    (list 201 96 342 965 150)
                    (list 630 803 746 422 111)
                    (list 537 699 497 121 956)
                    (list 805 732 524 37 331)))
      (lambda (x y) (list y x))
      5 5))
   (dump-array 'INPUT test-matrix)
   (print (shortest-path test-matrix)))
  (else
   (define (dump-array _ _) #f)
   (define (load-matrix path size)
     (let ((matrix (make-array (A:fixN32b *max*) size size)))
       (with-input-from-file path
         (lambda ()
           (do-ec (:range y size)
                  (let ((columns (map string->number (string-split (read-line) ","))))
                    (assert (= size (length columns)) (format "row ~A has ~A columns" (+ y 1) (length columns)))
                    (do-ec (:list col (index x) columns)
                           (array-set! matrix col x y))))
           (assert (eof-object? (read-line)) (format "more than ~A rows found" size))))
       matrix))
   (define (solve) (apply print `("Answer: " ,(shortest-path (load-matrix "0083_matrix.txt" 80)))))
   (time (solve))))
