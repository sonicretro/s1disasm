; ===========================================================================
; ---------------------------------------------------------------------------
; Object 80 - Mini-Sonics on the Continue screen
; ---------------------------------------------------------------------------

ContScrItem:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	CSI_Index(pc,d0.w),d1
		jmp	CSI_Index(pc,d1.w)
; ===========================================================================
CSI_Index:	dc.w CSI_Main-CSI_Index				; 0
		dc.w CSI_Display-CSI_Index			; 2
		dc.w CSI_MakeMiniSonic-CSI_Index		; 4
		dc.w CSI_ShowMiniSonic-CSI_Index		; 6
; ===========================================================================

CSI_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to CSI_Display
		move.l	#Map_ContScr,obMap(a0)			; set mappings
		move.w	#ArtTile_Continue_Sonic|Tile_Prio,obGfx(a0) ; set art tile and priority flag
		move.b	#sprite_cam_screen,obRender(a0)		; set to screen-positioned mode
		move.b	#120/2,obActWid(a0)			; set sprite display width
		move.w	#$80+(320/2),obX(a0)			; set X-position to centered
		move.w	#$80+64,obScreenY(a0)			; set Y-position

		move.w	#0,(v_rings).w				; clear rings
; ---------------------------------------------------------------------------

CSI_Display:	; Routine 2
		jmp	(DisplaySprite).l			; display element

; ===========================================================================
; --- X-positions for Mini-Sonics ---
; These values are pseudo-interlaced instead of going left-to-right,
; keeping consecutively collected continues overall centered (roughly).
CSI_MinSonXPos:	dc.w $116, $12A
		dc.w $102, $13E
		dc.w  $EE, $152
		dc.w  $DA, $166
		dc.w  $C6, $17A
		dc.w  $B2, $18E
		dc.w  $9E, $1A2
		dc.w  $8A	; at most, 15 mini-Sonics will be rendered
; ===========================================================================

CSI_MakeMiniSonic:
		; Routine 4
		movea.l	a0,a1					; write first mini-Sonic to current object RAM slot

		lea	(CSI_MinSonXPos).l,a2			; load X-position data
		moveq	#0,d1					; clear d1 for dbf
		move.b	(v_continues).w,d1			; get number of continues you have
		subq.b	#1+1,d1					; -1 for dbf, and -1 to hide one continue
		bhs.s	CSI_CreateMiniSonics			; if you have at least two continues, branch
		jmp	(DeleteObject).l			; mini-Sonics are only spawned if at least 2 continues are available
; ---------------------------------------------------------------------------

CSI_CreateMiniSonics:
		moveq	#1,d3					; flash the "used" mini-Sonic sprite
		cmpi.b	#15-1,d1				; do you have more than 15 continues?
		blo.s	.checkEven				; if not, branch
		moveq	#0,d3					; don't flash any "used" mini-Sonic
		moveq	#15-1,d1				; cap at 15 mini-Sonics
	.checkEven:
		move.b	d1,d2					; copy final number of mini-Sonics to draw
		andi.b	#1,d2					; limit it to 1 for even/odd check

.loopMiniSonics:
		_move.b	#id_ContScrItem,obID(a1)		; load another mini-Sonic object
		move.w	(a2)+,obX(a1)				; get next X-position from CSI_MinSonXPos
		tst.b	d2					; do you have an odd number of continues?
		beq.s	.configMiniSonic			; if not, branch
		subi.w	#10,obX(a1)				; shift mini-Sonics slightly to the left to center them
	.configMiniSonic:
		move.w	#$80+$50,obScreenY(a1)			; set fixed Y-position
		move.b	#6,obFrame(a1)				; set to first mini-Sonic frame (foot down)
		move.b	#6,obRoutine(a1)			; use CSI_ShowMiniSonic routine
		move.l	#Map_ContScr,obMap(a1)			; set mappings
		move.w	#ArtTile_Mini_Sonic|Tile_Prio,obGfx(a1)	; set art tile and priority flag
		move.b	#sprite_cam_screen,obRender(a1)		; set to screen-positioned mode
		lea	object_size(a1),a1			; advance to next object RAM slot
		dbf	d1,.loopMiniSonics			; repeat for number of continues

		lea	-object_size(a1),a1			; go back to rightmost mini-Sonic object
		move.b	d3,obSubtype(a1)			; make this mini-Sonic be the one that flashes when it gets used
; ---------------------------------------------------------------------------

CSI_ShowMiniSonic: ; Routine 6
		tst.b	obSubtype(a0)				; is this the mini-Sonic sprite that should get "used"?
		beq.s	.animate				; if not, branch
		cmpi.b	#6,(v_player+obRoutine).w		; is Sonic running after a continue has been used?
		blo.s	.animate				; if not, branch
		move.b	(v_vblank_byte).w,d0			; make "used" mini-Sonic flash
		andi.b	#1,d0					; show every other frame
		bne.s	.animate				; branch if on odd frame
		tst.w	(v_player+obVelX).w			; has Sonic started actually moving?
		bne.s	.delete					; if yes, goto delete
		rts						; hide mini-Sonic
