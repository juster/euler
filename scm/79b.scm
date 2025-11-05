(import srfi-1)
(import list-comprehensions)
(import (chicken io))

(define (interleave-missing hint guess)
  (cond
   ((null? hint) (list guess))
   ((null? guess) (list hint))
   (else (append
		  (map (lambda (result) (cons (car hint) result))
			   (interleave-missing (cdr hint) guess))
		  (map (lambda (result) (cons (car guess) result))
			   (interleave-missing hint (cdr guess)))))))

(define (expand-match hint guess)
  (let loop ((hint-iter hint) (acc '()))
	(if (null? hint-iter)
		;; None of the hint characters are present in guess.
		(begin
		  (interleave-missing hint guess))
		;; Continue searching for hint characters that are present.
		(let ((hint-next (car hint-iter)))
		  (if (member hint-next guess)
			  ;; Split the guess at the next hint found. Interleave the guess before the match with the skipped hint chars.
			  (receive (guess-pre guess-post) (break (lambda (x) (= x hint-next)) guess)
				(collect (append expand-pre (cons hint-next expand-post))
						 (expand-pre (interleave-missing (reverse acc) guess-pre))
						 (expand-post (expand-match (cdr hint-iter) (cdr guess-post)))))
			  ;; Continue searching for a matching hint char.
			  (loop (cdr hint-iter) (cons hint-next acc)))))))

;; Assume the hint is in the correct order and characters only appear once.
(define (impossible-guess? hint guess)
  (if (null? guess) #f
	  (let loop ((hint hint) (guess guess) (guess-prev '()))
		(if (null? hint) #f
			(let ((hint-next (car hint)))
			  (receive (guess-prefix guess-suffix) (break (lambda (x) (= x hint-next)) guess)
				(if (null? guess-suffix)
					;; Next hint character was not found. Check if it was a previous guess character.
					(if (member hint-next guess-prev) #t
						(loop (cdr hint) guess-suffix guess-prev))
					;; Next hint character was found.
					(loop (cdr hint) (cdr guess-suffix) (append guess-prefix guess-prev)))))))))

(define (expand-guesses hint guesses)
  (let ((clean-guesses (remove (lambda (guess) (impossible-guess? hint guess)) guesses)))
	(append-map (lambda (guess) (expand-match hint guess)) clean-guesses)))

(define (solve path)
  (with-input-from-file path
	(lambda ()
	  (let ((guesses '(())))
		(do ((line "" (read-line)))
			((eof-object? line) (print `(Answer: ,guesses)))
		  (let ((hint (map (lambda (ch) (- (char->integer ch) (char->integer #\0))) (string->list line))))
			(set! guesses (expand-guesses hint guesses))))))))
