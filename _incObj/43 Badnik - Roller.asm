; ===========================================================================
; ---------------------------------------------------------------------------
; Object 43 - Roller enemy (SYZ)
; ---------------------------------------------------------------------------

Roller:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Roll_Index(pc,d0.w),d1
		jmp	Roll_Index(pc,d1.w)
; ===========================================================================
Roll_Index:	dc.w Roll_Main-Roll_Index
		dc.w Roll_Action-Roll_Index

roll_waitunfolded:	equ objoff_30	; frames to wait in destroyable, unfolded state
roll_stateflags:	equ objoff_32	; flags (bit 0 set if hit a ledge before // bit 7 set if Roller has unfolded before)
; ===========================================================================

Roll_Main:	; Routine 0
		move.b	#28/2,obHeight(a0)			; set height
		move.b	#16/2,obWidth(a0)			; set width

		; Make the Roller fall until it has collided with the floor (while invisible)
		bsr.w	ObjectFall				; increase gravity and update position
		bsr.w	ObjFloorDist				; get distance between Roller and floor
		tst.w	d1					; has Roller hit the floor?
		bpl.s	.hide					; if not, branch
		add.w	d1,obY(a0)				; match object's position with the floor
		move.w	#0,obVelY(a0)				; clear falling speed
		addq.b	#2,obRoutine(a0)			; advance to Moto_Action
		move.l	#Map_Roll,obMap(a0)			; set mappings
		move.w	#ArtTile_Roller,obGfx(a0)		; set art tile
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.b	#32/2,obActWid(a0)			; set sprite display width

	.hide:
		rts						; return (and do NOT display sprite yet)
; ===========================================================================

Roll_Action:	; Routine 2
		moveq	#0,d0					; clear d0
		move.b	ob2ndRout(a0),d0			; get secondary routine counter
		move.w	Roll_ActIndex(pc,d0.w),d1		; find current secondary index
		jsr	Roll_ActIndex(pc,d1.w)			; jump there and return here

		lea	(Ani_Roll).l,a1				; load animation script
		bsr.w	AnimateSprite				; animate Roller

	if FixBugs
		bra.w	RememberState				; display or handle offscreen deletion
	else
		; This is an exact copy-paste of the RememberState subroutine, except that
		; it uses bgt instead of bhi for the offscreen check. As a result, Rollers
		; cannot despawn when going too far offscreen to the left, which can cause
		; occasional double spawnings. It's not exactly clear if this behavior was
		; intended or if it's an oversight, but it's definitely very inconsistent.
		move.w	obX(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bgt.w	.offscreen	; <-- bgt (signed check) instead of the usual bhi (unsigned check)!
		bra.w	DisplaySprite
	; ---------------------------------------------------------------------------

	.offscreen:
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	.delete
		bclr	#7,2(a2,d0.w)
	.delete:
		bra.w	DeleteObject
	endif

; ===========================================================================
Roll_ActIndex:	dc.w Roll_Action_FromLeft-Roll_ActIndex		; 0
		dc.w Roll_Action_Unfolded-Roll_ActIndex		; 2
		dc.w Roll_Action_Rolling-Roll_ActIndex		; 4
		dc.w Roll_Action_Jumping-Roll_ActIndex		; 6
; ===========================================================================

Roll_Action_FromLeft:
		move.w	(v_player+obX).w,d0			; get Sonic's X-position
		subi.w	#256,d0					; check 256px to the left
		blo.s	.returnAndSkip				; if near left level boundary, branch
		sub.w	obX(a0),d0				; check distance between Roller and Sonic
		blo.s	.returnAndSkip				; if Sonic isn't more than 256px to the right of Roller, branch

		addq.b	#4,ob2ndRout(a0)			; advance to Roll_Action_Rolling
		move.b	#2,obAnim(a0)				; set to rolling animation
		move.w	#$700,obVelX(a0)			; move Roller horizontally to the right
		move.b	#col_28x28|col_hurt,obColType(a0)	; make Roller invincible and damaging ($8E)

	.returnAndSkip:
		addq.l	#4,sp					; skip returning to Roll_Action to avoid sprite render and despawning
		rts						; return
; ===========================================================================

Roll_Action_Unfolded:
		cmpi.b	#2,obAnim(a0)				; has Roller advanced to rolling animation again? (handled in animation script)
		beq.s	.rollAgain				; if yes, branch
		subq.w	#1,roll_waitunfolded(a0)		; has exposed, unrolled timer run out?
		bpl.s	.return					; if not, branch

		move.b	#1,obAnim(a0)				; set to re-folding animation (sets itself to rolling animation once finished)
		move.w	#$700,obVelX(a0)			; move Roller horizontally to the right
		move.b	#col_28x28|col_hurt,obColType(a0)	; make Roller invincible and damaging again ($8E)

	.return:
		rts						; return
; ---------------------------------------------------------------------------

	.rollAgain:
		addq.b	#2,ob2ndRout(a0)			; advance to Roll_Action_Rolling
		rts						; return
; ===========================================================================

Roll_Action_Rolling:
		bsr.w	Roll_Action_StopAndUnfold		; (only once) make Roller stop and unfold 48px left of Sonic
		bsr.w	SpeedToPos				; update Roller's position

		bsr.w	ObjFloorDist				; find Roller's distance to floor
		cmpi.w	#-8,d1					; is there a steep upward slope ahead?
		blt.s	.ledgeHit				; if yes, branch
		cmpi.w	#$C,d1					; is there a large drop ahead?
		bge.s	.ledgeHit				; if yes, branch
		add.w	d1,obY(a0)				; match Roller's position with the floor
		rts						; return
; ---------------------------------------------------------------------------

	.ledgeHit:
		addq.b	#2,ob2ndRout(a0)			; advance to Roll_Action_Jumping
		bset	#0,roll_stateflags(a0)			; set flag that Roller hit a ledge before
		beq.s	.return					; if this is the first ledge hit, branch
		move.w	#-$600,obVelY(a0)			; launch Roller upwards

	.return:
		rts						; return
; ===========================================================================

Roll_Action_Jumping:
		bsr.w	ObjectFall				; make Roller fall and update positions

		tst.w	obVelY(a0)				; is Roller still going upwards?
		bmi.s	.return					; if yes, branch
		bsr.w	ObjFloorDist				; get distance to floor
		tst.w	d1					; has Roller hit the floor again?
		bpl.s	.return					; if not, branch

		add.w	d1,obY(a0)				; match Roller's position with the floor
		subq.b	#2,ob2ndRout(a0)			; go back to Roll_Action_Rolling
		move.w	#0,obVelY(a0)				; stop Roller falling

	.return:
		rts						; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Only once: Subroutine to check if Roller is 48px to the left of Sonic,
; then stop it, unfold it, make it destroyable, and set to waiting state.
; ---------------------------------------------------------------------------

Roll_Action_StopAndUnfold:
		tst.b	roll_stateflags(a0)			; has Roller already stopped before? (bit 7)
		bmi.s	.return					; if yes, don't allow it to stop again

		move.w	(v_player+obX).w,d0			; get Sonic's current X-position
		subi.w	#48,d0					; check 48px to the left
		sub.w	obX(a0),d0				; calculate X-difference to Roller
		bhs.s	.return					; if Roller isn't within 48px to the left of Sonic, branch

		move.b	#0,obAnim(a0)				; set to unfolding animation
		move.b	#col_28x28|col_badnik,obColType(a0)	; make Roller destroyable ($E)
		clr.w	obVelX(a0)				; stop Roller moving horizontally
		move.w	#2*60,roll_waitunfolded(a0)		; set waiting time in unfolded state to 2 seconds
		move.b	#2,ob2ndRout(a0)			; set to Roll_Action_Unfolded

		bset	#7,roll_stateflags(a0)			; set flag to prevent Roll_Action_StopAndUnfold from running again

	.return:
		rts						; return
; End of function Roll_Action_StopAndUnfold

; ===========================================================================

		include	"_anim/Roller.asm"
Map_Roll:	include	"_maps/Roller.asm"
