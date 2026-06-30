; ===========================================================================
; ---------------------------------------------------------------------------
; Object 57 - spiked balls twirling on a chain (SYZ, LZ)
; ---------------------------------------------------------------------------

SpikeBall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	SBall_Index(pc,d0.w),d1
		jmp	SBall_Index(pc,d1.w)
; ===========================================================================
SBall_Index:	dc.w SBall_Main-SBall_Index
		dc.w SBall_Move-SBall_Index
		dc.w SBall_Child-SBall_Index

sball_children:	equ objoff_29		; number of child objects (1 byte)
		; $30-$37		; object RAM numbers of children (1 byte each)
sball_origY:	equ objoff_38		; centre y-axis position (2 bytes)
sball_origX:	equ objoff_3A		; centre x-axis position (2 bytes)
sball_radius:	equ objoff_3C		; radius (1 byte)
sball_speed:	equ objoff_3E		; rate of spin (2 bytes)
; ===========================================================================

SBall_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to SBall_Move
		move.l	#Map_SBall,obMap(a0)			; set mappings
		move.w	#ArtTile_SYZ_Spikeball_Chain,obGfx(a0)	; set art tile
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.b	#16/2,obActWid(a0)			; set sprite display width
		move.w	obX(a0),sball_origX(a0)			; remember initial X-position
		move.w	obY(a0),sball_origY(a0)			; remember initial Y-position

		move.b	#col_8x8|col_hurt,obColType(a0)		; SYZ specific code (chain hurts Sonic)
		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		bne.s	.continueSetup				; if not, branch
		move.b	#col_none,obColType(a0)			; LZ specific code (chain doesn't hurt Sonic)
		move.w	#ArtTile_LZ_Spikeball_Chain,obGfx(a0)	; use alternate art tile
		move.l	#Map_SBall2,obMap(a0)			; use alternate mappings

	.continueSetup:
		move.b	obSubtype(a0),d1			; get object subtype
		andi.b	#$F0,d1					; read only the upper digit
		ext.w	d1					; extend to word (can move clockwise or counterclockwise)
		asl.w	#3,d1					; multiply speed by 8
		move.w	d1,sball_speed(a0)			; set object twirl speed

		move.b	obStatus(a0),d0				; get X/Y-flip flags
		ror.b	#2,d0					; shift those flags into topmost bits
		andi.b	#%11000000,d0				; mask out other bits ($C0)
		move.b	d0,obAngle(a0)				; set starting angle for chain based on flip flags

		lea	sball_children(a0),a2			; load child RAM index array
		move.b	obSubtype(a0),d1			; get object subtype again
		andi.w	#7,d1					; read only the lower digit, limited to 0-7 (child count)
		move.b	#0,(a2)+				; initialize to 0 children
		move.w	d1,d3					; copy child count
		lsl.w	#4,d3					; multiply by $10 (distance between each link)
		move.b	d3,sball_radius(a0)			; set radius for parent tip to maximum

		subq.w	#1,d1					; subtract 1 for dbf
		bcs.s	.finalizeTip				; if it underflowed, only the parent is in chain, branch
		btst	#3,obSubtype(a0)			; are 8 balls set to be spawned?
		beq.s	.makeChain				; if not, branch
		subq.w	#1,d1					; only load 7 balls instead? (...why?)
		bcs.s	.finalizeTip				; if it underflowed, only the parent is in chain, branch

.makeChain:
	if FixBugs
		; If an object is allocated before the parent object, then
		; when the child is deleted, it will have already been queued
		; for display, which is a display-and-delete bug.
		bsr.w	FindNextFreeObj				; find a free object slot (after current)
	else
		bsr.w	FindFreeObj				; find a free object slot (anywhere)
	endif
		bne.s	.finalizeTip				; if object RAM is full, branch

		addq.b	#1,sball_children(a0)			; increment child object counter
		move.w	a1,d5					; get child object RAM address
		subi.w	#v_objspace&$FFFF,d5			; subtract by base object RAM location
		lsr.w	#object_size_bits,d5			; divide by $40 (object_size)
		andi.w	#$7F,d5					; limit to sane values
		move.b	d5,(a2)+				; store RAM index for child object in parent for twirl and delete logic

		move.b	#4,obRoutine(a1)			; set to SBall_Child
		_move.b	obID(a0),obID(a1)			; copy object ID from parent
		move.l	obMap(a0),obMap(a1)			; copy mappings from parent
		move.w	obGfx(a0),obGfx(a1)			; copy art tile from parent
		move.b	obRender(a0),obRender(a1)		; copy render flags from parent
		move.b	obPriority(a0),obPriority(a1)		; copy sprite priority from parent
		move.b	obActWid(a0),obActWid(a1)		; copy sprite display width from parent
		move.b	obColType(a0),obColType(a1)		; copy collision type from parent (damaging or not damaging)

		subi.b	#$10,d3					; reduce radius distance by $10
		move.b	d3,sball_radius(a1)			; set new radius distance

		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		bne.s	.next					; if not, branch
		tst.b	d3					; is this the final child? (stem attached to floor)
		bne.s	.next					; if not, branch
		move.b	#2,obFrame(a1)				; use different frame for the LZ stem

	.next:
		dbf	d1,.makeChain				; repeat for length of chain

