; ===========================================================================
; ---------------------------------------------------------------------------
; Object 65 - decorative waterfall objects (LZ)
; ---------------------------------------------------------------------------

Waterfall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	WFall_Index(pc,d0.w),d1
		jmp	WFall_Index(pc,d1.w)
; ===========================================================================
WFall_Index:	dc.w WFall_Main-WFall_Index	; 0
		dc.w WFall_Animate-WFall_Index	; 2
		dc.w WFall_Display-WFall_Index	; 4
		dc.w WFall_OnWater-WFall_Index	; 6
		dc.w WFall_Priority-WFall_Index	; 8
; ===========================================================================

WFall_Main:	; Routine 0
		addq.b	#4,obRoutine(a0)			; advance to WFall_Display
		move.l	#Map_WFall,obMap(a0)			; set mappings
		move.w	#ArtTile_LZ_Splash|Tile_Pal3,obGfx(a0)	; set art tile and palette line (palette cycle)
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#48/2,obActWid(a0)			; set sprite display width
		move.b	#1,obPriority(a0)			; set sprite priority (above Sonic)

		move.b	obSubtype(a0),d0			; get object type
		bpl.s	.setFrame				; branch if $00-$7F
		bset	#7,obGfx(a0)				; set high-priority VRAM flag

	.setFrame:
		andi.b	#$0F,d0					; read only the lower digit
		move.b	d0,obFrame(a0)				; set that as frame ID

		; Special variations of the splash subtype ($x9)
		cmpi.b	#9,d0					; is object type $x9 (splash)?
		bne.s	WFall_Display				; if not, branch
		clr.b	obPriority(a0)				; use highest sprite priority (in front of other waterfalls)
		subq.b	#2,obRoutine(a0)			; go back to WFall_Animate
		btst	#6,obSubtype(a0)			; is object subtype $49?
		beq.s	.chkHidden				; if not, branch
		move.b	#6,obRoutine(a0)			; advance to WFall_OnWater (align splash to surface)

	.chkHidden:
		btst	#5,obSubtype(a0)			; is object type $A9? (hidden splash in changing chunk at LZ3 start)
		beq.s	WFall_Animate				; if not, branch
		move.b	#8,obRoutine(a0)			; set to WFall_Priority
; ---------------------------------------------------------------------------

WFall_Animate:	; Routine 2
		lea	(Ani_WFall).l,a1			; load animation scripts
		jsr	(AnimateSprite).l			; infinite animation loop
; ---------------------------------------------------------------------------

WFall_Display:	; Routine 4
		bra.w	RememberState				; display object, or delete if out of range
; ===========================================================================

WFall_OnWater:	; Routine 6
		move.w	(v_waterpos1).w,d0			; get current water height including sway
		subi.w	#16,d0					; adjust splash 16px above it
		move.w	d0,obY(a0)				; match splash position to water height
		bra.s	WFall_Animate				; animate splash
; ===========================================================================

; loc_12B36:
WFall_Priority:	; Routine 8
		bclr	#7,obGfx(a0)				; render splash object on low-plane (hide behind level chunk)
		cmpi.b	#7,(v_lvllayout_fg+((layout_row*2)+6)).w ; is LZ3 water slide layout currently altered?
		bne.s	.animate				; if not, branch
		bset	#7,obGfx(a0)				; render splash object on high-plane (make visible)

	.animate:
		bra.s	WFall_Animate				; animate and display

; ===========================================================================

		include	"_anim/Waterfalls.asm"
Map_WFall:	include	"_maps/Waterfalls.asm"
