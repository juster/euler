(import (chicken base) (chicken time) srfi-1 iset euler)

(define maximus-prime 10000) ; must be a power of 10

(define (symmetric-pairs prime-seq)
  (define (pair-helper seq p s)
      (if (null? (force seq)) s
          (let [(q (car (force seq)))]
            (pair-helper (cdr (force seq)) p
                         (if (and (prime-concat? p q) (prime-concat? q p))
                             (iset-adjoin s q)
                             s)))))
  (define (helper seq acc)
    (if (null? (force seq)) (reverse acc)
        (let* [(p (car (force seq)))
               (seq (cdr (force seq)))
               (set (pair-helper seq p (make-iset)))]
          (helper seq
                  (if (iset-empty? set) acc
                      (cons (cons p set) acc))))))
  ;; Skip 2 because any number ending in 2 will not be prime.
  (helper (cdr (force prime-seq)) '()))

(print "Generating sieve of eratosthenes...")
(set! prime-sieve (time (sieve maximus-prime)))
(print (list (sieve-count prime-sieve) 'primes))

(define (prime-concat? x y) (sieve-prime? prime-sieve (number-append x y)))

;;(define (prime-concat? x y) (prime-jorgbrown? (number-append x y)))
(define (prime-jorgbrown? n)
  (let loop ((seq (sieve-prime-seq prime-sieve)))
    (if (null? (force seq)) #t
	(let ((p (car (force seq))))
	  (cond ((> (* p p) n) #t)
		((= n (* p (quotient n p))) #f)
		(else (loop (cdr (force seq)))))))))

(print "Finding all pairs which concatenate into a prime...")
(set! pair-sets
  (time (symmetric-pairs (sieve-prime-seq prime-sieve))))

(define (pair-groups-with sym-set)
  (define (intersection s u)
    (let [(v (iset-intersection s u))] (and (not (iset-empty? v)) v)))
  (define (helper s group todo acc)
    (if (null? todo) acc
        (let* [(next (car todo))
               (u (assv next pair-sets))
               (v (and u (intersection s (cdr u))))
               (next-group (cons next group))
               (acc (cons (reverse next-group) acc))]
          (helper s group (cdr todo)
                  (if (not v) acc
                      (helper v next-group (iset->list v) acc))))))
  (let* [(i (car sym-set))
         (s (cdr sym-set))]
    (reverse (helper s (list i) (iset->list s) '()))))

(print "Finding all prime pair groups...")
(set! pair-groups (time (append-map pair-groups-with pair-sets)))

(for-each
  (lambda (g) (print (list sum: (foldl + (car g) (cdr g)) group: g)))
  (filter (compose (cut = 5 <>) length) pair-groups))
