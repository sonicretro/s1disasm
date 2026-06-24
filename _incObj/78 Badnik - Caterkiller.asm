; ===========================================================================
; ---------------------------------------------------------------------------
; Object 78 - Caterkiller enemy (MZ, SBZ)
; 
; This is easily the most complex badnik object in the entire game, and also
; a contender for the most complex object overall. It also came with a whole
; bunch of bugfixes introduced in REV01 to cover various edge cases.
; ---------------------------------------------------------------------------

Caterkiller:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Cat_Index(pc,d0.w),d1
		jmp	Cat_Index(pc,d1.w)
; ===========================================================================
Cat_Index:	dc.w Cat_Main-Cat_Index		; 0 - init
		dc.w Cat_Head-Cat_Index		; 2 - head
		dc.w Cat_BodySeg1-Cat_Index	; 4 - 1st body segment
		dc.w Cat_BodySeg2-Cat_Index	; 6 - 2nd body segment
		dc.w Cat_BodySeg1-Cat_Index	; 8 - 3rd body segment
		dc.w Cat_Delete-Cat_Index	; A - delete head or segment
		dc.w Cat_Fragment-Cat_Index	; C - fragmentated/bouncy state

cat_waittime:	equ objoff_2A	; time to wait between actions
cat_mode:	equ objoff_2B	; bit 4 (+$10) = mouth is open/segment moving up; bit 7 (+$80) = update animation
cat_floormap:	equ objoff_2C	; height map of floor beneath caterkiller (16 bytes)
cat_parent:	equ objoff_3C	; address of parent object (4 bytes - high byte is cat_segmentpos)
cat_segmentpos:	equ cat_parent	; segment position - starts as 0/4/8/$A, increments as it moves
; ===========================================================================

Cat_Return:
		rts						; return
; ===========================================================================

Cat_Main:	; Routine 0
		move.b	#14/2,obHeight(a0)			; set height
		move.b	#16/2,obWidth(a0)			; set width

		; Make the Caterkiller fall until it has collided with the floor (while invisible)
		jsr	(ObjectFall).l				; increase gravity and update position
		jsr	(ObjFloorDist).l			; get distance between Caterkiller and floor
		tst.w	d1					; has Caterkiller hit the floor?
		bpl.s	Cat_Return				; if not, branch
		add.w	d1,obY(a0)				; match object's position with the floor
		clr.w	obVelY(a0)				; clear falling speed
		addq.b	#2,obRoutine(a0)			; advance to Cat_Head
		move.l	#Map_Cat,obMap(a0)			; set mappings

		move.w	#ArtTile_SBZ_Caterkiller|Tile_Pal2,obGfx(a0) ; set art tile and palette line for SBZ
		cmpi.b	#id_SBZ,(v_zone).w			; are we in SBZ?
		beq.s	.continueSetup				; if yes, branch
		move.w	#ArtTile_MZ_SYZ_Caterkiller|Tile_Pal2,obGfx(a0) ; set art tile and palette for MZ/SYZ

	.continueSetup:
		andi.b	#sprite_xflip|sprite_yflip,obRender(a0)	; clear render flags except X/Y-flip
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	obRender(a0),obStatus(a0)		; copy render flags to status flags
		move.b	#4,obPriority(a0)			; set to sprite priority
		move.b	#16/2,obActWid(a0)			; set sprite display width
		move.b	#col_16x16|col_badnik,obColType(a0)	; set ReactToItem type for head to be destroyable ($B)

		move.w	obX(a0),d2				; use head's X-position as start body part position
		moveq	#12,d5					; set gap distance between body parts to 12px
		btst	#0,obStatus(a0)				; is Caterkiller facing left?
		beq.s	.prepareBodyLoop			; if not, branch
		neg.w	d5					; invert body part gap distance
	.prepareBodyLoop:
		move.b	#4,d6					; set start routine for first segment to Cat_BodySeg1
		moveq	#0,d3
		moveq	#4,d4
		movea.l	a0,a2					; parent object address
		moveq	#3-1,d1					; load 3 spiked body segments

