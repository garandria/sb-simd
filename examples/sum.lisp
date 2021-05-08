(in-package #:sb-simd)

(defun simd-sum1 (array &aux (n (array-total-size array)))
  (declare (type (simple-array double-float 1) array)
           (optimize speed (safety 0)))
  (do ((index 0 (the (integer 0 #.(- array-total-size-limit 16)) (+ index 16)))
       (acc1 (make-f64.4 0 0 0 0) (f64.4+ acc1 (f64.4-row-major-aref array (+ index 0))))
       (acc2 (make-f64.4 0 0 0 0) (f64.4+ acc2 (f64.4-row-major-aref array (+ index 4))))
       (acc3 (make-f64.4 0 0 0 0) (f64.4+ acc3 (f64.4-row-major-aref array (+ index 8))))
       (acc4 (make-f64.4 0 0 0 0) (f64.4+ acc4 (f64.4-row-major-aref array (+ index 12)))))
      ((>= index (- n 16))
       (do ((result (multiple-value-call #'+ (f64.4-values (f64.4+ acc1 acc2 acc3 acc4)))
                    (+ result (row-major-aref array index)))
            (index index (1+ index)))
           ((>= index n) result)))))

(defun simd-sum2 (array &aux (n (array-total-size array)))
  (declare (type (simple-array double-float (*)) array)
           (optimize speed (safety 0)))
  (do ((index 0 (the (integer 0 #.(- array-total-size-limit 16)) (+ index 16)))
       (acc1 (make-f64.4 0 0 0 0) (f64.4+ acc1 (f64.4-ref array (+ index 0))))
       (acc2 (make-f64.4 0 0 0 0) (f64.4+ acc2 (f64.4-ref array (+ index 4))))
       (acc3 (make-f64.4 0 0 0 0) (f64.4+ acc3 (f64.4-ref array (+ index 8))))
       (acc4 (make-f64.4 0 0 0 0) (f64.4+ acc4 (f64.4-ref array (+ index 12)))))
      ((>= index (- n 16))
       (do ((result (multiple-value-call #'+ (f64.4-values (f64.4+ acc1 acc2 acc3 acc4)))
                    (+ result (row-major-aref array index)))
            (index index (1+ index)))
           ((>= index n) result)))))

(defun simd-vdot (array1 array2 &aux (n (min (array-total-size array1) (array-total-size array2))))
  (declare (type (simple-array double-float 1) array1 array2)
           (optimize speed (safety 0)))
  (do ((index 0 (the (integer 0 #.(- array-total-size-limit 16)) (+ index 16)))
       (acc1 (make-f64.4 0 0 0 0) (f64.4+ acc1 (f64.4* (f64.4-row-major-aref array1 (+ index 0))
						       (f64.4-row-major-aref array2 (+ index 0)))))
       (acc2 (make-f64.4 0 0 0 0) (f64.4+ acc2 (f64.4* (f64.4-row-major-aref array1 (+ index 4))
						       (f64.4-row-major-aref array2 (+ index 4)))))
       (acc3 (make-f64.4 0 0 0 0) (f64.4+ acc3 (f64.4* (f64.4-row-major-aref array1 (+ index 8))
						       (f64.4-row-major-aref array2 (+ index 8)))))
       (acc4 (make-f64.4 0 0 0 0) (f64.4+ acc4 (f64.4* (f64.4-row-major-aref array1 (+ index 12))
						       (f64.4-row-major-aref array2 (+ index 12))))))
      ((>= index (- n 16))
       (do ((result (multiple-value-call #'+ (f64.4-values (f64.4+ acc1 acc2 acc3 acc4)))
                    (+ result (* (row-major-aref array1 index)
				 (row-major-aref array2 index))))
            (index index (1+ index)))
           ((>= index n) result)))))
