; ===========================================================================
; ---------------------------------------------------------------------------
; Object 5B - blocks that form a staircase when touched (SLZ)
; ---------------------------------------------------------------------------

Staircase:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Stair_Index(pc,d0.w),d1
		jsr	Stair_Index(pc,d1.w)
		out_of_range.w	DeleteObject,stair_origX(a0)
		bra.w	DisplaySprite
; ===========================================================================
Stair_Index:	dc.w Stair_Main-Stair_Index
		dc.w Stair_Move-Stair_Index
		dc.w Stair_Solid-Stair_Index

stair_origX:		equ objoff_30		; original x-axis position
stair_origY:		equ objoff_32		; original y-axis position
stair_delay:		equ objoff_34		; delay between activation and stairs moving down
stair_touch:		equ objoff_36		; state the stairs is touched by Sonic (0 = none, 1 = from above, -1 = from below)
stair_parentYindex:	equ objoff_37		; orientation of the stairs (1 = move down to the right, -1 = move down to the left)
stair_childrenY:	equ objoff_38		; relative Y-positions got the four child blocks, one byte per block
stair_childrenY_End:	equ objoff_3B		; last entry for the above array
stair_parent:		equ objoff_3C		; address of parent object (4 bytes)
; ===========================================================================

Stair_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Stair_Move

		moveq	#stair_childrenY,d3			; write children Y-positions to SSTs $38 to $3B
		moveq	#1,d4					; store SSTs forwards
		btst	#0,obStatus(a0)				; is object X-flipped?
		beq.s	.writeFirst				; if not, branch
		moveq	#stair_childrenY_End,d3			; write children Y-positions to SSTs $3B to $38 (backwards)
		moveq	#-1,d4					; write SSTs backwards (stairs move down to the left)

	.writeFirst:
		move.w	obX(a0),d2				; base X-position for stair blocks
		movea.l	a0,a1					; load first stair block into current RAM (will be parent)
		moveq	#4-1,d1					; load 4 stair blocks
		bra.s	.makeblocks				; first stair blocks stays in obRoutine 2
; ===========================================================================

	.loop:
		bsr.w	FindNextFreeObj				; find a free object slot
		bne.w	Stair_Move				; if object RAM is full, branch
		move.b	#4,obRoutine(a1)			; set stair element to Stair_Solid routine

	.makeblocks:
		_move.b	#id_Staircase,obID(a1)			; load stair block object
		move.l	#Map_Stair,obMap(a1)			; set mappings
		move.w	#ArtTile_Level|Tile_Pal3,obGfx(a1)	; set art tile (part of main level graphics) and palette line
		move.b	#sprite_cam_field,obRender(a1)		; set to playfield-positioned mode
		move.b	#3,obPriority(a1)			; set sprite priority
		move.b	#32/2,obActWid(a1)			; set sprite display width and solidity width
		move.b	obSubtype(a0),obSubtype(a1)		; copy subtype from parent
		move.w	d2,obX(a1)				; set X-position for block
		move.w	obY(a0),obY(a1)				; copy Y-position from parent
		move.w	obX(a0),stair_origX(a1)			; remember initial X-position
		move.w	obY(a1),stair_origY(a1)			; remember initial Y-position
		addi.w	#32,d2					; spawn next block 32px further to the right
		move.b	d3,stair_parentYindex(a1)		; remember SST in parent (any of $38 to $3B)
		move.l	a0,stair_parent(a1)			; remember parent stair block
		add.b	d4,d3					; advance to next child SST index
		dbf	d1,.loop				; repeat sequence 3 times
; ---------------------------------------------------------------------------

Stair_Move:	; Routine 2
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get subtype of parent stair (usually 0 or 2)
		andi.w	#7,d0					; limit to sane values
		add.w	d0,d0					; double for word-based indexing
		move.w	Stair_TypeIndex(pc,d0.w),d1		; find stair behavior in offset table
		jsr	Stair_TypeIndex(pc,d1.w)		; jump there to control stairs, then return here
; ---------------------------------------------------------------------------

