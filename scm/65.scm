;; Chicken scheme 5
(import (only srfi-1 iota))

(define (e-series-ref i)
  (set! i (- i 1))
  (if (<= i 0) 2
      (receive (q r) (quotient&remainder i 3)
	(if (= r 2) (* 2 (+ q 1)) 1))))

(define (converge series)
  (do ((prev-num 1 num)
       (num (car series) (+ (* num (car series)) prev-num))
       (prev-denom 0 denom)
       (denom 1 (+ (* denom (car series)) prev-denom))
       (series (cdr series) (cdr series)))
      ((null? series) (cons num denom))))

(define (sum-digits n)
  (let loop ((n n) (sum 0))
    (if (= n 0) sum
	(receive (q r) (quotient&remainder n 10)
	  (loop q (+ sum r))))))

(define (solve n)
  (sum-digits (car (converge (map e-series-ref (iota n 1))))))

(print (solve 100))
