; ===========================================================================
; ---------------------------------------------------------------------------
; Object 5F - Walking Bomb enemy (SLZ, SBZ)
; ---------------------------------------------------------------------------

Bomb:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Bom_Index(pc,d0.w),d1
		jmp	Bom_Index(pc,d1.w)
; ===========================================================================
Bom_Index:	dc.w Bom_Main-Bom_Index		; 0
		dc.w Bom_Action-Bom_Index	; 2
		dc.w Bom_Fuse-Bom_Index		; 4
		dc.w Bom_Shrapnel-Bom_Index	; 6

bom_time:	equ objoff_30		; multi-purpose timer (walking, waiting, fuse)
bom_origY:	equ objoff_34		; fuse's original y-axis position independent it moving
bom_parent:	equ objoff_3C		; address of parent Bomb object (set but not used)
; ===========================================================================

Bom_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Bom_Action
		move.l	#Map_Bomb,obMap(a0)			; set mappings
		move.w	#ArtTile_Bomb,obGfx(a0)			; set art tile
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#3,obPriority(a0)			; set sprite priority
		move.b	#24/2,obActWid(a0)			; set sprite display width

		move.b	obSubtype(a0),d0			; get subtype (0 = normal badnik, 4 = fuse, 6 = shrapnel)
		beq.s	.normalBadnik				; if normal badnik, branch
		move.b	d0,obRoutine(a0)			; directly set alternate routine from subtype
		rts						; go there on next run
; ---------------------------------------------------------------------------

	.normalBadnik:
		move.b	#col_24x24|col_hurt,obColType(a0)	; set ReactToItem type (invincible and damaging)
		bchg	#0,obStatus(a0)				; face right by default (immediately gets changed to left on spawn)
; ---------------------------------------------------------------------------

Bom_Action:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	Bom_ActIndex(pc,d0.w),d1
		jsr	Bom_ActIndex(pc,d1.w)

		lea	(Ani_Bomb).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
Bom_ActIndex:	dc.w Bom_Action_Waiting-Bom_ActIndex		; 0
		dc.w Bom_Action_Walking-Bom_ActIndex		; 2
		dc.w Bom_Action_WaitAndExplode-Bom_ActIndex	; 4
; ===========================================================================

Bom_Action_Waiting:
		bsr.w	Bom_CheckStartFuse			; check if Sonic is in range of Bomb and start fuse if so

		subq.w	#1,bom_time(a0)				; decrement time delay before turning around
		bpl.s	.return					; if time remains, branch
		addq.b	#2,ob2ndRout(a0)			; advance to Bom_Action_Walking
		move.w	#(25*60)+36-1,bom_time(a0)		; set time delay before Bomb stops walking to just over 25.5 seconds
		move.w	#$10,obVelX(a0)				; slowly walk to the right
		move.b	#1,obAnim(a0)				; use walking animation
		bchg	#0,obStatus(a0)				; invert X-flip flag
		beq.s	.return					; if Bomb is facing to the right now, branch
		neg.w	obVelX(a0)				; slowly walk to the left instead

	.return:
		rts						; return
; ===========================================================================

Bom_Action_Walking:
		bsr.w	Bom_CheckStartFuse			; check if Sonic is in range of Bomb and start fuse if so

		subq.w	#1,bom_time(a0)				; decrement time delay before stopping to walk
		bmi.s	.stopWalking				; if time expired, branch
		bsr.w	SpeedToPos				; update Bomb's position
		rts						; return
; ---------------------------------------------------------------------------

	.stopWalking:
		subq.b	#2,ob2ndRout(a0)			; go back to Bom_Action_Waiting
		move.w	#(3*60)-1,bom_time(a0)			; set time delay before turning around to 3 seconds
		clr.w	obVelX(a0)				; stop walking
		move.b	#0,obAnim(a0)				; use waiting animation
		rts						; return
; ===========================================================================

Bom_Action_WaitAndExplode:
		subq.w	#1,bom_time(a0)				; decrement time delay before exploding
		bpl.s	.return					; if time remains, branch
		_move.b	#id_Explosion,obID(a0)			; change Bomb into an explosion
		move.b	#0,obRoutine(a0)			; set explosion object to init routine

	.return:
		rts						; return


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to start the fuse if Sonic is in range of the Walking Bomb.
; ---------------------------------------------------------------------------

