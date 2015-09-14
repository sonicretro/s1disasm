; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindWall:
		bsr.w	FindNearestTile		; MJ: get chunk/block location
		move.w	(a1),d0			; MJ: load block ID from chunk
		move.w	d0,d4			; MJ: copy to d4
		andi.w	#$3FF,d0		; MJ: clear flip/mirror/etc data
		beq.s	loc_14B1E		; MJ: if it was null, branch
		btst	d5,d4			; MJ: check solid set (C top solid | D Left/right solid)
		bne.s	loc_14B2C		; MJ: if the specific solid is set, branch

loc_14B1E:
		add.w	a3,d3			; MJ: add 10 to X position
		bsr.w	FindWall2
		sub.w	a3,d3			; MJ: minus 10 from X position
		addi.w	#$10,d1
		rts	
; ===========================================================================

loc_14B2C:
		movea.l	(v_collindex).w,a2	; MJ: load address of collision for level
		move.b	(a2,d0.w),d0		; MJ: load correct colision ID based on the block ID
		andi.w	#$FF,d0			; MJ: keep within FF
		beq.s	loc_14B1E		; MJ: if it's null, branch
		lea	(AngleMap).l,a2		; MJ: load angle map data to a2
		move.b	(a2,d0.w),(a4)		; MJ: load angle set location based on collision ID
		lsl.w	#4,d0			; MJ: multiply by 10
		move.w	d2,d1			; MJ: load Y position
		btst	#$B,d4			; MJ: is the block ID flipped?
		beq.s	loc_14B5A		; MJ: if not, branch
		not.w	d1
		addi.b	#$40,(a4)		; MJ: increase angle set by 40
		neg.b	(a4)			; MJ: negate to opposite
		subi.b	#$40,(a4)		; MJ: decrease angle set by 40

loc_14B5A:
		btst	#$A,d4			; MJ: is the block ID mirrored?
		beq.s	loc_14B62		; MJ: if not, branch
		neg.b	(a4)			; MJ: negate to opposite

loc_14B62:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(CollArray2).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$A,d4		; MJ: B to A (because S2 format has two solids)
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


FindWall2:
		bsr.w	FindNearestTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$3FF,d0	; MJ: ($800/2)-1
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
		btst	#$B,d4		; MJ: C to B (because S2 format has two solids)
		beq.s	loc_14C02
		not.w	d1
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_14C02:
		btst	#$A,d4		; MJ: B to A (because S2 format has two solids)
		beq.s	loc_14C0A
		neg.b	(a4)

loc_14C0A:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(CollArray2).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$A,d4		; MJ: B to A (because S2 format has two solids)
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
