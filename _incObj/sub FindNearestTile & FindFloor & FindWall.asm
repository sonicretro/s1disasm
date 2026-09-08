; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to find which 16x16 block tile the object is standing on
; 
; input:
;	d2.w = y-position of object's bottom edge
;	d3.w = x-position of object
; 
; output:
;	a1 = address within 256x256 mappings where object is standing
;	(a1).w = 16x16 tile number, x/yflip, solidness
; ---------------------------------------------------------------------------

FindNearestTile:
		move.w	d2,d0					; get Y-position of bottom edge of object
		lsr.w	#1,d0					; divide Y-position by 2 (because layout alternates between level and bg lines)
		andi.w	#$380,d0				; read only high byte of Y-position (because each level chunk is 256px tall)
		move.w	d3,d1					; get X-position of object
		lsr.w	#8,d1
		andi.w	#$7F,d1					; read only high byte of X-position
		add.w	d1,d0					; combine for position within layout
		moveq	#$FFFFFFFF,d1				; d1 = $FFFFFFFF (used to make a RAM address)
		lea	(v_lvllayout_fg).w,a1
		move.b	(a1,d0.w),d1				; get 256x256 chunk number
		beq.s	.blanktile				; branch if 0 (blank chunk)
		bmi.s	.specialtile				; branch if > $7F

		subq.b	#1,d1					; make chunks start at 0
		ext.w	d1					; d1 = $FFFF00xx
		ror.w	#7,d1					; d1 = $FFFFxx00 where xx is multiplied by 2
		move.w	d2,d0
		add.w	d0,d0					; d0 = Y-position * 2 (because each 16x16 block is represented by 2 bytes)
		andi.w	#$1E0,d0				; read only high nybble of low byte (for Y-position within 256x256 chunk)
		add.w	d0,d1					; add to base address
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0					; d0 = high nybble of low byte of X-position, multiplied by 2
		add.w	d0,d1					; add to base address

	if FixBugs
		movea.l	d1,a1
		rts

		; The regular branch to .blanktile will result in d1 being set to $FFFFFF00,
		; which will be returned in a1 and subsequently be used as the RAM location
		; for blank chunk collision. By luck, that address (v_chunk0collision) is
		; never changed from 0, so it doesn't cause any trouble in the final game,
		; but it is still incredibly dangerous and requires RAM to be laid out in a
		; specific way so it doesn't break, which is why it has an assembly check.
		; With this fix, blank chunks instead use a fixed ROM location that always
		; contains a 0 word. This will also remove the need for that assembly check.

	    .blanktile:
		lea	.chunk0(pc),a1
		rts

	    .chunk0:
		dc.w 0
	else
	    .blanktile:
		movea.l	d1,a1
		rts
	endif

; ===========================================================================

.specialtile:
		andi.w	#$7F,d1
		btst	#sprite_looping_bit,obRender(a0)	; is object "behind a loop"?
		beq.s	.treatasnormal				; if not, branch
		addq.w	#1,d1
		cmpi.w	#$29,d1					; is 256x256 chunk number $28?
		bne.s	.treatasnormal				; if not, branch
		move.w	#$51,d1					; replace with $51

	.treatasnormal:
		subq.b	#1,d1
		ror.w	#7,d1
		move.w	d2,d0
		add.w	d0,d0
		andi.w	#$1E0,d0
		add.w	d0,d1
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		add.w	d0,d1
		movea.l	d1,a1
		rts
; End of function FindNearestTile


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to find the floor
; 
; input:
;	d2.w = y-position of object's bottom edge
;	d3.w = x-position of object
;	d5.l = bit to test for solidness: $D = top solid; $E = left/right/bottom solid
;	d6.w = eor bitmask for 16x16 block
;	a3.w = height of 16x16 blocks: $10 or -$10 if object is inverted
;	a4 = RAM address to write angle byte
; 
; output:
;	d1.w = distance to the floor
;	a1 = address within 256x256 mappings where object is standing
;	(a1).w = 16x16 block number, x/yflip, solidness
;	(a4).b = floor angle
; ---------------------------------------------------------------------------

