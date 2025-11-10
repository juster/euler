(module heap (make-min-heap heap-push! heap-pop!)
  (import scheme (chicken base) miscmacros srfi-1)

;;------------------------------------------------------------------------------

  (define-record heap rank-proc vector cmp size)

  (define (make-min-heap rank-proc v) (make-heap rank-proc v < 0))

  ;; (define (list->heap rank-proc lst #!optional (cmp <))
  ;;   (let* ((v (list->vector lst))
  ;;          (size (vector-length v))
  ;;          (heap (make-heap rank-proc v cmp size)))
  ;;     (do ((i (sub1 (quotient (add1 size) 2)) (- i 1)))
  ;;         ((< i 0))
  ;;       (sink-down heap i))
  ;;     heap))

  (define (rank heap i) ((heap-rank-proc heap) (vector-ref (heap-vector heap) i)))

  (define (left-child-index i) (sub1 (* 2 (add1 i))))

  (define (right-child-index i) (* 2 (add1 i)))

  (define (parent-index i)
    (if (= i 0) #f (sub1 (quotient (add1 i) 2))))

  (define (swap! heap i j)
    (let* ((v (heap-vector heap))
           (x (vector-ref v i)))
      (vector-set! v i (vector-ref v j))
      (vector-set! v j x)))

  (define (sink-down heap i)
    (define (sink-down- heap i result)
      (define (heap-top-index heap i j)
        (if (and (< j (heap-size heap))
                 ((heap-cmp heap) (rank heap j) (rank heap i)))
            j i))
      (let ((parent-i i))
        (set! parent-i (heap-top-index heap parent-i (left-child-index i)))
        (set! parent-i (heap-top-index heap parent-i (right-child-index i)))
        (if (= i parent-i) result
            (begin
              (swap! heap i parent-i)
              (sink-down- heap parent-i #t)))))
    (sink-down- heap i #f))

  (define (bubble-up heap i)
    (let ((parent (parent-index i)))
      (if (and parent (sink-down heap parent))
          (begin (bubble-up heap parent) #t)
          #f)))

  (define (heap-push! heap item)
    (let ((size (heap-size heap)))
      (vector-set! (heap-vector heap) size item)
      (heap-size-set! heap (add1 size))
      (bubble-up heap size)))

  (define (heap-pop! heap)
    (let ((size (heap-size heap)))
      (if (= size 0) #f
          (let* ((v (heap-vector heap))
                 (root (vector-ref v 0))
                 (size (sub1 size)))
            (heap-size-set! heap size)
            (when (> size 0)
              (vector-set! v 0 (vector-ref v size))
              (sink-down heap 0))
            root)))))
