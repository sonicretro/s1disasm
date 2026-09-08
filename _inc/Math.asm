; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to generate a pseudo-random number in d0
; ---------------------------------------------------------------------------

RandomNumber:
		move.l	(v_random).w,d1				; load current pseudo random number
		bne.s	.scramble				; if it's not 0, branch
		move.l	#$2A6D365A,d1				; set initial/starting seed

.scramble:
		move.l	d1,d0					; copy to d0
		asl.l	#2,d1					; shift left two bits
		add.l	d0,d1					; add original to shifted
		asl.l	#3,d1					; shift left three more bits
		add.l	d0,d1					; add original again
		move.w	d1,d0					; load lower word of shifted to original
		swap	d1					; get upper word
		add.w	d1,d0					; add upper to lower
		move.w	d0,d1					; save back to d1
		swap	d1					; swap upper and lower back
		move.l	d1,(v_random).w				; save result for next time
		rts						; return (d0 contains pseudo-random number)
; End of function RandomNumber

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

	if (Revision=0)&(UnusedOptimization=0)
	; Only in REV00, and even there it was never used
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine calculate a square root (only available in REV00 and unused)
; 
; input:
;	d0 = number
; 
; output:
;	d0 = square root of number
; ---------------------------------------------------------------------------

CalcSqrt:
		movem.l	d1-d2,-(sp)				; store register data
		move.w	d0,d1					; copy input
		swap	d1					; send to upper word
		moveq	#0,d0					; clear lower word
		move.w	d0,d1					; ''
		moveq	#($10/2)-1,d2				; set elements to count ($10 bits, 2 each time)

.nextElement:
		rol.l	#2,d1					; send two bits down
		add.w	d0,d0					; shift current result left
		addq.w	#1,d0					; increase by 1
		sub.w	d0,d1					; subtract from current two bits
		bhs.s	.incrementRoot				; if current result is not larger than the input so far, branch
		add.w	d0,d1					; restore back to normal
		subq.w	#1,d0					; subtract 1 back again
		dbf	d2,.nextElement				; repeat for all elements

		lsr.w	#1,d0					; keep result in the lower 8 bits
		movem.l	(sp)+,d1-d2				; restore register data
		rts						; return
; ---------------------------------------------------------------------------

.incrementRoot:
		addq.w	#1,d0					; increase by 1 again
		dbf	d2,.nextElement				; repeat for all elements

		lsr.w	#1,d0					; keep result in the lower 8 bits
		movem.l	(sp)+,d1-d2				; restore register data
		rts						; return
; End of function CalcSqrt
	endif

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine calculate an arctangent of two input coordinates (i.e. the angle)
; 
; input:
;	d1 = x-axis distance
;	d2 = y-axis distance
; 
; output:
;	d0 = angle
; ---------------------------------------------------------------------------

CalcAngle:
		movem.l	d3-d4,-(sp)				; store register data
		moveq	#0,d3					; clear registers
		moveq	#0,d4					; ''
		move.w	d1,d3					; copy X and Y distances
		move.w	d2,d4					; ''
		or.w	d3,d4					; fuse X and Y together
		beq.s	CA_NullAngle				; if they're both 0, branch to finish with angle 40 right away
		move.w	d2,d4					; reload Y

		tst.w	d3					; check X polarity
		bpl.w	.posX					; if it's already positive, branch
		neg.w	d3					; convert to positive
.posX:
		tst.w	d4					; check Y polarity
		bpl.w	.posY					; if it's already positive, branch
		neg.w	d4					; convert to positive
.posY:
		cmp.w	d3,d4					; find out which one has a larger distance
		bhs.w	.yIsBigger				; if Y has a larger distance, branch

.xIsBigger:	; degrees 0 to 45
		lsl.l	#8,d4					; multiply Y by 100 (creating fraction space)
		divu.w	d3,d4					; divide by X distance
		moveq	#0,d0					; prepare 0 degree angle
		move.b	Angle_Data(pc,d4.w),d0			; load correct angle (advance up to correct angle 00 - 45 degrees)
		bra.s	.checkXFlip				; continue to 360 accommodation
; ===========================================================================

.yIsBigger:	; degrees 45 to 90
		lsl.l	#8,d3					; multiply X by 100 (creating fraction space)
		divu.w	d4,d3					; divide by Y distance
		moveq	#$40,d0					; prepare 90 degree angle
		sub.b	Angle_Data(pc,d3.w),d0			; load correct angle (subtract down to correct angle 90 - 45 degrees)

.checkXFlip:
		tst.w	d1					; check X distance
		bpl.w	.chkYFlip				; if distance were positive, branch to skip mirror
		neg.w	d0					; mirror angle
		addi.w	#$40*2,d0				; ''

.chkYFlip:
		tst.w	d2					; check Y distance
		bpl.w	.return					; if distance were positive, branch to skip flip
		neg.w	d0					; flip angle
		addi.w	#$40*4,d0				; ''

.return:
		movem.l	(sp)+,d3-d4				; restore register data
		rts						; return
; ===========================================================================

CA_NullAngle:
		move.w	#$40,d0					; force angle to $40 (90 degrees)
		movem.l	(sp)+,d3-d4				; restore register data
		rts						; return
; End of function CalcAngle

; ===========================================================================
; This data consists of 256 bytes to account for one 45 degree section of a circle.
; The other quadrants are retrieved by adding multiples of $40.
; The extra 257th byte at the end is for ratio X=Y when inputs are unequal 0.

Angle_Data:
		dc.b    0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  2,  2,  2,  2,  2,  2
		dc.b    3,  3,  3,  3,  3,  3,  3,  4,  4,  4,  4,  4,  4,  5,  5,  5
		dc.b    5,  5,  5,  6,  6,  6,  6,  6,  6,  6,  7,  7,  7,  7,  7,  7
		dc.b    8,  8,  8,  8,  8,  8,  8,  9,  9,  9,  9,  9,  9, $A, $A, $A
		dc.b   $A, $A, $A, $A, $B, $B, $B, $B, $B, $B, $B, $C, $C, $C, $C, $C
		dc.b   $C, $C, $D, $D, $D, $D, $D, $D, $D, $E, $E, $E, $E, $E, $E, $E
		dc.b   $F, $F, $F, $F, $F, $F, $F,$10,$10,$10,$10,$10,$10,$10,$11,$11
		dc.b  $11,$11,$11,$11,$11,$11,$12,$12,$12,$12,$12,$12,$12,$13,$13,$13
		dc.b  $13,$13,$13,$13,$13,$14,$14,$14,$14,$14,$14,$14,$14,$15,$15,$15
		dc.b  $15,$15,$15,$15,$15,$15,$16,$16,$16,$16,$16,$16,$16,$16,$17,$17
		dc.b  $17,$17,$17,$17,$17,$17,$17,$18,$18,$18,$18,$18,$18,$18,$18,$18
		dc.b  $19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$1A,$1A,$1A,$1A,$1A,$1A
		dc.b  $1A,$1A,$1A,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1C,$1C,$1C
		dc.b  $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D
		dc.b  $1D,$1D,$1D,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1F,$1F
		dc.b  $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$20,$20,$20,$20,$20,$20
		dc.b  $20
		even
; ===========================================================================
