; ===========================================================================
; ---------------------------------------------------------------------------
; Object 6B - stomper and sliding door (SBZ)
;             and ancient lift at the start of SBZ3/LZ4
; ---------------------------------------------------------------------------

ScrapStomp:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Sto_Index(pc,d0.w),d1
		jmp	Sto_Index(pc,d1.w)
; ===========================================================================
Sto_Index:	dc.w Sto_Main-Sto_Index
		dc.w Sto_Action-Sto_Index

sto_origY:	equ objoff_30		; original y-axis position
sto_origX:	equ objoff_34		; original x-axis position
sto_delay:	equ objoff_36		; delay timer before moving again
sto_active:	equ objoff_38		; flag set when a switch is pressed
sto_offset_now:	equ objoff_3A		; current X/Y-offset from origin
sto_offset_max:	equ objoff_3C		; maximum move distance from origin (third entry in Sto_Var)
sto_switch:	equ objoff_3E		; switch ID that triggers platform behavior
; ===========================================================================

Sto_Var:	; width, height, max distance, action type
		dc.b  128/2,  24/2, 128, 1	; $8x - sliding platform extending on switch press
		dc.b   56/2,  64/2,  56, 3	; $1x - stomper (stomps down and slowly goes back up)
		dc.b   56/2,  64/2,  64, 4	; $2x - stomper (stomps up and down)
		dc.b   56/2,  64/2,  96, 4	; $3x - stomper (stomps up and down, larger distance)
		dc.b  256/2, 128/2,   0, 5	; $4x - ancient lift at the start of SBZ3/LZ4
; ===========================================================================

Sto_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Sto_Action

		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get object subtype
		lsr.w	#2,d0					; read only upper digit, multiplied by 4 bytes per entry
		andi.w	#$1C,d0					; limit to upper digits 0-7
		lea	Sto_Var(pc,d0.w),a3			; load setup array
		move.b	(a3)+,obActWid(a0)			; load sprite display width and solidity width
		move.b	(a3)+,obHeight(a0)			; set solidity width (and display height for SBZ3 platform)
		lsr.w	#2,d0					; move rest of upper subtype digit exactly into lower digit
		move.b	d0,obFrame(a0)				; use upper subtype digit for frame ID

		move.l	#Map_Stomp,obMap(a0)			; set mappings
		move.w	#ArtTile_SBZ_Moving_Block_Short|Tile_Pal2,obGfx(a0) ; set art tile (SBZ1/2)

		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ (SBZ3)
		bne.s	.continueSetup				; if not, branch
		bset	#0,(v_obj6B).w				; set flag that ancient lift has been loaded
		beq.s	.isSBZ3					; if it hasn't already been loaded, branch

	; .chkdel:
	.despawn:
		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0
		move.b	obRespawnNo(a0),d0			; get object respawn table index
		beq.s	.delete					; it if doesn't have one, branch
		bclr	#7,2(a2,d0.w)				; clear respawn block flag

	.delete:
		jmp	(DeleteObject).l			; delete ancient lift object
; ===========================================================================

.isSBZ3:	; ancient lift at the start of SBZ3
		move.w	#ArtTile_Level+$1F0|Tile_Pal3,obGfx(a0)	; set alternate art tile (part of the level graphics)
		cmpi.w	#$A80,obX(a0)				; is this the platform before the switch was pressed? (X-coordinate $A80)
		bne.s	.continueSetup				; if not, branch

		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0
		move.b	obRespawnNo(a0),d0			; get object respawn table index
		beq.s	.continueSetup				; if it doesn't have one, branch
		btst	#0,2(a2,d0.w)				; has switch that starts moving lift already been pressed? (see Sto_AncientLift)
		beq.s	.continueSetup				; if not, branch
		clr.b	(v_obj6B).w				; clear "ancient lift loaded" flag
		bra.s	.despawn				; prevent pre-switched ancient lift from reappearing after switch was pressed
; ===========================================================================

