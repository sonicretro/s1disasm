; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to resume regular level music after the underwater
; countdown music in LZ/SBZ3 has started
; ---------------------------------------------------------------------------

ResumeMusic:
		cmpi.w	#12,(v_air).w				; more than 12 seconds of air left?
		bhi.s	.replenishAir				; if yes, branch

		move.w	#bgm_LZ,d0				; play LZ music
		cmpi.w	#id_LZ_act4,(v_zone_act).w		; check if level is SBZ3 (LZ4)
		bne.s	.notSBZ					; if not, branch
		move.w	#bgm_SBZ,d0				; play SBZ music instead
	.notSBZ:

	if Revision<>0
		tst.b	(v_invinc).w				; is Sonic invincible?
		beq.s	.notInvincible				; if not, branch
		move.w	#bgm_Invincible,d0			; play invincibility music instead
	.notInvincible:
		tst.b	(f_lockscreen).w			; is Sonic at a boss?
		beq.s	.playselected				; if not, branch
		move.w	#bgm_Boss,d0				; play boss music instead
	.playselected:
	endif

		jsr	(QueueSound1).l				; play selected music

.replenishAir:
		move.w	#30,(v_air).w				; reset air to 30 seconds
		clr.b	(v_sonicbubbles+bub_time).w		; reset time until next bubble spawn
		rts						; return
; End of function ResumeMusic
