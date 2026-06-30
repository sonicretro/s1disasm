; ===========================================================================
; ---------------------------------------------------------------------------
; Object 4B - Giant Ring for entry to Special Stage
; ---------------------------------------------------------------------------

GiantRing:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	GRing_Index(pc,d0.w),d1
		jmp	GRing_Index(pc,d1.w)
; ===========================================================================
GRing_Index:	dc.w GRing_Main-GRing_Index
		dc.w GRing_Animate-GRing_Index
		dc.w GRing_Collect-GRing_Index
		dc.w GRing_Delete-GRing_Index

gring_parent:	equ objoff_3C	; parent giant ring object address used by flash object
; ===========================================================================

GRing_Main:	; Routine 0
		move.l	#Map_GRing,obMap(a0)			; set mappings
		move.w	#ArtTile_Giant_Ring|Tile_Pal2,obGfx(a0)	; set art tile and palette line
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield positioned mode
		move.b	#128/2,obActWid(a0)			; set sprite display width

		tst.b	obRender(a0)				; is giant ring on screen?
		bpl.s	GRing_Animate				; if not, branch
		cmpi.b	#ss_emeralds_num,(v_emeralds).w		; do you have all 6 emeralds?
		beq.w	GRing_Delete				; if yes, branch
		cmpi.w	#ss_giantring_rings,(v_rings).w		; do you have at least 50 rings?
		bhs.s	GRing_Okay				; if yes, branch
		rts						; otherwise, don't show giant ring
; ===========================================================================

GRing_Okay:
		addq.b	#2,obRoutine(a0)			; set to GRing_Animate
		move.b	#2,obPriority(a0)			; set sprite priority
		move.b	#col_16x32|col_item,obColType(a0)	; set col type (ReactToItem will advance obRoutine on collection)
		move.w	#Art_BigRing_size,(v_gfxbigring).w	; trigger AniArt_GiantRing to load graphics (Art_BigRing_size = $C40)
; ---------------------------------------------------------------------------

GRing_Animate:	; Routine 2
		move.b	(v_ani1_frame).w,obFrame(a0)		; set frame (updated in SynchroAnimate => Sync2)
		out_of_range.w	DeleteObject			; is giant ring offscreen? if yes, delete it
		bra.w	DisplaySprite				; otherwise, display sprite
; ===========================================================================

GRing_Collect:	; Routine 4
		subq.b	#2,obRoutine(a0)			; go back to GRing_Animate
		move.b	#col_none,obColType(a0)			; disable further collision with ring

		bsr.w	FindFreeObj				; find a free object RAM slot
		bne.w	GRing_PlaySnd				; if RAM is full, branch
		_move.b	#id_RingFlash,obID(a1)			; load giant ring flash object
		move.w	obX(a0),obX(a1)				; copy X-position
		move.w	obY(a0),obY(a1)				; copy Y-position
		move.l	a0,gring_parent(a1)			; make flash object remember parent ring object
		move.w	(v_player+obX).w,d0			; get Sonic's X-position
		cmp.w	obX(a0),d0				; has Sonic entered the giant ring from the right?
		blo.s	GRing_PlaySnd				; if not, branch
		bset	#sprite_xflip_bit,obRender(a1)		; set X-flip flag for flash object

GRing_PlaySnd:
		move.w	#sfx_GiantRing,d0			; set giant ring sound
		jsr	(QueueSound2).l				; play it
		bra.s	GRing_Animate				; keep animating ring until it's deleted by flash
; ===========================================================================

GRing_Delete:	; Routine 6
		bra.w	DeleteObject				; delete giant ring


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 7C - Flash effect when you collect the Giant Ring
; ---------------------------------------------------------------------------

RingFlash:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Flash_Index(pc,d0.w),d1
		jmp	Flash_Index(pc,d1.w)
; ===========================================================================
Flash_Index:	dc.w Flash_Main-Flash_Index
		dc.w Flash_ChkDel-Flash_Index
		dc.w Flash_Delete-Flash_Index
; ===========================================================================

Flash_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; set to Flash_ChkDel
		move.l	#Map_Flash,obMap(a0)			; set mappings
		move.w	#ArtTile_Giant_Ring_Flash|Tile_Pal2,obGfx(a0) ; set art tile and palette line
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield positioned mode
		move.b	#0,obPriority(a0)			; set to maximum sprite priority
		move.b	#64/2,obActWid(a0)			; set sprite display width
		move.b	#-1,obFrame(a0)				; set to frame -1 so first run of Flash_Collect will set it to 0
; ---------------------------------------------------------------------------

Flash_ChkDel:	; Routine 2
		bsr.s	Flash_Collect				; advance ring animation, delete Sonic, and set flag
		out_of_range.w	DeleteObject			; is object offscreen? if yes, delete
		bra.w	DisplaySprite				; otherwise, display sprite

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to handle the Giant Ring flash advance ring animation,
; delete Sonic, and set flag (this did not need to be a subroutine...)
; ---------------------------------------------------------------------------

Flash_Collect:
		subq.b	#1,obTimeFrame(a0)			; decrement delay until next frame
		bpl.s	.return					; if time remains, branch
		move.b	#1,obTimeFrame(a0)			; reset delay to 2 frames
		addq.b	#1,obFrame(a0)				; advance to next frame
		cmpi.b	#8,obFrame(a0)				; has animation finished? (8 frames)
		bhs.s	.deleteSonic				; if yes, branch
		cmpi.b	#3,obFrame(a0)				; is 3rd frame displayed?
		bne.s	.return					; if not, branch

		movea.l	gring_parent(a0),a1			; get parent giant ring object address
		move.b	#6,obRoutine(a1)			; delete parent object
		move.b	#id_Null,(v_player+obAnim).w		; make Sonic invisible
		move.b	#1,(f_bigring).w			; set flag that giant ring was collected
		clr.b	(v_invinc).w				; remove invincibility
		clr.b	(v_shield).w				; remove shield

	.return:
		rts						; return
; ---------------------------------------------------------------------------

	.deleteSonic:
		addq.b	#2,obRoutine(a0)			; set to Flash_Delete
		move.w	#0,(v_player).w				; delete Sonic object
		addq.l	#4,sp					; skip returning to Flash_ChkDel
		rts						; return
; End of function Flash_Collect

; ===========================================================================

Flash_Delete:	; Routine 4
		bra.w	DeleteObject				; delete flash object
