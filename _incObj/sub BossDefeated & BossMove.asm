; ===========================================================================
; ---------------------------------------------------------------------------
; Defeated boss subroutine (shared by all bosses)
; ---------------------------------------------------------------------------

BossDefeated:
		move.b	(v_vblank_byte).w,d0			; get V-Blank counter
		andi.b	#7,d0 					; limits spawning explosions to every 8 frames
		bne.s	.noExplosion 				; if on other frame, branch

		jsr	(FindFreeObj).l				; find a free object slot
		bne.s	.noExplosion 				; if RAM is full, branch

		_move.b	#id_Explosion,obID(a1)			; load explosion object
		move.w	obX(a0),obX(a1) 			; set base explosion X-position to boss X-position
		move.w	obY(a0),obY(a1)				; set base explosion Y-position to boss Y-position

		jsr	(RandomNumber).l 			; generate a random number for position
		move.w	d0,d1 					; copy random number to d1
		moveq	#0,d1 					; ditch the first byte
		move.b	d0,d1 					; copy first byte of d0 to first byte of d1
		lsr.b	#2,d1 					; scale down the random number
		subi.w	#$20,d1 				; shift left by $20 pixels (otherwise all explosions would be on the right side of the boss)
		add.w	d1,obX(a1) 				; apply random x

		; Unlike the X-position, no shift is made for the Y-position.
		; It's hard to tell if it was intentional or not,
		; but all explosions are biased downwards due to this.

		lsr.w	#8,d0 					; shift high byte into low byte
		lsr.b	#3,d0 					; scale down the random number
		add.w	d0,obY(a1) 				; apply random y

	.noExplosion:
		rts						; return
; End of function BossDefeated


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to move a boss (shared by all bosses).
; This is a modified variation of SpeedToPos.
; ---------------------------------------------------------------------------

BossMove:
		move.l	obBossX(a0),d2				; get boss' X-axis position
		move.l	obBossY(a0),d3				; get boss' Y-axis position
		move.w	obVelX(a0),d0				; load horizontal speed
		ext.l	d0					; extend speed to longword
		asl.l	#8,d0					; shift speed up a byte (16.16 fixed point)
		add.l	d0,d2					; add speed to X-axis position

		move.w	obVelY(a0),d0				; load vertical speed
		ext.l	d0					; extend speed to longword
		asl.l	#8,d0					; shift speed up a byte (16.16 fixed point)
		add.l	d0,d3					; add speed to Y-axis position

		move.l	d2,obBossX(a0)				; update X-axis position
		move.l	d3,obBossY(a0)				; update Y-axis position
		rts						; return
; End of function BossMove