.loopCreateBodySegments:
		jsr	(FindNextFreeObj).l			; find a free object slot
	if Revision=0
		bne.s	.nextBodyPart				; if object RAM is full, branch
	else
		; REV01 will delete the entire Caterkiller if object RAM is full.
		bne.w	Cat_Despawn				; if object RAM is full, branch
	endif
		_move.b	#id_Caterkiller,obID(a1)		; load body segment object
		move.b	d6,obRoutine(a1)			; goto Cat_BodySeg1 or Cat_BodySeg2 next
		addq.b	#2,d6					; alternate between the two
		move.l	obMap(a0),obMap(a1)			; copy mappings
		move.w	obGfx(a0),obGfx(a1)			; copy art tile and palette line
		move.b	#5,obPriority(a1)			; set sprite priority (behind head)
		move.b	#16/2,obActWid(a1)			; set sprite display width
		move.b	#col_16x16|col_special,obColType(a1)	; special ReactToItem handler for body parts ($CB)
		add.w	d5,d2					; increase body part gap distance
		move.w	d2,obX(a1)				; set X-position for current body part
		move.w	obY(a0),obY(a1)				; copy Y-position from head
		move.b	obStatus(a0),obStatus(a1)		; copy status flags (X-flip etc.)
		move.b	obStatus(a0),obRender(a1)		; copy render flags
		move.b	#8,obFrame(a1)				; set to ".body1" frame
		move.l	a2,cat_parent(a1)			; make body part remember parent head object
		move.b	d4,cat_segmentpos(a1)
		addq.b	#4,d4
		movea.l	a1,a2					; make adjacent segment the parent object instead of head
	.nextBodyPart:
		dbf	d1,.loopCreateBodySegments		; repeat sequence 2 more times

		move.b	#8-1,cat_waittime(a0)			; set time delay to stay on high/low head position frame
		clr.b	cat_segmentpos(a0)
; ---------------------------------------------------------------------------

Cat_Head:	; Routine 2
		tst.b	obStatus(a0)				; has Sonic touched a spiked body segment? (set in ReactToItem)
		bmi.w	Cat_FragmentateBody			; if yes, fragmentate Caterkiller head

		moveq	#0,d0					; clear d0 for word-addressing
		move.b	ob2ndRout(a0),d0			; get current secondary routine counter
		move.w	Cat_HeadIndex(pc,d0.w),d1		; find index in head actions
		jsr	Cat_HeadIndex(pc,d1.w)			; jump there, then return here

		move.b	cat_mode(a0),d1				; should head frame get changed?
		bpl.s	.display				; if not, branch

		lea	(Ani_Cat).l,a1				; load special Caterkiller animation script
		move.b	obAngle(a0),d0
		andi.w	#$7F,d0					; ignore high bit of angle
		addq.b	#4,obAngle(a0)				; increment angle (wraps from $FC to 0)
		move.b	(a1,d0.w),d0				; get byte from animation script, based on angle
		bpl.s	.animate				; branch if not $FF
		bclr	#7,cat_mode(a0)				; disable animation
		bra.s	.display

	.animate:
		andi.b	#$10,d1					; read mouth open/closed bit
		add.b	d1,d0					; add to frame (+$10)
		move.b	d0,obFrame(a0)				; set frame

	.display:
		out_of_range.w	Cat_Despawn			; has Caterkiller gone offscreen? if yes, branch
		jmp	(DisplaySprite).l			; display head sprite
; ---------------------------------------------------------------------------

; Cat_ChkGone:
Cat_Despawn:
		lea	(v_objstate).w,a2			; load respawn table
		moveq	#0,d0					; clear d0 for word-addressing
		move.b	obRespawnNo(a0),d0			; get respawn table index
		beq.s	.delete					; if it doesn't have one, branch
		bclr	#7,2(a2,d0.w)				; clear respawn block flag

	.delete:
		move.b	#$A,obRoutine(a0)			; goto Cat_Delete next (also used as flag in .chk_broken)
		rts						; return
; ===========================================================================

Cat_Delete:	; Routine $A
		jmp	(DeleteObject).l			; delete Caterkiller head

; ===========================================================================
Cat_HeadIndex:	dc.w Cat_Undulate-Cat_HeadIndex	; 0
		dc.w Cat_Floor-Cat_HeadIndex	; 2
; ===========================================================================

; .wait:
Cat_Undulate:
		subq.b	#1,cat_waittime(a0)			; decrement time delay staying on high/low head position frame
		bmi.s	.move					; if timer expired, branch
		rts						; stay still this frame
