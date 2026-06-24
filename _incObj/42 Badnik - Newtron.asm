; ===========================================================================
; ---------------------------------------------------------------------------
; Object 42 - Newtron enemy (GHZ)
; ---------------------------------------------------------------------------

Newtron:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Newt_Index(pc,d0.w),d1
		jmp	Newt_Index(pc,d1.w)
; ===========================================================================
Newt_Index:	dc.w Newt_Main-Newt_Index			; 0
		dc.w Newt_Action-Newt_Index			; 2
		dc.w Newt_GreenDelete-Newt_Index		; 4

newt_fired:	equ objoff_32	; flag set once a missile has been fired (green Newtron only)
; ===========================================================================

Newt_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Newt_Action
		move.l	#Map_Newt,obMap(a0)			; set mappings
		move.w	#ArtTile_Newtron,obGfx(a0)		; set art tile
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.b	#40/2,obActWid(a0)			; set sprite display width
		move.b	#32/2,obHeight(a0)			; set height
		move.b	#16/2,obWidth(a0)			; set width
; ---------------------------------------------------------------------------

Newt_Action:	; Routine 2
		moveq	#0,d0					; clear d0 (ob2ndRout is a byte, but we need word-addressing)
		move.b	ob2ndRout(a0),d0			; get secondary routine counter
		move.w	Newt_ActIndex(pc,d0.w),d1		; find current index in Newt_ActIndex
		jsr	Newt_ActIndex(pc,d1.w)			; jump there, then return here

		lea	(Ani_Newt).l,a1				; load Newtron animation script
		bsr.w	AnimateSprite				; animate with correct slope ID
		bra.w	RememberState				; display sprite, or delete object if offscreen
; ===========================================================================
Newt_ActIndex:	dc.w Newt_Action_ChkDistance-Newt_ActIndex	; 0
		dc.w Newt_Action_WaitDrop-Newt_ActIndex		; 2
		dc.w Newt_Action_MoveOnFloor-Newt_ActIndex	; 4
		dc.w Newt_Action_MoveInAir-Newt_ActIndex	; 6
		dc.w Newt_Action_GreenNewtron-Newt_ActIndex	; 8
; ===========================================================================

; .chkdistance:
Newt_Action_ChkDistance:
		bset	#0,obStatus(a0)				; make Newtron face right
		move.w	(v_player+obX).w,d0			; get Sonic's current X-position
		sub.w	obX(a0),d0				; calculate difference to Newtron
		bhs.s	.chkDistance				; if difference is positive, branch
		neg.w	d0					; make difference positive for check
		bclr	#0,obStatus(a0)				; make Newtron face left
	.chkDistance:
		cmpi.w	#128,d0					; is Sonic within 128 pixels of the Newtron?
		bhs.s	.return					; if not, branch

		addq.b	#2,ob2ndRout(a0)			; advance to Newt_Action_WaitDrop
		move.b	#1,obAnim(a0)				; use ".drop" animation

		tst.b	obSubtype(a0)				; is this a green, missile-firing Newtron? (subtype 1)
		beq.s	.return					; if not, branch
		move.w	#ArtTile_Newtron|Tile_Pal2,obGfx(a0)	; use alternate palette line
		move.b	#8,ob2ndRout(a0)			; advance to Newt_Action_GreenNewtron instead
		move.b	#4,obAnim(a0)				; use ".fires" animation

	.return:
		rts						; return
; ===========================================================================

; .type00:
Newt_Action_WaitDrop:
		cmpi.b	#4,obFrame(a0)				; has "appearing" animation finished?
		bhs.s	Newt_Action_Drop			; is yes, branch

		bset	#0,obStatus(a0)				; make Newtron face right
		move.w	(v_player+obX).w,d0			; get Sonic's current X-position
		sub.w	obX(a0),d0				; calculate difference to Newtron
		bhs.s	.return					; if difference is positive, branch
		bclr	#0,obStatus(a0)				; make Newtron face left

	.return:
		rts						; return
; ---------------------------------------------------------------------------

