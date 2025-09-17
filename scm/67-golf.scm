;; Chicken scheme 5
(import (chicken io) (chicken string) (miscmacros))
;; Flatten input into a vector.
(let* ((triangle
	(with-input-from-file "0067_triangle.txt"
	  (lambda () (list->vector (map string->number (string-split (read-string #f)))))))
       ;; Use quadratic equation to solve (n * (n+1)) / 2 = length.
       (height (/ (- (sqrt (+ 1 (* 8 (vector-length triangle)))) 1) 2)))
  ;; Start at second-to-last row.
  (do ((i (- (vector-length triangle) height height -1) (- i (inc! row -1)))
       (row (- height 1)))
      ((= row 0) (print (vector-ref triangle 0)))
    (do ((j 0 (+ j 1)))
	((= j row))
      (inc! (vector-ref triangle (+ i j))
	    (max (vector-ref triangle (+ i row j))
		 (vector-ref triangle (+ i row j 1)))))))
