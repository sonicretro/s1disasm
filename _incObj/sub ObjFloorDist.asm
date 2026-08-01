; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the floor
; 
; input:
;	d3 = x-pos. of object (ObjFloorDist2 only)
; 
; output:
;	d1 = distance to the floor
;	d3 = floor angle
;	     (0 = flat surface, >0 = descending right // <0 = ascending right)
;	a1 = address within 256x256 mappings where object is standing
;	     (refers to a 16x16 tile number)
;	(a4) = floor angle
; ---------------------------------------------------------------------------

ObjFloorDist:
		move.w	obX(a0),d3				; get object's X-position
; ---------------------------------------------------------------------------

ObjFloorDist2:	; X-position is already in d3
		move.w	obY(a0),d2				; get object's Y-position
		moveq	#0,d0					; clear d0 (obHeight is a byte)
		move.b	obHeight(a0),d0				; get object's height
		ext.w	d0					; extend height to word
		add.w	d0,d2					; add height to Y-position
		lea	(v_anglebuffer).w,a4			; write angle here
		move.b	#0,(a4)					; set initial angle to blank
		movea.w	#$10,a3					; height of a 16x16 tile
		move.w	#0,d6					; clear x/y-flip xor mask
		moveq	#$D,d5					; bit to test for solidness
		bsr.w	FindFloor				; find distance to floor
		move.b	(v_anglebuffer).w,d3			; get resulting angle
		btst	#0,d3					; is angle snap bit set?
		beq.s	.return					; if not, branch
		move.b	#0,d3					; snap to flat floor

	.return:
		rts						; return
; End of function ObjFloorDist