FindFloor:
		bsr.s	FindNearestTile				; a1 = address within 256x256 mappings of 16x16 block being stood on
		move.w	(a1),d0					; get value for solidness, orientation and 16x16 block number
		move.w	d0,d4
		andi.w	#$7FF,d0				; ignore solid/orientation bits
		beq.s	.isblank				; branch if block is blank
		btst	d5,d4					; is the block solid?
		bne.s	.issolid				; if yes, branch

.isblank:
		add.w	a3,d2
		bsr.w	FindFloor2				; try block below the nearest
		sub.w	a3,d2
		addi.w	#$10,d1					; return distance to floor
		rts
; ===========================================================================

.issolid:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0				; get collision heightmap id
		andi.w	#$FF,d0					; heightmap id is 1 byte
		beq.s	.isblank				; branch if 0
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)				; get collision angle value
		lsl.w	#4,d0					; d0 = heightmap id * $10 (the width of a heightmap for 1 block)
		move.w	d3,d1					; get X-position of object
		btst	#$B,d4					; is block flipped horizontally?
		beq.s	.no_xflip				; if not, branch
		not.w	d1
		neg.b	(a4)					; xflip angle

	.no_xflip:
		btst	#$C,d4					; is block flipped vertically?
		beq.s	.no_yflip				; if not, branch
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)				; yflip angle

	.no_yflip:
		andi.w	#$F,d1					; read only low nybble of X-position (i.e. X-position within 16x16 block)
		add.w	d0,d1					; (id * $10) + X-position. = place in heightmap data
		lea	(CollArray1).l,a2
		move.b	(a2,d1.w),d0				; get actual height value from heightmap
		ext.w	d0
		eor.w	d6,d4					; apply x/yflip (allows for double-flip cancellation)
		btst	#$C,d4					; is block flipped vertically?
		beq.s	.no_yflip2				; if not, branch
		neg.w	d0

	.no_yflip2:
		tst.w	d0
		beq.s	.isblank				; branch if height is 0
		bmi.s	.negfloor				; branch if height is negative
		cmpi.b	#$10,d0
		beq.s	.maxfloor				; branch if height is $10 (max)
		move.w	d2,d1					; get Y-position of object
		andi.w	#$F,d1					; read only low nybble for Y-position within 16x16 block
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1					; return distance to floor
		rts
; ===========================================================================

.negfloor:
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	.isblank

.maxfloor:
		sub.w	a3,d2
		bsr.w	FindFloor2				; try block above the nearest
		add.w	a3,d2
		subi.w	#$10,d1					; return distance to floor
		rts
; End of function FindFloor

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find the floor above/below the current 16x16 block
; ---------------------------------------------------------------------------

FindFloor2:
	if FixBugs
		move.w	d4,-(sp)
	endif
		bsr.w	FindNearestTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	.isblank2
		btst	d5,d4
		bne.s	.issolid

.isblank2:
		move.w	#$F,d1
		move.w	d2,d0
		andi.w	#$F,d0
		sub.w	d0,d1
	if FixBugs
		move.w	(sp)+,d4
	endif
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
		btst	#$B,d4
		beq.s	.no_xflip
		not.w	d1
		neg.b	(a4)

	.no_xflip:
		btst	#$C,d4
		beq.s	.no_yflip
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

	.no_yflip:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(CollArray1).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$C,d4
		beq.s	.no_yflip2
		neg.w	d0

	.no_yflip2:
		tst.w	d0
		beq.s	.isblank2
		bmi.s	.negfloor
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
	if FixBugs
		addq.w	#2,sp
	endif
		rts
; ===========================================================================

.negfloor:
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	.isblank2
		not.w	d1
	if FixBugs
		addq.w	#2,sp
	endif
		rts
; End of function FindFloor2


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find a wall
; 
; input:
;	d2.w = Y-position of object's bottom edge
;	d3.w = X-position of object
;	d5.l = bit to test for solidness: $D = top solid; $E = left/right/bottom solid
;	d6.w = eor bitmask for 16x16 block
;	a3.w = height of 16x16 blocks: $10 or -$10 if object is inverted
;	a4 = RAM address to write angle byte
; 
; output:
;	d1.w = distance to the wall
;	a1 = address within 256x256 mappings where object is standing
;	(a1).w = 16x16 block number, x/yflip, solidness
;	(a4).b = floor angle
; ---------------------------------------------------------------------------

