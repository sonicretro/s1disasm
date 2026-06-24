; ===========================================================================
; ---------------------------------------------------------------------------
; Object 4E - advancing wall of lava (MZ act 2)
; ---------------------------------------------------------------------------

LavaWall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	LWall_Index(pc,d0.w),d1
		jmp	LWall_Index(pc,d1.w)
; ===========================================================================
LWall_Index:	dc.w LWall_Main-LWall_Index		; 0
		dc.w LWall_Solid-LWall_Index		; 2
		dc.w LWall_ChkSonic-LWall_Index		; 4
		dc.w LWall_BackChild-LWall_Index	; 6
		dc.w LWall_Delete-LWall_Index		; 8

lwall_flag:	equ objoff_36		; flag set when lava wall is moving
lwall_parent:	equ objoff_3C		; address of parent lava wall object for child
; ===========================================================================

LWall_Main:	; Routine 0
		addq.b	#4,obRoutine(a0)			; advance to LWall_ChkSonic
		movea.l	a0,a1					; replace this root object with the first lava segment
		moveq	#2-1,d1					; load two lava segments (parent and child object)
		bra.s	.make					; no need to find free RAM for root object
; ---------------------------------------------------------------------------

	.loop:
		bsr.w	FindNextFreeObj				; find a free object slot
		bne.s	.next					; if object RAM is full, branch
	.make:
		_move.b	#id_LavaWall,obID(a1)			; load another lava wall object
		move.l	#Map_LWall,obMap(a1)			; set mappings
		move.w	#ArtTile_MZ_Lava|Tile_Pal4,obGfx(a1)	; set art tile and palette line (contains lava palcycle)
		move.b	#sprite_cam_field,obRender(a1)		; set to playfield-positioned mode
		move.b	#160/2,obActWid(a1)			; set sprite display width (very large)
		move.w	obX(a0),obX(a1)				; copy X-position
		move.w	obY(a0),obY(a1)				; copy Y-position
		move.b	#1,obPriority(a1)			; set sprite priority (above Sonic)
		move.b	#0,obAnim(a1)				; set to first animation (it only has one)
		move.b	#col_128x64|col_hurt,obColType(a1)	; set ReactToItem type (damaging)
		move.l	a0,lwall_parent(a1)			; remember parent object
	.next:
		dbf	d1,.loop				; repeat sequence once for child lava wall

		addq.b	#6,obRoutine(a1)			; set child lava wall to LWall_BackChild
		move.b	#4,obFrame(a1)				; set child lava wall to frame 4 (".lava_back")
; ---------------------------------------------------------------------------

LWall_ChkSonic:	; Routine 4
		move.w	(v_player+obX).w,d0			; get Sonic's X-position
		sub.w	obX(a0),d0				; calculate X-difference
		bhs.s	.chkX					; if positive, branch
		neg.w	d0					; make positive for range check
	.chkX:	cmpi.w	#192,d0					; is Sonic horizontally within 192 pixels of lava wall?
		bhs.s	.checkMoveStart				; if not, branch

		move.w	(v_player+obY).w,d0			; get Sonic's Y-position
		sub.w	obY(a0),d0				; calculate Y-difference
		bhs.s	.chkY					; if positive, branch
		neg.w	d0					; make positive for range check
	.chkY:	cmpi.w	#96,d0					; is Sonic vertically within 96 pixels of lava wall?
		bhs.s	.checkMoveStart				; if not, branch

		move.b	#1,lwall_flag(a0)			; set lava wall to start moving
		bra.s	LWall_Solid				; skip movement start for one more frame
; ---------------------------------------------------------------------------

.checkMoveStart:
		tst.b	lwall_flag(a0)				; is lava wall set to move?
		beq.s	LWall_Solid				; if not, branch
		move.w	#$180,obVelX(a0)			; set lava wall to move to the right
		subq.b	#2,obRoutine(a0)			; go back to LWall_Solid
; ---------------------------------------------------------------------------

LWall_Solid:	; Routine 2
		move.w	#64/2+sonic_solid_width,d1		; set collision width
		move.w	#48/2,d2				; set collision height (initial)
		move.w	d2,d3					; copy for collision height (stood-on)
		addq.w	#1,d3					; +1px for stood-on height
		move.w	obX(a0),d4				; use current X-position for collision check
		move.b	obRoutine(a0),d0			; backup routine number (...why? SolidObject doesn't change it!)
		move.w	d0,-(sp)				; store routine number to stack
		bsr.w	SolidObject				; make lava wall solid
		move.w	(sp)+,d0				; restore routine number from stack
		move.b	d0,obRoutine(a0)			; restore routine number

		; The lava wall object appears to be hardcoded with the expectation to only appear
		; a single time in MZ2, as this X-position check expects a very specific coordinate.
		; To able to use this object elsewhere, this value should probably be stored as subtype.
		cmpi.w	#$6A0,obX(a0)				; has object reached $6A0 on the x-axis?
		bne.s	.animateAndMove				; if not, branch
		clr.w	obVelX(a0)				; stop lava wall moving
		clr.b	lwall_flag(a0)				; clear movement flag so object can be deleted again

	.animateAndMove:
		lea	(Ani_LWall).l,a1			; load animation script
		bsr.w	AnimateSprite				; animate lava wall

		cmpi.b	#4,(v_player+obRoutine).w		; is Sonic in a hurt state or dying?
		bhs.s	.displayOrDelete			; if yes, temporarily stop moving lava wall
		bsr.w	SpeedToPos				; update lava wall's position to make it move

.displayOrDelete:
	if FixBugs
		tst.b	lwall_flag(a0)				; is lava wall already moving?
		bne.s	.show					; if yes, don't delete it
		out_of_range.s	.startDelete			; is lava wall offscreen? if yes, branch to delete it
	.show:	bra.w	DisplaySprite				; display lava wall sprite
	else
		; Objects shouldn't call DisplaySprite and DeleteObject on
		; the same frame or else cause a null-pointer dereference.
		bsr.w	DisplaySprite				; display lava wall sprite
		tst.b	lwall_flag(a0)				; is lava wall already moving?
		bne.s	.show					; if yes, don't delete it
		out_of_range.s	.startDelete			; is lava wall offscreen? if yes, branch to delete it
	.show:	rts						; return
	endif
; ---------------------------------------------------------------------------

.startDelete:
		lea	(v_objstate).w,a2			; load respawn table
		moveq	#0,d0					; clear d0 for word-addressing
		move.b	obRespawnNo(a0),d0			; get respawn table index
	if FixBugs
		; This didn't verify if the lava wall even has a respawn entry,
		; which could write bad data (such as when placed in debug mode).
		beq.s	.delete					; if it doesn't have an index, branch
	endif
		bclr	#7,2(a2,d0.w)				; clear respawn block flag so lava wall can spawn again

	.delete:
		move.b	#8,obRoutine(a0)			; set to LWall_Delete
		rts						; return
; ===========================================================================

LWall_BackChild: ; Routine 6
		movea.l	lwall_parent(a0),a1			; get parent object
		cmpi.b	#8,obRoutine(a1)			; has parent been marked for deletion?
		beq.s	LWall_Delete				; if yes, delete child object too

		move.w	obX(a1),obX(a0)				; move rest of lava wall
		subi.w	#128,obX(a0)				; rest of lava wall is 128px to the left of parent
		bra.w	DisplaySprite				; display lava
; ===========================================================================

LWall_Delete:	; Routine 8
		bra.w	DeleteObject				; delete lava wall object