Stair_Solid:	; Routine 4
		movea.l	stair_parent(a0),a2			; load parent stair block
		moveq	#0,d0					; clear d0
		move.b	stair_parentYindex(a0),d0		; get child index used inside parent
		move.b	(a2,d0.w),d0				; get current Y-offset for child stair block
		add.w	stair_origY(a0),d0			; add initial Y-position
		move.w	d0,obY(a0)				; set new Y-position for child stair block

		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as solidity width
		addi.w	#sonic_solid_width,d1			; add Sonic's own collision width
		move.w	#32/2,d2				; collision height (initial)
		move.w	#34/2,d3				; collision height (stood-on)
		move.w	obX(a0),d4				; X-position (stood-on)
		bsr.w	SolidObject				; make stair block solid and return value on touch
		tst.b	d4					; has Sonic touched the block? (positive = top/bottom collision)
		bpl.s	.checkStanding				; if not, branch
		move.b	d4,stair_touch(a2)			; remember collision state (negative for "from below")

	.checkStanding:
		btst	#3,obStatus(a0)				; is Sonic standing on this block?
		beq.s	.return					; if not, branch
		move.b	#1,stair_touch(a2)			; make collision state positive ("from above")

	.return:
		rts						; return

; ===========================================================================
Stair_TypeIndex:dc.w Stair_Type00-Stair_TypeIndex		; 0
		dc.w Stair_Type01-Stair_TypeIndex		; 1
		dc.w Stair_Type02-Stair_TypeIndex		; 2
		dc.w Stair_Type01-Stair_TypeIndex		; 3
; ===========================================================================

Stair_Type00:	; Moves down when Sonic stands on it
		tst.w	stair_delay(a0)				; are stairs already set to move down?
		bne.s	.delayMove				; if yes, branch
		cmpi.b	#1,stair_touch(a0)			; is Sonic standing on the stairs?
		bne.s	.return					; if not, branch
		move.w	#30,stair_delay(a0)			; wait half a second before moving stairs down

	.return:
		rts						; return
; ---------------------------------------------------------------------------

.delayMove:
		subq.w	#1,stair_delay(a0)			; decrement timer before moving stairs down
		bne.s	.return					; if time remains, branch
		addq.b	#1,obSubtype(a0)			; set subtype to Stair_Type01 (move down stairs)
		rts						; return
; ===========================================================================

Stair_Type02:	; Moves down when Sonic hits it from below
		tst.w	stair_delay(a0)				; are stairs already set to move down?
		bne.s	.delayMove				; if yes, branch
		tst.b	stair_touch(a0)				; has Sonic touched the stairs from below?
		bpl.s	.return					; if not, branch
		move.w	#60,stair_delay(a0)			; wobble stairs for 1 second before moving down

	.return:
		rts						; return
; ---------------------------------------------------------------------------

.delayMove:
		subq.w	#1,stair_delay(a0)			; decrement timer before moving stairs down
		bne.s	.wobbleStairs				; if time remains, make stairs wobble
		addq.b	#1,obSubtype(a0)			; set subtype to Stair_Type01 (move down stairs)
		rts						; return
; ---------------------------------------------------------------------------

.wobbleStairs:
		lea	stair_childrenY(a0),a1			; load child block Y-positions
		move.w	stair_delay(a0),d0			; use current delay as wobble seed
		lsr.b	#2,d0					; divide by 4
		andi.b	#1,d0					; limit to 0-1
		move.b	d0,(a1)+				; wobble 1st block
		eori.b	#1,d0					; invert wobble direction
		move.b	d0,(a1)+				; wobble 2nd block
		eori.b	#1,d0					; invert wobble direction
		move.b	d0,(a1)+				; wobble 3rd block
		eori.b	#1,d0					; invert wobble direction
		move.b	d0,(a1)+				; wobble 4th block
		rts						; return
; ===========================================================================

Stair_Type01:	; Moves down automatically (usually only set from subtype 0 or 2)
		lea	stair_childrenY(a0),a1			; load child block Y-positions
		cmpi.b	#128,(a1)				; have stairs already fully moved down? (128px)
		beq.s	.return					; if yes, don't move it down further

		addq.b	#1,(a1)					; move blocks one step down further (first block is 1px/frame)
		moveq	#0,d1					; clear d1
		move.b	(a1)+,d1				; get current moving-down value (D)
		swap	d1					; convert to 16.16 fixed point
		lsr.l	#1,d1					; d1 = D / 2
		move.l	d1,d2					; d2 = D / 2
		lsr.l	#1,d1					; d1 = D / 4
		move.l	d1,d3					; d3 = D / 4
		add.l	d2,d3					; d3 = D * (3 / 4)
		swap	d1					; undo conversion to 16.16 fixed point
		swap	d2					; ''
		swap	d3					; ''
		move.b	d3,(a1)+				; move 2nd block down at 2px/frame
		move.b	d2,(a1)+				; move 3rd block down at 3px/frame
		move.b	d1,(a1)+				; move 4th block down at 4px/frame

	.return:
		rts						; return
		rts						; redundant second rts
; ===========================================================================

Map_Stair:	include	"_maps/Staircase.asm"
