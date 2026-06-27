; ===========================================================================
; ---------------------------------------------------------------------------
; Object 0B - breakable pole in wind tunnels that Sonic hangs onto (LZ)
; ---------------------------------------------------------------------------

Pole:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Pole_Index(pc,d0.w),d1
		jmp	Pole_Index(pc,d1.w)
; ===========================================================================
Pole_Index:	dc.w Pole_Main-Pole_Index
		dc.w Pole_Action-Pole_Index
		dc.w Pole_Display-Pole_Index

pole_breaktime:	equ objoff_30		; time between grabbing the pole and it breaking
pole_grabbed:	equ objoff_32		; flag set while Sonic grabs the pole
; ===========================================================================

Pole_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Pole_Action
		move.l	#Map_Pole,obMap(a0)			; set mappings
		move.w	#ArtTile_LZ_Pole|Tile_Pal3,obGfx(a0)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#16/2,obActWid(a0)			; set sprite display width
		move.b	#4,obPriority(a0)			; set sprite priority

		move.b	#col_8x64|col_special,obColType(a0)	; set special ReactToItem collision type for poles
		moveq	#0,d0					; clear d0 for mulu
		move.b	obSubtype(a0),d0			; get subtype of pole
		mulu.w	#60,d0					; multiply by 60 frames (1 second)
		move.w	d0,pole_breaktime(a0)			; set time until pole breaks
; ---------------------------------------------------------------------------

Pole_Action:	; Routine 2
		tst.b	pole_grabbed(a0)			; has Sonic already grabbed the pole?
		beq.s	.checkGrab				; if not, branch to check for grab

		tst.w	pole_breaktime(a0)			; has pole alread broken?
		beq.s	.checkMoveUp				; if not, branch to allow Sonic moving up/down
		subq.w	#1,pole_breaktime(a0)			; decrement time until pole breaks
		bne.s	.checkMoveUp				; if time remains, branch
		move.b	#1,obFrame(a0)				; set to "broken pole" frame
		bra.s	.release				; force Sonic to let go of pole
; ===========================================================================

.checkMoveUp:
		lea	(v_player).w,a1				; load Sonic player object
		move.w	obY(a0),d0				; get pole's Y-position
		subi.w	#24,d0					; allow moving up to 24px up from center
		btst	#bitUp,(v_jpadhold1).w			; is UP button held?
		beq.s	.checkMoveDown				; if not, branch
		subq.w	#1,obY(a1)				; move Sonic up at 1px/frame
		cmp.w	obY(a1),d0				; has Sonic hit top end of the pole?
		blo.s	.checkMoveDown				; if not, branch
		move.w	d0,obY(a1)				; force Sonic to not exceed top end of pole

	.checkMoveDown:
		addi.w	#12+24,d0				; allow moving up to 12px down from center (and undo above subtraction)
		btst	#bitDn,(v_jpadhold1).w			; is DOWN button held?
		beq.s	.checkLetGo				; if not, branch
		addq.w	#1,obY(a1)				; move Sonic down at 1px/frame
		cmp.w	obY(a1),d0				; has Sonic hit the bottom end of the pole?
		bhs.s	.checkLetGo				; if not, branch
		move.w	d0,obY(a1)				; force Sonic to not exceed bottom end of pole
; ---------------------------------------------------------------------------

.checkLetGo:
		move.b	(v_jpadpress2).w,d0			; get current button presses for Sonic
		andi.w	#btnABC,d0				; was A/B/C pressed?
		beq.s	Pole_Display				; if not, branch

	.release:
		clr.b	obColType(a0)				; clear ReactToItem touched flag
		addq.b	#2,obRoutine(a0)			; set pole to Pole_Display (no more interactability)
		clr.b	(f_playerctrl).w			; clear control override flag
		clr.b	(f_wtunneldisallow).w			; re-enable wind tunnels
		clr.b	pole_grabbed(a0)			; clear pole-grabbed flag
		bra.s	Pole_Display				; display pole sprite
; ===========================================================================

.checkGrab:
		tst.b	obColProp(a0)				; has Sonic touched the pole? (set from ReactToItem => React_LZPole)
		beq.s	Pole_Display				; if not, branch

		lea	(v_player).w,a1				; load Sonic player object
		move.w	obX(a0),d0				; get pole's X-position
		addi.w	#20,d0					; check 20px to the right of pole
		cmp.w	obX(a1),d0				; is Sonic in range of pole?
		bhs.s	Pole_Display				; if not, branch
		clr.b	obColProp(a0)				; clear grab flag from ReactToItem
		cmpi.b	#4,obRoutine(a1)			; is Sonic hurt or dying?
		bhs.s	Pole_Display				; if yes, branch

		clr.w	obVelX(a1)				; stop Sonic moving horizontally
		clr.w	obVelY(a1)				; stop Sonic moving vertically
		move.w	obX(a0),d0				; get pole's X-position
		addi.w	#20,d0					; align Sonic 20px to the right of pole
		move.w	d0,obX(a1)				; set Sonic's aligned X-position
		bclr	#0,obStatus(a1)				; clear Sonic's X-flip flag
		move.b	#id_Hang,obAnim(a1)			; set Sonic's animation to "hanging" ($11)
		move.b	#1,(f_playerctrl).w			; set Sonic control override flag
		move.b	#1,(f_wtunneldisallow).w		; disable wind tunnel
		move.b	#1,pole_grabbed(a0)			; set flag that pole has been grabbed
; ---------------------------------------------------------------------------

Pole_Display:	; Routine 4
		bra.w	RememberState				; display pole, or delete it if out of range

; ===========================================================================

Map_Pole:	include	"_maps/Pole that Breaks.asm"
