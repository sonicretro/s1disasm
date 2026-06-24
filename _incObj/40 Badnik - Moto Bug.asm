; ===========================================================================
; ---------------------------------------------------------------------------
; Object 40 - Moto Bug enemy (GHZ)
; ---------------------------------------------------------------------------

MotoBug:
		moveq	#0,d0				; clear d0 (for word-based addressing)
		move.b	obRoutine(a0),d0		; get current object routine
		move.w	Moto_Index(pc,d0.w),d1		; find current index in jump table
		jmp	Moto_Index(pc,d1.w)		; jump there
; ===========================================================================
Moto_Index:	dc.w Moto_Main-Moto_Index		; 0 - initialization
		dc.w Moto_Action-Moto_Index		; 2 - main mode
		dc.w Moto_Smoke_Animate-Moto_Index	; 4 - smoke 
		dc.w Moto_Smoke_Delete-Moto_Index	; 6 - delete smoke

moto_ledgewait:	equ	objoff_30			; wait time when reaching a ledge before turning around
moto_smokewait:	equ	objoff_33			; interval between spawning smoke particle objects
; ===========================================================================

Moto_Main:	; Routine 0
		move.l	#Map_Moto,obMap(a0)		; set mappings
		move.w	#ArtTile_Moto_Bug,obGfx(a0)	; set art tile
		move.b	#sprite_cam_field,obRender(a0)	; set to playfield-positioned mode
		move.b	#4,obPriority(a0)		; set sprite priority
		move.b	#40/2,obActWid(a0)		; set sprite display width

		tst.b	obAnim(a0)			; is this a smoke particle object?
		bne.s	.smoke				; if yes, branch
		move.b	#28/2,obHeight(a0)		; set object height
		move.b	#16/2,obWidth(a0)		; set object width
		move.b	#col_40x32|col_badnik,obColType(a0) ; set collision type for ReactToItem

		; Make the Motobug fall until it has collided with the floor (while invisible)
		bsr.w	ObjectFall			; increase gravity and update position
		jsr	(ObjFloorDist).l		; get distance between Motobug and floor
		tst.w	d1				; has Motobug hit the floor?
		bpl.s	.hide				; if not, branch
		add.w	d1,obY(a0)			; match object's position with the floor
		move.w	#0,obVelY(a0)			; clear falling speed
		addq.b	#2,obRoutine(a0)		; advance to Moto_Action
		bchg	#0,obStatus(a0)			; make Motobug face to the left on spawn
	.hide:
		rts					; return (and do NOT display sprite yet)
; ---------------------------------------------------------------------------

	.smoke:
		addq.b	#4,obRoutine(a0)		; set to Moto_Smoke_Animate
		bra.w	Moto_Smoke_Animate		; branch there immediately
; ===========================================================================

Moto_Action:	; Routine 2
		moveq	#0,d0				; clear d0
		move.b	ob2ndRout(a0),d0		; get secondary routine counter
		move.w	Moto_ActIndex(pc,d0.w),d1	; find current secondary index
		jsr	Moto_ActIndex(pc,d1.w)		; jump there and return here

		lea	(Ani_Moto).l,a1			; load animation script
		bsr.w	AnimateSprite			; animate Motobug
		; fall-through to RememberState...
; ---------------------------------------------------------------------------

		; RememberState is included here and Moto_Action terminates in it (ends with an rts).
		; The Motobug was likely the first object where that subroutine was introduced,
		; and the developers never cleanly moved it elsewhere, despite it being heavily reused.

		include	"_incObj/sub RememberState.asm"	; check if offscreen: display sprite if no, delete if yes

; ===========================================================================
Moto_ActIndex:	dc.w Moto_Action_Ledge-Moto_ActIndex	; 0 - waiting at a ledge
		dc.w Moto_Action_Drive-Moto_ActIndex	; 2 - driving and spawning smoke particles
; ===========================================================================

Moto_Action_Ledge:
		subq.w	#1,moto_ledgewait(a0)		; subtract 1 from pause time
		bpl.s	.wait				; if time remains, branch

		addq.b	#2,ob2ndRout(a0)		; advance to Moto_Action_Drive
		move.w	#-$100,obVelX(a0)		; move Motobug to the left
		move.b	#1,obAnim(a0)			; use "drive" animation
		bchg	#0,obStatus(a0)			; invert X-flip flag
		bne.s	.wait				; is Motobug facing to the right now? if not, branch
		neg.w	obVelX(a0)			; change direction to make Motobug move to the right
	.wait:
		rts					; return
; ===========================================================================

Moto_Action_Drive:
		bsr.w	SpeedToPos			; update Motobug's position based on velocities

		jsr	(ObjFloorDist).l		; find Motobug's distance to floor
		cmpi.w	#-8,d1				; is there a steep upward slope ahead?
		blt.s	.ledgeHit			; if yes, stop Motobug
		cmpi.w	#$C,d1				; is there a large drop ahead?
		bge.s	.ledgeHit			; if yes, stop Motobug
		add.w	d1,obY(a0)			; match Motobug's position with the floor

		subq.b	#1,moto_smokewait(a0)		; decrement delay until next smoke particle spawn
		bpl.s	.return				; if time remains, branch
		move.b	#16-1,moto_smokewait(a0)	; reset smoke delay timer

		bsr.w	FindFreeObj			; find a free object slot
		bne.s	.return				; if object RAM is full, branch
		_move.b	#id_MotoBug,obID(a1)		; load exhaust smoke particle object (handled through obAnim)
		move.w	obX(a0),obX(a1)			; copy Motobug's X-position
		move.w	obY(a0),obY(a1)			; copy Motobug's Y-position
		move.b	obStatus(a0),obStatus(a1)	; copy Motobug's status flags (i.e. flipped or not)
		move.b	#2,obAnim(a1)			; set to smoke animation
	.return:
		rts					; return
; ---------------------------------------------------------------------------

.ledgeHit:
		subq.b	#2,ob2ndRout(a0)		; go back to Moto_Action_Ledge
		move.w	#60-1,moto_ledgewait(a0)	; set time to wait at ledge to 1 second
		move.w	#0,obVelX(a0)			; stop the Motobug moving
		move.b	#0,obAnim(a0)			; set to "wait" animation
		rts					; return
; ===========================================================================

Moto_Smoke_Animate: ; Routine 4
		lea	(Ani_Moto).l,a1			; load animation script
		bsr.w	AnimateSprite			; advance animation (for smoke, obRoutine will increase on finish)
		bra.w	DisplaySprite			; display smoke sprite
; ===========================================================================

Moto_Smoke_Delete: ; Routine 6
		bra.w	DeleteObject			; delete smoke object
; ===========================================================================

		include	"_anim/Moto Bug.asm"
Map_Moto:	include	"_maps/Moto Bug.asm"
