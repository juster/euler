(import srfi-69)

(define (memoize symbol)
  (let ((table (make-hash-table))
		(old-proc (eval symbol)))
	(define (new-proc args)
	  (if (hash-table-exists? table args)
		  (hash-table-ref table args)
		  (let ((result (apply old-proc args)))
			(hash-table-set! table args result)
			result)))
	(set! symbol new-proc)))

(define (count-partitions n max-part)
  (cond ((= n 0) 1)                         ; found a valid partition
        ((or (< n 0) (= max-part 0)) 0)     ; no valid partition
        (else (+ (count-partitions (- n max-part) max-part) ; include max-part
                 (count-partitions n (- max-part 1))))))    ; exclude max-part
(memoize 'count-partitions)

;; (print (count-partitions 100 100))