.finalizeTip:
		move.w	a0,d5					; move RAM address for this parent object to d5
		subi.w	#v_objspace&$FFFF,d5			; subtract by base object RAM location
		lsr.w	#object_size_bits,d5			; divide by $40 (object_size)
		andi.w	#$7F,d5					; limit to sane values
		move.b	d5,(a2)+				; store RAM index for parent object in itself for twirl logic

		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		bne.s	SBall_Move				; if not, branch
		move.b	#col_16x16|col_hurt,obColType(a0)	; make tip of chain harmful
		move.b	#1,obFrame(a0)				; use larger spikeball frame for tip
; ---------------------------------------------------------------------------

SBall_Move:	; Routine 2
		bsr.w	Sball_Twirl				; twirl all objects in chain
		bra.w	SBall_ChkDel				; display parent object, or delete whole chain if offscreen

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to twirl chain with all child objects
; ---------------------------------------------------------------------------

Sball_Twirl:
		move.w	sball_speed(a0),d0			; get twirl speed for chain (can be positive or negative)
		add.w	d0,obAngle(a0)				; add it to current twirling angle

		move.b	obAngle(a0),d0				; get new angle
		jsr	(CalcSine).l				; calculate sine and cosine for current angle
		move.w	sball_origY(a0),d2			; get initial Y-position
		move.w	sball_origX(a0),d3			; get initial X-position
		lea	sball_children(a0),a2			; load child RAM index array

		moveq	#0,d6					; clear d6
		move.b	(a2)+,d6				; get number of loaded child objects
	.loop:
		moveq	#0,d4					; clear d4
		move.b	(a2)+,d4				; get next child RAM index from array
		lsl.w	#object_size_bits,d4			; multiply by $40 (object_size)
		addi.l	#v_objspace&$FFFFFF,d4			; add base object RAM location
		movea.l	d4,a1					; a1 = address of current child object in RAM

		moveq	#0,d4					; clear d4 again
		move.b	sball_radius(a1),d4			; get radius for child object
		move.l	d4,d5					; copy radius for later
		muls.w	d0,d4					; multiply radius by angle sine
		asr.l	#8,d4					; shift result down a byte
		muls.w	d1,d5					; multiply radius by angle cosine
		asr.l	#8,d5					; shift result down a byte
		add.w	d2,d4					; add original Y-position to sine result
		add.w	d3,d5					; add original X-position to cosine result
		move.w	d4,obY(a1)				; update Y-position for twirling
		move.w	d5,obX(a1)				; update X-position for twirling
		dbf	d6,.loop				; loop for all child objects

		rts						; return
; End of function Sball_Twirl
; ===========================================================================

SBall_ChkDel:
		out_of_range.w	.delete,sball_origX(a0)		; has object gone offscreen? if yes, branch
		bra.w	DisplaySprite				; display parent object
; ---------------------------------------------------------------------------

	.delete:
		moveq	#0,d2					; clear d2
		lea	sball_children(a0),a2			; load child RAM index array
		move.b	(a2)+,d2				; get number of loaded child objects
	.deleteloop:
		moveq	#0,d0					; clear d0
		move.b	(a2)+,d0				; get next child RAM index from array
		lsl.w	#object_size_bits,d0			; multiply by $40 (object_size)
		addi.l	#v_objspace&$FFFFFF,d0			; add base object RAM location
		movea.l	d0,a1					; move result to a1 (input for DeleteChild)
		bsr.w	DeleteChild				; delete the child object
		dbf	d2,.deleteloop				; loop for all childrne in chain

		rts						; return
; ===========================================================================

; SBall_Display:
SBall_Child:	; Routine 4
		; Child objects are just displayed normally, rotation and deletion is handled by parent
		bra.w	DisplaySprite				; display child

; ===========================================================================

Map_SBall:	include	"_maps/Spiked Ball and Chain (SYZ).asm"
Map_SBall2:	include	"_maps/Spiked Ball and Chain (LZ).asm"
