(module euler * 
  (import scheme (chicken base) (chicken random) (chicken type) iset)

  ;; Sieve of Eratosthenes stored as byte vector
  (define (sieve n)
    ;; Only store values for odd numbers, starting with 1.
    (let [(v (make-bit-vector (ceiling (/ n 2)) #t))
          (n (- n (remainder n 2)))]
      (bit-vector-set! v 0 #f)
      (do [(i 1 (add1 i))] [(= i (bit-vector-length v))] (bit-vector-set! v i #t))
      (do [(i 3 (+ i 2))] [(>= i n) v]
        (when (sieve-prime? v i)
          (do [(j (* 3 i) (+ j i i))] [(> j n)]
            ;(print `(i: ,i j: ,j))
            (when (odd? j)
              (bit-vector-set! v (quotient j 2) #f)))))))

  (define (sieve-count v)
    (do ((i 0 (add1 i)) (n (bit-vector-length v)) (x 0))
	((>= i n) x)
      (when (bit-vector-ref v i) (set! x (add1 x)))))

  (: sieve-prime? ((vector-of boolean) integer --> boolean))
  (define (sieve-prime? v n)
    (if (= 0 (remainder n 2)) (= n 2)
	(let [(i (quotient n 2))]
          (if (> i (bit-vector-length v))
              (prime? n)
              (bit-vector-ref v i)))))

  (define (sieve-prime-test lst n)
    (if (null? lst) #t
	(let ((p (car lst)))
	  (cond ((> (* p p) n) #t)
		((= n (* p (quotient n p))) #f)
		(else (sieve-prime-test (cdr lst) n))))))

  (define (sieve-prime-list v)
    (define (helper pair acc)
      (if (null? pair) (reverse acc)
	  (helper (force (cdr pair)) (cons (car pair) acc))))
    (helper (force (sieve-prime-seq v)) '()))

  (define (sieve-prime-seq v)
    (define (sieve-primes-helper v i n)
      (cond [(>= i n) '()]
            [(sieve-prime? v i) (delay (cons i (delay-force (sieve-primes-helper v (+ i 2) n))))]
            [else (sieve-primes-helper v (+ i 2) n)]))
    (delay (cons 2 (delay-force (sieve-primes-helper v 3 (* 2 (bit-vector-length v)))))))

  ;; (define (prime? n)
  ;;   (cond [(< n 1) (error "no support for <1")]
  ;;         [(= n 1) #f]
  ;;         [(= n 2) #t]
  ;;         [(= 0 (remainder n 2)) #f]
  ;;         [else 
  ;;          (let ([m (ceiling (sqrt n))])
  ;;            (let loop [(i 3)]
  ;;              (cond [(> i m) #t]
  ;;                    [(= 0 (remainder n i)) #f]
  ;;                    [else (loop (+ 2 i))])))]))

  (: prime? (integer --> boolean))
  (define (prime? n)
    (cond [(< n 1) (error "no support for <1")]
          [(= n 1) #f]
          [(= n 2) #t]
          [(= 0 (remainder n 2)) #f]
          [else 
	    (let loop [(i 3)]
	      (cond [(>= (* i i) n) #t]
		    [(= n (* i (quotient n i))) #f]
		    [else (loop (+ 2 i))]))]))

  (define (fermat-prime? n)
    (let [(a (pseudo-random-integer n))]
      (if (< a 2) (fermat-prime? n)
          (= 1 (remainder (expt a (sub1 n)) n)))))

  (define (fermat-prime-repeat? n i)
    (let [(is-prime (fermat-prime? n))]
      (if (and is-prime (> i 0)) (fermat-prime-repeat? n (sub1 i))
          is-prime)))

  (define (permute-string! input)
    ;; https://en.wikipedia.org/wiki/Heap%27s_algorithm 
    (define (yield output str)
      (call/cc (lambda (continue) (output (cons str continue)))))
    (define (swap str i j)
      (let ((x (string-ref str i)))
	(string-set! str i (string-ref str j))
	(string-set! str j x)))
    (define (perm str output)
      (let ((c (make-vector (string-length str) 0)))
	(set! output (yield output str))
	(do ((i 1)) ((= i (string-length str)) (output '()))
	  (if (< (vector-ref c i) i)
	      (begin
		(swap str (if (even? i) 0 (vector-ref c i)) i)
		(set! output (yield output str))
		(vector-set! c i (+ (vector-ref c i) 1))
		(set! i 1))
	      (begin
		(vector-set! c i 0)
		(set! i (+ i 1)))))))
    (cond 
     ((null? input)
      '())
     ((string? input)
      (call/cc (lambda (output) (perm input output))))
     ((pair? input)
      (let ((next (cdr input)))
	(call/cc (lambda (output) (next output)))))))

  (define (permute-list str)
    (let loop ((seq (permute-string! str)) (acc '()))
      (if (null? seq) acc
          (let ((str (string-copy (car seq))))
            (loop (permute-string! seq) (cons str acc))))))

  (define (number-append a b)
    ;;(+ (* a (inexact->exact (expt 10 (ceiling (log b 10)))))
    ;;   b)))
    (string->number (string-append (number->string a) (number->string b)))))
