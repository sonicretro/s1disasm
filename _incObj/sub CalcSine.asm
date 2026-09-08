; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine calculate a sine and cosine
; 
; input:
;	d0 = angle
; 
; output:
;	d0 = sine
;	d1 = cosine
; ---------------------------------------------------------------------------

CalcSine:
		andi.w	#$FF,d0					; clear upper input byte
		add.w	d0,d0					; multiply input for word-sized addressing
		addi.w	#$80,d0					; advance to cosine value index
		move.w	Sine_Data(pc,d0.w),d1			; get cosine value
		subi.w	#$80,d0					; go back sine value index
		move.w	Sine_Data(pc,d0.w),d0			; get sine value
		rts						; return
; End of function CalcSine

; ===========================================================================
; Precalculated Sinewave data. Do note that because two entries are $100,
; only reading a byte for the retrieved return value can result in those
; being interpreted as $00. It would be safer to change those values to $FF.

Sine_Data:
		dc.w    $0,  $6,  $C, $12, $19, $1F, $25, $2B	;          -=--
		dc.w   $31, $38, $3E, $44, $4A, $50, $56, $5C	;            -=--
		dc.w   $61, $67, $6D, $73, $78, $7E, $83, $88	;              -=-
		dc.w   $8E, $93, $98, $9D, $A2, $A7, $AB, $B0	;                -=
		dc.w   $B5, $B9, $BD, $C1, $C5, $C9, $CD, $D1	;                 -=
		dc.w   $D4, $D8, $DB, $DE, $E1, $E4, $E7, $EA	;                  =-
		dc.w   $EC, $EE, $F1, $F3, $F4, $F6, $F8, $F9	;                  -=
		dc.w   $FB, $FC, $FD, $FE, $FE, $FF, $FF, $FF	;                   =
		dc.w  $100, $FF, $FF, $FF, $FE, $FE, $FD, $FC	;                   =
		dc.w   $FB, $F9, $F8, $F6, $F4, $F3, $F1, $EE	;                  -=
		dc.w   $EC, $EA, $E7, $E4, $E1, $DE, $DB, $D8	;                  =-
		dc.w   $D4, $D1, $CD, $C9, $C5, $C1, $BD, $B9	;                 -=
		dc.w   $B5, $B0, $AB, $A7, $A2, $9D, $98, $93	;                -=
		dc.w   $8E, $88, $83, $7E, $78, $73, $6D, $67	;              -=-
		dc.w   $61, $5C, $56, $50, $4A, $44, $3E, $38	;            -=--
		dc.w   $31, $2B, $25, $1F, $19, $12,  $C,  $6	;          -=--
		dc.w    $0, -$6, -$C,-$12,-$19,-$1F,-$25,-$2B	;       --=-
		dc.w  -$31,-$38,-$3E,-$44,-$4A,-$50,-$56,-$5C	;     --=-
		dc.w  -$61,-$67,-$6D,-$75,-$78,-$7E,-$83,-$88	;    -=-
		dc.w  -$8E,-$93,-$98,-$9D,-$A2,-$A7,-$AB,-$B0	;   =-
		dc.w  -$B5,-$B9,-$BD,-$C1,-$C5,-$C9,-$CD,-$D1	;  =-
		dc.w  -$D4,-$D8,-$DB,-$DE,-$E1,-$E4,-$E7,-$EA	; -=
		dc.w  -$EC,-$EE,-$F1,-$F3,-$F4,-$F6,-$F8,-$F9	; =-
		dc.w  -$FB,-$FC,-$FD,-$FE,-$FE,-$FF,-$FF,-$FF	; =
		dc.w -$100,-$FF,-$FF,-$FF,-$FE,-$FE,-$FD,-$FC	; =
		dc.w  -$FB,-$F9,-$F8,-$F6,-$F4,-$F3,-$F1,-$EE	; =-
		dc.w  -$EC,-$EA,-$E7,-$E4,-$E1,-$DE,-$DB,-$D8	; -=
		dc.w  -$D4,-$D1,-$CD,-$C9,-$C5,-$C1,-$BD,-$B9	;  =-
		dc.w  -$B5,-$B0,-$AB,-$A7,-$A2,-$9D,-$98,-$93	;   =-
		dc.w  -$8E,-$88,-$83,-$7E,-$78,-$75,-$6D,-$67	;    -=-
		dc.w  -$61,-$5C,-$56,-$50,-$4A,-$44,-$3E,-$38	;     --=-
		dc.w  -$31,-$2B,-$25,-$1F,-$19,-$12, -$C, -$6	;       --=-

		; Repeat of the first 64 values in case of overflow
		dc.w    $0,  $6,  $C, $12, $19, $1F, $25, $2B	;          -=--
		dc.w   $31, $38, $3E, $44, $4A, $50, $56, $5C	;            -=--
		dc.w   $61, $67, $6D, $73, $78, $7E, $83, $88	;              -=-
		dc.w   $8E, $93, $98, $9D, $A2, $A7, $AB, $B0	;                -=
		dc.w   $B5, $B9, $BD, $C1, $C5, $C9, $CD, $D1	;                 -=
		dc.w   $D4, $D8, $DB, $DE, $E1, $E4, $E7, $EA	;                  =-
		dc.w   $EC, $EE, $F1, $F3, $F4, $F6, $F8, $F9	;                  -=
		dc.w   $FB, $FC, $FD, $FE, $FE, $FF, $FF, $FF	;                   =
		even
; ===========================================================================
