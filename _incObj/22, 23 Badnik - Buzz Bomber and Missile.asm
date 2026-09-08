; ===========================================================================
; ---------------------------------------------------------------------------
; Object 22 - Buzz Bomber enemy (GHZ, MZ, SYZ)
; ---------------------------------------------------------------------------

BuzzBomber:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Buzz_Index(pc,d0.w),d1
		jmp	Buzz_Index(pc,d1.w)
; ===========================================================================
Buzz_Index:	dc.w Buzz_Main-Buzz_Index	; 0
		dc.w Buzz_Action-Buzz_Index	; 2
		dc.w Buzz_Delete-Buzz_Index	; 4

buzz_timedelay:	equ objoff_32	; time delays for flying and before/during/after firing a missile
buzz_buzzstate:	equ objoff_34	; state flags (0 = normal // 1 = just fired // 2 = near Sonic, before firing)
; ===========================================================================

Buzz_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Buzz_Action
		move.l	#Map_Buzz,obMap(a0)			; set mappings
		move.w	#ArtTile_Buzz_Bomber,obGfx(a0)		; set art tile
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#3,obPriority(a0)			; set sprite priority
		move.b	#col_48x24|col_badnik,obColType(a0)	; set ReactToItem entry to 8 (badnik, 48x24)
		move.b	#48/2,obActWid(a0)			; set sprite display width
; ---------------------------------------------------------------------------

Buzz_Action:	; Routine 2
		moveq	#0,d0					; clear d0 (ob2ndRout is a byte, but we need word-addressing)
		move.b	ob2ndRout(a0),d0			; get secondary routine counter
		move.w	Buzz_ActIndex(pc,d0.w),d1		; find current index in Buzz_ActIndex
		jsr	Buzz_ActIndex(pc,d1.w)			; jump there, then return here

		lea	(Ani_Buzz).l,a1				; load Buzz Bomber animation script
		bsr.w	AnimateSprite				; animate with correct slope ID
		bra.w	RememberState				; display sprite, or delete object if offscreen
; ===========================================================================
Buzz_ActIndex:	dc.w Buzz_Action_Wait-Buzz_ActIndex		; 0
		dc.w Buzz_Action_Move-Buzz_ActIndex		; 2
; ===========================================================================

; .move:
Buzz_Action_Wait:
		subq.w	#1,buzz_timedelay(a0)			; decrement time delay
		bpl.s	.return					; if time remains, branch
		btst	#1,buzz_buzzstate(a0)			; has flag been set that Buzz Bomber is near Sonic?
		bne.s	Buzz_Action_Fire			; if yes, branch

		addq.b	#2,ob2ndRout(a0)			; set to Buzz_Action_Move
		move.w	#128-1,buzz_timedelay(a0)		; set flight time to just over 2 seconds
		move.w	#$400,obVelX(a0)			; move Buzz Bomber to the right
		move.b	#1,obAnim(a0)				; use "flying" animation
		btst	#0,obStatus(a0)				; is Buzz Bomber facing left?
		bne.s	.return					; if not, branch
		neg.w	obVelX(a0)				; move Buzz Bomber to the left instead

	.return:
		rts						; return
; ---------------------------------------------------------------------------

; .fire:
Buzz_Action_Fire:
		bsr.w	FindFreeObj				; find a free object slot
		bne.s	.return					; if object RAM is full, branch
		_move.b	#id_Missile,obID(a1)			; load missile object
		move.w	obX(a0),obX(a1)				; copy Buzz Bomber's X-position
		move.w	obY(a0),obY(a1)				; copy Buzz Bomber's Y-position
		addi.w	#$1C,obY(a1)				; align missile vertically
		move.w	#$200,obVelY(a1)			; move missile downwards
		move.w	#$200,obVelX(a1)			; move missile to the right
	if FixBugs
		moveq	#$18-4,d0				; set horizontal alignment offset (corrected)
	else
		; This horizontal offset is misaligned with the Buzz Bomber's sprites.
		move.w	#$18,d0					; set horizontal alignment offset
	endif
		btst	#0,obStatus(a0)				; is Buzz Bomber facing left?
		bne.s	.alignX					; if not, branch
		neg.w	d0					; invert X-alignment offset
		neg.w	obVelX(a1)				; move missile to the left
	.alignX:
		add.w	d0,obX(a1)				; align missile horizontally

		move.b	obStatus(a0),obStatus(a1)		; copy X-flip flag to missile
		move.w	#15-1,msl_timedelay(a1)			; set 15 frames delay before missile becomes active
		move.l	a0,msl_parent(a1)			; make missile remember the parent object
		move.b	#1,buzz_buzzstate(a0)			; set Buzz Bomber to "already fired" to prevent refiring
		move.w	#60-1,buzz_timedelay(a0)		; stay on firing animation for 1 second
		move.b	#2,obAnim(a0)				; use "firing" animation

	.return:
		rts						; return
; ===========================================================================

; .chknearsonic:
Buzz_Action_Move:
		subq.w	#1,buzz_timedelay(a0)			; decrement remaining flight time
		bmi.s	.changeDirection			; if timer expired, branch

		bsr.w	SpeedToPos				; update Buzz Bomber's position

		tst.b	buzz_buzzstate(a0)			; has Buzz Bomber just fired already?
		bne.s	.return					; if yes, prevent firing again until it changed direction

		move.w	(v_player+obX).w,d0			; get Sonic's X-position
		sub.w	obX(a0),d0				; calculate difference to Buzz Bomber's X-position
		bpl.s	.checkDistance				; if positive, branch
		neg.w	d0					; make difference positive for check
	.checkDistance:
		cmpi.w	#96,d0					; is Buzz Bomber within 96 pixels of Sonic?
		bhs.s	.return					; if not, branch
		tst.b	obRender(a0)				; is Buzz Bomber on screen?
		bpl.s	.return					; if not, branch

		move.b	#2,buzz_buzzstate(a0)			; set Buzz Bomber to "near Sonic"
		move.w	#30-1,buzz_timedelay(a0)		; set time delay before firing to half a second
		bra.s	.stopMoving				; stop Buzz Bomber moving to prepare for fire
; ---------------------------------------------------------------------------

.changeDirection:
		move.b	#0,buzz_buzzstate(a0)			; set Buzz Bomber state to "normal" (no firing)
		bchg	#0,obStatus(a0)				; reverse direction
		move.w	#60-1,buzz_timedelay(a0)		; set delay before starting to move again to 1 second

	.stopMoving:
		subq.b	#2,ob2ndRout(a0)			; got back to Buzz_Action_Wait
		move.w	#0,obVelX(a0)				; stop Buzz Bomber moving
		move.b	#0,obAnim(a0)				; use "hovering" animation

	.return:
		rts						; return
; ===========================================================================

Buzz_Delete:	; Routine 4 (unreachable, deletion is handled elsewhere)
		bsr.w	DeleteObject				; delete object
		rts						; return


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 23 - Missile launched by Buzz Bomber and wall Newtron badniks
; ---------------------------------------------------------------------------

Missile:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Msl_Index(pc,d0.w),d1
		jmp	Msl_Index(pc,d1.w)
; ===========================================================================
Msl_Index:	dc.w Msl_Main-Msl_Index		; 0
		dc.w Msl_Animate-Msl_Index	; 2
		dc.w Msl_FromBuzz-Msl_Index	; 4
		dc.w Msl_Delete-Msl_Index	; 6
		dc.w Msl_FromNewt-Msl_Index	; 8

msl_timedelay:	equ objoff_32	; delay before loading missile (Buzz Bomber missile only)
msl_parent:	equ objoff_3C	; parent object (Buzz Bomber missile only)
; ===========================================================================

Msl_Main:	; Routine 0
		subq.w	#1,msl_timedelay(a0)			; decrement delay before loading missile
		bpl.s	Msl_ChkCancel				; if time remains, check if parent has been destroyed to cancel it

		addq.b	#2,obRoutine(a0)			; advance to Msl_Animate
		move.l	#Map_Missile,obMap(a0)			; set mappings
		move.w	#ArtTile_Buzz_Bomber|Tile_Pal2,obGfx(a0) ; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#3,obPriority(a0)			; set sprite priority
		move.b	#16/2,obActWid(a0)			; set sprite display width
		andi.b	#3,obStatus(a0)				; clear status flags except X/Y-flip flags

		tst.b	obSubtype(a0)				; was object created by a Newtron?
		beq.s	Msl_Animate				; if not, branch
		move.b	#8,obRoutine(a0)			; set to Msl_FromNewt
		move.b	#col_12x12|col_hurt,obColType(a0)	; set ReactToItem entry to $87 (damaging, 12x12)
		move.b	#1,obAnim(a0)				; set animation directly to ".missile"
		bra.s	Msl_FromNewt_Animate			; branch to animate and move missile
; ===========================================================================

Msl_Animate:	; Routine 2
		bsr.s	Msl_ChkCancel				; check if parent Buzz Bomber has been destroyed, delete missile if so
	if FixBugs
		; Msl_ChkCancel can call DeleteObject, so we shouldn't queue
		; this object for display or update the animation state.
		bne.s	.display				; has missile been deleted by Msl_ChkCancel? if not, branch
		rts						; return without displaying deleted missile
	endif

	.display:
		lea	(Ani_Missile).l,a1			; load animation script
		bsr.w	AnimateSprite				; animate missile (animation 0 ".flare" will advance obRoutine once it's finished)
		bra.w	DisplaySprite				; display missile sprite

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to check if the Buzz Bomber which fired the missile has been
; destroyed, and if it has, then cancel the missile
; ---------------------------------------------------------------------------

Msl_ChkCancel:
		movea.l	msl_parent(a0),a1			; load parent Buzz Bomber object
		_cmpi.b	#id_ExplosionItem,obID(a1)		; has Buzz Bomber been destroyed?
	if FixBugs
		; This adds a return value so that we know if the object has been freed.
		bne.s	.return					; if not, branch (Z-flag = 0)
		bsr.s	Msl_Delete				; delete missile and return here
		moveq	#0,d0					; notify caller that missile has been deleted (Z-flag = 1)
	else
		beq.s	Msl_Delete				; if yes, delete missile
	endif

	.return:
		rts						; return with result in Z-flag
; End of function Msl_ChkCancel

; ===========================================================================

Msl_FromBuzz:	; Routine 4
		; This check would change the missile into a small explosion object
		; (the same one used by the prototype front-facing Ball Hog badniks)
		; if bit 7 was set in its status flags. However, this flag never gets
		; set, and even if it was, the small explosion's graphics are broken.
		btst	#7,obStatus(a0)				; has bit 7 of status flags been set? (impossible condition)
		bne.s	.explode				; if yes, dissolve missile

		move.b	#col_12x12|col_hurt,obColType(a0)	; set ReactToItem entry to $87 (damaging, 12x12)
		move.b	#1,obAnim(a0)				; set to ".missile" animation
		bsr.w	SpeedToPos				; update missile position

	if FixBugs=0
		; Object should not call DisplaySprite and DeleteObject on
		; the same frame, or else cause a null-pointer dereference.
		lea	(Ani_Missile).l,a1			; load animation script
		bsr.w	AnimateSprite				; animate missile
		bsr.w	DisplaySprite				; display missile
	endif
		move.w	(v_limitbtm2).w,d0			; load bottom level boundary
		addi.w	#224,d0					; add screen height
		cmp.w	obY(a0),d0				; has missile moved below the bottom level boundary?
		blo.s	Msl_Delete				; if yes, delete it
	if FixBugs
		lea	(Ani_Missile).l,a1			; load animation script
		bsr.w	AnimateSprite				; animate missile
		bra.w	DisplaySprite				; display missile
	else
		rts						; return
	endif
; ---------------------------------------------------------------------------

.explode:	; Unreachable code (see notes above).
		_move.b	#id_UnusedExplosion,obID(a0)		; change object to a small explosion ($24)
		move.b	#0,obRoutine(a0)			; reset routine counter
		bra.w	UnusedExplosion				; jump to unused explosion code
; ===========================================================================

Msl_Delete:	; Routine 6
		bsr.w	DeleteObject				; delete missile
		rts						; return
; ===========================================================================

Msl_FromNewt:	; Routine 8
		tst.b	obRender(a0)				; is missile still on screen?
		bpl.s	Msl_Delete				; if not, delete it
		bsr.w	SpeedToPos				; update missile's position

Msl_FromNewt_Animate:
		lea	(Ani_Missile).l,a1			; load animation script
		bsr.w	AnimateSprite				; animate missile
		bsr.w	DisplaySprite				; display missile sprite
		rts						; return
; ===========================================================================

		include	"_anim/Buzz Bomber.asm"
		include	"_anim/Buzz Bomber Missile.asm"
Map_Buzz:	include	"_maps/Buzz Bomber.asm"
Map_Missile:	include	"_maps/Buzz Bomber Missile.asm"
