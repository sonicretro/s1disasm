; ===========================================================================
; ---------------------------------------------------------------------------
; Object 1D - switch that activates when Sonic touches it
; (this is not used anywhere in the game)
; ---------------------------------------------------------------------------

MagicSwitch:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Swi_Index(pc,d0.w),d1
		jmp	Swi_Index(pc,d1.w)
; ===========================================================================
Swi_Index:	dc.w Swi_Main-Swi_Index
		dc.w Swi_Action-Swi_Index
		dc.w Swi_Delete-Swi_Index

swi_origY:	equ objoff_30		; initial y-axis position
; ===========================================================================

Swi_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Swi_Action
		move.l	#Map_Swi,obMap(a0)			; set mappings
		move.w	#ArtTile_Level|Tile_Pal3,obGfx(a0)	; set art tile ($000, so probably broken anyway) and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.w	obY(a0),swi_origY(a0)			; remember initial Y-position
		move.b	#32/2,obActWid(a0)			; set sprite display width
		move.b	#5,obPriority(a0)			; set sprite priority
; ---------------------------------------------------------------------------

Swi_Action:	; Routine 2
		move.w	swi_origY(a0),obY(a0)			; restore initial Y-position
		move.w	#16,d1					; set trigger height
		bsr.w	Swi_ChkTouch				; check if Sonic touched the switch
		beq.s	.display				; if not, branch

		addq.w	#2,obY(a0)				; move switch 2 pixels down while it's touched
		moveq	#1,d0					; set d0 to 1
		move.w	d0,(f_switch+0).w			; set switch 0 in switch array as "pressed"

.display:
	if FixBugs
		; Objects shouldn't call DisplaySprite and DeleteObject in
		; the same frame or else cause a null-pointer dereference.
		out_of_range.s	Swi_Delete			; has object gone out of range? if yes, branch
		bra.w	DisplaySprite				; display object
	else
		bsr.w	DisplaySprite				; display object
		out_of_range.w	Swi_Delete			; has object gone out of range? if yes, branch
		rts						; return
	endif
; ===========================================================================

Swi_Delete:	; Routine 4
		bsr.w	DeleteObject				; delete object
		rts						; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to check if Sonic touches the object (d1 = input trigger width)
; ---------------------------------------------------------------------------

Swi_ChkTouch:
		lea	(v_player).w,a1				; load Sonic player object
		move.w	obX(a1),d0				; get Sonic's current X-position
		sub.w	obX(a0),d0				; subtract switch's X-position
		add.w	d1,d0					; add trigger width
		bmi.s	.noTouch				; if Sonic is left of switch, exit

		add.w	d1,d1					; double trigger width for right check
		cmp.w	d1,d0					; is Sonic within the right bound of the switch?
		bhs.s	.noTouch				; if not, exit

		move.w	obY(a1),d2				; get Sonic's current Y-position
		move.b	obHeight(a1),d1				; get switch's height as trigger height
		ext.w	d1					; extend height to word
		add.w	d2,d1					; add Sonic's Y-position
		move.w	obY(a0),d0				; get switch's current Y-position
		subi.w	#16,d0					; subtract trigger width (static 16px)
		sub.w	d1,d0					; subtract Sonic's Y-position adjusted for height
		bhi.s	.noTouch				; if Sonic is above switch, exit
		cmpi.w	#-16,d0					; is Sonic within the lower bound of the switch?
		blo.s	.noTouch				; if not, exit

	.touch:
		moveq	#-1,d0					; Sonic has touched switch
		rts						; return with result in CCR
; ---------------------------------------------------------------------------

	.noTouch:
		moveq	#0,d0					; Sonic hasn't touched switch
		rts						; return with result in CCR
; End of function Swi_ChkTouch

; ===========================================================================

Map_Swi:	include	"_maps/Unused Switch.asm"