; .isSBZ12:
.continueSetup:
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.w	obX(a0),sto_origX(a0)			; remember initial X-position
		move.w	obY(a0),sto_origY(a0)			; remember initial Y-position

		moveq	#0,d0					; clear d0
		move.b	(a3)+,d0				; get max move distance
		move.w	d0,sto_offset_max(a0)			; store it

		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get object subtype
		bpl.s	Sto_Action				; is subtype $80 or above (extending sliding platform)? if not, branch
		andi.b	#$F,d0					; read only lower digit
		move.b	d0,sto_switch(a0)			; store switch ID that will trigger platform behavior
		move.b	(a3),obSubtype(a0)			; set action type number

		cmpi.b	#5,(a3)					; is this the ancient lift in SBZ3?
		bne.s	.chkgone				; if not, branch
		bset	#sprite_customheight_bit,obRender(a0)	; set custom sprite render height flag

	.chkgone:
		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0
		move.b	obRespawnNo(a0),d0			; get object respawn table index
		beq.s	Sto_Action				; if it doesn't have one, branch
		bclr	#7,2(a2,d0.w)				; clear respawn block flag
; ---------------------------------------------------------------------------

Sto_Action:	; Routine 2
		move.w	obX(a0),-(sp)				; backup previous X-position before executing behavior
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get action type (set from Sto_Var)
		andi.w	#$F,d0					; only read lower digit
		add.w	d0,d0					; double for word-based indexing
		move.w	Sto_TypeIndex(pc,d0.w),d1		; find entry in jump table
		jsr	Sto_TypeIndex(pc,d1.w)			; execute behavior, then return here
		move.w	(sp)+,d4				; restore previoux X-position as input for SolidObject

		tst.b	obRender(a0)				; is platform on screen?
		bpl.s	.chkdel					; if not, skip collision detection

		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as solidity width
		addi.w	#sonic_solid_width,d1			; add Sonic's own collision width
		moveq	#0,d2					; clear d2
		move.b	obHeight(a0),d2				; object collision height (initial)
		move.w	d2,d3					; object collision height (stood-on)
		addq.w	#1,d3					; +1px height when stood-on
		bsr.w	SolidObject				; make object solid and handle squash kills
; ---------------------------------------------------------------------------

	.chkdel:
		out_of_range.s	.chkgone,sto_origX(a0)		; has object gone out of range? if yes, branch
		jmp	(DisplaySprite).l			; display object

	.chkgone:
		cmpi.b	#id_LZ,(v_zone).w			; are we in LZ? (SBZ3/LZ4)
		bne.s	.delete					; if not, branch

		clr.b	(v_obj6B).w				; clear "ancient lift loaded" flag
		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0
		move.b	obRespawnNo(a0),d0			; get object respawn table index
		beq.s	.delete					; it it doesn't have one, branch
		bclr	#7,2(a2,d0.w)				; clear respawn block flag

	.delete:
		jmp	(DeleteObject).l			; delete object

; ===========================================================================
Sto_TypeIndex:	dc.w Sto_Stationary-Sto_TypeIndex		; 0
		dc.w Sto_SlidingPlatform_Extend-Sto_TypeIndex	; 1
		dc.w Sto_SlidingPlatform_Retract-Sto_TypeIndex	; 2
		dc.w Sto_Stomper_DownAndRetract-Sto_TypeIndex	; 3
		dc.w Sto_Stomper_UpAndDown-Sto_TypeIndex	; 4
		dc.w Sto_AncientLift-Sto_TypeIndex		; 5
; ===========================================================================

; Type 0 - stationary
Sto_Stationary:
		rts						; do nothing
; ===========================================================================

; Type 1 - extending sliding platform
Sto_SlidingPlatform_Extend:
		tst.b	sto_active(a0)				; has sliding platform already been activated?
		bne.s	.extendPlatform				; if yes, branch

		lea	(f_switch).w,a2				; load switch states
		moveq	#0,d0					; clear d0
		move.b	sto_switch(a0),d0			; get switch ID that will trigger platform
		btst	#0,(a2,d0.w)				; is respective switch button pressed?
		beq.s	.updatePosition				; if not, branch
		move.b	#1,sto_active(a0)			; start extending platform

	.extendPlatform:
		move.w	sto_offset_max(a0),d0			; get maximum distance platform should move (128px)
		cmp.w	sto_offset_now(a0),d0			; has it reached the max distance?
		beq.s	.stopPlatform				; if yes, branch
		addq.w	#2,sto_offset_now(a0)			; extend platform at 2px/frame to the left

	.updatePosition:
		move.w	sto_offset_now(a0),d0			; get current extension length
		btst	#0,obStatus(a0)				; is platform X-flipped?
		beq.s	.setX					; if not, branch
		neg.w	d0					; extend platform to the right instead
		addi.w	#128,d0					; keep in same general X-range (platform width is 128px)
	.setX:	move.w	sto_origX(a0),d1			; get initial platform X-position
		sub.w	d0,d1					; adjust by current movement offset
		move.w	d1,obX(a0)				; set new X-position
		rts						; return
