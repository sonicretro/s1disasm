; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindWall:				; XREF: Sonic_WalkVertR; et al
		bsr.w	FindNearestTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_14B1E
		btst	d5,d4
		bne.s	loc_14B2C

loc_14B1E:
		add.w	a3,d3
		bsr.w	FindWall2
		sub.w	a3,d3
		addi.w	#$10,d1
		rts	
; ===========================================================================

loc_14B2C:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_14B1E
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d2,d1
		btst	#$C,d4
		beq.s	loc_14B5A
		not.w	d1
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_14B5A:
		btst	#$B,d4
		beq.s	loc_14B62
		neg.b	(a4)

loc_14B62:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(CollArray2).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$B,d4
		beq.s	loc_14B7E
		neg.w	d0

loc_14B7E:
		tst.w	d0
		beq.s	loc_14B1E
		bmi.s	loc_14B9A
		cmpi.b	#$10,d0
		beq.s	loc_14BA6
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts	
; ===========================================================================

loc_14B9A:
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_14B1E

loc_14BA6:
		sub.w	a3,d3
		bsr.w	FindWall2
		add.w	a3,d3
		subi.w	#$10,d1
		rts	
; End of function FindWall


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindWall2:				; XREF: FindWall
		bsr.w	FindNearestTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_14BC6
		btst	d5,d4
		bne.s	loc_14BD4

loc_14BC6:
		move.w	#$F,d1
		move.w	d3,d0
		andi.w	#$F,d0
		sub.w	d0,d1
		rts	
; ===========================================================================

loc_14BD4:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_14BC6
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d2,d1
		btst	#$C,d4
		beq.s	loc_14C02
		not.w	d1
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_14C02:
		btst	#$B,d4
		beq.s	loc_14C0A
		neg.b	(a4)

loc_14C0A:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(CollArray2).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$B,d4
		beq.s	loc_14C26
		neg.w	d0

loc_14C26:
		tst.w	d0
		beq.s	loc_14BC6
		bmi.s	loc_14C3C
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts	
; ===========================================================================

loc_14C3C:
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_14BC6
		not.w	d1
		rts	
; End of function FindWall2
