; ===========================================================================
; ---------------------------------------------------------------------------
; Object 69 - stationary spinning platforms and trapdoors (SBZ)
; ---------------------------------------------------------------------------

SpinPlatform:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Spin_Index(pc,d0.w),d1
		jmp	Spin_Index(pc,d1.w)
; ===========================================================================
Spin_Index:	dc.w Spin_Main-Spin_Index
		dc.w Spin_Trapdoor-Spin_Index
		dc.w Spin_Spinner-Spin_Index

spin_timer:	equ objoff_30	; counter for time until event
spin_timelen:	equ objoff_32	; time between changes (general)
spin_spinning:	equ objoff_34	; flag set while platform is spinning
spin_syncmask:	equ objoff_36	; level frame counter synchronization bit mask to check if platform should start spinning
; ===========================================================================

Spin_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Spin_Trapdoor
		move.l	#Map_Trap,obMap(a0)			; set mappings
		move.w	#ArtTile_SBZ_Trap_Door|Tile_Pal3,obGfx(a0) ; set art tile and palette line
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
	if FixBugs
		move.b	#128/2,obActWid(a0)			; set sprite display width (corrected)
	else
		; This width is way too big, resulting in screen wrapping issues
		move.b	#256/2,obActWid(a0)			; set sprite display width (too large)
	endif

		moveq	#0,d0					; clear d0 
		move.b	obSubtype(a0),d0			; get object subtype
		andi.w	#$0F,d0					; read only the lower digit
		mulu.w	#60,d0					; multiply by 60 frames (1 second)
		move.w	d0,spin_timelen(a0)			; set trapdoor open/close delay timer

	; Set up spinning platforms...
		tst.b	obSubtype(a0)				; is subtype at least $80? (spinning platforms)
		bpl.s	Spin_Trapdoor				; if not, branch (object is a trapdoor)
		addq.b	#2,obRoutine(a0)			; advance to Spin_Spinner
		move.l	#Map_Spin,obMap(a0)			; set alternate mappings
		move.w	#ArtTile_SBZ_Spinning_Platform,obGfx(a0) ; set alternate art tile
		move.b	#32/2,obActWid(a0)			; set alternate sprite display width
		move.b	#2,obAnim(a0)				; use spinning platforms animations

		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get object subtype
		move.w	d0,d1					; backup subtype for below
		andi.w	#$0F,d0					; read only the lower digit
		mulu.w	#6,d0					; multiply by 6 frames
		move.w	d0,spin_timer(a0)			; set initial timer
		move.w	d0,spin_timelen(a0)			; also store as base reset time

		andi.w	#$70,d1					; limit upper subtype nybble to 0-7
		addi.w	#$10,d1					; add 1 to upper digit
		lsl.w	#2,d1					; multiply by 4
		subq.w	#1,d1					; subtract 1 to turn into bitmask
		move.w	d1,spin_syncmask(a0)			; set synchronization toggle bitmask

		bra.s	Spin_Spinner				; go straight to spinning platform logic
; ===========================================================================

Spin_Trapdoor:	; Routine 2
		subq.w	#1,spin_timer(a0)			; decrement timer
		bpl.s	.animate				; if time remains, branch

		move.w	spin_timelen(a0),spin_timer(a0)		; reset trapdoor timer
		bchg	#0,obAnim(a0)				; toggle between open/close trapdoor animations
		tst.b	obRender(a0)				; was trapdoor on screen as it toggled?
		bpl.s	.animate				; if not, branch
		move.w	#sfx_Door,d0				; set flapping door sound
		jsr	(QueueSound2).l				; play it

	.animate:
		lea	(Ani_Spin).l,a1				; load animation scripts
		jsr	(AnimateSprite).l			; (animations stay on last trapdoor frame indefinitely)

		tst.b	obFrame(a0)				; is frame number 0 displayed? (trapdoor fully closed)
		bne.s	.notSolid				; if not, branch
		move.w	#128/2+sonic_solid_width,d1		; collision width
		move.w	#24/2,d2				; collision height (initial)
		move.w	d2,d3					; collision height (stood-on)
		addq.w	#1,d3					; +1px for stood-on height
		move.w	obX(a0),d4				; collision X-position (stood-on)
		bsr.w	SolidObject				; make trapdoor solid

		bra.w	RememberState				; display trapdoor, or delete it if out of range
; ---------------------------------------------------------------------------

.notSolid:
		btst	#3,obStatus(a0)				; was Sonic standing on the trapdoor as it opened?
		beq.s	.display				; if not, branch
		lea	(v_player).w,a1				; load Sonic player object
		bclr	#3,obStatus(a1)				; clear Sonic's on-platform flag
		bclr	#3,obStatus(a0)				; clear trapdoor's stood-on flag
		clr.b	obSolid(a0)				; clear trapdoor's solidity flag

	.display:
		bra.w	RememberState				; display trapdoor, or delete it if out of range
; ===========================================================================

Spin_Spinner:	; Routine 4
		move.w	(v_framecount).w,d0			; get current level frame counter
		and.w	spin_syncmask(a0),d0			; check against bitmask
		bne.s	.checkSpinStart				; if it's not 0, don't spin platform
		move.b	#1,spin_spinning(a0)			; set flag to start spinning platform

	.checkSpinStart:
		tst.b	spin_spinning(a0)			; is platform set to spin?
		beq.s	.animate				; if not, branch
		subq.w	#1,spin_timer(a0)			; decrement timer to spin
		bpl.s	.animate				; if time remains, branch
		move.w	spin_timelen(a0),spin_timer(a0)		; reset spinning timer
		clr.b	spin_spinning(a0)			; clear spinning flag
		bchg	#0,obAnim(a0)				; toggle between animation 1 and 2 to start spinning (they are otherwise identical)

	.animate:
		lea	(Ani_Spin).l,a1				; load animation scripts
		jsr	(AnimateSprite).l			; (animations stay on last frame (ID 0) indefinitely)

		tst.b	obFrame(a0)				; is frame number 0 displayed? (platform not spinning)
		bne.s	.notSolid				; if not, branch
		move.w	#32/2+sonic_solid_width,d1		; collision width
		move.w	#14/2,d2				; collision height (initial)
		move.w	d2,d3					; collision height (stood-on)
		addq.w	#1,d3					; +1px for stood-on height
		move.w	obX(a0),d4				; collision X-position (stood-on)
		bsr.w	SolidObject				; make platform solid

		bra.w	RememberState				; display platform, or delete it if out of range
; ---------------------------------------------------------------------------

.notSolid:
		btst	#3,obStatus(a0)				; was Sonic standing on the platform as it started spinning?
		beq.s	.display				; if not, branch
		lea	(v_player).w,a1				; load Sonic player object
		bclr	#3,obStatus(a1)				; clear Sonic's on-platform flag
		bclr	#3,obStatus(a0)				; clear platform's stood-on flag
		clr.b	obSolid(a0)				; clear platform's solidity flag

	.display:
		bra.w	RememberState				; display platform, or delete it if out of range

; ===========================================================================

		include	"_anim/SBZ Spinning Platforms.asm"
Map_Trap:	include	"_maps/Trapdoor.asm"
Map_Spin:	include	"_maps/SBZ Spinning Platforms.asm"