; ---------------------------------------------------------------------------

	.move:
		addq.b	#2,ob2ndRout(a0)			; advance to Cat_Floor
		move.b	#17-1,cat_waittime(a0)			; set timer for movement
		move.w	#-$C0,obVelX(a0)			; move head to the left
		move.w	#$40,obInertia(a0)
		bchg	#4,cat_mode(a0)				; change between mouth open/moving up, and mouth closed/moving down
		bne.s	.updateHeadSprite			; if going up now (mouth open), branch
		clr.w	obVelX(a0)				; don't move left
		neg.w	obInertia(a0)

	.updateHeadSprite:
		bset	#7,cat_mode(a0)				; set flag to update head sprite
		; Continue to Cat_Floor...
; ===========================================================================

Cat_Floor:
		subq.b	#1,cat_waittime(a0)			; decrement timer
		bmi.s	.undulateNext				; branch if -1

	if Revision=0
		move.l	obX(a0),-(sp)				; backuop current head X-position (with subpixels)
		move.l	obX(a0),d2				; get current head X-position (with subpixels)
	else
		tst.w	obVelX(a0)				; is head moving horizontally?
		beq.s	.return					; if not, branch
		move.l	obX(a0),d2				; get current head X-position (with subpixels)
		move.l	d2,d3					; d3 = X-pos before update
	endif
		move.w	obVelX(a0),d0				; get current head X-speed
		btst	#0,obStatus(a0)				; is Caterkiller is flipped?
		beq.s	.noFlip					; if not, branch
		neg.w	d0					; change direction if X-flipped (i.e. move right)
	.noFlip:
		ext.l	d0
		asl.l	#8,d0					; multiply speed by $100
		add.l	d0,d2					; add to x pos
		move.l	d2,obX(a0)				; update position
	if Revision=0
		jsr	(ObjFloorDist).l
		move.l	(sp)+,d2				; retrieve previous X-pos from stack
		cmpi.w	#-8,d1
		blt.s	.ledgeHit				; branch if > 8px below floor
		cmpi.w	#$C,d1
		bge.s	.ledgeHit				; branch if > 11px above floor (also detects a ledge)
		add.w	d1,obY(a0)				; align to floor
		swap	d2
		cmp.w	obX(a0),d2
		beq.s	.return					; branch if head hasn't moved horizontally
	else
		swap	d3
		cmp.w	obX(a0),d3
		beq.s	.return					; branch if head hasn't moved horizontally
		jsr	(ObjFloorDist).l
		cmpi.w	#-8,d1
		blt.s	.ledgeHit				; branch if > 8px below floor
		cmpi.w	#$C,d1
		bge.s	.ledgeHit				; branch if > 11px above floor (also detects a ledge)
		add.w	d1,obY(a0)				; align to floor
	endif
		moveq	#0,d0
		move.b	cat_segmentpos(a0),d0			; get pos counter for head (starts as 0)
		addq.b	#1,cat_segmentpos(a0)			; increment counter
		andi.b	#$F,cat_segmentpos(a0)			; wrap to 0 after $F
		move.b	d1,cat_floormap(a0,d0.w)		; write floor height for current position in array

	.return:
		rts						; return
; ---------------------------------------------------------------------------

.undulateNext:
		subq.b	#2,ob2ndRout(a0)			; go back to Cat_Undulate
		move.b	#8-1,cat_waittime(a0)			; set time delay to stay on high/low head position frame
	if Revision=0
		move.w	#0,obVelX(a0)				; stop moving
	else
		clr.w	obVelX(a0)				; stop moving
		clr.w	obInertia(a0)
	endif
		rts						; return
; ---------------------------------------------------------------------------

.ledgeHit:
	if Revision=0
		move.l	d2,obX(a0)				; restore previous x pos (i.e. stop moving)
		bchg	#0,obStatus(a0) 			; change direction
		move.b	obStatus(a0),obRender(a0)
		moveq	#0,d0
		move.b	cat_segmentpos(a0),d0			; get pos counter for head
		move.b	#$80,cat_floormap(a0,d0.w)		; save stop position in floor map array
	else
		moveq	#0,d0
		move.b	cat_segmentpos(a0),d0			; get pos counter for head
		move.b	#$80,cat_floormap(a0,d0.w)		; save stop position in floor map array
		neg.w	obSubpixelX(a0)
		beq.s	.faceLeft				; branch if x subpixel is 0
		btst	#0,obStatus(a0)
		beq.s	.faceLeft				; branch if facing left
		subq.w	#1,obX(a0)
		addq.b	#1,cat_segmentpos(a0)			; increment pos counter
		moveq	#0,d0
		move.b	cat_segmentpos(a0),d0
		clr.b	cat_floormap(a0,d0.w)
	.faceLeft:
		bchg	#0,obStatus(a0)
		move.b	obStatus(a0),obRender(a0)
	endif
		addq.b	#1,cat_segmentpos(a0)			; increment pos counter
		andi.b	#$F,cat_segmentpos(a0)			; wrap to 0 after $F
		rts						; return
