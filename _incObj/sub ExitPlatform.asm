; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk or jump off a platform
; 
; input:
;	d1 = platform width/2
; ---------------------------------------------------------------------------

ExitPlatform:
		move.w	d1,d2					; copy input width to d2
; ---------------------------------------------------------------------------

ExitPlatform2:	; input width is already in d2
		add.w	d2,d2					; double input platform width
		lea	(v_player).w,a1				; load Sonic player object
	if FixBugs
		; Fix getting stuck on platforms when entering debug mode
		tst.w	(v_debuguse).w				; is debug mode active?
		bne.s	.exitedPlatform				; if yes, exit platform right away
	endif
		btst	#1,obStatus(a1)				; is Sonic airborne?
		bne.s	.exitedPlatform				; if yes, exit platform right away

		move.w	obX(a1),d0				; get Sonic's X-position
		sub.w	obX(a0),d0				; subtract platform's X-position
		add.w	d1,d0					; add half platform width
		bmi.s	.exitedPlatform				; if Sonic is to the left of the platform, branch
		cmp.w	d2,d0					; is Sonic to the right of the platform?
		blo.s	.return					; if not, stay on platform

	.exitedPlatform:
		bclr	#3,obStatus(a1)				; clear Sonic's on-platform flag
		move.b	#2,obRoutine(a0)			; reset platform to "Sonic is not standing on me" routine (always second)
		bclr	#3,obStatus(a0)				; clear platform's stood-on flag

	.return:
		rts						; return
; End of function ExitPlatform
