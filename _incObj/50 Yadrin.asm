; ---------------------------------------------------------------------------
; Subroutine to check whether the object has hit the left or right wall. 
; In the prototype, this routine was shared between Splats (Obj4F) and Yadrin,
; but since the former was deleted, it is only used by the latter. See here:
; https://github.com/Totally-Not-Filter/s1-proto-disasm/blob/AS/obj/4F%20Splats.asm
; ---------------------------------------------------------------------------
 
; Yad_ChkWall: 
ChkHitLeftRightWall:
		move.w	(v_framecount).w,d0		; get frame counter
		add.w	d7,d0				; add object object enumerator from RAM
		andi.w	#3,d0				; and by 3 (effectively makes it so it's only checked every 4 frames, presumably for performance reasons)
		bne.s	.nowallhit			; if outside a 4th frame, branch
		moveq	#0,d3				; clear d3
		move.b	obActWid(a0),d3			; load object width to d3 (input param for wall col detection subroutines)
		tst.w	obVelX(a0)			; is object moving to the left?
		bmi.s	.chkleftwall			; if yes, branch
		bsr.w	ObjHitWallRight			; get distance to nearest right wall
		tst.w	d1				; did object hit wall?
		bpl.s	.nowallhit			; if not, branch
 
.wallhit:
		moveq	#1,d0				; set Z-flag (wall touched)
		rts
; ---------------------------------------------------------------------------
 
.chkleftwall:
		not.w	d3				; invert object width to make it work for left wall col
		bsr.w	ObjHitWallLeft			; get distance to nearest left wall
		tst.w	d1				; did object hit wall?
		bmi.s	.wallhit			; if yes, branch
 
.nowallhit:
		moveq	#0,d0				; clear Z-flag (wall not touched)
		rts					; return
; End of function ChkHitLeftRightWall

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 50 - Yadrin enemy (SYZ)
; ---------------------------------------------------------------------------

Yadrin:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Yad_Index(pc,d0.w),d1
		jmp	Yad_Index(pc,d1.w)
; ===========================================================================
Yad_Index:	offsetTable
		ptr Yad_Main
		ptr Yad_Action

yad_timedelay = objoff_30
; ===========================================================================

Yad_Main:	; Routine 0
		move.l	#Map_Yad,obMap(a0)
		move.w	#ArtTile_Yadrin|Tile_Pal2,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#$14,obActWid(a0)
		move.b	#$11,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.b	#$CC,obColType(a0)
		bsr.w	ObjectFall
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_F89E
		add.w	d1,obY(a0)	; match object's position with the floor
		move.w	#0,obVelY(a0)
		addq.b	#2,obRoutine(a0)
		bchg	#0,obStatus(a0)

locret_F89E:
		rts
; ===========================================================================

Yad_Action:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	Yad_Index2(pc,d0.w),d1
		jsr	Yad_Index2(pc,d1.w)
		lea	(Ani_Yad).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
Yad_Index2:	offsetTable
		ptr Yad_Move
		ptr Yad_FixToFloor
; ===========================================================================

Yad_Move:
		subq.w	#1,yad_timedelay(a0) ; subtract 1 from pause time
		bpl.s	locret_F8E2	; if time remains, branch
		addq.b	#2,ob2ndRout(a0)
		move.w	#-$100,obVelX(a0) ; move object
		move.b	#1,obAnim(a0)
		bchg	#0,obStatus(a0)
		bne.s	locret_F8E2
		neg.w	obVelX(a0)	; change direction

locret_F8E2:
		rts
; ===========================================================================

Yad_FixToFloor:
		bsr.w	SpeedToPos
		bsr.w	ObjFloorDist
		cmpi.w	#-8,d1
		blt.s	Yad_Pause
		cmpi.w	#$C,d1
		bge.s	Yad_Pause
		add.w	d1,obY(a0)	; match object's position to the floor
		bsr.w	ChkHitLeftRightWall
		bne.s	Yad_Pause
		rts
; ===========================================================================

Yad_Pause:
		subq.b	#2,ob2ndRout(a0)
		move.w	#59,yad_timedelay(a0) ; set pause time to 1 second
		move.w	#0,obVelX(a0)
		move.b	#0,obAnim(a0)
		rts
