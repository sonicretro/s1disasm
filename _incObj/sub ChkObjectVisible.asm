; ---------------------------------------------------------------------------
; Subroutine to	check if an object is off screen

; output:
;	d0 = flag set if object is off screen
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ChkObjectVisible:
		move.w	obX(a0),d0	; get object x-position
		sub.w	(v_screenposx).w,d0 ; subtract screen x-position
		bmi.s	.offscreen
		cmpi.w	#320,d0		; is object on the screen?
		bge.s	.offscreen	; if not, branch

		move.w	obY(a0),d1	; get object y-position
		sub.w	(v_screenposy).w,d1 ; subtract screen y-position
		bmi.s	.offscreen
		cmpi.w	#224,d1		; is object on the screen?
		bge.s	.offscreen	; if not, branch

		moveq	#0,d0		; set flag to 0
		rts	

.offscreen:
		moveq	#1,d0		; set flag to 1
		rts	
; End of function ChkObjectVisible

; ---------------------------------------------------------------------------
; Subroutine to	check if an object is off screen
; More precise than above subroutine, taking width into account

; output:
;	d0 = flag set if object is off screen
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ChkPartiallyVisible:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		move.w	obX(a0),d0	; get object x-position
		sub.w	(v_screenposx).w,d0 ; subtract screen x-position
		add.w	d1,d0		; add object width
		bmi.s	.offscreen2
		add.w	d1,d1
		sub.w	d1,d0
		cmpi.w	#320,d0
		bge.s	.offscreen2

		move.w	obY(a0),d1
		sub.w	(v_screenposy).w,d1
		bmi.s	.offscreen2
		cmpi.w	#224,d1
		bge.s	.offscreen2

		moveq	#0,d0
		rts	

.offscreen2:
		moveq	#1,d0
		rts	
; End of function ChkPartiallyVisible
