; ---------------------------------------------------------------------------
; Subroutine to	find the floor

; input:
;	d2 = y-position of object's bottom edge
;	d3 = x-position of object
;	d5 = bit to test for solidness

; output:
;	d1 = distance to the floor
;	a1 = address within 128x128 mappings where object is standing
;	     (refers to a 16x16 tile number)
;	(a4) = floor angle
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindFloor:
		bsr.s	FindNearestTile
		move.w	(a1),d0		; get value for solidness, orientation and 16x16 tile number
		move.w	d0,d4
		andi.w	#$3FF,d0	; MJ: ($800/2)-1
		beq.s	.isblank	; branch if tile is blank
		btst	d5,d4		; is the tile solid?
		bne.s	.issolid	; if yes, branch

.isblank:
		add.w	a3,d2
		bsr.w	FindFloor2	; try tile below the nearest
		sub.w	a3,d2
		addi.w	#$10,d1		; return distance to floor
		rts	
; ===========================================================================

.issolid:
		movea.l	(v_collindex).w,a2	; MJ: load collision index address
		move.b	(a2,d0.w),d0		; MJ: load correct Collision ID based on the Block ID
		andi.w	#$FF,d0			; MJ: clear the left byte
		beq.s	.isblank		; MJ: if collision ID is 00, branch
		lea	(AngleMap).l,a2		; MJ: load angle map data to a2
		move.b	(a2,d0.w),(a4)		; MJ: collect correct angle based on the collision ID
		lsl.w	#4,d0			; MJ: multiply collision ID by 10
		move.w	d3,d1			; MJ: load X position
		btst	#$A,d4			; MJ: is the block mirrored?
		beq.s	.noflip			; MJ: if not, branch
		not.w	d1			; MJ: reverse bits of the X position
		neg.b	(a4)			; MJ: reverse the angle ID

.noflip:
		btst	#$B,d4			; MJ: is the block flipped?
		beq.s	.noflip2		; MJ: if not, branch
		addi.b	#$40,(a4)		; MJ: increase angle ID by 40..
		neg.b	(a4)			; MJ: ..reverse the angle ID..
		subi.b	#$40,(a4)		; MJ: ..and subtract 40 again 

.noflip2:
		andi.w	#$F,d1			; MJ: get only within 10 (d1 is pixel based on the collision block)
		add.w	d0,d1			; MJ: add collision ID (x10) (d0 is the collision block being read)
		lea	(CollArray1).l,a2	; MJ: load collision array
		move.b	(a2,d1.w),d0		; MJ: load solid value
		ext.w	d0			; MJ: clear left byte
		eor.w	d6,d4			; MJ: set ceiling/wall bits
		btst	#$B,d4			; MJ: is sonic walking on the left wall?
		beq.s	.noflip3		; MJ: if not, branch
		neg.w	d0			; MJ: reverse solid value

.noflip3:
		tst.w	d0			; MJ: is the solid data null?
		beq.s	.isblank		; MJ: if so, branch
		bmi.s	.negfloor		; MJ: if it's negative, branch
		cmpi.b	#$10,d0			; MJ: is it 10?
		beq.s	.maxfloor		; MJ: if so, branch
		move.w	d2,d1			; MJ: load Y position
		andi.w	#$F,d1			; MJ: get only within 10 pixels
		add.w	d1,d0			; MJ: add to solid value
		move.w	#$F,d1			; MJ: set F
		sub.w	d0,d1			; MJ: minus solid value from F
		rts				; MJ: return
; ===========================================================================

.negfloor:
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	.isblank

.maxfloor:
		sub.w	a3,d2
		bsr.w	FindFloor2	; try tile above the nearest
		add.w	a3,d2
		subi.w	#$10,d1		; return distance to floor
		rts	
; End of function FindFloor


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindFloor2:
		bsr.w	FindNearestTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$3FF,d0	; MJ: ($800/2)-1
		beq.s	.isblank2
		btst	d5,d4
		bne.s	.issolid

.isblank2:
		move.w	#$F,d1
		move.w	d2,d0
		andi.w	#$F,d0
		sub.w	d0,d1
		rts	
; ===========================================================================

.issolid:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	.isblank2
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d3,d1
		btst	#$A,d4		; MJ: B to A (because S2 format has two solids)
		beq.s	.noflip
		not.w	d1
		neg.b	(a4)

.noflip:
		btst	#$B,d4		; MJ: C to B (because S2 format has two solids)
		beq.s	.noflip2
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

.noflip2:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(CollArray1).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$B,d4		; MJ: C to B (because S2 format has two solids)
		beq.s	.noflip3
		neg.w	d0

.noflip3:
		tst.w	d0
		beq.s	.isblank2
		bmi.s	.negfloor
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts	
; ===========================================================================

.negfloor:
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	.isblank2
		not.w	d1
		rts	
; End of function FindFloor2
