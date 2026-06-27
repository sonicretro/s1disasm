; ===========================================================================
; ---------------------------------------------------------------------------
; Object 17 - rotating helix of spikes on a horizontal pole (GHZ)
; ---------------------------------------------------------------------------

Helix:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Hel_Index(pc,d0.w),d1
		jmp	Hel_Index(pc,d1.w)
; ===========================================================================
Hel_Index:	dc.w Hel_Main-Hel_Index		; 0
		dc.w Hel_ParentSpike-Hel_Index	; 2
		dc.w Hel_ParentSpike-Hel_Index	; 4 (never set)
		dc.w Hel_Delete-Hel_Index	; 6 (never set)
		dc.w Hel_ChildSpike-Hel_Index	; 8

helix_frame:	equ objoff_3E		; start frame (different for each spike)
helix_children:	equ obSubtype		; $28 = helix length // $29-38 = indeces for child object RAM addresses
; ===========================================================================

Hel_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Hel_ParentSpike (2)
		move.l	#Map_Hel,obMap(a0)			; set mappings
		move.w	#ArtTile_GHZ_Spike_Pole|Tile_Pal3,obGfx(a0) ; set art tile and palette (located inside main GHZ graphics)
		move.b	#7,obStatus(a0)				; (unused leftover?)
		move.b	#sprite_cam_field,obRender(a0)		; set playfield-positioned mode
		move.b	#3,obPriority(a0)			; set sprite priority
		move.b	#16/2,obActWid(a0)			; set sprite display width

		move.w	obY(a0),d2				; get base Y-position of parent
		move.w	obX(a0),d3				; get base X-position of parent
		_move.b	obID(a0),d4				; create children with same object ID as parent

		lea	helix_children(a0),a2			; load helix children array (will hold RAM indeces for child spikes)
		moveq	#0,d1					; clear d1
		move.b	(a2),d1					; get number of spikes to load from subtype (OST $28)
		move.b	#0,(a2)+				; clear subtype and advance to helix_children
		move.w	d1,d0					; copy spike count
		lsr.w	#1,d0					; divide by 2 to center
		lsl.w	#4,d0					; multiply by $10px width per spike
		sub.w	d0,d3					; d3 = X-position of leftmost spike

		subq.b	#2,d1					; adjust dbf loop count (-1 for parent spike; -1 for dbf itself)
		bcs.s	Hel_ParentSpike				; if only one spike needs to be loaded, branch (all we need is the parent)
		moveq	#0,d6					; start at frame ID 0

.loopBuildHelix:
	if FixBugs
		; If an object is allocated before the parent object, then
		; when the child is deleted, it will have already been queued
		; for display, which is a display-and-delete bug.
		bsr.w	FindNextFreeObj				; find next free object slot
	else
		bsr.w	FindFreeObj				; find a free object slot
	endif
		bne.s	Hel_ParentSpike				; if object RAM is full, branch
		addq.b	#1,helix_children(a0)			; increment number of loaded spikes

		move.w	a1,d5					; get resulting target RAM address for child spike
		subi.w	#v_objspace&$FFFF,d5			; make address 0-based
		lsr.w	#object_size_bits,d5			; divide by object_size ($40)
		andi.w	#$7F,d5					; d5 = 0-based index of child spike in object RAM
		move.b	d5,(a2)+				; copy child address index to parent RAM (helix_children)

		move.b	#8,obRoutine(a1)			; set to Hel_ChildSpike
		_move.b	d4,obID(a1)				; copy parent object ID
		move.w	d2,obY(a1)				; copy parent Y-position
		move.w	d3,obX(a1)				; copy parent X-position
		move.l	obMap(a0),obMap(a1)			; copy parent mappings
		move.w	#ArtTile_GHZ_Spike_Pole|Tile_Pal3,obGfx(a1) ; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a1)		; set to playfield-positioned mode
		move.b	#3,obPriority(a1)			; set sprite priority
		move.b	#16/2,obActWid(a1)			; set sprite display width

		move.b	d6,helix_frame(a1)			; set base spike frame ID
		addq.b	#1,d6					; increment base frame ID for next spike
		andi.b	#7,d6					; wrap around 0-7 frame IDs
		addi.w	#$10,d3					; position each spike $10px apart (left to right)

		cmp.w	obX(a0),d3				; is this the middle spike? (will be the parent spike)
		bne.s	.next					; if not, branch
		move.b	d6,helix_frame(a0)			; set base spike frame ID for parent
		addq.b	#1,d6					; increment base frame ID for next spike
		andi.b	#7,d6					; wrap around 0-7 frame IDs
		addi.w	#$10,d3					; position each spike $10px apart (left to right)
		addq.b	#1,helix_children(a0)			; increment number of loaded spikes
	.next:
		dbf	d1,.loopBuildHelix			; repeat d1 times (helix length)
