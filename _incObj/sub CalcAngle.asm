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