; ---------------------------------------------------------------------------

; .loc_15DE0:
.stopPlatform:
		addq.b	#1,obSubtype(a0)			; change to Sto_SlidingPlatform_Retract (delay and retract again)
		move.w	#3*60,sto_delay(a0)			; set delay before retracting to 3 seconds
		clr.b	sto_active(a0)				; clear activation flag

		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0
		move.b	obRespawnNo(a0),d0			; get object respawn table index
		beq.s	.updatePosition				; if it doesn't have one, branch
		bset	#0,2(a2,d0.w)				; set flag that platform has been extended (seems to be unused?)
		bra.s	.updatePosition				; 
; ===========================================================================

; Type 2 (set from Type 1) - retract sliding platform again after a delay
Sto_SlidingPlatform_Retract:
		tst.b	sto_active(a0)				; is platform already set to retract?
		bne.s	.retractPlatform			; if yes, branch

		subq.w	#1,sto_delay(a0)			; decrement delay before retracting
		bne.s	.updatePosition				; if time remains, branch
		move.b	#1,sto_active(a0)			; start retracting platform

	.retractPlatform:
		tst.w	sto_offset_now(a0)			; has current extension range gone back to 0?
		beq.s	.stopPlatform				; if yes, branch
		subq.w	#2,sto_offset_now(a0)			; retract platform at 2px/frame to the right

	.updatePosition:
		move.w	sto_offset_now(a0),d0			; get current extension length
		btst	#0,obStatus(a0)				; is platform X-flipped?
		beq.s	.setX					; if not, branch
		neg.w	d0					; retract platform to the left instead
		addi.w	#128,d0					; keep in same general X-range (platform width is 128px)
	.setX:	move.w	sto_origX(a0),d1			; get initial platform X-position
		sub.w	d0,d1					; adjust by current movement offset
		move.w	d1,obX(a0)				; set new X-position
		rts						; return
; ---------------------------------------------------------------------------

; .loc_15E3C:
.stopPlatform:
		subq.b	#1,obSubtype(a0)			; change back to Sto_SlidingPlatform_Extend (extend on switch press)
		clr.b	sto_active(a0)				; clear activation flag

		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0
		move.b	obRespawnNo(a0),d0			; get object respawn table index
		beq.s	.updatePosition				; if it doesn't have one, branch
		bclr	#0,2(a2,d0.w)				; clear flag that platform has been extended (seems to be unused?)
		bra.s	.updatePosition				; 
; ===========================================================================

; Type 3 - stomper (stomps down, immediately goes slowly back up, waits 1 second, stomps down again)
Sto_Stomper_DownAndRetract:
		tst.b	sto_active(a0)				; is stomper set stomp down?
		bne.s	.stompDown				; if yes, branch

	.retract:
		tst.w	sto_offset_now(a0)			; has stomper gone fully back up again?
		beq.s	.delay					; if yes, branch
		subq.w	#1,sto_offset_now(a0)			; move stomper back up at 1px/frame
		bra.s	.updatePosition				; update Y-position
; ---------------------------------------------------------------------------

	.delay:
		subq.w	#1,sto_delay(a0)			; decrement delay before stomping down again
		bpl.s	.updatePosition				; if time remains, branch
		move.w	#1*60,sto_delay(a0)			; reset next delay to 1 second
		move.b	#1,sto_active(a0)			; start stomping down

	.stompDown:
		addq.w	#8,sto_offset_now(a0)			; move stomper down at 8px/frame
		move.w	sto_offset_now(a0),d0			; get current stomp distance
		cmp.w	sto_offset_max(a0),d0			; has stomper reached max distance?
		bne.s	.updatePosition				; if not, branch
		clr.b	sto_active(a0)				; start moving stomper back up again

	.updatePosition:
		move.w	sto_offset_now(a0),d0			; get current stomp distance
		btst	#0,obStatus(a0)				; is stomper X-flipped?
		beq.s	.setY					; if not, branch
		neg.w	d0					; invert base stomp direction
		addi.w	#56,d0					; keep in same general Y-range (stomper height is 56px)
	.setY:	move.w	sto_origY(a0),d1			; get initial stomper Y-position
		add.w	d0,d1					; adjust by current stomp distance
		move.w	d1,obY(a0)				; set new Y-position
		rts						; return
