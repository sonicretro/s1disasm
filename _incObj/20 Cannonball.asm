; ---------------------------------------------------------------------------
; Object 20 - cannonball that Ball Hog throws (SBZ)
; ---------------------------------------------------------------------------

Cannonball:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Cbal_Index(pc,d0.w),d1
		jmp	Cbal_Index(pc,d1.w)
; ===========================================================================
Cbal_Index:	offsetTable
		ptr Cbal_Main
		ptr Cbal_Bounce

cbal_time = objoff_30		; time until the cannonball explodes (2 bytes)
; ===========================================================================

Cbal_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.b	#7,obHeight(a0)
		move.l	#Map_Hog,obMap(a0)
		move.w	#ArtTile_Ball_Hog|Tile_Pal2,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#8,obActWid(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; move subtype to d0
		mulu.w	#60,d0		; multiply by 60 frames (1 second)
		move.w	d0,cbal_time(a0) ; set explosion time
		move.b	#4,obFrame(a0)

Cbal_Bounce:	; Routine 2
		jsr	(ObjectFall).l
		tst.w	obVelY(a0)
		bmi.s	Cbal_ChkExplode
		jsr	(ObjFloorDist).l
		tst.w	d1		; has ball hit the floor?
		bpl.s	Cbal_ChkExplode	; if not, branch

		add.w	d1,obY(a0)
		move.w	#-$300,obVelY(a0) ; bounce
		tst.b	d3
		beq.s	Cbal_ChkExplode
		bmi.s	loc_8CA4
		tst.w	obVelX(a0)
		bpl.s	Cbal_ChkExplode
		neg.w	obVelX(a0)
		bra.s	Cbal_ChkExplode
; ===========================================================================

loc_8CA4:
		tst.w	obVelX(a0)
		bmi.s	Cbal_ChkExplode
		neg.w	obVelX(a0)

Cbal_ChkExplode:
		subq.w	#1,cbal_time(a0) ; subtract 1 from explosion time
		bpl.s	Cbal_Animate	; if time is > 0, branch

Cbal_Explode:
		; This is a leftover from the front-facing prototype Ball Hogs, where the
		; dropped cannonballs would spawn a small explosion instead of the regular one.
		; However, after setting the ID, it immediately gets replaced again with the
		; normal explosions, making this object (and its associated graphics) unused.
		; The small explosion is technically also used by the Buzz Bomber's missiles,
		; but also goes completely unused because the relevant flag is never set
		; and no graphics are ever loaded into VRAM (would be "Nem_UnkExplode").
		_move.b	#id_UnusedExplosion,obID(a0)	; change object to small explosion ($24), and...
		_move.b	#id_Explosion,obID(a0)		; ...immediately change it again to a normal explosion ($3F)
		move.b	#0,obRoutine(a0)		; reset routine counter
		bra.w	Explosion			; jump to explosion code
; ===========================================================================

Cbal_Animate:
		subq.b	#1,obTimeFrame(a0) ; subtract 1 from frame duration
		bpl.s	Cbal_Display
		move.b	#5,obTimeFrame(a0) ; set frame duration to 5 frames
		bchg	#0,obFrame(a0)	; change frame

Cbal_Display:
	if FixBugs=0
		; Moved to prevent a display-and-delete bug.
		bsr.w	DisplaySprite
	endif
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	obY(a0),d0	; has object fallen off the level?
		blo.w	DeleteObject	; if yes, branch
	if FixBugs
		bra.w	DisplaySprite
	else
		rts
	endif
