; ---------------------------------------------------------------------------
; Subroutine to find a free object space

; output:
;	a1 = free position in object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindFreeObj:
		lea	(v_objspace+$800).w,a1 ; start address for object RAM
		move.w	#$5F,d0

	FFree_Loop:
		tst.b	(a1)		; is object RAM	slot empty?
		beq.s	FFree_Found	; if yes, branch
		lea	$40(a1),a1	; goto next object RAM slot
		dbf	d0,FFree_Loop	; repeat $5F times

	FFree_Found:
		rts	

; End of function FindFreeObj


; ---------------------------------------------------------------------------
; Subroutine to find a free object space AFTER the current one

; output:
;	a1 = free position in object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindNextFreeObj:
		movea.l	a0,a1
		move.w	#$F000,d0
		sub.w	a0,d0
		lsr.w	#6,d0
		subq.w	#1,d0
		bcs.s	NFree_Found

	NFree_Loop:
		tst.b	(a1)
		beq.s	NFree_Found
		lea	$40(a1),a1
		dbf	d0,NFree_Loop

	NFree_Found:
		rts	

; End of function FindNextFreeObj