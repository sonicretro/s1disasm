; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to check if an object is off screen
;
; output:
;	d0 = 0 if on screen, 1 if off screen
; ---------------------------------------------------------------------------

ChkObjectVisible:
		move.w	obX(a0),d0				; get object x-position
		sub.w	(v_screenposx).w,d0			; subtract screen x-position
		bmi.s	.offscreen				; branch if object is off screen to the left
		cmpi.w	#320,d0					; is object on screen?
		bge.s	.offscreen				; if not, object is off screen to the right

		move.w	obY(a0),d1				; get object y-position
		sub.w	(v_screenposy).w,d1			; subtract screen y-position
		bmi.s	.offscreen				; branch if object is off screen to the top
		cmpi.w	#224,d1					; is object on screen?
		bge.s	.offscreen				; if not, object is off screen to the bottom

		moveq	#0,d0					; set Z-flag (object on screen)
		rts
; ---------------------------------------------------------------------------

.offscreen:
		moveq	#1,d0					; clear Z-flag (object off screen)
		rts
; End of function ChkObjectVisible


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to check if an object is off screen
; More precise than above subroutine, taking width into account
;
; output:
;	d0 = 0 if on screen, 1 if off screen
; ---------------------------------------------------------------------------

ChkPartiallyVisible:
		moveq	#0,d1					; clear d1 (obActWid is byte-sized)
		move.b	obActWid(a0),d1				; get object's display width
		move.w	obX(a0),d0				; get object x-position
		sub.w	(v_screenposx).w,d0			; subtract screen x-position
		add.w	d1,d0					; add object display width
		bmi.s	.offscreen				; branch if object is off screen to the left
		add.w	d1,d1					; double width for undoing above addition and right-side check
		sub.w	d1,d0					; sub object display width
		cmpi.w	#320,d0					; is object on screen?
		bge.s	.offscreen				; if not, object is off screen to the right

	if FixBugs
		; Fix partial visibility check for height, too
		moveq	#0,d1					; clear d1 (obHeight is byte-sized)
		move.b	obHeight(a0),d1				; get object's height
		move.w	obY(a0),d0				; get object's y-position
		sub.w	(v_screenposy).w,d0			; subtract screen y-position
		add.w	d1,d0					; add object height
		bmi.s	.offscreen				; branch if object is off screen to the top
		add.w	d1,d1					; double height for undoing above addition and for bottom-side check
		sub.w	d1,d0					; su object height
		cmpi.w	#224,d1					; is object on screen?
		bge.s	.offscreen				; if not, object is off screen to the bottom
	else
		move.w	obY(a0),d1				; get object y-position
		sub.w	(v_screenposy).w,d1			; subtract screen y-position
		bmi.s	.offscreen				; branch if object is off screen to the top
		cmpi.w	#224,d1					; is object on screen?
		bge.s	.offscreen				; if not, object is off screen to the bottom
	endif

		moveq	#0,d0					; set Z-flag (object on screen)
		rts
; ---------------------------------------------------------------------------

.offscreen:
		moveq	#1,d0					; clear Z-flag (object off screen)
		rts
; End of function ChkPartiallyVisible
