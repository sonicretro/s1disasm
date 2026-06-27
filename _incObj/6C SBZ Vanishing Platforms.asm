; ===========================================================================
; ---------------------------------------------------------------------------
; Object 6C - vanishing platforms (SBZ)
; ---------------------------------------------------------------------------

VanishPlatform:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	VanP_Index(pc,d0.w),d1
		jmp	VanP_Index(pc,d1.w)
; ===========================================================================
VanP_Index:	dc.w VanP_Main-VanP_Index
		dc.w VanP_Detect-VanP_Index
		dc.w VanP_StoodOn-VanP_Index
		dc.w VanP_Sync-VanP_Index

vanp_timer:	equ objoff_30	; counter for time until event
vanp_timelen:	equ objoff_32	; time between events (general)
vanp_syncoffset:equ objoff_36	; offset to synchronize multiple platforms to level frame counter (multiples of $80)
vanp_syncmask:	equ objoff_38	; level frame counter synchronization bit mask to check if platform should toggle
; ===========================================================================

VanP_Main:	; Routine 0
		addq.b	#6,obRoutine(a0)			; advance to VanP_Sync
		move.l	#Map_VanP,obMap(a0)			; set mappings
		move.w	#ArtTile_SBZ_Vanishing_Block|Tile_Pal3,obGfx(a0) ; set art tile and palette line
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#32/2,obActWid(a0)			; set sprite display width and solidity width
		move.b	#4,obPriority(a0)			; set sprite priority

		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get object subtype
		andi.w	#$0F,d0					; read only the lower digit
		addq.w	#1,d0					; make value 1-based
		lsl.w	#7,d0					; multiply by $80
		move.w	d0,d1					; copy for below
		subq.w	#1,d0					; make value 0-based again
		move.w	d0,vanp_timer(a0)			; set initial timer
		move.w	d0,vanp_timelen(a0)			; also store as base reset time

		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get object subtype again
		andi.w	#$F0,d0					; read only the upper digit
		addi.w	#$80,d1					; add a static $80 to earlier result
		mulu.w	d1,d0					; multiply upper subtype digit by lower one (multiples of $80)
		lsr.l	#8,d0					; divide by $100
		move.w	d0,vanp_syncoffset(a0)			; set level timer offset for this platform
		subq.w	#1,d1					; subtract 1 for bitmask check
		move.w	d1,vanp_syncmask(a0)			; set synchronization toggle bitmask
; ---------------------------------------------------------------------------

; loc_16068:
VanP_Sync:	; Routine 6
		move.w	(v_framecount).w,d0			; get current level frame counter
		sub.w	vanp_syncoffset(a0),d0			; subtract level timer offset for this platform
		and.w	vanp_syncmask(a0),d0			; check against bitmask
		bne.s	.animate				; if it's not 0, don't toggle platform

		subq.b	#4,obRoutine(a0)			; goto VanP_Detect next
		bra.s	VanP_Detect				; go there immediately
; ===========================================================================

	.animate:
		lea	(Ani_Van).l,a1				; load animation script
		jsr	(AnimateSprite).l			; (stays on final animation frame indefinitely)
		bra.w	RememberState				; display sprite, or delete if offscreen
; ===========================================================================

; VanP_Vanish: VanP_Appear:
VanP_Detect:	; Routine 2
VanP_StoodOn:	; Routine 4
		subq.w	#1,vanp_timer(a0)			; decrement timer
		bpl.s	.animate				; if time remains, branch
		move.w	#$80-1,vanp_timer(a0)			; reset timer (while vanishing)

		tst.b	obAnim(a0)				; is platform vanishing? (animation ID 0)
		beq.s	.toggleAnimation			; if yes, branch
		move.w	vanp_timelen(a0),vanp_timer(a0)		; reset timer (while visible)

	.toggleAnimation:
		bchg	#0,obAnim(a0)				; alternate between animation 0 and 1
; ---------------------------------------------------------------------------

.animate:
		lea	(Ani_Van).l,a1				; load animation script
		jsr	(AnimateSprite).l			; (stays on final animation frame indefinitely)

		btst	#1,obFrame(a0)				; is platform visible? (frame IDs 1 and 3)
		bne.s	.notSolid				; if not, don't make solid

		cmpi.b	#2,obRoutine(a0)			; is Sonic already standing on platform?
		bne.s	.sonicOnPlatform			; if yes, branch
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as solidity width
		jsr	(PlatformObject).l			; allow Sonic to stand on platform (obRoutine is set to 4 here if he is)
		bra.w	RememberState				; display sprite, or delete if offscreen
; ===========================================================================

.sonicOnPlatform:
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as solidity width
		jsr	(ExitPlatform).l			; allow Sonic to exit the platform

		move.w	obX(a0),d2				; get platform's X-position
		jsr	(MvSonicOnPtfm2).l			; move Sonic with platform
		bra.w	RememberState				; display sprite, or delete if offscreen
; ===========================================================================

.notSolid:
		btst	#3,obStatus(a0)				; was Sonic standing on platform as it went invisible?
		beq.s	.display				; if not, branch
		lea	(v_player).w,a1				; load Sonic player object
		bclr	#3,obStatus(a1)				; clear Sonic's on-platform flag
		bclr	#3,obStatus(a0)				; clear platform's stood-on flag
		move.b	#2,obRoutine(a0)			; set platform back to VanP_Detect
		clr.b	obSolid(a0)				; clear platform solidity flag

	.display:
		bra.w	RememberState				; display sprite, or delete if offscreen

; ===========================================================================

		include	"_anim/SBZ Vanishing Platforms.asm"
Map_VanP:	include	"_maps/SBZ Vanishing Platforms.asm"
