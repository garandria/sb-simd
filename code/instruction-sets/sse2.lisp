(in-package #:sb-simd-sse2)

(define-instruction-set :sse2
  (:include :sse)
  (:test (sse2-supported-p))
  (:scalars
   (f64 64 double-float #:double-float (#:double-reg)))
  (:simd-packs
   (f64.2 f64 128 #:simd-pack-double (#:double-sse-reg))
   (u8.16 u8  128 #:simd-pack-ub8  (#:int-sse-reg))
   (u16.8 u16 128 #:simd-pack-ub16 (#:int-sse-reg))
   (u32.4 u32 128 #:simd-pack-ub32 (#:int-sse-reg))
   (u64.2 u64 128 #:simd-pack-ub64 (#:int-sse-reg))
   (s8.16 s8  128 #:simd-pack-sb8  (#:int-sse-reg))
   (s16.8 s16 128 #:simd-pack-sb16 (#:int-sse-reg))
   (s32.4 s32 128 #:simd-pack-sb32 (#:int-sse-reg))
   (s64.2 s64 128 #:simd-pack-sb64 (#:int-sse-reg)))
  (:simd-casts
   (f64.2 f64.2-broadcast)
   (u8.16 u8.16-broadcast)
   (u16.8 u16.8-broadcast)
   (u32.4 u32.4-broadcast)
   (u64.2 u64.2-broadcast)
   (s8.16 s8.16-broadcast)
   (s16.8 s16.8-broadcast)
   (s32.4 s32.4-broadcast)
   (s64.2 s64.2-broadcast))
  (:reinterpret-casts
   (f64!   f64!-from-p128)
   (u8!    u8!-from-p128)
   (u16!   u16!-from-p128)
   (u32!   u32!-from-p128)
   (u64!   u64!-from-p128)
   (f64.2! f64.2!-from-f64 f64.2!-from-p128)
   (u8.16! u8.16!-from-u8 u8.16!-from-p128)
   (u16.8! u16.8!-from-u16 u16.8!-from-p128)
   (u32.4! u32.4!-from-u32 u32.4!-from-p128)
   (u64.2! u64.2!-from-u64 u64.2!-from-p128)
   (s8.16! s8.16!-from-s8 s8.16!-from-p128)
   (s16.8! s16.8!-from-s16 s16.8!-from-p128)
   (s32.4! s32.4!-from-s32 s32.4!-from-p128)
   (s64.2! s64.2!-from-s64 s64.2!-from-p128))
  (:instructions
   ;; f32
   (f32-from-f64      #:cvtsd2ss   (f32) (f64)     :cost 5)
   ;; f64
   (f64-from-f32      #:cvtss2sd   (f64) (f32)     :cost 5)
   (f64-from-s64      nil          (f64) (s64)     :cost 5 :encoding :custom)
   (f64!-from-p128    nil          (f64) (p128)    :cost 1 :encoding :custom :always-translatable nil)
   (two-arg-f64-and   #:andpd      (f64) (f64 f64) :cost 1 :encoding :sse :associative t)
   (two-arg-f64-or    #:orpd       (f64) (f64 f64) :cost 1 :encoding :sse :associative t)
   (two-arg-f64-xor   #:xorpd      (f64) (f64 f64) :cost 1 :encoding :sse :associative t)
   (two-arg-f64-max   #:maxsd      (f64) (f64 f64) :cost 1 :encoding :sse :associative t)
   (two-arg-f64-min   #:minsd      (f64) (f64 f64) :cost 1 :encoding :sse :associative t)
   (two-arg-f64+      #:addsd      (f64) (f64 f64) :cost 1 :encoding :sse :associative t)
   (two-arg-f64-      #:subsd      (f64) (f64 f64) :cost 2 :encoding :sse)
   (two-arg-f64*      #:mulsd      (f64) (f64 f64) :cost 2 :encoding :sse :associative t)
   (two-arg-f64/      #:divsd      (f64) (f64 f64) :cost 8 :encoding :sse)
   (two-arg-f64=      #:cmpsd      (u64) (f64 f64) :cost 4 :encoding :custom :prefix '(:eq) :associative t)
   (two-arg-f64/=     #:cmpsd      (u64) (f64 f64) :cost 4 :encoding :custom :prefix '(:neq) :associative t)
   (two-arg-f64<      #:cmpsd      (u64) (f64 f64) :cost 4 :encoding :custom :prefix '(:lt))
   (two-arg-f64<=     #:cmpsd      (u64) (f64 f64) :cost 4 :encoding :custom :prefix '(:le))
   (two-arg-f64>      #:cmpsd      (u64) (f64 f64) :cost 4 :encoding :custom :prefix '(:nle))
   (two-arg-f64>=     #:cmpsd      (u64) (f64 f64) :cost 4 :encoding :custom :prefix '(:nlt))
   (f64-andc1         #:andnpd     (f64) (f64 f64) :cost 1 :encoding :sse)
   (f64-not           nil          (f64) (f64)     :cost 1 :encoding :fake-vop)
   (f64.2-hsum        nil          (f64) (f64.2)   :cost 3 :encoding :fake-vop)
   (f64.2-hprod       nil          (f64) (f64.2)   :cost 3 :encoding :fake-vop)
   (f64-sqrt          #:sqrtsd     (f64) (f64)     :cost 15)
   ;; scalar reinterpret casts
   ( u8!-from-p128    nil          (u8)    (p128)        :cost 1 :encoding :fake-vop)
   (u16!-from-p128    nil          (u16)   (p128)        :cost 1 :encoding :fake-vop)
   (u32!-from-p128    nil          (u32)   (p128)        :cost 1 :encoding :fake-vop)
   (u64!-from-p128    #:movq       (u64)   (p128)        :cost 1 :always-translatable nil)
   ;; f32.4
   (f32.4-from-s32.4  #:cvtdq2ps   (f32.4) (s32.4)       :cost 5)
   (f32.4!-from-p128  #:movups     (f32.4) (p128)        :cost 1 :encoding :move :always-translatable nil)
   (two-arg-f32.4=    #:cmpps      (u32.4) (f32.4 f32.4) :cost 4 :encoding :sse :prefix '(:eq) :associative t)
   (two-arg-f32.4/=   #:cmpps      (u32.4) (f32.4 f32.4) :cost 4 :encoding :sse :prefix '(:neq) :associative t)
   (two-arg-f32.4<    #:cmpps      (u32.4) (f32.4 f32.4) :cost 4 :encoding :sse :prefix '(:lt))
   (two-arg-f32.4<=   #:cmpps      (u32.4) (f32.4 f32.4) :cost 4 :encoding :sse :prefix '(:le))
   (two-arg-f32.4>    #:cmpps      (u32.4) (f32.4 f32.4) :cost 4 :encoding :sse :prefix '(:nle))
   (two-arg-f32.4>=   #:cmpps      (u32.4) (f32.4 f32.4) :cost 4 :encoding :sse :prefix '(:nlt))
   ;; f64.2
   (f64.2!-from-f64   #:movupd     (f64.2) (f64)         :cost 1 :encoding :move)
   (f64.2!-from-p128  #:movupd     (f64.2) (p128)        :cost 1 :encoding :move :always-translatable nil)
   (make-f64.2        nil          (f64.2) (f64 f64)     :cost 1 :encoding :fake-vop)
   (f64.2-values      nil          (f64 f64) (f64.2)     :cost 1 :encoding :fake-vop)
   (f64.2-broadcast   nil          (f64.2) (f64)         :cost 1 :encoding :fake-vop)
   (two-arg-f64.2-and #:andpd      (f64.2) (f64.2 f64.2) :cost 1 :encoding :sse :associative t)
   (two-arg-f64.2-or  #:orpd       (f64.2) (f64.2 f64.2) :cost 1 :encoding :sse :associative t)
   (two-arg-f64.2-xor #:xorpd      (f64.2) (f64.2 f64.2) :cost 1 :encoding :sse :associative t)
   (two-arg-f64.2-max #:maxpd      (f64.2) (f64.2 f64.2) :cost 3 :encoding :sse :associative t)
   (two-arg-f64.2-min #:minpd      (f64.2) (f64.2 f64.2) :cost 3 :encoding :sse :associative t)
   (two-arg-f64.2+    #:addpd      (f64.2) (f64.2 f64.2) :cost 2 :encoding :sse :associative t)
   (two-arg-f64.2-    #:subpd      (f64.2) (f64.2 f64.2) :cost 2 :encoding :sse)
   (two-arg-f64.2*    #:mulpd      (f64.2) (f64.2 f64.2) :cost 2 :encoding :sse :associative t)
   (two-arg-f64.2/    #:divpd      (f64.2) (f64.2 f64.2) :cost 8 :encoding :sse)
   (two-arg-f64.2=    #:cmppd      (u64.2) (f64.2 f64.2) :cost 4 :encoding :sse :prefix '(:eq) :associative t)
   (two-arg-f64.2/=   #:cmppd      (u64.2) (f64.2 f64.2) :cost 4 :encoding :sse :prefix '(:neq) :associative t)
   (two-arg-f64.2<    #:cmppd      (u64.2) (f64.2 f64.2) :cost 4 :encoding :sse :prefix '(:lt))
   (two-arg-f64.2<=   #:cmppd      (u64.2) (f64.2 f64.2) :cost 4 :encoding :sse :prefix '(:le))
   (two-arg-f64.2>    #:cmppd      (u64.2) (f64.2 f64.2) :cost 4 :encoding :sse :prefix '(:nle))
   (two-arg-f64.2>=   #:cmppd      (u64.2) (f64.2 f64.2) :cost 4 :encoding :sse :prefix '(:nlt))
   (f64.2-horizontal-and nil       (f64)   (f64.2)       :cost 3 :encoding :fake-vop)
   (f64.2-horizontal-or  nil       (f64)   (f64.2)       :cost 3 :encoding :fake-vop)
   (f64.2-horizontal-xor nil       (f64)   (f64.2)       :cost 3 :encoding :fake-vop)
   (f64.2-horizontal-max nil       (f64)   (f64.2)       :cost 3 :encoding :fake-vop)
   (f64.2-horizontal-min nil       (f64)   (f64.2)       :cost 3 :encoding :fake-vop)
   (f64.2-horizontal+    nil       (f64)   (f64.2)       :cost 3 :encoding :fake-vop)
   (f64.2-horizontal*    nil       (f64)   (f64.2)       :cost 3 :encoding :fake-vop)
   (f64.2-andc1       #:andnpd     (f64.2) (f64.2 f64.2) :cost 1 :encoding :sse)
   (f64.2-not         nil          (f64.2) (f64.2)       :cost 1 :encoding :fake-vop)
   (f64.2-sqrt        #:sqrtpd     (f64.2) (f64.2)       :cost 20)
   (f64.2-unpackhi    #:unpckhpd   (f64.2) (f64.2 f64.2) :cost 1 :encoding :sse)
   (f64.2-unpacklo    #:unpcklpd   (f64.2) (f64.2 f64.2) :cost 1 :encoding :sse)
   (f64.2-shuffle     #:shufpd     (f64.2) (f64.2 imm2)  :cost 1)
   (f64.2-movemask    #:movmskpd   (u2)    (f64.2)       :cost 1)
   ;; u8.16
   (u8.16!-from-u8    #:movq       (u8.16) (u8)          :cost 1)
   (u8.16!-from-p128  #:movdqu     (u8.16) (p128)        :cost 1 :encoding :move :always-translatable nil)
   (make-u8.16        nil          (u8.16) (u8 u8 u8 u8 u8 u8 u8 u8 u8 u8 u8 u8 u8 u8 u8 u8) :cost 1 :encoding :fake-vop)
   (u8.16-values      nil          (u8 u8 u8 u8 u8 u8 u8 u8 u8 u8 u8 u8 u8 u8 u8 u8) (u8.16) :cost 1 :encoding :fake-vop)
   (u8.16-broadcast   nil          (u8.16) (u8)          :cost 1 :encoding :fake-vop)
   (two-arg-u8.16-and #:pand       (u8.16) (u8.16 u8.16) :cost 1 :encoding :sse :associative t)
   (two-arg-u8.16-or  #:por        (u8.16) (u8.16 u8.16) :cost 1 :encoding :sse :associative t)
   (two-arg-u8.16-xor #:pxor       (u8.16) (u8.16 u8.16) :cost 1 :encoding :sse :associative t)
   (u8.16-andc1       #:pandn      (u8.16) (u8.16 u8.16) :cost 1 :encoding :sse)
   (u8.16-not         nil          (u8.16) (u8.16)       :cost 1 :encoding :fake-vop)
   (two-arg-u8.16+    #:paddb      (u8.16) (u8.16 u8.16) :cost 2 :encoding :sse :associative t)
   (two-arg-u8.16-    #:psubb      (u8.16) (u8.16 u8.16) :cost 2 :encoding :sse)
   (two-arg-u8.16=    #:pcmpeqb    (u8.16) (u8.16 u8.16) :cost 1 :encoding :sse)
   (two-arg-u8.16/=   nil          (u8.16) (u8.16 u8.16) :cost 2 :associative t :encoding :fake-vop)
   (two-arg-u8.16>~   #:pcmpgtb    (u8.16) (u8.16 u8.16) :cost 1 :encoding :sse)
   (two-arg-u8.16>    nil          (u8.16) (u8.16 u8.16) :cost 1 :encoding :fake-vop)
   (two-arg-u8.16<    nil          (u8.16) (u8.16 u8.16) :cost 1 :encoding :fake-vop)
   (two-arg-u8.16>=   nil          (u8.16) (u8.16 u8.16) :cost 2 :encoding :fake-vop)
   (two-arg-u8.16<=   nil          (u8.16) (u8.16 u8.16) :cost 2 :encoding :fake-vop)
   (u8.16-average     #:pavgw      (u8.16) (u8.16 u8.16) :cost 1 :encoding :sse)
   (u8.16-unpackhi    #:punpckhbw  (u8.16) (u8.16 u8.16) :cost 1 :encoding :sse)
   (u8.16-unpacklo    #:punpcklbw  (u8.16) (u8.16 u8.16) :cost 1 :encoding :sse)
   (u8.16-movemask    #:pmovmskb   (u16)   (u8.16)       :cost 1)
   ;; u16.8
   (u16.8!-from-u16   #:movq       (u16.8) (u16)         :cost 1)
   (u16.8!-from-p128  #:movdqu     (u16.8) (p128)        :cost 1 :encoding :move :always-translatable nil)
   (make-u16.8        nil          (u16.8) (u16 u16 u16 u16 u16 u16 u16 u16) :cost 1 :encoding :fake-vop)
   (u16.8-values      nil          (u16 u16 u16 u16 u16 u16 u16 u16) (u16.8) :cost 1 :encoding :fake-vop)
   (u16.8-broadcast   nil          (u16.8) (u16)         :cost 1 :encoding :fake-vop)
   (two-arg-u16.8-and #:pand       (u16.8) (u16.8 u16.8) :cost 1 :encoding :sse :associative t)
   (two-arg-u16.8-or  #:por        (u16.8) (u16.8 u16.8) :cost 1 :encoding :sse :associative t)
   (two-arg-u16.8-xor #:pxor       (u16.8) (u16.8 u16.8) :cost 1 :encoding :sse :associative t)
   (u16.8-andc1       #:pandn      (u16.8) (u16.8 u16.8) :cost 1 :encoding :sse)
   (u16.8-not         nil          (u16.8) (u16.8)       :cost 1 :encoding :fake-vop)
   (two-arg-u16.8+    #:paddw      (u16.8) (u16.8 u16.8) :cost 2 :encoding :sse :associative t)
   (two-arg-u16.8-    #:psubw      (u16.8) (u16.8 u16.8) :cost 2 :encoding :sse)
   (two-arg-u16.8=    #:pcmpeqw    (u16.8) (u16.8 u16.8) :cost 1 :encoding :sse)
   (two-arg-u16.8/=   nil          (u16.8) (u16.8 u16.8) :cost 2 :associative t :encoding :fake-vop)
   (two-arg-u16.8>~   #:pcmpgtw    (u16.8) (u16.8 u16.8) :cost 1 :encoding :sse)
   (two-arg-u16.8>    nil          (u16.8) (u16.8 u16.8) :cost 1 :encoding :fake-vop)
   (two-arg-u16.8<    nil          (u16.8) (u16.8 u16.8) :cost 1 :encoding :fake-vop)
   (two-arg-u16.8>=   nil          (u16.8) (u16.8 u16.8) :cost 2 :encoding :fake-vop)
   (two-arg-u16.8<=   nil          (u16.8) (u16.8 u16.8) :cost 2 :encoding :fake-vop)
   (u16.8-average     #:pavgb      (u16.8) (u16.8 u16.8) :cost 1 :encoding :sse)
   (u16.8-unpackhi    #:punpckhwd  (u16.8) (u16.8 u16.8) :cost 1 :encoding :sse)
   (u16.8-unpacklo    #:punpcklwd  (u16.8) (u16.8 u16.8) :cost 1 :encoding :sse)
   (u16.8-movemask    nil          (u8)    (u16.8)       :cost 1 :encoding :fake-vop)
   (u16.8-elt         #:pextrw     (u16)   (u16.8 imm3)  :cost 1)
   (u16.8-shufflehi   #:pshufhw    (u16.8) (u16.8 imm8)  :cost 1)
   (u16.8-shufflelo   #:pshuflw    (u16.8) (u16.8 imm8)  :cost 1)
   (u16.8-shiftl      #:psllw-imm  (u16.8) (u16.8 imm4)  :cost 1 :encoding :sse)
   (u16.8-shiftr      #:psrlw-imm  (u16.8) (u16.8 imm4)  :cost 1 :encoding :sse)
   ;; u32.4
   (u32.4!-from-u32   #:movq       (u32.4) (u16)         :cost 1)
   (u32.4!-from-p128  #:movdqu     (u32.4) (p128)        :cost 1 :encoding :move :always-translatable nil)
   (make-u32.4        nil          (u32.4) (u32 u32 u32 u32) :cost 1 :encoding :fake-vop)
   (u32.4-values      nil          (u32 u32 u32 u32) (u32.4) :cost 1 :encoding :fake-vop)
   (u32.4-broadcast   nil          (u32.4) (u32)         :cost 1 :encoding :fake-vop)
   (two-arg-u32.4-and #:pand       (u32.4) (u32.4 u32.4) :cost 1 :encoding :sse :associative t)
   (two-arg-u32.4-or  #:por        (u32.4) (u32.4 u32.4) :cost 1 :encoding :sse :associative t)
   (two-arg-u32.4-xor #:pxor       (u32.4) (u32.4 u32.4) :cost 1 :encoding :sse :associative t)
   (u32.4-andc1       #:pandn      (u32.4) (u32.4 u32.4) :cost 1 :encoding :sse)
   (u32.4-not         nil          (u32.4) (u32.4)       :cost 1 :encoding :fake-vop)
   (two-arg-u32.4+    #:paddd      (u32.4) (u32.4 u32.4) :cost 2 :encoding :sse :associative t)
   (two-arg-u32.4-    #:psubd      (u32.4) (u32.4 u32.4) :cost 2 :encoding :sse)
   (two-arg-u32.4=    #:pcmpeqd    (u32.4) (u32.4 u32.4) :cost 1 :encoding :sse)
   (two-arg-u32.4/=   nil          (u32.4) (u32.4 u32.4) :cost 2 :associative t :encoding :fake-vop)
   (two-arg-u32.4>~   #:pcmpgtd    (u32.4) (u32.4 u32.4) :cost 1 :encoding :sse)
   (two-arg-u32.4>    nil          (u32.4) (u32.4 u32.4) :cost 1 :encoding :fake-vop)
   (two-arg-u32.4<    nil          (u32.4) (u32.4 u32.4) :cost 1 :encoding :fake-vop)
   (two-arg-u32.4>=   nil          (u32.4) (u32.4 u32.4) :cost 2 :encoding :fake-vop)
   (two-arg-u32.4<=   nil          (u32.4) (u32.4 u32.4) :cost 2 :encoding :fake-vop)
   (u32.4-unpackhi    #:punpckhdq  (u32.4) (u32.4 u32.4) :cost 1 :encoding :sse)
   (u32.4-unpacklo    #:punpckldq  (u32.4) (u32.4 u32.4) :cost 1 :encoding :sse)
   (u32.4-movemask    #:movmskps   (u4)    (u32.4)       :cost 1)
   (u32.4-shuffle     #:pshufd     (u32.4) (u32.4 imm8)  :cost 1)
   (u32.4-shiftl      #:pslld-imm  (u32.4) (u32.4 imm5)  :cost 1 :encoding :sse)
   (u32.4-shiftr      #:psrld-imm  (u32.4) (u32.4 imm5)  :cost 1 :encoding :sse)
   ;; u64.2
   (u64.2!-from-u64   #:movq       (u64.2) (u64)         :cost 1)
   (u64.2!-from-p128  #:movdqu     (u64.2) (p128)        :cost 1 :encoding :move :always-translatable nil)
   (make-u64.2        nil          (u64.2) (u64 u64)     :cost 1 :encoding :fake-vop)
   (u64.2-values      nil          (u64 u64) (u64.2)     :cost 1 :encoding :fake-vop)
   (u64.2-broadcast   nil          (u64.2) (u64)         :cost 1 :encoding :fake-vop)
   (two-arg-u64.2-and #:pand       (u64.2) (u64.2 u64.2) :cost 1 :encoding :sse :associative t)
   (two-arg-u64.2-or  #:por        (u64.2) (u64.2 u64.2) :cost 1 :encoding :sse :associative t)
   (two-arg-u64.2-xor #:pxor       (u64.2) (u64.2 u64.2) :cost 1 :encoding :sse :associative t)
   (u64.2-andc1       #:pandn      (u64.2) (u64.2 u64.2) :cost 1 :encoding :sse)
   (u64.2-not         nil          (u64.2) (u64.2)       :cost 1 :encoding :fake-vop)
   (two-arg-u64.2+    #:paddq      (u64.2) (u64.2 u64.2) :cost 2 :encoding :sse :associative t)
   (two-arg-u64.2-    #:psubq      (u64.2) (u64.2 u64.2) :cost 2 :encoding :sse)
   (u64.2-unpackhi    #:punpckhqdq (u64.2) (u64.2 u64.2) :cost 1 :encoding :sse)
   (u64.2-unpacklo    #:punpcklqdq (u64.2) (u64.2 u64.2) :cost 1 :encoding :sse)
   (u64.2-movemask    #:movmskpd   (u2)    (u64.2)       :cost 1)
   (u64.2-shiftl      #:psllq-imm  (u64.2) (u64.2 imm6)  :cost 1 :encoding :sse)
   (u64.2-shiftr      #:psrlq-imm  (u64.2) (u64.2 imm6)  :cost 1 :encoding :sse)
   ;; s8.16
   (s8.16!-from-s8    nil          (s8.16) (s8)          :cost 1 :encoding :fake-vop)
   (s8.16!-from-p128  #:movdqu     (s8.16) (p128)        :cost 1 :encoding :move :always-translatable nil)
   (make-s8.16        nil          (s8.16) (s8 s8 s8 s8 s8 s8 s8 s8 s8 s8 s8 s8 s8 s8 s8 s8) :cost 1 :encoding :fake-vop)
   (s8.16-values      nil          (s8 s8 s8 s8 s8 s8 s8 s8 s8 s8 s8 s8 s8 s8 s8 s8) (s8.16) :cost 1 :encoding :fake-vop)
   (s8.16-broadcast   nil          (s8.16) (s8)          :cost 1 :encoding :fake-vop)
   (two-arg-s8.16-and #:pand       (s8.16) (s8.16 s8.16) :cost 1 :encoding :sse :associative t)
   (two-arg-s8.16-or  #:por        (s8.16) (s8.16 s8.16) :cost 1 :encoding :sse :associative t)
   (two-arg-s8.16-xor #:pxor       (s8.16) (s8.16 s8.16) :cost 1 :encoding :sse :associative t)
   (s8.16-andc1       #:pandn      (s8.16) (s8.16 s8.16) :cost 1 :encoding :sse)
   (s8.16-not         nil          (s8.16) (s8.16)       :cost 1 :encoding :fake-vop)
   (two-arg-s8.16+    #:paddb      (s8.16) (s8.16 s8.16) :cost 2 :encoding :sse :associative t)
   (two-arg-s8.16-    #:psubb      (s8.16) (s8.16 s8.16) :cost 2 :encoding :sse)
   (two-arg-s8.16=    #:pcmpeqb    (u8.16) (s8.16 s8.16) :cost 1 :encoding :sse)
   (two-arg-s8.16/=   nil          (u8.16) (s8.16 s8.16) :cost 2 :associative t :encoding :fake-vop)
   (two-arg-s8.16>    #:pcmpgtb    (u8.16) (s8.16 s8.16) :cost 1 :encoding :sse)
   (two-arg-s8.16<    nil          (u8.16) (s8.16 s8.16) :cost 1 :encoding :fake-vop)
   (two-arg-s8.16>=   nil          (u8.16) (s8.16 s8.16) :cost 2 :encoding :fake-vop)
   (two-arg-s8.16<=   nil          (u8.16) (s8.16 s8.16) :cost 2 :encoding :fake-vop)
   (s8.16-unpackhi    #:punpckhbw  (s8.16) (s8.16 s8.16) :cost 1 :encoding :sse)
   (s8.16-unpacklo    #:punpcklbw  (s8.16) (s8.16 s8.16) :cost 1 :encoding :sse)
   (s8.16-movemask    #:pmovmskb   (u16)   (s8.16)       :cost 1)
   ;; s16.8
   (s16.8!-from-s16   nil          (s16.8) (s16)         :cost 1 :encoding :fake-vop)
   (s16.8!-from-p128  #:movdqu     (s16.8) (p128)        :cost 1 :encoding :move :always-translatable nil)
   (make-s16.8        nil          (s16.8) (s16 s16 s16 s16 s16 s16 s16 s16) :cost 1 :encoding :fake-vop)
   (s16.8-values      nil          (s16 s16 s16 s16 s16 s16 s16 s16) (s16.8) :cost 1 :encoding :fake-vop)
   (s16.8-broadcast   nil          (s16.8) (s16)         :cost 1 :encoding :fake-vop)
   (two-arg-s16.8-and #:pand       (s16.8) (s16.8 s16.8) :cost 1 :encoding :sse :associative t)
   (two-arg-s16.8-or  #:por        (s16.8) (s16.8 s16.8) :cost 1 :encoding :sse :associative t)
   (two-arg-s16.8-xor #:pxor       (s16.8) (s16.8 s16.8) :cost 1 :encoding :sse :associative t)
   (s16.8-andc1       #:pandn      (s16.8) (s16.8 s16.8) :cost 1 :encoding :sse)
   (s16.8-not         nil          (s16.8) (s16.8)       :cost 1 :encoding :fake-vop)
   (two-arg-s16.8+    #:paddw      (s16.8) (s16.8 s16.8) :cost 2 :encoding :sse :associative t)
   (two-arg-s16.8-    #:psubw      (s16.8) (s16.8 s16.8) :cost 2 :encoding :sse)
   (two-arg-s16.8=    #:pcmpeqw    (u16.8) (s16.8 s16.8) :cost 1 :encoding :sse)
   (two-arg-s16.8/=   nil          (u16.8) (s16.8 s16.8) :cost 2 :associative t :encoding :fake-vop)
   (two-arg-s16.8>    #:pcmpgtw    (u16.8) (s16.8 s16.8) :cost 1 :encoding :sse)
   (two-arg-s16.8<    nil          (u16.8) (s16.8 s16.8) :cost 1 :encoding :fake-vop)
   (two-arg-s16.8>=   nil          (u16.8) (s16.8 s16.8) :cost 2 :encoding :fake-vop)
   (two-arg-s16.8<=   nil          (u16.8) (s16.8 s16.8) :cost 2 :encoding :fake-vop)
   (s16.8-unpackhi    #:punpckhwd  (s16.8) (s16.8 s16.8) :cost 1 :encoding :sse)
   (s16.8-unpacklo    #:punpcklwd  (s16.8) (s16.8 s16.8) :cost 1 :encoding :sse)
   (s16.8-movemask    nil          (u8)    (s16.8)       :cost 1 :encoding :fake-vop)
   (s16.8-mullo       #:pmullw     (s16.8) (s16.8 s16.8) :cost 1 :encoding :sse)
   (s16.8-elt         #:pextrw     (s16)   (s16.8 imm3)  :cost 1)
   (s16.8-shufflehi   #:pshufhw    (s16.8) (s16.8 imm8)  :cost 1)
   (s16.8-shufflelo   #:pshuflw    (s16.8) (s16.8 imm8)  :cost 1)
   (s16.8-shiftl      #:psllw-imm  (s16.8) (s16.8 imm4)  :cost 1 :encoding :sse)
   (s16.8-shiftr      #:psrlw-imm  (s16.8) (s16.8 imm4)  :cost 1 :encoding :sse)
   ;; s32.4
   (s32.4!-from-s32   nil          (s32.4) (s32)         :cost 1 :encoding :fake-vop)
   (s32.4!-from-p128  #:movdqu     (s32.4) (p128)        :cost 1 :encoding :move :always-translatable nil)
   (make-s32.4        nil          (s32.4) (s32 s32 s32 s32) :cost 1 :encoding :fake-vop)
   (s32.4-values      nil          (s32 s32 s32 s32) (s32.4) :cost 1 :encoding :fake-vop)
   (s32.4-broadcast   nil          (s32.4) (s32)         :cost 1 :encoding :fake-vop)
   (s32.4-from-f32.4  #:cvtps2dq   (s32.4) (f32.4)       :cost 5)
   (s32.4-from-f64.2  #:cvtpd2dq   (s32.4) (f64.2)       :cost 1)
   (two-arg-s32.4-and #:pand       (s32.4) (s32.4 s32.4) :cost 1 :encoding :sse :associative t)
   (two-arg-s32.4-or  #:por        (s32.4) (s32.4 s32.4) :cost 1 :encoding :sse :associative t)
   (two-arg-s32.4-xor #:pxor       (s32.4) (s32.4 s32.4) :cost 1 :encoding :sse :associative t)
   (s32.4-andc1       #:pandn      (s32.4) (s32.4 s32.4) :cost 1 :encoding :sse)
   (s32.4-not         nil          (s32.4) (s32.4)       :cost 1 :encoding :fake-vop)
   (two-arg-s32.4+    #:paddd      (s32.4) (s32.4 s32.4) :cost 2 :encoding :sse :associative t)
   (two-arg-s32.4-    #:psubd      (s32.4) (s32.4 s32.4) :cost 2 :encoding :sse)
   (two-arg-s32.4=    #:pcmpeqd    (u32.4) (s32.4 s32.4) :cost 1 :encoding :sse)
   (two-arg-s32.4/=   nil          (u32.4) (s32.4 s32.4) :cost 2 :associative t :encoding :fake-vop)
   (two-arg-s32.4>    #:pcmpgtd    (u32.4) (s32.4 s32.4) :cost 1 :encoding :sse)
   (two-arg-s32.4<    nil          (u32.4) (s32.4 s32.4) :cost 1 :encoding :fake-vop)
   (two-arg-s32.4>=   nil          (u32.4) (s32.4 s32.4) :cost 2 :encoding :fake-vop)
   (two-arg-s32.4<=   nil          (u32.4) (s32.4 s32.4) :cost 2 :encoding :fake-vop)
   (s32.4-unpackhi    #:punpckhdq  (s32.4) (s32.4 s32.4) :cost 1 :encoding :sse)
   (s32.4-unpacklo    #:punpckldq  (s32.4) (s32.4 s32.4) :cost 1 :encoding :sse)
   (s32.4-movemask    #:movmskps   (u4)    (s32.4)       :cost 1)
   (s32.4-shuffle     #:pshufd     (s32.4) (s32.4 imm8)  :cost 1)
   (s32.4-shiftl      #:pslld-imm  (s32.4) (s32.4 imm5)  :cost 1 :encoding :sse)
   (s32.4-shiftr      #:psrld-imm  (s32.4) (s32.4 imm5)  :cost 1 :encoding :sse)
   ;; s64.2
   (s64.2!-from-s64   nil          (s64.2) (s64)         :cost 1 :encoding :fake-vop)
   (s64.2!-from-p128  #:movdqu     (s64.2) (p128)        :cost 1 :encoding :move :always-translatable nil)
   (make-s64.2        nil          (s64.2) (s64 s64)     :cost 1 :encoding :fake-vop)
   (s64.2-values      nil          (s64 s64) (s64.2)     :cost 1 :encoding :fake-vop)
   (s64.2-broadcast   nil          (s64.2) (s64)         :cost 1 :encoding :fake-vop)
   (two-arg-s64.2-and #:pand       (s64.2) (s64.2 s64.2) :cost 1 :encoding :sse :associative t)
   (two-arg-s64.2-or  #:por        (s64.2) (s64.2 s64.2) :cost 1 :encoding :sse :associative t)
   (two-arg-s64.2-xor #:pxor       (s64.2) (s64.2 s64.2) :cost 1 :encoding :sse :associative t)
   (s64.2-andc1       #:pandn      (s64.2) (s64.2 s64.2) :cost 1 :encoding :sse)
   (s64.2-not         nil          (s64.2) (s64.2)       :cost 1 :encoding :fake-vop)
   (two-arg-s64.2+    #:paddq      (s64.2) (s64.2 s64.2) :cost 2 :encoding :sse :associative t)
   (two-arg-s64.2-    #:psubq      (s64.2) (s64.2 s64.2) :cost 2 :encoding :sse)
   (s64.2-unpackhi    #:punpckhqdq (s64.2) (s64.2 s64.2) :cost 1 :encoding :sse)
   (s64.2-unpacklo    #:punpcklqdq (s64.2) (s64.2 s64.2) :cost 1 :encoding :sse)
   (s64.2-movemask    #:movmskpd   (u2)    (s64.2)       :cost 1)
   (s64.2-shiftl      #:psllq-imm  (s64.2) (s64.2 imm6)  :cost 1 :encoding :sse)
   (s64.2-shiftr      #:psrlq-imm  (s64.2) (s64.2 imm6)  :cost 1 :encoding :sse))
  (:loads
   (u32.4-load-from-string #:movdqu u32.4 charvec char-array u32.4-string-ref u32.4-row-major-string-ref)
   (f64-load   #:movsd  f64   f64vec f64-array f64-aref   f64-row-major-aref)
   (f64.2-load #:movupd f64.2 f64vec f64-array f64.2-aref f64.2-row-major-aref)
   (u8.16-load #:movdqu u8.16  u8vec  u8-array u8.16-aref u8.16-row-major-aref)
   (u16.8-load #:movdqu u16.8 u16vec u16-array u16.8-aref u16.8-row-major-aref)
   (u32.4-load #:movdqu u32.4 u32vec u32-array u32.4-aref u32.4-row-major-aref)
   (u64.2-load #:movdqu u64.2 u64vec u64-array u64.2-aref u64.2-row-major-aref)
   (s8.16-load #:movdqu s8.16  s8vec  s8-array s8.16-aref s8.16-row-major-aref)
   (s16.8-load #:movdqu s16.8 s16vec s16-array s16.8-aref s16.8-row-major-aref)
   (s32.4-load #:movdqu s32.4 s32vec s32-array s32.4-aref s32.4-row-major-aref)
   (s64.2-load #:movdqu s64.2 s64vec s64-array s64.2-aref s64.2-row-major-aref))
  (:stores
   (u32.4-store-into-string #:movdqu u32.4 charvec char-array u32.4-string-ref u32.4-row-major-string-ref)
   (f64-store   #:movsd  f64   f64vec f64-array f64-aref   f64-row-major-aref)
   (f64.2-store #:movupd f64.2 f64vec f64-array f64.2-aref f64.2-row-major-aref)
   (u8.16-store #:movdqu u8.16  u8vec  u8-array u8.16-aref u8.16-row-major-aref)
   (u16.8-store #:movdqu u16.8 u16vec u16-array u16.8-aref u16.8-row-major-aref)
   (u32.4-store #:movdqu u32.4 u32vec u32-array u32.4-aref u32.4-row-major-aref)
   (u64.2-store #:movdqu u64.2 u64vec u64-array u64.2-aref u64.2-row-major-aref)
   (s8.16-store #:movdqu s8.16  s8vec  s8-array s8.16-aref s8.16-row-major-aref)
   (s16.8-store #:movdqu s16.8 s16vec s16-array s16.8-aref s16.8-row-major-aref)
   (s32.4-store #:movdqu s32.4 s32vec s32-array s32.4-aref s32.4-row-major-aref)
   (s64.2-store #:movdqu s64.2 s64vec s64-array s64.2-aref s64.2-row-major-aref)
   (f64.2-ntstore #:movntpd f64.2 f64vec f64-array f64.2-non-temporal-aref f64.2-non-temporal-row-major-aref)
   (u8.16-ntstore #:movntdq u8.16  u8vec  u8-array u8.16-non-temporal-aref u8.16-non-temporal-row-major-aref)
   (u16.8-ntstore #:movntdq u16.8 u16vec u16-array u16.8-non-temporal-aref u16.8-non-temporal-row-major-aref)
   (u32.4-ntstore #:movntdq u32.4 u32vec u32-array u32.4-non-temporal-aref u32.4-non-temporal-row-major-aref)
   (u64.2-ntstore #:movntdq u64.2 u64vec u64-array u64.2-non-temporal-aref u64.2-non-temporal-row-major-aref)
   (s8.16-ntstore #:movntdq s8.16  s8vec  s8-array s8.16-non-temporal-aref s8.16-non-temporal-row-major-aref)
   (s16.8-ntstore #:movntdq s16.8 s16vec s16-array s16.8-non-temporal-aref s16.8-non-temporal-row-major-aref)
   (s32.4-ntstore #:movntdq s32.4 s32vec s32-array s32.4-non-temporal-aref s32.4-non-temporal-row-major-aref)
   (s64.2-ntstore #:movntdq s64.2 s64vec s64-array s64.2-non-temporal-aref s64.2-non-temporal-row-major-aref))
  (:associatives
   (f64-and two-arg-f64-and +f64-true+)
   (f64-or  two-arg-f64-or  +f64-false+)
   (f64-xor two-arg-f64-xor +f64-false+)
   (f64-max two-arg-f64-max nil)
   (f64-min two-arg-f64-min nil)
   (f64+    two-arg-f64+ 0d0)
   (f64*    two-arg-f64* 1d0)
   (f64.2-and two-arg-f64.2-and +f64-true+)
   (f64.2-or  two-arg-f64.2-or  +f64-false+)
   (f64.2-xor two-arg-f64.2-xor +f64-false+)
   (f64.2-max two-arg-f64.2-max nil)
   (f64.2-min two-arg-f64.2-min nil)
   (f64.2+    two-arg-f64.2+ 0d0)
   (f64.2*    two-arg-f64.2* 1d0)
   (u8.16-and two-arg-u8.16-and +u8-true+)
   (u8.16-or  two-arg-u8.16-or  +u8-false+)
   (u8.16-xor two-arg-u8.16-xor +u8-false+)
   (u8.16+    two-arg-u8.16+    0)
   (u16.8-and two-arg-u16.8-and +u16-true+)
   (u16.8-or  two-arg-u16.8-or  +u16-false+)
   (u16.8-xor two-arg-u16.8-xor +u16-false+)
   (u16.8+    two-arg-u16.8+    0)
   (u32.4-and two-arg-u32.4-and +u32-true+)
   (u32.4-or  two-arg-u32.4-or  +u32-false+)
   (u32.4-xor two-arg-u32.4-xor +u32-false+)
   (u32.4+    two-arg-u32.4+    0)
   (u64.2-and two-arg-u64.2-and +u64-true+)
   (u64.2-or  two-arg-u64.2-or  +u64-false+)
   (u64.2-xor two-arg-u64.2-xor +u64-false+)
   (u64.2+    two-arg-u64.2+    0)
   (s8.16-and two-arg-s8.16-and +s8-true+)
   (s8.16-or  two-arg-s8.16-or  +s8-false+)
   (s8.16-xor two-arg-s8.16-xor +s8-false+)
   (s8.16+    two-arg-s8.16+    0)
   (s16.8-and two-arg-s16.8-and +s16-true+)
   (s16.8-or  two-arg-s16.8-or  +s16-false+)
   (s16.8-xor two-arg-s16.8-xor +s16-false+)
   (s16.8+    two-arg-s16.8+    0)
   (s32.4-and two-arg-s32.4-and +s32-true+)
   (s32.4-or  two-arg-s32.4-or  +s32-false+)
   (s32.4-xor two-arg-s32.4-xor +s32-false+)
   (s32.4+    two-arg-s32.4+    0)
   (s64.2-and two-arg-s64.2-and +s64-true+)
   (s64.2-or  two-arg-s64.2-or  +s64-false+)
   (s64.2-xor two-arg-s64.2-xor +s64-false+)
   (s64.2+    two-arg-s64.2+    0))
  (:comparisons
   (f64=  two-arg-f64=  u64-and +u64-true+)
   (f64<  two-arg-f64<  u64-and +u64-true+)
   (f64<= two-arg-f64<= u64-and +u64-true+)
   (f64>  two-arg-f64>  u64-and +u64-true+)
   (f64>= two-arg-f64>= u64-and +u64-true+)
   (f32.4=  two-arg-f32.4=  u32.4-and +u32-true+)
   (f32.4<  two-arg-f32.4<  u32.4-and +u32-true+)
   (f32.4<= two-arg-f32.4<= u32.4-and +u32-true+)
   (f32.4>  two-arg-f32.4>  u32.4-and +u32-true+)
   (f32.4>= two-arg-f32.4>= u32.4-and +u32-true+)
   (f64.2=  two-arg-f64.2=  u64.2-and +u64-true+)
   (f64.2<  two-arg-f64.2<  u64.2-and +u64-true+)
   (f64.2<= two-arg-f64.2<= u64.2-and +u64-true+)
   (f64.2>  two-arg-f64.2>  u64.2-and +u64-true+)
   (f64.2>= two-arg-f64.2>= u64.2-and +u64-true+)
   (u8.16=  two-arg-u8.16=  u8.16-and +u8-true+)
   (u8.16<  two-arg-u8.16<  u8.16-and +u8-true+)
   (u8.16<= two-arg-u8.16<= u8.16-and +u8-true+)
   (u8.16>  two-arg-u8.16>  u8.16-and +u8-true+)
   (u8.16>= two-arg-u8.16>= u8.16-and +u8-true+)
   (u16.8=  two-arg-u16.8=  u16.8-and +u16-true+)
   (u16.8<  two-arg-u16.8<  u16.8-and +u16-true+)
   (u16.8<= two-arg-u16.8<= u16.8-and +u16-true+)
   (u16.8>  two-arg-u16.8>  u16.8-and +u16-true+)
   (u16.8>= two-arg-u16.8>= u16.8-and +u16-true+)
   (u32.4=  two-arg-u32.4=  u32.4-and +u32-true+)
   (u32.4<  two-arg-u32.4<  u32.4-and +u32-true+)
   (u32.4<= two-arg-u32.4<= u32.4-and +u32-true+)
   (u32.4>  two-arg-u32.4>  u32.4-and +u32-true+)
   (u32.4>= two-arg-u32.4>= u32.4-and +u32-true+)
   (s8.16=  two-arg-s8.16=  u8.16-and +u8-true+)
   (s8.16<  two-arg-s8.16<  u8.16-and +u8-true+)
   (s8.16<= two-arg-s8.16<= u8.16-and +u8-true+)
   (s8.16>  two-arg-s8.16>  u8.16-and +u8-true+)
   (s8.16>= two-arg-s8.16>= u8.16-and +u8-true+)
   (s16.8=  two-arg-s16.8=  u16.8-and +u16-true+)
   (s16.8<  two-arg-s16.8<  u16.8-and +u16-true+)
   (s16.8<= two-arg-s16.8<= u16.8-and +u16-true+)
   (s16.8>  two-arg-s16.8>  u16.8-and +u16-true+)
   (s16.8>= two-arg-s16.8>= u16.8-and +u16-true+)
   (s32.4=  two-arg-s32.4=  u32.4-and +u32-true+)
   (s32.4<  two-arg-s32.4<  u32.4-and +u32-true+)
   (s32.4<= two-arg-s32.4<= u32.4-and +u32-true+)
   (s32.4>  two-arg-s32.4>  u32.4-and +u32-true+)
   (s32.4>= two-arg-s32.4>= u32.4-and +u32-true+))
  (:reducers
   (f64- two-arg-f64- 0d0)
   (f64/ two-arg-f64/ 1d0)
   (f64.2- two-arg-f64.2- 0d0)
   (f64.2/ two-arg-f64.2/ 1d0)
   (u8.16- two-arg-u8.16- 0)
   (u16.8- two-arg-u16.8- 0)
   (u32.4- two-arg-u32.4- 0)
   (u64.2- two-arg-u64.2- 0)
   (s8.16- two-arg-s8.16- 0)
   (s16.8- two-arg-s16.8- 0)
   (s32.4- two-arg-s32.4- 0)
   (s64.2- two-arg-s64.2- 0))
  (:unequals
   (f64/= two-arg-f64/= u64-and +u64-true+)
   (f32.4/= two-arg-f32.4/= sb-simd-sse2:u32.4-and +u32-true+)
   (f64.2/= two-arg-f64.2/= u64.2-and +u64-true+)
   (u8.16/= two-arg-u8.16/= u8.16-and +u8-true+)
   (u16.8/= two-arg-u16.8/= u16.8-and +u16-true+)
   (u32.4/= two-arg-u32.4/= u32.4-and +u32-true+)
   (s8.16/= two-arg-s8.16/= u8.16-and +u8-true+)
   (s16.8/= two-arg-s16.8/= u16.8-and +u16-true+)
   (s32.4/= two-arg-s32.4/= u32.4-and +u32-true+)))
