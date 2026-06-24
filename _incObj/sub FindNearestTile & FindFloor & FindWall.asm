; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to find which tile the object is standing on
; 
; input:
;	d2 = y-position of object's bottom edge
;	d3 = x-position of object
; 
; output:
;	a1 = address within 256x256 mappings where object is standing
;	     (refers to a 16x16 tile number)
; ---------------------------------------------------------------------------

FindNearestTile:
		move.w	d2,d0		; get y-pos. of bottom edge of object
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.w	d3,d1		; get x-pos. of object
		lsr.w	#8,d1
		andi.w	#$7F,d1
		add.w	d1,d0		; combine
		moveq	#$FFFFFFFF,d1	; = -1 (prefill to prepare creating a RAM address)
		lea	(v_lvllayout_fg).w,a1
		move.b	(a1,d0.w),d1	; get 256x256 tile number
		beq.s	.blanktile	; branch if 0 (blank chunk)
		bmi.s	.specialtile	; branch if >$7F
		subq.b	#1,d1
		ext.w	d1
		ror.w	#7,d1
		move.w	d2,d0
		add.w	d0,d0
		andi.w	#$1E0,d0
		add.w	d0,d1
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		add.w	d0,d1

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
		btst	#sprite_looping_bit,obRender(a0) ; is object "behind a loop"?
		beq.s	.treatasnormal	; if not, branch
		addq.w	#1,d1
		cmpi.w	#$29,d1
		bne.s	.treatasnormal
		move.w	#$51,d1

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
;	d2 = y-position of object's bottom edge
;	d3 = x-position of object
;	d5 = bit to test for solidness
;	d6 = x/y-flip xor mask
; 
; output:
;	d1 = distance to the floor
;	a1 = address within 256x256 mappings where object is standing
;	     (refers to a 16x16 tile number)
;	(a4) = floor angle
; ---------------------------------------------------------------------------

FindFloor:
		bsr.s	FindNearestTile
		move.w	(a1),d0		; get value for solidness, orientation and 16x16 tile number
		move.w	d0,d4
		andi.w	#$7FF,d0
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
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0	; get collision block number
		andi.w	#$FF,d0
		beq.s	.isblank	; branch if 0
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)	; get collision angle value
		lsl.w	#4,d0
		move.w	d3,d1		; get x-pos. of object
		btst	#$B,d4		; is block flipped horizontally?
		beq.s	.noflip		; if not, branch
		not.w	d1
		neg.b	(a4)

.noflip:
		btst	#$C,d4		; is block flipped vertically?
		beq.s	.noflip2	; if not, branch
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

.noflip2:
		andi.w	#$F,d1
		add.w	d0,d1		; (block num. * $10) + x-pos. = place in array
		lea	(CollArray1).l,a2
		move.b	(a2,d1.w),d0	; get collision height
		ext.w	d0
		eor.w	d6,d4
		btst	#$C,d4		; is block flipped vertically?
		beq.s	.noflip3	; if not, branch
		neg.w	d0

.noflip3:
		tst.w	d0
		beq.s	.isblank	; branch if height is 0
		bmi.s	.negfloor	; branch if height is negative
		cmpi.b	#$10,d0
		beq.s	.maxfloor	; branch if height is $10 (max)
		move.w	d2,d1		; get y-pos. of object
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1		; return distance to floor
		rts
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
; ===========================================================================


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
		beq.s	.noflip
		not.w	d1
		neg.b	(a4)

.noflip:
		btst	#$C,d4
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
		btst	#$C,d4
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

; input:
;	d2.w = y position of object's bottom edge
;	d3.w = x position of object
;	d5.l = bit to test for solidness: $D = top solid; $E = left/right/bottom solid
;	d6.w = eor bitmask for 16x16 tile
;	a3.w = height of 16x16 tiles: $10 or -$10 if object is inverted
;	a4 = RAM address to write angle byte

; output:
;	d1.w = distance to the wall
;	a1 = address within 256x256 mappings where object is standing
;	(a1).w = 16x16 tile number, x/yflip, solidness
;	(a4).b = floor angle

;	uses d0.w, d3.w, d4.w
; ---------------------------------------------------------------------------

FindWall:
		bsr.w	FindNearestTile				; a1 = address within 256x256 mappings of 16x16 tile being stood on
		move.w	(a1),d0					; get value for solidness, orientation and 16x16 tile number
		move.w	d0,d4
		andi.w	#$7FF,d0				; ignore solid/orientation bits
		beq.s	.isblank				; branch if tile is blank
		btst	d5,d4					; is the tile solid?
		bne.s	.issolid				; if yes, branch

.isblank:
		add.w	a3,d3
		bsr.w	FindWall2				; try tile to the right
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
		lsl.w	#4,d0					; d0 = heightmap id * $10 (the width of a heightmap for 1 tile)
		move.w	d2,d1					; get y pos of object
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
		andi.w	#$F,d1					; read only low nybble of x pos (i.e. x pos within 16x16 tile)
		add.w	d0,d1					; (id * $10) + x pos. = place in heightmap data
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
		move.w	d3,d1					; get x pos of object
		andi.w	#$F,d1					; read only low nybble for x pos within 16x16 tile
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1					; return distance to wall
		rts	

.negfloor:
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	.isblank

.maxfloor:
		sub.w	a3,d3
		bsr.w	FindWall2				; try tile to the left
		add.w	a3,d3
		subi.w	#$10,d1					; return distance to wall
		rts
; End of function FindWall

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find a wall left/right of the current 16x16 tile
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