FindWall:
		bsr.w	FindNearestTile				; a1 = address within 256x256 mappings of 16x16 block being stood on
		move.w	(a1),d0					; get value for solidness, orientation and 16x16 block number
		move.w	d0,d4
		andi.w	#$7FF,d0				; ignore solid/orientation bits
		beq.s	.isblank				; branch if block is blank
		btst	d5,d4					; is the block solid?
		bne.s	.issolid				; if yes, branch

.isblank:
		add.w	a3,d3
		bsr.w	FindWall2				; try block to the right
		sub.w	a3,d3
		addi.w	#$10,d1					; return distance to wall
		rts
; ===========================================================================

.issolid:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0				; get collision heightmap id
		andi.w	#$FF,d0					; heightmap id is 1 byte
		beq.s	.isblank				; branch if 0
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)				; get collision angle value
		lsl.w	#4,d0					; d0 = heightmap id * $10 (the width of a heightmap for 1 block)
		move.w	d2,d1					; get Y-position of object
		btst	#$C,d4					; is block flipped vertically?
		beq.s	.no_yflip				; if not, branch
		not.w	d1
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)				; yflip angle

	.no_yflip:
		btst	#$B,d4					; is block flipped horizontally?
		beq.s	.no_xflip				; if not, branch
		neg.b	(a4)					; xflip angle

	.no_xflip:
		andi.w	#$F,d1					; read only low nybble of X-position (i.e. X-position within 16x16 block)
		add.w	d0,d1					; (id * $10) + X-position. = place in heightmap data
		lea	(CollArray2).l,a2
		move.b	(a2,d1.w),d0				; get actual height value from heightmap
		ext.w	d0
		eor.w	d6,d4					; apply x/yflip (allows for double-flip cancellation)
		btst	#$B,d4					; is block flipped horizontally?
		beq.s	.no_xflip2				; if not, branch
		neg.w	d0

	.no_xflip2:
		tst.w	d0
		beq.s	.isblank				; branch if height is 0
		bmi.s	.negfloor				; branch if height is negative
		cmpi.b	#$10,d0
		beq.s	.maxfloor				; branch if height is $10 (max)
		move.w	d3,d1					; get X-position of object
		andi.w	#$F,d1					; read only low nybble for X-position within 16x16 block
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1					; return distance to wall
		rts
; ===========================================================================

.negfloor:
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	.isblank

.maxfloor:
		sub.w	a3,d3
		bsr.w	FindWall2				; try block to the left
		add.w	a3,d3
		subi.w	#$10,d1					; return distance to wall
		rts
; End of function FindWall

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find a wall left/right of the current 16x16 block
; ---------------------------------------------------------------------------

FindWall2:
	if FixBugs
		move.w	d4,-(sp)
	endif
		bsr.w	FindNearestTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	.isblank
		btst	d5,d4
		bne.s	.issolid

.isblank:
		move.w	#$F,d1
		move.w	d3,d0
		andi.w	#$F,d0
		sub.w	d0,d1
	if FixBugs
		move.w	(sp)+,d4
	endif
		rts
; ===========================================================================

.issolid:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	.isblank
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d2,d1
		btst	#$C,d4
		beq.s	.no_yflip
		not.w	d1
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

	.no_yflip:
		btst	#$B,d4
		beq.s	.no_xflip
		neg.b	(a4)

	.no_xflip:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(CollArray2).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$B,d4
		beq.s	.no_xflip2
		neg.w	d0

	.no_xflip2:
		tst.w	d0
		beq.s	.isblank
		bmi.s	.negfloor
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
	if FixBugs
		addq.w	#2,sp
	endif
		rts
; ===========================================================================

.negfloor:
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	.isblank
		not.w	d1
	if FixBugs
		addq.w	#2,sp
	endif
		rts
; End of function FindWall2
