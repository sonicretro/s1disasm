; ===========================================================================
; ---------------------------------------------------------------------------
; Object 2A - small vertical door (SBZ)
; ---------------------------------------------------------------------------

AutoDoor:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	ADoor_Index(pc,d0.w),d1
		jmp	ADoor_Index(pc,d1.w)
; ===========================================================================
ADoor_Index:	dc.w ADoor_Main-ADoor_Index
		dc.w ADoor_OpenShut-ADoor_Index
; ===========================================================================

ADoor_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to ADoor_OpenShut
		move.l	#Map_ADoor,obMap(a0)			; set mappings
		move.w	#ArtTile_SBZ_Door|Tile_Pal3,obGfx(a0)	; set art tile and palette line
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#16/2,obActWid(a0)			; set sprite display width
		move.b	#4,obPriority(a0)			; set sprite priority
; ---------------------------------------------------------------------------

ADoor_OpenShut:	; Routine 2
		move.w	#64,d1					; set horizontal range for door detection to 64px (per left/right)
		clr.b	obAnim(a0)				; use "closing" animation (ID 0)

		move.w	(v_player+obX).w,d0			; get Sonic's current X-position
		add.w	d1,d0					; add trigger range (right)
		cmp.w	obX(a0),d0				; is Sonic inside right range?
		blo.s	ADoor_Animate				; if not, branch (close door)
		sub.w	d1,d0					; undo above addition
		sub.w	d1,d0					; add trigger range (left)
		cmp.w	obX(a0),d0				; is Sonic inside left range?
		bhs.s	ADoor_Animate				; if not, branch (close door)

		add.w	d1,d0					; Sonic is in range, now check which side
		cmp.w	obX(a0),d0				; is Sonic to the left of the door?
		bhs.s	.sonicLeft				; if yes, branch

	.sonicRight:
		btst	#0,obStatus(a0)				; is door facing right?
		bne.s	ADoor_Animate				; if not, branch (close door)
		bra.s	.openDoor				; otherwise, open door
; ===========================================================================

	.sonicLeft:
		btst	#0,obStatus(a0)				; is door facing left?
		beq.s	ADoor_Animate				; if not, branch (close door)

	.openDoor:
		move.b	#1,obAnim(a0)				; use "opening" animation (ID 1)
; ---------------------------------------------------------------------------

ADoor_Animate:
		lea	(Ani_ADoor).l,a1			; load animation script
		bsr.w	AnimateSprite				; (animations stay on final frames indefinitely)

		tst.b	obFrame(a0)				; is the door open? (last frame of "opening" animation)
		bne.s	.display				; if yes, don't make door solid
		move.w	#12/2+sonic_solid_width,d1		; collision width
		move.w	#64/2,d2				; collision height (initial)
		move.w	d2,d3					; collision height (stood-on)
		addq.w	#1,d3					; stood-on height is +1px
		move.w	obX(a0),d4				; object position (stood-on)
		bsr.w	SolidObject				; make the door solid

	.display:
		bra.w	RememberState				; display door, or delete it if offscreen

; ===========================================================================

		include	"_anim/SBZ Small Door.asm"
Map_ADoor:	include	"_maps/SBZ Small Door.asm"