; ===========================================================================

; Type 4 - stomper (stomps up and down, waits 1 second between each stomp)
Sto_Stomper_UpAndDown:
		tst.b	sto_active(a0)				; is stomper set to stomp down?
		bne.s	.stompDown				; if yes, branch

	.stompUp:
		tst.w	sto_offset_now(a0)			; has stomper gone fully back up again?
		beq.s	.delayStompDown				; if yes, brancch
		subq.w	#8,sto_offset_now(a0)			; move stomper back up at 8px/frame
		bra.s	.updatePosition				; update Y-position
; ---------------------------------------------------------------------------

	.delayStompDown:
		subq.w	#1,sto_delay(a0)			; decrement delay before stomping down
		bpl.s	.updatePosition				; if time remains, branch
		move.w	#1*60,sto_delay(a0)			; set delay before stomping back up to 1 second
		move.b	#1,sto_active(a0)			; start stomping down

	.stompDown:
		move.w	sto_offset_now(a0),d0			; get current stomp distance
		cmp.w	sto_offset_max(a0),d0			; has stomper reached max distance?
		beq.s	.delayStompUp				; if yes, branch
		addq.w	#8,sto_offset_now(a0)			; move stomper down at 8px/frame
		bra.s	.updatePosition				; update Y-position
; ---------------------------------------------------------------------------

	.delayStompUp:
		subq.w	#1,sto_delay(a0)			; decrement delay before stomping up
		bpl.s	.updatePosition				; fi time remains, branch
		move.w	#1*60,sto_delay(a0)			; set delay before stomping back down to 1 second
		clr.b	sto_active(a0)				; start stomping up

	.updatePosition:
		move.w	sto_offset_now(a0),d0			; get current stomp distance
		btst	#0,obStatus(a0)				; is stomper X-flipped?
		beq.s	.setY					; if not, branch
		neg.w	d0					; invert base stomp direction
		addi.w	#56,d0					; keep in same general Y-range (stomper height is 56px)
	.setY:	move.w	sto_origY(a0),d1			; get initial stomper Y-position
		add.w	d0,d1					; adjust by current stomp distance
		move.w	d1,obY(a0)				; set new Y-position
		rts						; return
; ===========================================================================

; Type 5 - ancient lift at the start of SBZ3/LZ4
; .type05:
Sto_AncientLift:
		tst.b	sto_active(a0)				; has ancient lift already started moving?
		bne.s	.moveLift				; if yes, branch

		lea	(f_switch).w,a2				; load switch states
		moveq	#0,d0					; clear d0
		move.b	sto_switch(a0),d0			; get switch ID that will trigger ancient lift
		btst	#0,(a2,d0.w)				; is respective switch button pressed?
		beq.s	.return					; if not, branch

		move.b	#1,sto_active(a0)			; start moving ancient lift

		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0
		move.b	obRespawnNo(a0),d0			; get object respawn table index
		beq.s	.moveLift				; if it doesn't have one, branch
		bset	#0,2(a2,d0.w)				; globally remember that lift has already started moving

	.moveLift:
		subi.l	#$10000,obX(a0)				; move ancient lift to the left at 1px/frame (including subpixels)
		addi.l	#$8000,obY(a0)				; move ancient lift down at 0.5px/frame (including subpixels)
		move.w	obX(a0),sto_origX(a0)			; overwrite initial X-position with current one
		cmpi.w	#$980,obX(a0)				; has ancient lift reached target X-position? ($980)
		beq.s	.stopLift				; if yes, stop it moving

	.return:
		rts						; return
; ---------------------------------------------------------------------------

.stopLift:
		clr.b	obSubtype(a0)				; stop any further platform behavior (Sto_Stationary)
		clr.b	sto_active(a0)				; clear active flag (redundant at this point)
		rts						; return

; ===========================================================================

Map_Stomp:	include	"_maps/SBZ Stomper and Door.asm"
