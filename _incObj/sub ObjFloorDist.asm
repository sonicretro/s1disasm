; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the floor

; input:
;	d3 = x-pos. of object (ObjFloorDist2 only)

; output:
;	d1 = distance to the floor
;	d3 = floor angle
;	a1 = address within 128x128 mappings where object is standing
;	     (refers to a 16x16 tile number)
;	(a4) = floor angle
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ObjFloorDist:
		move.w	obX(a0),d3


ObjFloorDist2:
		move.w	obY(a0),d2
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		moveq	#$C,d5					; MJ: set solid type to check
		cmpi.b	#id_SonicPlayer,(a0)			; MJ: is the parent object Sonic?
		bne.s	.notsonic				; MJ: if not, branch and only use first collision set
		move.b	(v_top_solid_bit).w,d5			; MJ: load solid type to check
		move.l	(v_colladdr1).w,(v_collindex).w		; MJ: load first collision data location
		cmpi.b	#$C,d5					; MJ: is second collision set to be used?
		beq.s	.first					; MJ: if not, branch
		move.l	(v_colladdr2).w,(v_collindex).w		; MJ: load second collision data location
.first:	
.notsonic:
		lea	(v_anglebuffer).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3		; height of a 16x16 tile
		move.w	#0,d6
		bsr.w	FindFloor		; MJ: check solidity
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	locret_14E4E
		move.b	#0,d3

locret_14E4E:
		rts	

; End of function ObjFloorDist2
