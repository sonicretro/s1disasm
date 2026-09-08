; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to make an object fall downwards, increasingly fast
; ---------------------------------------------------------------------------
gravity:	equ	$38				; gravity constant used by many objects
; ---------------------------------------------------------------------------

ObjectFall:
		move.l	obX(a0),d2				; get object's X-axis position
		move.l	obY(a0),d3				; get object's Y-axis position
		move.w	obVelX(a0),d0				; load horizontal speed
		ext.l	d0					; extend speed to longword
		asl.l	#8,d0					; shift speed up a byte (16.16 fixed point)
		add.l	d0,d2					; add speed to X-axis position

		move.w	obVelY(a0),d0				; load vertical speed
		addi.w	#gravity,obVelY(a0)			; increase vertical speed (apply gravity)
		ext.l	d0					; extend speed to longword
		asl.l	#8,d0					; shift speed up a byte (16.16 fixed point)
		add.l	d0,d3					; add speed to Y-axis position

		move.l	d2,obX(a0)				; update X-axis position
		move.l	d3,obY(a0)				; update Y-axis position
		rts						; return
; End of function ObjectFall


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine translating object speed to update object position.
; Identical to ObjectFall, but without applying gravity.
; ---------------------------------------------------------------------------

SpeedToPos:
		move.l	obX(a0),d2				; get object's X-axis position
		move.l	obY(a0),d3				; get object's Y-axis position
		move.w	obVelX(a0),d0				; load horizontal speed
		ext.l	d0					; extend speed to longword
		asl.l	#8,d0					; shift speed up a byte (16.16 fixed point)
		add.l	d0,d2					; add speed to X-axis position

		move.w	obVelY(a0),d0				; load vertical speed
		ext.l	d0					; extend speed to longword
		asl.l	#8,d0					; shift speed up a byte (16.16 fixed point)
		add.l	d0,d3					; add speed to Y-axis position

		move.l	d2,obX(a0)				; update X-axis position
		move.l	d3,obY(a0)				; update Y-axis position
		rts						; return
; End of function SpeedToPos
