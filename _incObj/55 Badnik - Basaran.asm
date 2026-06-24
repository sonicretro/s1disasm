; ===========================================================================
; ---------------------------------------------------------------------------
; Object 55 - Basaran enemy (MZ)
; ---------------------------------------------------------------------------

Basaran:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Bas_Index(pc,d0.w),d1
		jmp	Bas_Index(pc,d1.w)
; ===========================================================================
Bas_Index:	dc.w Bas_Main-Bas_Index		; 0
		dc.w Bas_Action-Bas_Index	; 2

bas_sonicY:	equ objoff_36	; copy of Sonic's Y-position when Basaran started to drop down
; ===========================================================================

Bas_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Bas_Action
		move.l	#Map_Bas,obMap(a0)			; set mappings
		move.w	#ArtTile_Basaran|Tile_Prio,obGfx(a0)	; set art tile and priority flag
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#24/2,obHeight(a0)			; set height
		move.b	#2,obPriority(a0)			; set sprite priority
		move.b	#col_16x16|col_badnik,obColType(a0)	; set ReactToItem type ($B)
		move.b	#32/2,obActWid(a0)			; set sprite display width
; ---------------------------------------------------------------------------

Bas_Action:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	Bas_ActIndex(pc,d0.w),d1
		jsr	Bas_ActIndex(pc,d1.w)

		lea	(Ani_Bas).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
Bas_ActIndex:	dc.w Bas_Action_ChkSonic-Bas_ActIndex		; 0
		dc.w Bas_Action_DropDown-Bas_ActIndex		; 2
		dc.w Bas_Action_Fly-Bas_ActIndex		; 4
		dc.w Bas_Action_BackToCeiling-Bas_ActIndex	; 6
; ===========================================================================

; .dropcheck:
Bas_Action_ChkSonic:
		move.w	#128,d2					; set trigger zone to drop from ceiling to 96px
		bsr.w	Bas_CheckDistanceAndFaceSonic		; is Sonic (horizontally) within 128px of the Basaran?
		bhs.s	.return					; if not, branch

		move.w	(v_player+obY).w,d0			; get Sonic's Y-position
		move.w	d0,bas_sonicY(a0)			; remember Sonic's Y-position for drop-down
		sub.w	obY(a0),d0				; calculate Y-difference
		blo.s	.return					; if Sonic is above Basaran, branch
		cmpi.w	#128,d0					; is Sonic (vertically) within 128px below the Basaran?
		bhs.s	.return					; if not, branch
		tst.w	(v_debuguse).w				; is debug mode in use?
		bne.s	.return					; if yes, branch

		; This restricts Basarans to only drop down once every 8 frames,
		; further affected by RAM location. While not entirely clear,
		; perhaps it's to make sure multiple Basarans don't fly in sync.
		; The same restriction exists for flying back up to a ceiling.
		move.b	(v_vblank_byte).w,d0			; get current VBlank frame counter
		add.b	d7,d0					; add index in object RAM
		andi.b	#7,d0					; limit result to 0-7
		bne.s	.return					; if result is non-zero, don't drop down yet

		move.b	#1,obAnim(a0)				; set to drop-down animation
		addq.b	#2,ob2ndRout(a0)			; advance to Bas_Action_DropDown

	.return:
		rts						; return
; ===========================================================================

