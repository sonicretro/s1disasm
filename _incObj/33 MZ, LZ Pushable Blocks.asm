; ===========================================================================
; ---------------------------------------------------------------------------
; Object 33 - pushable blocks (MZ, available but unused in LZ)
; ---------------------------------------------------------------------------

PushBlock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	PushB_Index(pc,d0.w),d1
		jmp	PushB_Index(pc,d1.w)
; ===========================================================================
PushB_Index:	dc.w PushB_Main-PushB_Index		; 0
		dc.w PushB_Action-PushB_Index		; 2
		dc.w PushB_ChkVisible-PushB_Index	; 4

pblock_lavaspeed:	equ objoff_30	; X-speed while block is on lava
pblock_onlava:		equ objoff_32	; flag set if block is on lava
pblock_origX:		equ objoff_34	; initial X-position
pblock_origY:		equ objoff_36	; initial Y-position
; ===========================================================================

PushB_Var:	;    width, frame
		dc.b  32/2, 0	; 1x1 block
		dc.b 128/2, 1	; 4x1 block
; ===========================================================================

PushB_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to PushB_Action
		move.b	#30/2,obHeight(a0)			; set height
		move.b	#30/2,obWidth(a0)			; set width
		move.l	#Map_Push,obMap(a0)			; set mappings

		move.w	#ArtTile_MZ_Block|Tile_Pal3,obGfx(a0)	; MZ-specific art tile
		cmpi.b	#id_LZ,(v_zone).w			; are we in LZ?
		bne.s	.notLZ					; if not, branch
		move.w	#ArtTile_LZ_Push_Block|Tile_Pal3,obGfx(a0) ; LZ-specific art tile (unused)
	.notLZ:
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#3,obPriority(a0)			; set sprite priority
		move.w	obX(a0),pblock_origX(a0)		; remember original X-position
		move.w	obY(a0),pblock_origY(a0)		; remember original Y-position

		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get subtype (0 = 1x1 block // 1 = 4x1 block)
		add.w	d0,d0					; double for word-based indexing
		andi.w	#$E,d0					; limit to sane values (kinda)
		lea	PushB_Var(pc,d0.w),a2			; load config data for subtype
		move.b	(a2)+,obActWid(a0)			; set solidity and sprite display width for subtype
		move.b	(a2)+,obFrame(a0)			; set frame for subtype

		tst.b	obSubtype(a0)				; is this the 4x1 block?
		beq.s	.chkgone				; if not, branch
		move.w	#ArtTile_MZ_Block|Tile_Pal3|Tile_Prio,obGfx(a0) ; set high-priority flag for 4x1 block

	.chkgone:
		lea	(v_objstate).w,a2			; load respawn table
		moveq	#0,d0					; clear d0
		move.b	obRespawnNo(a0),d0			; get respawn index
		beq.s	PushB_Action				; if it doesn't have one, branch
		bclr	#7,2(a2,d0.w)				; clear respawn block flag
		bset	#0,2(a2,d0.w)				; set flag that this block has been loaded before
		bne.w	DeleteObject				; if it's a reload, delete it (only one block can exist)
; ---------------------------------------------------------------------------

PushB_Action:	; Routine 2
		tst.b	pblock_onlava(a0)			; is block on lava?
		bne.w	PushB_OnLava				; if yes, branch to alternate handler

		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as solidity width
		addi.w	#sonic_solid_width,d1			; add Sonic's solid width
		move.w	#32/2,d2				; set block's solid height (initial)
		move.w	#34/2,d3				; set block's solid height (stood on)
		move.w	obX(a0),d4				; use currenet X-position if stood on
		bsr.w	PushB_SolidAction			; allow Sonic to push block or stand on it as platform

		; Hardcoded MZ1 stuff for the block that pushes down a button to lift a spiked stomper
		cmpi.w	#id_MZ_act1,(v_zone_act).w		; is the level MZ act 1?
		bne.s	PushB_Display				; if not, branch
		bclr	#7,obSubtype(a0)			; clear flag that block is in stomper
		move.w	obX(a0),d0				; get block's current X-position
		cmpi.w	#$A20,d0				; is block within the left side of the stomper?
		blo.s	PushB_Display				; if not, branch
		cmpi.w	#$AA1,d0				; is block within the right side of the stomper?
		bhs.s	PushB_Display				; if not, branch
		move.w	(v_obj31ypos).w,d0			; get global Y-position of spiked stomper
		subi.w	#$1C,d0					; align block to be $1Cpx above it
		move.w	d0,obY(a0)				; set that as block's Y-position
		bset	#7,(v_obj31ypos).w			; notify stomper to not go past a certain Y-limit
		bset	#7,obSubtype(a0)			; set flag that block is on stomper

PushB_Display:
		out_of_range.s	PushB_ChkWithinOrigin		; is block offscreen (current X-position)? if yes, branch
		bra.w	DisplaySprite				; otherwise, keep displaying block sprite
; ===========================================================================

PushB_ChkWithinOrigin:
		out_of_range.s	.deleteAndAllowRespawn,pblock_origX(a0) ; is block offscreen (original X-position?) if yes, branch

		move.w	pblock_origX(a0),obX(a0)		; force back to original X-position
		move.w	pblock_origY(a0),obY(a0)		; force back to original Y-position
		move.b	#4,obRoutine(a0)			; set to PushB_ChkVisible
		bra.s	PushB_ChkVisible			; check if block is visible right away
; ---------------------------------------------------------------------------

.deleteAndAllowRespawn:
		lea	(v_objstate).w,a2			; load respawn table
		moveq	#0,d0					; clear d0
		move.b	obRespawnNo(a0),d0			; get respawn table index
		beq.s	.delete					; if it doesn't have one, branch
		bclr	#0,2(a2,d0.w)				; allow block to respawn
	.delete:
		bra.w	DeleteObject				; delete block object
; ===========================================================================

PushB_ChkVisible: ; Routine 4
		bsr.w	ChkPartiallyVisible			; is sprite (at least partially) on screen?
		beq.s	.return					; if not, branch

		move.b	#2,obRoutine(a0)			; set to PushB_Action
		clr.b	pblock_onlava(a0)			; clear on-lava flag
		clr.w	obVelX(a0)				; clear X-spped
		clr.w	obVelY(a0)				; clear Y-speed

	.return:
		rts						; block doesn't exist until it is visible

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to handle pushable blocks moving on lava
; ---------------------------------------------------------------------------

PushB_OnLava:
		move.w	obX(a0),-(sp)				; backup current X-position for later
		cmpi.b	#4,ob2ndRout(a0)			; is block currently falling?
		bhs.s	loc_C056				; if yes, branch (has its own SpeedToPos)
		bsr.w	SpeedToPos				; update block's position

	loc_C056:
		btst	#1,obStatus(a0)				; is block getting shot up by a lava geyser? (set in GMake_MakeLava)
		beq.s	PushB_OnLava_CheckWall			; if not, branch

		; Block is getting shot up by a lava geyser, make it fall again
		addi.w	#$18,obVelY(a0)				; make block fall faster
		jsr	(ObjFloorDist).l			; get distance to floor (and block ID in a1)
		tst.w	d1					; has block hit the floor?
		bpl.w	loc_C09E				; if not, branch
		add.w	d1,obY(a0)				; align block to floor
		clr.w	obVelY(a0)				; stop block falling

		bclr	#1,obStatus(a0)
		move.w	(a1),d0					; get ID of 16x16 block mapping that block is standing on
		andi.w	#$3FF,d0				; mask out everything except raw ID
		cmpi.w	#$16A,d0				; is block standing on a 16x16 lava block? (IDs $16A and above)
		blo.s	loc_C09E				; if not, branch

		move.w	pblock_lavaspeed(a0),d0			; get X-speed before block landed on lava
		asr.w	#3,d0					; divide that speed by 8 ($400/8 = $80)
		move.w	d0,obVelX(a0)				; move block horizontally on lava
		move.b	#1,pblock_onlava(a0)			; set on-lava flag
		clr.w	obSubpixelY(a0)				; clear Y-subpixel position (needed for sinking in lava)

	loc_C09E:
		bra.s	PushB_LavaPlatform
; ===========================================================================

PushB_OnLava_CheckWall:
		tst.w	obVelX(a0)				; has block stopped moving on lava?
		beq.w	.sinkingInLava				; if yes, make it sink
		bmi.s	.checkWallLeft				; if it's moving to the left, branch

	.checkWallRight:
		moveq	#0,d3					; clear d3
		move.b	obActWid(a0),d3				; use sprite display width as solidity width
		jsr	(ObjHitWallRight).l			; get distance to right wall
		tst.w	d1					; has block touched a wall to the right?
		bmi.s	.hitWallOnLava				; if yes, branch
		bra.s	PushB_LavaPlatform			; otherwise, keep normal platform behavior

	.checkWallLeft:
		moveq	#0,d3					; clear d3
		move.b	obActWid(a0),d3				; use sprite display width as solidity width
		not.w	d3					; invert width for leftside distance check
		jsr	(ObjHitWallLeft).l			; get distance to left wall
		tst.w	d1					; has block touched a wall to the left?
		bmi.s	.hitWallOnLava				; if yes, branch
		bra.s	PushB_LavaPlatform			; otherwise, keep normal platform behavior
; ---------------------------------------------------------------------------

.hitWallOnLava:
		clr.w	obVelX(a0)				; stop block moving
		bra.s	PushB_LavaPlatform			; don't sink until next frame
; ===========================================================================

.sinkingInLava:
		addi.l	#$2000+1,obY(a0)			; sink block (subpixel is used as sink depth check)
		cmpi.b	#160,obSubpixelY+1(a0)			; has block sunk for 160 frames?
		bhs.s	PushB_Sunken				; if yes, branch
; ---------------------------------------------------------------------------

PushB_LavaPlatform:
		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as solidity width
		addi.w	#sonic_solid_width,d1			; add Sonic's solid width
		move.w	#32/2,d2				; set block's solid height (initial)
		move.w	#34/2,d3				; set block's solid height (stood on)
		move.w	(sp)+,d4				; restore X-position

		bsr.w	PushB_SolidAction			; continue treating block as platform
		bsr.s	PushB_SpawnLavaGeysers			; spawn hardcoded lava geysers in MZ2 and MZ3
		bra.w	PushB_Display				; display block
; ---------------------------------------------------------------------------

PushB_Sunken:
		move.w	(sp)+,d4				; restore X-position
		lea	(v_player).w,a1				; load Sonic object
		bclr	#3,obStatus(a1)				; clear Sonic's on-platform flag
		bclr	#3,obStatus(a0)				; clear block's stood-on flag
		bra.w	PushB_ChkWithinOrigin			; potentially respawn block while offscreen
; End of function PushB_OnLava


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to spawn lava geysers as block is moving along lava.
; This is entirely hardcoded to specific X-positions in MZ2 and MZ3.
; ---------------------------------------------------------------------------

PushB_SpawnLavaGeysers:
	.geysersMZ2:
		; Hardcoded MZ2 stuff for the block that moves leftwards on lava and spawns lava geysers
		cmpi.w	#id_MZ_act2,(v_zone_act).w		; is the level MZ act 2?
		bne.s	.geysersMZ3				; if not, branch
		move.w	#-32,d2					; spawn geysers 32px ahead of block (to the left)
		cmpi.w	#$DD0,obX(a0)				; has block moved to $DD0 on X-axis?
		beq.s	.spawnGeyser				; if yes, spawn first geyser
		cmpi.w	#$CC0,obX(a0)				; has block moved to $CC0 on X-axis?
		beq.s	.spawnGeyser				; if yes, spawn second geyser
		cmpi.w	#$BA0,obX(a0)				; has block moved to $BA0 on X-axis?
		beq.s	.spawnGeyser				; if yes, spawn second geyser
		rts						; return
; ---------------------------------------------------------------------------

	.geysersMZ3:
		; Hardcoded MZ3 stuff for the block that moves rightwards on lava and spawns lava geysers
		cmpi.w	#id_MZ_act3,(v_zone_act).w		; is the level MZ act 3?
		bne.s	.return					; if not, branch
		move.w	#32,d2					; spawn geysers 32px ahead of block (to the right)
		cmpi.w	#$560,obX(a0)				; has block moved to $560 on X-axis?
		beq.s	.spawnGeyser				; if yes, spawn first geyser
		cmpi.w	#$5C0,obX(a0)				; has block moved to $5C0 on X-axis?
		beq.s	.spawnGeyser				; if yes, spawn first geyser

	.return:
		rts						; return
; ---------------------------------------------------------------------------

.spawnGeyser:
		bsr.w	FindFreeObj				; find a free object slot
		bne.s	.fail					; if object RAM is full, branch
		_move.b	#id_GeyserMaker,obID(a1)		; load lava geyser object
		move.w	obX(a0),obX(a1)				; spawn at block's current X-position...
		add.w	d2,obX(a1)				; ...adjusted by 32px left or right
		move.w	obY(a0),obY(a1)				; spawn at block's current Y-position...
		addi.w	#16,obY(a1)				; ...adjusted 16px down
		move.l	a0,gmake_parent(a1)			; remember parent block object for geyser

	.fail:
		rts						; return
; End of function PushB_SpawnLavaGeysers


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine allowing blocks to be pushed or stood on as platforms.
; 
; input:
;	d1.w = object half width
;	d2.w = object half height (initial collision)
;	d3.w = object half height (when stood on block)
;	d4.w = object X-position (when stood on block)
; 
; ob2ndRout:
;	0 = not standing on platform and not pushing
;	2 = Sonic is standing on block
; 	4 = falling down
;	6 = snapping to ledge before falling down
; ---------------------------------------------------------------------------

PushB_SolidAction:
		move.b	ob2ndRout(a0),d0			; get current solid action state (0/2/4/6)
		beq.w	PushB_SolidAction_NotOnPlatform		; if 0, branch

		subq.b	#2,d0					; check next ob2ndRout state
		bne.s	.chkFalling				; branch if ob2ndRout is 4 or 6

.sonicOnBlock:	; ob2ndRout = 2
		bsr.w	ExitPlatform				; allow Sonic to exit platform
		btst	#3,obStatus(a1)				; check if Sonic is still on block
		bne.s	.moveSonicWithBlock			; if yes, branch
		clr.b	ob2ndRout(a0)				; clear platform flag
		rts						; return

	.moveSonicWithBlock:
		move.w	d4,d2					; set object's X-position as input for MvSonicOnPtfm
		bra.w	MvSonicOnPtfm				; move Sonic with block
; ---------------------------------------------------------------------------

.chkFalling:	; ob2ndRout = 4 or 6
		subq.b	#2,d0					; check next ob2ndRout state
		bne.s	.snapToLedge				; branch if ob2ndRout is 6

.falling:
		; ob2ndRout = 4
		bsr.w	SpeedToPos				; update block's position
		addi.w	#$18,obVelY(a0)				; make block fall faster

		jsr	(ObjFloorDist).l			; get distance to floor (and block ID in a1)
		tst.w	d1					; has block hit the floor?
		bpl.w	.return					; if not, branch
		add.w	d1,obY(a0)				; align block to floor
		clr.w	obVelY(a0)				; stop block falling
		clr.b	ob2ndRout(a0)				; reset solid action state

		move.w	(a1),d0					; get ID of 16x16 block mapping that block is standing on
		andi.w	#$3FF,d0				; mask out everything except raw ID
		cmpi.w	#$16A,d0				; is block standing on a 16x16 lava block? (IDs $16A and above)
		blo.s	.return					; if not, branch

		move.w	pblock_lavaspeed(a0),d0			; get X-speed before block landed on lava
		asr.w	#3,d0					; divide that speed by 8 ($400/8 = $80)
		move.w	d0,obVelX(a0)				; move block horizontally on lava
		move.b	#1,pblock_onlava(a0)			; set on-lava flag
		clr.w	obSubpixelY(a0)				; clear Y-subpixel position (needed for sinking in lava)

	.return:
		rts						; return
; ---------------------------------------------------------------------------

.snapToLedge:	; ob2ndRout = 6
		bsr.w	SpeedToPos				; update position
		move.w	obX(a0),d0				; get updated X-position
		andi.w	#$C,d0					; has block crossed threshold?
		bne.w	PushB_Return				; if not, branch

		andi.w	#$FFF0,obX(a0)				; snap block to nearest 16px X-position
		move.w	obVelX(a0),pblock_lavaspeed(a0)		; remember current X-velocity in case we land on lava (+-$400)
		clr.w	obVelX(a0)				; stop block moving horizontally
		subq.b	#2,ob2ndRout(a0)			; set to "falling" state
		rts						; return
; ===========================================================================

PushB_SolidAction_NotOnPlatform:
		; ob2ndRout = 0
		bsr.w	Solid_ChkCollision			; check Sonic's collision with block (also sets ob2ndRout/obSolid to 2 if stood on)
		tst.w	d4					; inspect returned collision type
		beq.w	PushB_Return				; if not touching at all, branch
		bmi.w	PushB_Return				; if touching top/bottom, branch
		tst.b	pblock_onlava(a0)			; is block on lava?
		beq.s	.allowPushing				; if not, see if block can be pushed
		bra.w	PushB_Return				; return
; ---------------------------------------------------------------------------

.allowPushing:
		tst.w	d0					; check Sonic's distance to block (set in Solid_ChkCollision)
		beq.w	PushB_Return				; if exactly on same X-axis, branch
		bmi.s	.leftSide				; if left of block, branch

	.rightSide:
		btst	#0,obStatus(a1)				; is Sonic looking to the right?
		bne.w	PushB_Return				; if not, branch

		move.w	d0,-(sp)				; backup X-distance to block
		moveq	#0,d3					; clear d3
		move.b	obActWid(a0),d3				; use sprite display width as solidity width
		jsr	(ObjHitWallRight).l			; get distance to right wall
		move.w	(sp)+,d0				; restore X-distance to block
		tst.w	d1					; has block hit a wall to the right?
		bmi.w	PushB_Return				; if yes, stop it moving
		addi.l	#$10000,obX(a0)				; push block right (including subpixels)
		moveq	#1,d0					; move Sonic 1px to the right
		move.w	#$40,d1					; set Sonic's ground speed
		bra.s	.pushBlock				; push the block
; ---------------------------------------------------------------------------

	.leftSide:
		btst	#0,obStatus(a1)				; is Sonic looking to the left?
		beq.s	PushB_Return				; if not, branch

		move.w	d0,-(sp)				; backup X-distance to block
		moveq	#0,d3					; clear d3
		move.b	obActWid(a0),d3				; use sprite display width as solidity width
		not.w	d3					; invert width for leftside distance check
		jsr	(ObjHitWallLeft).l			; get distance to left wall
		move.w	(sp)+,d0				; restore X-distance to block
		tst.w	d1					; has block hit a wall to the left?
		bmi.s	PushB_Return				; if yes, stop it moving
		subi.l	#$10000,obX(a0)				; push block left (including subpixels)
		moveq	#-1,d0					; move Sonic 1px to the left
		move.w	#-$40,d1				; set Sonic's ground speed

.pushBlock:
		lea	(v_player).w,a1				; load Sonic object
		add.w	d0,obX(a1)				; move Sonic 1px left/right
		move.w	d1,obInertia(a1)			; set new ground speed
		move.w	#0,obVelX(a1)				; cancel other horizontal speed

		move.w	d0,-(sp)				; backup X-distance to block
		move.w	#sfx_Push,d0				; play pushing sound
		jsr	(QueueSound2).l				; (hardcoded in the sound driver to not be interruptible by itself)
		move.w	(sp)+,d0				; restore X-distance to block

		tst.b	obSubtype(a0)				; is block on a spiked stomper?
		bmi.s	PushB_Return				; if yes, branch
		move.w	d0,-(sp)				; backup X-distance to block
		jsr	(ObjFloorDist).l			; get distance to floor
		move.w	(sp)+,d0				; restore X-distance to block
		cmpi.w	#4,d1					; is block within 4px of floor?
		ble.s	.alignToFloor				; if yes, branch
		move.w	#$400,obVelX(a0)			; quickly move block to the right as it falls off a ledge
		tst.w	d0					; is Sonic pushing block to the left?
		bpl.s	.setToDrop				; if not, branch
		neg.w	obVelX(a0)				; move block to the left instead
	.setToDrop:
		move.b	#6,ob2ndRout(a0)			; snap block to ledge before falling down
		bra.s	PushB_Return				; return
; ---------------------------------------------------------------------------

	.alignToFloor:
		add.w	d1,obY(a0)				; snap block vertically to floor

PushB_Return:
		rts						; return

; ===========================================================================

Map_Push:	include	"_maps/Pushable Blocks.asm"