Bom_CheckStartFuse:
		move.w	(v_player+obX).w,d0			; get Sonic's X-position
		sub.w	obX(a0),d0				; calculate X-difference
		bhs.s	.chkX					; if positive, branch
		neg.w	d0					; make positive for range check
	.chkX:	cmpi.w	#96,d0					; is Sonic horizontally within 96px of Bomb?
		bhs.s	.return					; if not, branch

		move.w	(v_player+obY).w,d0			; get Sonic's Y-position
		sub.w	obY(a0),d0				; calculate Y-difference
		bhs.s	.chkY					; if positive, branch
		neg.w	d0					; mkae positive for range check
	.chkY:	cmpi.w	#96,d0					; is Sonic vertically within 96px of Bomb?
		bhs.s	.return					; if not, branch

		tst.w	(v_debuguse).w				; is debug mode in use?
		bne.s	.return					; if yes, branch

		move.b	#4,ob2ndRout(a0)			; set to Bom_Action_WaitAndExplode
		move.w	#(2*60)+24-1,bom_time(a0)		; set fuse time to just over 2 seconds
		clr.w	obVelX(a0)				; stop Bomb moving
		move.b	#2,obAnim(a0)				; use activated animation

		bsr.w	FindNextFreeObj				; find a free object slot
		bne.s	.return					; if object RAM is full, branch
		_move.b	#id_Bomb,obID(a1)			; load fuse object
		move.w	obX(a0),obX(a1)				; copy X-position
		move.w	obY(a0),obY(a1)				; copy Y-position
		move.w	obY(a0),bom_origY(a1)			; remember original Y-position when making shrapnel
		move.b	obStatus(a0),obStatus(a1)		; copy X/Y-flip flags
		move.b	#4,obSubtype(a1)			; set fuse to use Bom_Fuse routine
		move.b	#3,obAnim(a1)				; set to fuse animation

		move.w	#$10,obVelY(a1)				; make fuse slowly move down
		btst	#1,obStatus(a0)				; is bomb upside-down?
		beq.s	.finishFuse				; if not, branch
		neg.w	obVelY(a1)				; make fuse move up instead

	.finishFuse:
		move.w	#(2*60)+24-1,bom_time(a1)		; set fuse time to just over 2 seconds
		move.l	a0,bom_parent(a1)			; make fuse remember parent bomb object (unused)

	.return:
		rts						; return
; End of function Bom_CheckStartFuse

; ===========================================================================

Bom_Fuse:	; Routine 4
		bsr.s	Bom_BurnFuseAndExplode			; advance fuse and spawn shrapnel once expired

		lea	(Ani_Bomb).l,a1				; load animation script
		bsr.w	AnimateSprite				; animate fuse
		bra.w	RememberState				; display or delete fuse

; ---------------------------------------------------------------------------
; Subroutine to advance burning the fuse, and spawn shrapnel on expiration.
; ---------------------------------------------------------------------------

Bom_BurnFuseAndExplode:
		subq.w	#1,bom_time(a0)				; decrement fuse timer
		bmi.s	.fuseExpired				; if timer expired, branch
		bsr.w	SpeedToPos				; update fuse's position
		rts						; return
; ---------------------------------------------------------------------------

.fuseExpired:
	if FixBugs
		; Avoid returning to Bom_Fuse to prevent display-and-delete
		; and double-delete bugs.
		addq.l	#4,sp					; skip returning to Bom_Fuse
	endif
		clr.w	bom_time(a0)				; clear fuse timer
		clr.b	obRoutine(a0)				; clear routine counter (redundant here)
		move.w	bom_origY(a0),obY(a0)			; restore initial Y-position of bomb

		moveq	#4-1,d1					; load four shrapnels
		movea.l	a0,a1					; replace fuse with first shrapnel object
		lea	(Bom_ShrSpeed).l,a2			; load shrapnel speed data
		bra.s	.firstShrapnel				; first shrapnel doesn't need a free object slot
; ---------------------------------------------------------------------------

.loopShrapnel:
		bsr.w	FindNextFreeObj				; find a free object slot
		bne.s	.nextShrapnel				; if object RAM is full, branch (should probably branch after the dbf...)

	.firstShrapnel:
		_move.b	#id_Bomb,obID(a1)			; load shrapnel object
		move.w	obX(a0),obX(a1)				; copy X-position
		move.w	obY(a0),obY(a1)				; copy Y-position
		move.b	#6,obSubtype(a1)			; set shrapnel to use Bom_Shrapnel routine
		move.b	#4,obAnim(a1)				; use shrapnel animation
		move.w	(a2)+,obVelX(a1)			; get next X-velocity from speed data
		move.w	(a2)+,obVelY(a1)			; get next Y-velocity from speed data
		move.b	#col_8x8|col_hurt,obColType(a1)		; set ReactToItem type (damaging)
		bset	#sprite_rendered_bit,obRender(a1)	; make sure shrapnel doesn't get immediately deleted from "obRender bpl" check below

	.nextShrapnel:
		dbf	d1,.loopShrapnel			; repeat 3 more times

		move.b	#6,obRoutine(a0)			; set root object (previously the fuse) to Bom_Shrapnel routine
		; Continue straight to Bom_Shrapnel for first shrapnel...

; End of function Bom_BurnFuseAndExplode
; ---------------------------------------------------------------------------

Bom_Shrapnel:	; Routine 6
		bsr.w	SpeedToPos				; update shrapnel's position
		addi.w	#$18,obVelY(a0)				; make shrapnel fall faster

		lea	(Ani_Bomb).l,a1				; load animation script
		bsr.w	AnimateSprite				; animate shrapnel

		tst.b	obRender(a0)				; has shrapnel gone offscreen?
		bpl.w	DeleteObject				; if yes, delete it
		bra.w	DisplaySprite				; otherwise, display shrapnel
; ===========================================================================

Bom_ShrSpeed:	;    X-vel  Y-vel
		dc.w -$200, -$300	; 1st shrapnel
		dc.w -$100, -$200	; 2nd shrapnel
		dc.w  $200, -$300	; 3rd shrapnel
		dc.w  $100, -$200	; 4th shrapnel
; ===========================================================================

		include	"_anim/Bomb Enemy.asm"
Map_Bomb:	include	"_maps/Bomb Enemy.asm"
