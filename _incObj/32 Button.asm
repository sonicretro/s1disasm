; ===========================================================================
; ---------------------------------------------------------------------------
; Object 32 - buttons/switches (MZ, SYZ, LZ, SBZ)
; ---------------------------------------------------------------------------

Button:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	But_Index(pc,d0.w),d1
		jmp	But_Index(pc,d1.w)
; ===========================================================================
But_Index:	dc.w But_Main-But_Index
		dc.w But_Pressed-But_Index
; ===========================================================================

But_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_But,obMap(a0)

		move.w	#ArtTile_Button_Main|Tile_Pal3,obGfx(a0); MZ specific code
		cmpi.b	#id_MZ,(v_zone).w			; is level Marble Zone?
		beq.s	.continueSetup				; if yes, branch
		move.w	#ArtTile_Button_Main,obGfx(a0)		; SYZ, LZ and SBZ specific code

	; But_IsMZ:
	.continueSetup:
		move.b	#sprite_cam_field,obRender(a0)
		move.b	#32/2,obActWid(a0)
		move.b	#4,obPriority(a0)
		addq.w	#3,obY(a0)
; ---------------------------------------------------------------------------

But_Pressed:	; Routine 2
		tst.b	obRender(a0)				; is button on screen?
	if FixBugs
		; Covers an out-of-range error due to the below fix.
		bpl.w	.display				; if not, branch
	else
		bpl.s	.display				; if not, branch
	endif

		move.w	#32/2+sonic_solid_width,d1
		move.w	#10/2,d2
		move.w	#10/2,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject

		bclr	#0,obFrame(a0)				; use "unpressed" frame

		move.b	obSubtype(a0),d0			; get subtype of button
		andi.w	#$F,d0					; only look at lower nybble
		lea	(f_switch).w,a3				; load button status array
		lea	(a3,d0.w),a3				; go to byte for this button
		moveq	#0,d3					; use bit 0 for the pressed state flag

		; This alters the target bit in the switch status array to be 7 instead of 0
		; if subtype 6 is set. It goes completely unused in the entire game.
		btst	#6,obSubtype(a0)			; is "alternate flag" state set? (unused)
		beq.s	.checkMZ1Block				; if not, branch
		moveq	#7,d3					; use bit 7 for the pressed state flag instead

	; loc_BDB2:
	.checkMZ1Block:
		tst.b	obSubtype(a0)				; is this the special MZ1 button? (bit 7 set)
		bpl.s	.checkSonicOnTop			; if not, branch
	if FixBugs
		; A handful of buttons in the object layout definitions outside Marble Zone also
		; have bit 7 set for unrelated purposes, making But_MZBlock a dangerous subroutine.
		cmpi.b	#id_MZ,(v_zone).w			; are we in Marble Zone?
		bne.s	.checkSonicOnTop			; if not, skip this subroutine
	endif
		bsr.w	But_MZBlock				; check if pushable block has landed on button
		bne.s	.pressed				; if it has, branch

	; loc_BDBE:
	.checkSonicOnTop:
		tst.b	obSolid(a0)				; is Sonic standing on top of button?
		bne.s	.pressed				; if yes, branch
		bclr	d3,(a3)					; clear stored button pressed state
		bra.s	.handleFlashing
; ===========================================================================

; loc_BDC8:
.pressed:
		tst.b	(a3)					; has Sonic already been standing on it the previous frame?
		bne.s	.setPressedState			; if yes, don't play sound again
		move.w	#sfx_Switch,d0
		jsr	(QueueSound2).l				; play switch sound

	; loc_BDD6:
	.setPressedState:
		bset	d3,(a3)					; set stored button pressed state
		bset	#0,obFrame(a0)				; use "pressed" frame

	; loc_BDDE:
	.handleFlashing:
		; This makes the switch flash between red and gray if bit 5 in subtype is set.
		; It goes completely unused in the entire game and is partially broken in some zones.
		btst	#5,obSubtype(a0)			; is "flashing" flag set? (unused)
		beq.s	.display				; if not, branch
		subq.b	#1,obTimeFrame(a0)			; decrement animation delay
		bpl.s	.display				; if time remains, branch
		move.b	#7,obTimeFrame(a0)			; reset animation delay
		bchg	#1,obFrame(a0)				; alternate between frame 0 (gray) and 2 (red)

; But_Display:
.display:
	if FixBugs
		; Objects shouldn't call DisplaySprite and DeleteObject on
		; the same frame or else cause a null-pointer dereference.
		out_of_range.s	.delete
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	.delete
		rts
	endif

	.delete:
		bsr.w	DeleteObject
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to handle the special button in Marble Zone act 1 that
; gets pressed down by a pushable block to raise a spiked chaindelier
;
; output:
;	d0 = 1 if block is on top of button, 0 if not
; ---------------------------------------------------------------------------

But_MZBlock:
		move.w	d3,-(sp)
		move.w	obX(a0),d2
		move.w	obY(a0),d3
		subi.w	#$10,d2					; d2 = x pos. of button left edge
		subq.w	#8,d3					; d3 = y pos. of button top edge
		move.w	#$20,d4					; d4 = x detection range; 
		move.w	#$10,d5					; d5 = y detection range

		lea	(v_lvlobjspace).w,a1			; begin checking object RAM
		move.w	#(v_lvlobjend-v_lvlobjspace)/object_size-1,d6
	; But_MZLoop:
	.findBlock:
		tst.b	obRender(a1)				; is object on screen?
		bpl.s	.nextObject				; if not, branch
		cmpi.b	#id_PushBlock,obID(a1)			; is object a pushable green MZ block?
		beq.s	.blockFound				; if yes, branch
	; loc_BE4E:
	.nextObject:
		lea	object_size(a1),a1			; check next object
		dbf	d6,.findBlock				; repeat $5F times

		move.w	(sp)+,d3
		moveq	#0,d0					; set pushable block NOT on top

	.return:
		rts

; ===========================================================================
.mzBlock_sizes:	dc.b $10, $10	; x/y radius
; ===========================================================================

; loc_BE5E:
.blockFound:
		moveq	#1,d0
		andi.w	#$3F,d0
		add.w	d0,d0
		lea	.mzBlock_sizes-2(pc,d0.w),a2

	.checkX:
		move.b	(a2)+,d1				; load X-radius
		ext.w	d1
		move.w	obX(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bhs.s	.checkX_fromRight			; branch if block is to the right of button
		add.w	d1,d1
		add.w	d1,d0
		blo.s	.checkY
		bra.s	.nextObject

	; loc_BE80:
	.checkX_fromRight:
		cmp.w	d4,d0
		bhi.s	.nextObject
; ---------------------------------------------------------------------------

; loc_BE84:
.checkY:
		move.b	(a2)+,d1				; load y-radius
		ext.w	d1
		move.w	obY(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bhs.s	.checkY_fromAbove			; branch if block is above button
		add.w	d1,d1
		add.w	d1,d0
		blo.s	.blockOnTop
		bra.s	.nextObject

	; loc_BE9A:
	.checkY_fromAbove:
		cmp.w	d5,d0
		bhi.s	.nextObject
; ---------------------------------------------------------------------------

; loc_BE9E:
.blockOnTop:
		move.w	(sp)+,d3
		moveq	#1,d0					; set pushable block on top
		rts
; End of function But_MZBlock
; ===========================================================================

Map_But:	include	"_maps/Button.asm"
