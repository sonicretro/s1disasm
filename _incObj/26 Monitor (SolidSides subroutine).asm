; ---------------------------------------------------------------------------
; Subroutine to	make the sides of a monitor solid
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Mon_SolidSides:
		lea	(v_player).w,a1
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	loc_A4E6
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	loc_A4E6
		move.b	obHeight(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	obY(a1),d3
		sub.w	obY(a0),d3
		add.w	d2,d3
		bmi.s	loc_A4E6
		add.w	d2,d2
		cmp.w	d2,d3
		bcc.s	loc_A4E6
		tst.b	(f_lockmulti).w
		bmi.s	loc_A4E6
		cmpi.b	#6,(v_player+obRoutine).w
		bcc.s	loc_A4E6
		tst.w	(v_debuguse).w
		bne.s	loc_A4E6
		cmp.w	d0,d1
		bcc.s	loc_A4DC
		add.w	d1,d1
		sub.w	d1,d0

loc_A4DC:
		cmpi.w	#$10,d3
		bcs.s	loc_A4EA

loc_A4E2:
		moveq	#1,d1
		rts	
; ===========================================================================

loc_A4E6:
		moveq	#0,d1
		rts	
; ===========================================================================

loc_A4EA:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addq.w	#4,d1
		move.w	d1,d2
		add.w	d2,d2
		add.w	obX(a1),d1
		sub.w	obX(a0),d1
		bmi.s	loc_A4E2
		cmp.w	d2,d1
		bcc.s	loc_A4E2
		moveq	#-1,d1
		rts	
; End of function Obj26_SolidSides