; ===========================================================================

Cat_BodySeg2:	; Routine 6
		movea.l	cat_parent(a0),a1			; get OST of 1st body segment
		move.b	cat_mode(a1),cat_mode(a0)		; copy animation mode flags
		bpl.s	Cat_BodySeg1				; branch if not updating

		lea	(Ani_Cat).l,a1
		move.b	obAngle(a0),d0
		andi.w	#$7F,d0					; ignore high bit of angle
		addq.b	#4,obAngle(a0)				; increment angle (wraps from $FC to 0)
		tst.b	4(a1,d0.w)				; get byte from animation script, based on angle
		bpl.s	.updateFrame				; branch if not $FF
		addq.b	#4,obAngle(a0)				; increment angle again

	.updateFrame:
		move.b	(a1,d0.w),d0				; get frame id from animation
		addq.b	#8,d0					; skip head frames to body frames
		move.b	d0,obFrame(a0)				; update frame
; ---------------------------------------------------------------------------

Cat_BodySeg1:	; Routine 4, 8
		movea.l	cat_parent(a0),a1			; get OST of head or previous body segment
		tst.b	obStatus(a0)
		bmi.w	Cat_FragmentateBody_NotifyHead		; branch if caterkiller is broken

		move.b	cat_mode(a1),cat_mode(a0)		; copy animation mode flags
		move.b	ob2ndRout(a1),ob2ndRout(a0)
		beq.w	.chkBroken

		move.w	obInertia(a1),obInertia(a0)
		move.w	obVelX(a1),d0
	if Revision=0
		add.w	obInertia(a1),d0
	else
		add.w	obInertia(a0),d0
	endif
		move.w	d0,obVelX(a0)				; update x speed
		move.l	obX(a0),d2
		move.l	d2,d3					; d3 = x pos before update
		move.w	obVelX(a0),d0
		btst	#0,obStatus(a0)
		beq.s	.noFlip
		neg.w	d0					; reverse speed if X-flipped
	.noFlip:
		ext.l	d0
		asl.l	#8,d0					; multiply speed by $100
		add.l	d0,d2					; add to x pos
		move.l	d2,obX(a0)				; update position
		swap	d3
		cmp.w	obX(a0),d3
		beq.s	.chkBroken				; branch if segment hasn't moved

		moveq	#0,d0
		move.b	cat_segmentpos(a0),d0			; get pos counter
		move.b	cat_floormap(a1,d0.w),d1		; get floor height from parent's floor array
		cmpi.b	#$80,d1					; floor height $80 means a wall or drop
		bne.s	.alignToFloor				; branch if not $80

	if Revision=0
		swap	d3
		move.l	d3,obX(a0)				; restore previous x pos (i.e. don't move)
		move.b	d1,cat_floormap(a0,d0.w)		; write $80 to current floor array (for next segment to read)
	else
		move.b	d1,cat_floormap(a0,d0.w)
		neg.w	obSubpixelX(a0)
		beq.s	.faceLeft				; branch if facing left
		btst	#0,obStatus(a0)
		beq.s	.faceLeft				; branch if not moving left
		cmpi.w	#-$C0,obVelX(a0)
		bne.s	.faceLeft
		subq.w	#1,obX(a0)
		addq.b	#1,cat_segmentpos(a0)
		moveq	#0,d0
		move.b	cat_segmentpos(a0),d0
		clr.b	cat_floormap(a0,d0.w)
	.faceLeft:
	endif

		bchg	#0,obStatus(a0)				; change direction
		move.b	obStatus(a0),obRender(a0)
		addq.b	#1,cat_segmentpos(a0)			; increment pos counter
		andi.b	#$F,cat_segmentpos(a0)			; wrap to 0 after $F
		bra.s	.chkBroken
; ===========================================================================

.alignToFloor:
		ext.w	d1
		add.w	d1,obY(a0)				; align to floor
		addq.b	#1,cat_segmentpos(a0)			; increment pos counter
		andi.b	#$F,cat_segmentpos(a0)			; wrap to 0 after $F
		move.b	d1,cat_floormap(a0,d0.w)		; write floor height for current position in array

.chkBroken:
		cmpi.b	#$C,obRoutine(a1)			; has head already been set to fragment? (set to Cat_Fragment)
		beq.s	Cat_FragmentateBody_NotifyHead		; if yes, branch

		_cmpi.b	#id_ExplosionItem,obID(a1)		; has the head been destroyed?
		beq.s	.delete					; if yes, branch
		cmpi.b	#$A,obRoutine(a1)			; is the parent going to delete itself? (set to Cat_Delete)
		bne.s	.display				; if not, branch
	if FixBugs
		; Each body segment deletes itself when it detects that the head is going to delete itself.
		; This mostly works, but does cause the sub-object to linger for one frame longer than it should,
		; which is why rolling into a Caterkiller at high speed causes Sonic to be hurt.
		jsr	(DeleteChild).l				; delete the parent (don't mind this misnomer)
	endif

.delete:
		move.b	#$A,obRoutine(a0)			; mark self for deletion (Cat_Delete)
	if FixBugs
		; Do not queue self for display, since it will be deleted by its child later.
		rts						; return
	endif

.display:
		jmp	(DisplaySprite).l			; display sprite

; ===========================================================================
Cat_FragSpeed:	; X-speed
		dc.w -$200	; obRoutine 2 = head
		dc.w -$180	; obRoutine 4 = body segment 1
		dc.w  $180	; obRoutine 6 = body segment 2
		dc.w  $200	; obRoutine 8 = body segment 3
; ===========================================================================

Cat_FragmentateBody_NotifyHead:
		bset	#7,obStatus(a1)				; set flag for head object that it should fragmentate

Cat_FragmentateBody:
		moveq	#0,d0					; clear d0 for word-addressing
		move.b	obRoutine(a0),d0			; use routine number as fragmentate X-speed
		move.w	Cat_FragSpeed-2(pc,d0.w),d0		; get X-speed (-2 because obRoutine 0 is init)
		btst	#0,obStatus(a0)				; is Caterkiller facing branch?
		beq.s	.setX					; if not, branch
		neg.w	d0					; invert X-speed for segment
	.setX:	move.w	d0,obVelX(a0)				; set X-speed for fragmented segment
		move.w	#-$400,obVelY(a0)			; launch segment upwards
		move.b	#$C,obRoutine(a0)			; set to Cat_Fragment routine
		andi.b	#$F8,obFrame(a0)			; reset to frame 0 per mapping set (each segment has 8 frames)
; ---------------------------------------------------------------------------

Cat_Fragment:	; Routine $C
		jsr	(ObjectFall).l				; make body fragment fall
		tst.w	obVelY(a0)				; is it still going upwards?
		bmi.s	.displayOrDelete			; if yes, branch
		jsr	(ObjFloorDist).l			; get distance to floor
		tst.w	d1					; has fragment hit the floor?
		bpl.s	.displayOrDelete			; if not, branch
		add.w	d1,obY(a0)				; align fragment to floor
		move.w	#-$400,obVelY(a0)			; make fragment bounce upwards

	.displayOrDelete:
		tst.b	obRender(a0)				; has body fragment gone offscreen?
		bpl.w	Cat_Despawn				; if yes, delete it
		jmp	(DisplaySprite).l			; otherwise, display it

; ===========================================================================
; ---------------------------------------------------------------------------
; Animation script - Caterkiller enemy (MZ)
; WARNING: This uses non-standard animation format!
; ---------------------------------------------------------------------------

Ani_Cat:
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
		dc.b 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3
		dc.b 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6
		dc.b 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, $FF, 7, 7, $FF
		dc.b 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 6
		dc.b 6, 6, 6, 6, 6, 6, 5, 5, 5, 5, 5, 4, 4, 4, 4, 4
		dc.b 4, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1
		dc.b 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $FF, 0, 0, $FF
		even

; ===========================================================================

Map_Cat:	include	"_maps/Caterkiller.asm"
