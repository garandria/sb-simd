(in-package #:sb-simd)

(defmacro call-vop (instruction-record-name &rest arguments)
  (with-accessors ((instruction-set instruction-record-instruction-set)
                   (vop instruction-record-vop))
      (find-instruction-record instruction-record-name)
    (if (instruction-set-available-p instruction-set)
        `(,vop ,@arguments)
        `(progn
           (missing-instruction (load-time-value (find-instruction-record ',instruction-record-name)))
           (touch ,@arguments)))))

(defmacro define-simd-cast (simd-record-name broadcast)
  (with-accessors ((name simd-record-name)
                   (size simd-record-size)
                   (scalar-record simd-record-scalar-record))
      (find-value-record simd-record-name)
    (let* ((package (symbol-package broadcast))
           (cast (mksym package (symbol-name name)))
           (err (mksym package "CANNOT-CONVERT-TO-" name))
           (instruction-set (find-instruction-set package)))
      `(progn
         (define-notinline ,err (x)
           (error "Cannot convert ~S to ~S." x ',name))
         (define-inline ,cast (x)
           (declare (sb-vm::instruction-sets ,@(available-instruction-sets instruction-set)))
           (typecase x
             (,name x)
             (real (call-vop ,broadcast (,(scalar-record-name scalar-record) x)))
             (otherwise (,err x))))))))

(defmacro define-simd-cast! (cast! pack!-from-scalar &optional pack!-from-p128 pack!-from-p256)
  (let* ((package (symbol-package cast!))
         (name (symbol-name cast!))
         (pack (find-symbol (subseq name 0 (1- (length name))) package))
         (err (mksym package "CANNOT-REINTERPRET-AS-" name))
         (instruction-set (find-instruction-set package)))
    (flet ((argument-type (instruction)
             (value-record-name
              (first
               (primitive-record-argument-records
                (find-instruction-record instruction))))))
      `(progn
         (define-notinline ,err (x)
           (error "Cannot reinterpret ~S as ~S." x ',pack))
         (define-inline ,cast! (x)
           (declare (sb-vm::instruction-sets ,@(available-instruction-sets instruction-set)))
           (typecase x
             (real (call-vop ,pack!-from-scalar (,(argument-type pack!-from-scalar) x)))
             ,@(unless (not pack!-from-p128)
                 `((,(argument-type pack!-from-p128)
                    (call-vop ,pack!-from-p128 x))))
             ,@(unless (not pack!-from-p256)
                 `((,(argument-type pack!-from-p256)
                    (call-vop ,pack!-from-p256 x))))
             (otherwise (,err x))))))))

(in-package #:sb-simd-sse)

(define-inline p128 (x) (the p128 x))

(sb-simd::define-simd-cast f32.4 f32.4-broadcast)
(sb-simd::define-simd-cast! f32.4! f32.4!-from-f32)

(in-package #:sb-simd-sse2)

(sb-simd::define-simd-cast f64.2 f64.2-broadcast)
(sb-simd::define-simd-cast! f64.2! f64.2!-from-f64 f64.2!-from-p128)

(sb-simd::define-simd-cast u8.16 u8.16-broadcast)
(sb-simd::define-simd-cast! u8.16! u8.16!-from-u8 u8.16!-from-p128)

(sb-simd::define-simd-cast u16.8 u16.8-broadcast)
(sb-simd::define-simd-cast! u16.8! u16.8!-from-u16 u16.8!-from-p128)

(sb-simd::define-simd-cast u32.4 u32.4-broadcast)
(sb-simd::define-simd-cast! u32.4! u32.4!-from-u32 u32.4!-from-p128)

(sb-simd::define-simd-cast u64.2 u64.2-broadcast)
(sb-simd::define-simd-cast! u64.2! u64.2!-from-u64 u64.2!-from-p128)

(sb-simd::define-simd-cast s8.16 s8.16-broadcast)
(sb-simd::define-simd-cast! s8.16! s8.16!-from-s8 s8.16!-from-p128)

(sb-simd::define-simd-cast s16.8 s16.8-broadcast)
(sb-simd::define-simd-cast! s16.8! s16.8!-from-s16 s16.8!-from-p128)

(sb-simd::define-simd-cast s32.4 s32.4-broadcast)
(sb-simd::define-simd-cast! s32.4! s32.4!-from-s32 s32.4!-from-p128)

(sb-simd::define-simd-cast s64.2 s64.2-broadcast)
(sb-simd::define-simd-cast! s64.2! s64.2!-from-s64 s64.2!-from-p128)

(in-package #:sb-simd-avx)

(define-inline p128 (x) (the p128 x))
(define-inline p256 (x) (the p256 x))

(sb-simd::define-simd-cast f32.4 f32.4-broadcast)
(sb-simd::define-simd-cast! f32.4! f32.4!-from-f32)

(sb-simd::define-simd-cast f64.2 f64.2-broadcast)
(sb-simd::define-simd-cast! f64.2! f64.2!-from-f64 f64.2!-from-p128)

(sb-simd::define-simd-cast f32.8 f32.8-broadcast)
(sb-simd::define-simd-cast! f32.8! f32.8!-from-f32 f32.8!-from-p128 f32.8!-from-p256)

(sb-simd::define-simd-cast f64.4 f64.4-broadcast)
(sb-simd::define-simd-cast! f64.4! f64.4!-from-f64 f64.4!-from-p128 f64.4!-from-p256)

(sb-simd::define-simd-cast u8.16 u8.16-broadcast)
(sb-simd::define-simd-cast! u8.16! u8.16!-from-u8 u8.16!-from-p128 u8.16!-from-p256)

(sb-simd::define-simd-cast u16.8 u16.8-broadcast)
(sb-simd::define-simd-cast! u16.8! u16.8!-from-u16 u16.8!-from-p128 u16.8!-from-p256)

(sb-simd::define-simd-cast u32.4 u32.4-broadcast)
(sb-simd::define-simd-cast! u32.4! u32.4!-from-u32 u32.4!-from-p128 u32.4!-from-p256)

(sb-simd::define-simd-cast u64.2 u64.2-broadcast)
(sb-simd::define-simd-cast! u64.2! u64.2!-from-u64 u64.2!-from-p128 u64.2!-from-p256)

(sb-simd::define-simd-cast u8.32 u8.32-broadcast)
(sb-simd::define-simd-cast! u8.32! u8.32!-from-u8 u8.32!-from-p128 u8.32!-from-p256)

(sb-simd::define-simd-cast u16.16 u16.16-broadcast)
(sb-simd::define-simd-cast! u16.16! u16.16!-from-u16 u16.16!-from-p128 u16.16!-from-p256)

(sb-simd::define-simd-cast u32.8 u32.8-broadcast)
(sb-simd::define-simd-cast! u32.8! u32.8!-from-u32 u32.8!-from-p128 u32.8!-from-p256)

(sb-simd::define-simd-cast u64.4 u64.4-broadcast)
(sb-simd::define-simd-cast! u64.4! u64.4!-from-u64 u64.4!-from-p128 u64.4!-from-p256)

(sb-simd::define-simd-cast s8.16 s8.16-broadcast)
(sb-simd::define-simd-cast! s8.16! s8.16!-from-s8 s8.16!-from-p128 s8.16!-from-p256)

(sb-simd::define-simd-cast s16.8 s16.8-broadcast)
(sb-simd::define-simd-cast! s16.8! s16.8!-from-s16 s16.8!-from-p128 s16.8!-from-p256)

(sb-simd::define-simd-cast s32.4 s32.4-broadcast)
(sb-simd::define-simd-cast! s32.4! s32.4!-from-s32 s32.4!-from-p128 s32.4!-from-p256)

(sb-simd::define-simd-cast s64.2 s64.2-broadcast)
(sb-simd::define-simd-cast! s64.2! s64.2!-from-s64 s64.2!-from-p128 s64.2!-from-p256)

(sb-simd::define-simd-cast s8.32 s8.32-broadcast)
(sb-simd::define-simd-cast! s8.32! s8.32!-from-s8 s8.32!-from-p128 s8.32!-from-p256)

(sb-simd::define-simd-cast s16.16 s16.16-broadcast)
(sb-simd::define-simd-cast! s16.16! s16.16!-from-s16 s16.16!-from-p128 s16.16!-from-p256)

(sb-simd::define-simd-cast s32.8 s32.8-broadcast)
(sb-simd::define-simd-cast! s32.8! s32.8!-from-s32 s32.8!-from-p128 s32.8!-from-p256)

(sb-simd::define-simd-cast s64.4 s64.4-broadcast)
(sb-simd::define-simd-cast! s64.4! s64.4!-from-s64 s64.4!-from-p128 s64.4!-from-p256)

(in-package #:sb-simd-avx2)

(sb-simd::define-simd-cast u8.32 u8.32-broadcast)

(sb-simd::define-simd-cast u16.16 u16.16-broadcast)

(sb-simd::define-simd-cast u32.8 u32.8-broadcast)

(sb-simd::define-simd-cast u64.4 u64.4-broadcast)

(sb-simd::define-simd-cast s8.32 s8.32-broadcast)

(sb-simd::define-simd-cast s16.16 s16.16-broadcast)

(sb-simd::define-simd-cast s32.8 s32.8-broadcast)

(sb-simd::define-simd-cast s64.4 s64.4-broadcast)
