;; Chicken 5
(import (chicken string) srfi-1)

(define (permute-vector! input)
  ;; https://en.wikipedia.org/wiki/Heap%27s_algorithm 
  (define (yield output str)
    (call/cc (lambda (continue) (output (cons str continue)))))
  (define (swap str i j)
    (let ((x (vector-ref str i)))
      (vector-set! str i (vector-ref str j))
      (vector-set! str j x)))
  (define (perm str output)
    (let ((c (make-vector (vector-length str) 0)))
      (set! output (yield output str))
      (do ((i 1)) ((= i (vector-length str)) (output '()))
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
   ((vector? input)
    (call/cc (lambda (output) (perm input output))))
   ((pair? input)
    (let ((next (cdr input)))
      (call/cc (lambda (output) (next output)))))))

(define (make-3gon-ring v)
  (do ((i 0 (+ i 2))
       (prev (vector-ref v (- (vector-length v) 1)) (vector-ref v (+ i 1)))
       (acc '() (cons (list (vector-ref v i) prev (vector-ref v (+ i 1))) acc)))
      ;; not sure why but reverse is needed to find example solution
      ((= i (vector-length v))
       (let* ((each-sum (map (lambda (set) (foldl + 0 set)) acc)))
	 (and (every (lambda (sum) (= (car each-sum) sum)) (cdr each-sum))
	      (3gon-sort (reverse acc)))))))

(define (3gon-sort triplets)
  (do ((sets triplets (cdr sets)) (i 0 (+ i 1)) (found (cons 1e6 -1)))
      ((null? sets)
       (receive (fore aft) (split-at triplets (cdr found))
	 (append aft fore)))
    ;; (print `(*DBG* ,sets ,found, i))
    (if (< (caar sets) (car found))
	(set! found (cons (caar sets) i)))))

(define (3gon-concat triplets)
  (apply conc (append-map (cut map number->string <>) triplets)))

(define (solve n)
  (let loop ((perm (permute-vector! (list->vector (cdr (iota (+ n 1))))))
	     (max ""))
    (if (null? perm) max
	(let ((solution (make-3gon-ring (car perm))))
	  (if solution
	      (let ((x (3gon-concat solution)))
		(print `(solution ,solution))
		(loop (permute-vector! perm)
		      (if (and (= (string-length x) 16)
			       (string>? x max)) x max)))
		      ;; (if (string>? x max) x max)))
	      (loop (permute-vector! perm) max))))))
