; ===========================================================================
; ---------------------------------------------------------------------------
; Object 0C - flapping door before wind tunnels (LZ)
; ---------------------------------------------------------------------------

FlapDoor:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Flap_Index(pc,d0.w),d1
		jmp	Flap_Index(pc,d1.w)
; ===========================================================================
Flap_Index:	dc.w Flap_Main-Flap_Index
		dc.w Flap_OpenClose-Flap_Index

flap_time:	equ objoff_32		; time between opening/closing
flap_wait:	equ objoff_30		; time until change (in multiples of 60 frames)
; ===========================================================================

Flap_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Flap_OpenClose
		move.l	#Map_Flap,obMap(a0)			; set mappings
		move.w	#ArtTile_LZ_Flapping_Door|Tile_Pal3,obGfx(a0) ; set art tile and palette line
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#80/2,obActWid(a0)			; set sprite display width

		moveq	#0,d0					; clear d0 for mulu
		move.b	obSubtype(a0),d0			; get object subtype
		mulu.w	#60,d0					; multiply by 60 frames (1 second)
		move.w	d0,flap_time(a0)			; set flap delay time
; ---------------------------------------------------------------------------

Flap_OpenClose:	; Routine 2
		subq.w	#1,flap_wait(a0)			; decrement time delay
		bpl.s	Flap_Animate				; if time remains, branch

		move.w	flap_time(a0),flap_wait(a0)		; reset time delay
		bchg	#0,obAnim(a0)				; open/close door
		tst.b	obRender(a0)				; is door on screen?
		bpl.s	Flap_Animate				; if not, don't play sound
		move.w	#sfx_Door,d0				; set flapping door sound
		jsr	(QueueSound2).l				; play it
; ---------------------------------------------------------------------------

Flap_Animate:
		lea	(Ani_Flap).l,a1				; load animation scripts
		bsr.w	AnimateSprite				; (animations stay on final frames indefinitely)

		clr.b	(f_wtunneldisallow).w			; enable wind tunnel by default

		tst.b	obFrame(a0)				; is the door open? (i.e. not last frame of "closing" animation)
		bne.s	.display				; if yes, allow wind tunnels and don't make door solid
		move.w	(v_player+obX).w,d0			; get Sonic's current X-position
		cmp.w	obX(a0),d0				; has Sonic horizontally passed through the door?
		bhs.s	.display				; if yes, allow wind tunnels and don't make door solid

		move.b	#1,(f_wtunneldisallow).w		; disable wind tunnel while door is closed

		move.w	#16/2+sonic_solid_width,d1		; collision width
		move.w	#64/2,d2				; collision height (initial)
		move.w	d2,d3					; collision height (stood-on)
		addq.w	#1,d3					; stood-on height is +1px
		move.w	obX(a0),d4				; object position (stood-on)
		bsr.w	SolidObject				; make the door solid

	.display:
		bra.w	RememberState				; display door, or delete it if offscreen

; ===========================================================================

		include	"_anim/Flapping Door.asm"
Map_Flap:	include	"_maps/Flapping Door.asm"