; ---------------------------------------------------------------------------

; Hel_Action:
Hel_ParentSpike: ; Routine 2, 4
		bsr.w	Hel_RotateSpikes			; rotate the parent spike like the others
	if FixBugs=0
		; This has been moved to prevent a display-after-free bug.
		bsr.w	DisplaySprite				; display parent helix
	endif
		bra.w	Hel_ChkDel				; delete helix if offscreen

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to rotate helix spike frames and make them conditionally harmful
; ---------------------------------------------------------------------------

Hel_RotateSpikes:
		move.b	(v_ani0_frame).w,d0			; get current frame value from SynchroAnimate => Sync1
		move.b	#col_none,obColType(a0)			; make spike harmless by default
		add.b	helix_frame(a0),d0			; add base spike frame ID
		andi.b	#7,d0					; limit to frames 0-7
		move.b	d0,obFrame(a0)				; update current spike frame
		bne.s	.return					; is new spike frame 0 ("pointing up")? if not, branch
		move.b	#col_8x32|col_hurt,obColType(a0)	; make spike harmful while it's pointing up

	.return:
		rts						; return
; End of function Hel_RotateSpikes

; ===========================================================================

Hel_ChkDel:
		out_of_range.w	.deleteHelix			; has helix gone offscreen? if yes, delete it
	if FixBugs
		; This has been moved to prevent a display-after-free bug.
		bra.w	DisplaySprite				; display parent spike
	else
		rts						; don't delete helix
	endif
; ---------------------------------------------------------------------------

.deleteHelix:
		moveq	#0,d2					; clear d2
		lea	helix_children(a0),a2			; load helix children array (holds RAM indeces for child spikes)
		move.b	(a2)+,d2				; get number of spikes that were loaded
		subq.b	#2,d2					; adjust dbf loop count (-1 for parent spike; -1 for dbf itself)
		bcs.s	Hel_Delete				; if only one spike was loaded (the parent itself), branch

	.delLoop:
		moveq	#0,d0					; clear d0
		move.b	(a2)+,d0				; get 0-based object RAM index of child spike
		lsl.w	#object_size_bits,d0			; multiply by object_size ($40)
		addi.l	#v_objspace&$FFFFFF,d0			; add base object RAM address
		movea.l	d0,a1					; get child spike address
		bsr.w	DeleteChild				; delete child spike object
		dbf	d2,.delLoop				; repeat d2 times (helix length)
		; finally, continue to Hel_Delete for the parent spike itself...
; ---------------------------------------------------------------------------

Hel_Delete:	; Routine 6
		bsr.w	DeleteObject				; delete spike object
		rts						; return
; ===========================================================================

; Hel_Display:
Hel_ChildSpike:	; Routine 8
		bsr.w	Hel_RotateSpikes			; rotate spike and set damage type
		bra.w	DisplaySprite				; display spike (deletion is handled by parent)

; ===========================================================================

Map_Hel:	include	"_maps/Spiked Pole Helix.asm"
