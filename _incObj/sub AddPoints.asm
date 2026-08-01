; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to add points to the score counter.
; 
; Input:
;	d0 = points to add / 10 (rightmost digit in HUD is a fake 0)
; ---------------------------------------------------------------------------
; - In REV00, a copy of the score is kept in a separate RAM value, and it's
;   coded so that it only updates when the current score is higher. This is
;   never used anywhere in the game, but probably once was intended as some
;   sort of high-score system, as it stays in memory after a soft reset.
; - In REV01, this value has been repurposed so that it awards an extra life
;   for every multiple of 50000 points acquired, but ONLY if the region is
;   set to Japanese. Overseas regions will update the requirement, but they
;   won't award the extra life under any circumstances.
; ---------------------------------------------------------------------------

AddPoints:
		move.b	#1,(f_scorecount).w			; set score counter to update

	if Revision=0
		lea	(v_scorecopy).w,a2			; load copy of score count (unused, REV00 only)
		lea	(v_score).w,a3				; load current score count
		add.l	d0,(a3)					; add d0*10 to the score
		move.l	#999999,d1				; set maximum score count to 9999990
		cmp.l	(a3),d1					; has score exceeded the maximum?
		bhi.w	.belowmax				; if not, branch
		move.l	d1,(a3)					; cap score to 9999990
		move.l	d1,(a2)					; cap unused score copy

.belowmax:
		move.l	(a3),d0					; get new score count
		cmp.l	(a2),d0					; is it lower than the copy?
		blo.w	.return					; if yes, branch
		move.l	d0,(a2)					; update copy

	else

		lea	(v_score).w,a3				; load current score count
		add.l	d0,(a3)					; add d0*10 to the score
		move.l	#999999,d1				; set maximum score count to 9999990
		cmp.l	(a3),d1					; has score exceeded the maximum?
		bhi.s	.belowmax				; if not, branch
		move.l	d1,(a3)					; cap score to 9999990

.belowmax:
		move.l	(a3),d0					; get new score count
		cmp.l	(v_scorelife).w,d0			; is new score count exceeding the next multiple of 50000?
		blo.s	.return					; if not, branch

		addi.l	#5000,(v_scorelife).w			; increase requirement for next score extra life by 50000
		tst.b	(v_megadrive).w				; is region set to Japanese?
		bmi.s	.return					; if not (i.e. overseas), branch
		addq.b	#1,(v_lives).w				; award 1 extra life
		addq.b	#1,(f_lifecount).w			; update lives counter
		move.w	#bgm_ExtraLife,d0			; set extra life music
		jmp	(QueueSound1).l				; play it
	endif

.return:
		rts						; return
; End of function AddPoints
; ===========================================================================