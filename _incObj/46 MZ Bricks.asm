; ===========================================================================
; ---------------------------------------------------------------------------
; Object 46 - solid blocks and blocks that fall from the ceiling (MZ)
; ---------------------------------------------------------------------------

MarbleBrick:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Brick_Index(pc,d0.w),d1
		jmp	Brick_Index(pc,d1.w)
; ===========================================================================
Brick_Index:	dc.w Brick_Main-Brick_Index
		dc.w Brick_Action-Brick_Index

brick_origY:	equ objoff_30		; initial Y-position used by wobble effect
; ===========================================================================

Brick_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Brick_Action
		move.b	#30/2,obHeight(a0)			; set height
		move.b	#30/2,obWidth(a0)			; set width
		move.l	#Map_Brick,obMap(a0)			; set mappings
		move.w	#ArtTile_Level|Tile_Pal3,obGfx(a0)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#3,obPriority(a0)			; set sprite priority
		move.b	#32/2,obActWid(a0)			; set sprite display width
		move.w	obY(a0),brick_origY(a0)			; remember initial Y-position for wobble effect
	if FixBugs=0
		; This appears to be some unused leftover with unknown purpose.
		; It already existed in the prototype, but didn't seem to have
		; any purpose there either. The value $5C0 matches one brick's
		; X-coordinate in MZ3, but this could just be coincidental.
		move.w	#$5C0,objoff_32(a0)			; unused leftover...
	endif
; ---------------------------------------------------------------------------

Brick_Action:	; Routine 2
		tst.b	obRender(a0)				; is brick on screen?
		bpl.s	.chkdel					; if not, branch

		moveq	#0,d0					; clear d0 for word-addressing
		move.b	obSubtype(a0),d0			; get object type
		andi.w	#7,d0					; read only the 1st digit
		add.w	d0,d0					; double for word-based indexing
		move.w	Brick_TypeIndex(pc,d0.w),d1		; find jummp table entry
		jsr	Brick_TypeIndex(pc,d1.w)		; execute movement logic for brick subtype

		move.w	#32/2+sonic_solid_width,d1
		move.w	#32/2,d2
		move.w	#34/2,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject				; handle solidity with Sonic
; ---------------------------------------------------------------------------

.chkdel:
	if Revision=0
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	else
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	endif
; ===========================================================================
Brick_TypeIndex:dc.w Brick_Type00-Brick_TypeIndex
		dc.w Brick_Type01-Brick_TypeIndex
		dc.w Brick_Type02-Brick_TypeIndex
		dc.w Brick_Type03-Brick_TypeIndex
		dc.w Brick_Type04-Brick_TypeIndex
; ===========================================================================

Brick_Type00:	; subtyoe 0 = do nothing
		rts						; just a static brick
; ===========================================================================

Brick_Type02:	; subtyoe 2 = fall when Sonic gets close
		move.w	(v_player+obX).w,d0			; get Sonic's X-position
		sub.w	obX(a0),d0				; calculate difference to brick's X-position
		bhs.s	.chkX					; if result is positive, branch
		neg.w	d0					; make positive to account for other side
	.chkX:
		cmpi.w	#$90,d0					; is Sonic within $90 pixels of the block?
		bhs.s	Brick_Type01				; if not, resume wobbling
		move.b	#3,obSubtype(a0)			; if yes, make the block fall
; ---------------------------------------------------------------------------

Brick_Type01:	; subtype 1 = wobble fast (in ceiling)
		moveq	#0,d0
		move.b	(v_oscillate+$16).w,d0			; get fast oscillation data
		btst	#3,obSubtype(a0)			; is "reverse movement" flag set?
		beq.s	.wobble					; if not, branch
		neg.w	d0					; invert wobble direction
		addi.w	#$10,d0					; add $10px offset
	.wobble:
		move.w	brick_origY(a0),d1			; get initial Y-position
		sub.w	d0,d1					; subtract wobble offset
		move.w	d1,obY(a0)				; update the block's position to make it wobble
		rts						; return
; ===========================================================================

Brick_Type03:	; subtype 3 = fall until floor is hit
		bsr.w	SpeedToPos				; update coordinates based on speed
		addi.w	#$18,obVelY(a0)				; increase falling speed

		bsr.w	ObjFloorDist				; check distance to floor
		tst.w	d1					; has the block hit the floor?
		bpl.w	.return					; if not, branch
		add.w	d1,obY(a0)				; align block to floor
		clr.w	obVelY(a0)				; stop the block falling

		move.w	obY(a0),brick_origY(a0)			; set new initial Y-position
		move.b	#4,obSubtype(a0)			; advance to Brick_Type04 (slow wobble on lava)

		move.w	(a1),d0					; a1 = 16x16 block ID the brick is resting on
		andi.w	#$3FF,d0				; mask out mirror/flip flags
	if Revision=0
		; The bricks did not wobble on lava in REV00, which was corrected in REV01.
		; Looking at the prototype, this is because Marble Zone originally had
		; a lot of unused blank 16x16 blocks between the main stuff and lava.
		; At some point, the unused blocks were deleted, but the devs forgot to
		; adjust this value accordingly, which resulted in the static bricks.
		cmpi.w	#$2E8,d0				; impossible condition (there aren't this many blocks in MZ)
	else
		cmpi.w	#$16A,d0				; is it a lava block? (block ID $16A and above)
	endif
		bhs.s	.return					; if yes, branch (keep it wobbling)
		move.b	#0,obSubtype(a0)			; otherwise, reset it back to static (no wobble)

	.return:
		rts						; return
; ===========================================================================

Brick_Type04:	; subtype 4 = wobble slow (on lava)
		moveq	#0,d0
		move.b	(v_oscillate+$12).w,d0			; get slow oscillation data
		lsr.w	#3,d0					; divide by 8 to slow down further
		move.w	brick_origY(a0),d1			; get initial Y-position
		sub.w	d0,d1					; subtract wobble offset
		move.w	d1,obY(a0)				; update the block's position to make it wobble
		rts						; return
; ===========================================================================

Map_Brick:	include	"_maps/MZ Bricks.asm"