; .fall:
Newt_Action_Drop:
	if FixBugs=0
		; This would set the hitbox to be 40x32 instead of the flat 40x16
		; while on frame 1. However, the above branch will only trigger on
		; frame 4, making this condition impossible. It might've been a
		; leftover for green Newtrons before those got their own routine.
		cmpi.b	#1,obFrame(a0)				; has animation advanced to frame 1? (impossible here)
		bne.s	.fall					; if not, branch
		move.b	#col_40x32|col_badnik,obColType(a0)	; set collision size 40x32
	.fall:
	endif

		bsr.w	ObjectFall				; make Newtron fall
		bsr.w	ObjFloorDist				; get distance to floor
		tst.w	d1					; has Newtron hit the floor?
		bpl.s	.return					; if not, branch
		add.w	d1,obY(a0)				; align Newtron with floor on landing

		move.w	#0,obVelY(a0)				; stop Newtron falling
		addq.b	#2,ob2ndRout(a0)			; advance to Newt_Action_MoveOnFloor
		move.b	#2,obAnim(a0)				; use ".fly1" animation
	if FixBugs=0
		; Another impossible condition at this location, and likely another leftover
		; from an earlier implementation of the green Newtron badnik.
		btst	#5,obGfx(a0)				; is this a green Newtron? (checked by palette line)
		beq.s	.notGreen				; if not, branch
		addq.b	#1,obAnim(a0)				; use ".fly2" animation instead
	.notGreen:
	endif
		move.b	#col_40x16|col_badnik,obColType(a0)	; make destroyable (badnik, 40x16)
		move.w	#$200,obVelX(a0)			; move Newtron horizontally to the right
		btst	#0,obStatus(a0)				; is Newtron facing left?
		bne.s	.return					; if not, branch
		neg.w	obVelX(a0)				; move to the left instead

	.return:
		rts						; return
; ===========================================================================

; .matchfloor:
Newt_Action_MoveOnFloor:
		bsr.w	SpeedToPos				; move Newtron sideways

		bsr.w	ObjFloorDist				; get distance to floor
		cmpi.w	#-8,d1					; is there a steep upward slope ahead?
		blt.s	.detach					; if yes, branch
		cmpi.w	#$C,d1					; is there a large drop ahead?
		bge.s	.detach					; if yes, branch
		add.w	d1,obY(a0)				; match Newtron's position with floor as it moves
		rts						; return
; ---------------------------------------------------------------------------

	.detach:
		addq.b	#2,ob2ndRout(a0)			; advance to Newt_Action_MoveInAir (keep moving, but no longer align to floor)
		rts						; return
; ===========================================================================

; .speed:
Newt_Action_MoveInAir:
		bsr.w	SpeedToPos				; move Newtron sideways
		rts						; no longer align with floor
; ===========================================================================

; .type01:
Newt_Action_GreenNewtron:
		cmpi.b	#1,obFrame(a0)				; has animation advanced to frame 1 in script?
		bne.s	.chkFire				; if not, don't make Newtron destroyable yet
		move.b	#col_40x32|col_badnik,obColType(a0)	; make destroyable (badnik, 40x32)

	.chkFire:
		cmpi.b	#2,obFrame(a0)				; has animation advance to frame 2 in script?
		bne.s	.return					; if not, branch
		tst.b	newt_fired(a0)				; has a missile already been fired?
		bne.s	.return					; if yes, prevent firing again
		move.b	#1,newt_fired(a0)			; set "missile fired" flag

		bsr.w	FindFreeObj				; find a free object slot
		bne.s	.return					; if object RAM is full, branch
		_move.b	#id_Missile,obID(a1)			; load missile object
		move.w	obX(a0),obX(a1)				; copy Newtron's X-position
		move.w	obY(a0),obY(a1)				; copy Newtron's Y-position
		subq.w	#8,obY(a1)				; align missile vertically
		move.w	#$200,obVelX(a1)			; move missile to the right
		move.w	#$14,d0					; set horizontal alignment offset
		btst	#0,obStatus(a0)				; is Newtron facing left?
		bne.s	.alignX					; if not, branch
		neg.w	d0					; invert X-alignment offset
		neg.w	obVelX(a1)				; move missile to the left
	.alignX:
		add.w	d0,obX(a1)				; align missile horizontally

		move.b	obStatus(a0),obStatus(a1)		; copy X-flip flag to missile
		move.b	#1,obSubtype(a1)			; set missile object to "from Newtron"

	.return:
		rts						; return
; ===========================================================================

Newt_GreenDelete: ; Routine 4 (Called by green Newtrons from animation script, which increases obRoutine once it finished)

		; Note: This will delete green Newtrons once their animation has made thme invisible again,
		; but it will keep the "respawn block" flag set, making them not respawnable anymore.
		; It's hard to tell if this was the intended effect or an oversight.
		bra.w	DeleteObject				; delete green Newtron
; ===========================================================================

		include	"_anim/Newtron.asm"
Map_Newt:	include	"_maps/Newtron.asm"