; .dropfly:
Bas_Action_DropDown:
		bsr.w	SpeedToPos				; update Basaran's position
		addi.w	#$18,obVelY(a0)				; make Basaran fall

		move.w	#128,d2					; set trigger zone check to 128px (unused here)
		bsr.w	Bas_CheckDistanceAndFaceSonic		; make Basaran face Sonic as it falls (distance check is ignored here)

		move.w	bas_sonicY(a0),d0			; get Sonic's Y-position at the moment the Basaran started dropping down
		sub.w	obY(a0),d0				; calculate Y-difference to current Basaran position
		blo.s	Bas_Action_DropDown_Delete		; if Sonic was above Basaran when it dropped, branch (this can't ever happen)
		cmpi.w	#16,d0					; has Basaran dropped down to within 16px of where Sonic was when it started falling?
		bhs.s	.return					; if not, branch

		move.w	d1,obVelX(a0)				; move left or right (set in Bas_CheckDistanceAndFaceSonic)
		move.w	#0,obVelY(a0)				; stop Basaran falling
		move.b	#2,obAnim(a0)				; set to flying animation
		addq.b	#2,ob2ndRout(a0)			; advance to Bas_Action_Fly

	.return:
		rts						; return
; ---------------------------------------------------------------------------

Bas_Action_DropDown_Delete:
		; This would delete the Basaran if it somehow started to drop down
		; even though Sonic was vertically above it as it began falling.
		; Due to the way the logic is laid out, this can't ever happen.

	if FixBugs
		; Objects shouldn't call DisplaySprite and DeleteObject on
		; the same frame or else cause a null-pointer dereference.
		tst.b	obRender(a0)				; has Basaran gone offscreen?
		bmi.s	.return					; if not, branch
		addq.l	#4,sp					; skip returning to Bas_Action to avoid delete-and-display bug
		bra.w	DeleteObject				; delete Basaran
	else
		tst.b	obRender(a0)				; has Basaran gone offscreen?
		bpl.w	DeleteObject				; if yes, delete it
	endif

	.return:
		rts						; return

; ===========================================================================

; .flapsound:
Bas_Action_Fly:
		move.b	(v_vblank_byte).w,d0			; get current VBlank frame counter value
		andi.b	#$F,d0					; only play flapping sound every 16th frame
		bne.s	.move					; if on other frame, branch
		move.w	#sfx_Basaran,d0				; set flapping sound
		jsr	(QueueSound2).l				; play it

	.move:
		bsr.w	SpeedToPos				; update Basaran's position

		move.w	(v_player+obX).w,d0			; get Sonic's current X-position
		sub.w	obX(a0),d0				; calculate X-difference
		bhs.s	.chkSonic				; if Sonic is right of Basaran, branch
		neg.w	d0					; make X-difference positive for check
	.chkSonic:
		cmpi.w	#128,d0					; is Sonic (still) within 128 pixels of Basaran?
		blo.s	.return					; if yes, branch

		; See notes in Bas_Action_ChkSonic.
		move.b	(v_vblank_byte).w,d0			; get current VBlank frame counter value
		add.b	d7,d0					; add index in object RAM
		andi.b	#7,d0					; limit result to 0-7
		bne.s	.return					; if result is non-zero, don't trigger flying back up

		addq.b	#2,ob2ndRout(a0)			; advance to Bas_Action_BackToCeiling

	.return:
		rts						; return
; ===========================================================================

; .flyup:
Bas_Action_BackToCeiling:
		bsr.w	SpeedToPos				; update Basaran's position
		subi.w	#$18,obVelY(a0)				; make Basaran fly upwards

		bsr.w	ObjHitCeiling				; get distance to ceiling
		tst.w	d1					; has Basaran hit the ceiling?
		bpl.s	.return					; if not, branch
		sub.w	d1,obY(a0)				; align Basaran with ceiling

		andi.w	#$FFF8,obX(a0)				; snap horizontal position to nearest multiple of 8px 
		clr.w	obVelX(a0)				; stop Basaran moving horizontally
		clr.w	obVelY(a0)				; stop Basaran moving vertically
		clr.b	obAnim(a0)				; set to "hanging from ceiling" animation
		clr.b	ob2ndRout(a0)				; go back to Bas_Action_ChkSonic

	.return:
		rts						; return


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to check if Sonic has walked into the Basaran's trigger zone
; and to make it face Sonic (adjust X-flip flag).
; 
; input:
;	d2 = trigger zone size (distance between Sonic and Basaran to check)
; 
; output:
;	CCR = carry (set if in range, clear if out of range)
; ---------------------------------------------------------------------------

; .chkdistance:
Bas_CheckDistanceAndFaceSonic:
		move.w	#$100,d1				; set horizontal move speed to the right
		bset	#0,obStatus(a0)				; make face right
		move.w	(v_player+obX).w,d0			; get Sonic's X-position
		sub.w	obX(a0),d0				; calculate X-difference
		bhs.s	.checkDistance				; if Sonic is left of Basaran, branch
		neg.w	d0					; make X-difference positive for check
		neg.w	d1					; move Basaran to the left instead 
		bclr	#0,obStatus(a0)				; make face left

	.checkDistance:
		cmp.w	d2,d0					; is Sonic inside trigger zone?
		rts						; cmp result returned in CCR
; End of function Bas_CheckDistanceAndFaceSonic


; ===========================================================================

	if FixBugs=0
		; Dead, unused code.
		; The simple nature of it may hint at the Basaran once being
		; able to launch projectiles that would despawn once offscreen.
		; Also, it contains yet another display-and-delete bug.
		bsr.w	SpeedToPos				; update position
		bsr.w	DisplaySprite				; display object
		tst.b	obRender(a0)				; did object go offscreen?
		bpl.w	DeleteObject				; if yes, delete object
		rts						; return
	endif

; ===========================================================================

		include	"_anim/Basaran.asm"
Map_Bas:	include	"_maps/Basaran.asm"
