(define *max-n* 12000)
(define (mediant min max)
  (/ (+ (numerator min) (numerator max))
     (+ (denominator min) (denominator max))))
(define (count-span min med max)
  (if (> (denominator med) *max-n*) 0
      (+ 1 (count-span min (mediant min med) med) (count-span med (mediant med max) max))))
(print (count-span (/ 1 3) (mediant (/ 1 3) (/ 1 2)) (/ 1 2)))