; ---------------------------------------------------------------------------

	.animate:
		move.b	(v_vblank_byte).w,d0			; use VBlank frame counter to animate
		andi.b	#$F,d0					; change frame every 16 frames
		bne.s	.display				; branch on other frames
		bchg	#0,obFrame(a0)				; alternate between "foot up" and "foot down" frames

	.display:
		jmp	(DisplaySprite).l			; display mini-Sonic sprite

	.delete:
		jmp	(DeleteObject).l			; delete mini-Sonic


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 81 - Sonic on the Continue screen
; ---------------------------------------------------------------------------

ContSonic:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	CSon_Index(pc,d0.w),d1
		jsr	CSon_Index(pc,d1.w)
		jmp	(DisplaySprite).l			; display Sonic
; ===========================================================================
CSon_Index:	dc.w CSon_Main-CSon_Index			; 0
		dc.w CSon_ChkLand-CSon_Index			; 2
		dc.w CSon_Animate-CSon_Index			; 4
		dc.w CSon_RunRight-CSon_Index			; 6
; ===========================================================================

CSon_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to CSon_ChkLand
		move.w	#$A0,obX(a0)				; set X-position
		move.w	#$C0,obY(a0)				; set starting Y-position
		move.l	#Map_Sonic,obMap(a0)			; set mappings (cross-referenced from main Sonic object)
		move.w	#ArtTile_Sonic,obGfx(a0)		; set art tile (cross-referenced from main Sonic object)
		move.b	#sprite_cam_field,obRender(a0)		; set playfield-positioned mode
		move.b	#2,obPriority(a0)			; set sprite priority (behind other elements)
		move.b	#id_Float3,obAnim(a0)			; use "floating" animation
		move.w	#$400,obVelY(a0)			; make Sonic fall from above
; ---------------------------------------------------------------------------

CSon_ChkLand:	; Routine 2
		cmpi.w	#$1A0,obY(a0)				; has Sonic landed yet?
		bne.s	CSon_ShowFall				; if not, branch

		addq.b	#2,obRoutine(a0)			; advance to CSon_Animate
		clr.w	obVelY(a0)				; stop Sonic falling
		move.l	#Map_ContScr,obMap(a0)			; swap out mappings with continue screen Sonic mappings
		move.w	#ArtTile_Continue_Sonic|Tile_Prio,obGfx(a0) ; swap out art tile with continue screen Sonic art tile
		move.b	#0,obAnim(a0)				; use "on floor" animation (this isn't Sonic's main animation script!)
		bra.s	CSon_Animate				; don't use main Sonic object's logic anymore
; ---------------------------------------------------------------------------

CSon_ShowFall:
		jsr	(SpeedToPos).l				; update Sonic's position as he falls
		jsr	(Sonic_Animate).l			; animate Sonic (cross-referenced)
		jmp	(Sonic_LoadGfx).l			; update Sonic's graphics if necessary (cross-referenced)
; ===========================================================================

CSon_Animate:	; Routine 4
		tst.b	(v_jpadpress1).w			; has Start button beenpressed?
		bmi.s	.continueUsed				; if yes, continue has been used

		lea	(Ani_CSon).l,a1				; load continue screen Sonic animation script
		jmp	(AnimateSprite).l			; advance animation
; ---------------------------------------------------------------------------

	.continueUsed:
		addq.b	#2,obRoutine(a0)			; advance to CSon_RunRight
		move.l	#Map_Sonic,obMap(a0)			; set mappings (cross-referenced from main Sonic object)
		move.w	#ArtTile_Sonic,obGfx(a0)		; set art tile (cross-referenced from main Sonic object)
		move.b	#id_Float4,obAnim(a0)			; use "getting up" animation (changes to id_Walk on finish)
		clr.w	obInertia(a0)				; stop ground speed
		subq.w	#8,obY(a0)				; shift Sonic up by a tile
		move.b	#bgm_Fade,d0				; set fade-out music command
		bsr.w	QueueSound2				; fade out music
; ---------------------------------------------------------------------------

CSon_RunRight:	; Routine 6
		cmpi.w	#$40*$20,obInertia(a0)			; check if Sonic's current ground speed reached $800
		bne.s	.addInertia				; if not, branch
		move.w	#$1000,obVelX(a0)			; shoot Sonic to the right once ground speed is fast enough
		bra.s	.showRun				; don't alter inertia anymore

	.addInertia:
		addi.w	#$20,obInertia(a0)			; increase Sonic's ground speed (doesn't actually move him yet!)

	.showRun:
		jsr	(SpeedToPos).l				; update Sonic's position once his inertia is fast enough
		jsr	(Sonic_Animate).l			; animate Sonic (cross-referenced)
		jmp	(Sonic_LoadGfx).l			; update Sonic's graphics if necessary (cross-referenced)

; ===========================================================================

		include	"_anim/Continue Screen Sonic.asm"
Map_ContScr:	include	"_maps/Continue Screen.asm"
