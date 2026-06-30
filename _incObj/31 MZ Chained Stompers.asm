; ===========================================================================
; ---------------------------------------------------------------------------
; Object 31 - stomping metal blocks on chains (MZ)
; ---------------------------------------------------------------------------

ChainStomp:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	CStom_Index(pc,d0.w),d1
		jmp	CStom_Index(pc,d1.w)
; ===========================================================================
CStom_Index:	dc.w CStom_Main-CStom_Index		; 0
		dc.w CStom_MainBlock-CStom_Index	; 2
		dc.w CStom_Spikes-CStom_Index		; 4
		dc.w CStom_Ceiling-CStom_Index		; 6
		dc.w CStom_Chain-CStom_Index		; 8

cstom_origY:	equ objoff_30		; initial Y-position
cstom_current:	equ objoff_32		; current distance the stomper is extended
cstom_length:	equ objoff_34		; maximum distance the stomper can be extended (set from CStom_Lengths)
cstom_rising:	equ objoff_36		; flag set while stomper is rising (0 implies falling)
cstom_delay:	equ objoff_38		; time to wait after auto-stomp before rising again
cstom_switch:	equ objoff_3A		; switch number for the current stomper
cstom_parent:	equ objoff_3C		; pointer to parent object (main metal block)
; ===========================================================================

CStom_SwchNums:	; switch number, obj number
		dc.b 0, 0	; $80 - stomper in MZ1 activated with block
		dc.b 1, 0	; $81 - unused

CStom_Var:	; routine, relative y-pos, frame
		dc.b 2,   0, 0	; Block
		dc.b 4, $1C, 1	; Spikes
		dc.b 8, $CC, 3	; Chain
		dc.b 6, $F0, 2	; Base attached to ceiling

CStom_Lengths:	; chain lengths
		dc.w $7000	; $x0
		dc.w $A000	; $x1
		dc.w $5000	; $x2
		dc.w $7800	; $x3
		dc.w $3800	; $x4
		dc.w $5800	; $x5
		dc.w $B800	; $x6
; ===========================================================================

CStom_Main:	; Routine 0
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get stomper subtype
		bpl.s	.loadChainLength			; if it's not switch-activated, branch (bit 7 clear)

		; Switch-activated, only used for one stomper in MZ1
		andi.w	#$7F,d0					; clear bit 7
		add.w	d0,d0					; double for two 2 bytes per entry
		lea	CStom_SwchNums(pc,d0.w),a2		; load switch activation array
		move.b	(a2)+,cstom_switch(a0)			; get switch ID that triggers stomper rising
		move.b	(a2)+,d0				; get subtype override value (this is always 0)
		move.b	d0,obSubtype(a0)			; replace subtype

	.loadChainLength:
		andi.b	#$F,d0					; only read lower subtype digit
		add.w	d0,d0					; double for one word per length
		move.w	CStom_Lengths(pc,d0.w),d2		; load chain length for stomper subtype
		tst.w	d0					; is subtype $x0?
		bne.s	.loadStomperObjects			; if not, branch
		move.w	d2,cstom_current(a0)			; spawn stomper immediately at max extension length

	.loadStomperObjects:
		lea	(CStom_Var).l,a2			; load stomper objects setup array
		movea.l	a0,a1					; write first object (block) into current RAM location
		moveq	#4-1,d1					; spawn 4 objects
		bra.s	.makeStomper				; first object doesn't need a new object slot
; ---------------------------------------------------------------------------

.loopMakeStomper:
		bsr.w	FindNextFreeObj				; find a free object slot
		bne.w	.setupMainBlock				; if object RAM is full, branch

	.makeStomper:
		move.b	(a2)+,obRoutine(a1)			; load routine for object
		_move.b	#id_ChainStomp,obID(a1)			; creater stomper object
		move.w	obX(a0),obX(a1)				; copy X-position from parent
		move.b	(a2)+,d0				; load relative Y-position for object
		ext.w	d0					; make word-sized
		add.w	obY(a0),d0				; add Y-position from parent
		move.w	d0,obY(a1)				; set final Y-position for child object

		move.l	#Map_CStom,obMap(a1)			; set mappings
		move.w	#ArtTile_MZ_Spike_Stomper,obGfx(a1)	; set art tile
		move.b	#sprite_cam_field,obRender(a1)		; set to playfield-positioned mode
		move.w	obY(a1),cstom_origY(a1)			; remember initial Y-position (with relative offset)
		move.b	obSubtype(a0),obSubtype(a1)		; copy subtype from parent
		move.b	#32/2,obActWid(a1)			; set sprite display width
		move.w	d2,cstom_length(a1)			; write stomper length fetched from CStom_Lengths
		move.b	#4,obPriority(a1)			; set sprite priority
		move.b	(a2)+,obFrame(a1)			; set frame ID (0-3)

		cmpi.b	#1,obFrame(a1)				; are we spawning the spikes object?
		bne.s	.next					; if not, branch
		subq.w	#1,d1					; spawn one less object for the small stomper
		move.b	obSubtype(a0),d0			; read subtype again
		andi.w	#$F0,d0					; only look at upper digit
		cmpi.w	#$20,d0					; is this a small, spike-less stomper?
		beq.s	.makeStomper				; if yes, don't load spikes object
		move.b	#112/2,obActWid(a1)			; set sprite display width for spikes
		move.b	#col_80x32|col_hurt,obColType(a1)	; make spikes harmful on touch
		addq.w	#1,d1					; undo earlier object loading adjustment
	.next:
		move.l	a0,cstom_parent(a1)			; remember parent object (block)
		dbf	d1,.loopMakeStomper			; repeat sequence 3 more times

		move.b	#3,obPriority(a1)			; make base at the ceiling higher priority

.setupMainBlock:
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get subtype again
		lsr.w	#3,d0					; read only upper digit, multiplied by 2
		andi.b	#$E,d0					; limit to sane values
		lea	CStom_Var2(pc,d0.w),a2			; load secondary setup array
		move.b	(a2)+,obActWid(a0)			; load sprite display and solidity width for block
		move.b	(a2)+,obFrame(a0)			; load frame ID for block
		bra.s	CStom_MainBlock				; skip over setup array
; ===========================================================================
CStom_Var2:	; width, frame
		dc.b $70/2, 0	; $0x - large
		dc.b $60/2, 9	; $1x - medium
		dc.b $20/2, $A	; $2x - small (spikeless)
; ===========================================================================

; CStom_Block:
CStom_MainBlock: ; Routine 2
		bsr.w	CStom_Types				; execute block behavior
		move.w	obY(a0),(v_obj31ypos).w			; write Y-position to global variable (used in PushBlock in MZ1)

		moveq	#0,d1					; clear d1
		move.b	obActWid(a0),d1				; use sprite display width as solidity width
		addi.w	#sonic_solid_width,d1			; add Sonic's own collision width
		move.w	#24/2,d2				; collision height (initial)
		move.w	#26/2,d3				; collision height (stood-on)
		move.w	obX(a0),d4				; X-position (stood-on)
		bsr.w	SolidObject				; make main metal block solid

		btst	#3,obStatus(a0)				; is Sonic standing on main metal block?
		beq.s	.display				; if not, branch
		cmpi.b	#$10,cstom_current(a0)			; is current stomper close enough to the ceiling to squash Sonic?
		bhs.s	.display				; if not, branch
		movea.l	a0,a2					; backup stomper (and set it as killing object)
		lea	(v_player).w,a0				; load Sonic player object
		jsr	(KillSonic).l				; squash kill Sonic
		movea.l	a2,a0					; restore stomper object

.display:
	if FixBugs=0
		bsr.w	DisplaySprite				; display main metal block
	endif
		bra.w	CStom_ChkDel				; handle out-of-range deletion
; ===========================================================================

CStom_Chain:	; Routine 8
		move.b	#256/2,obHeight(a0)			; set sprite display height
		bset	#sprite_customheight_bit,obRender(a0)	; use custom display height rendering (chain is long)
		movea.l	cstom_parent(a0),a1			; load parent metal block object
		move.b	cstom_current(a1),d0			; get current extension length of block
		lsr.b	#5,d0					; use a longer chain frame for every $20px
		addq.b	#3,d0					; chain mappings start at frame ID 3
		move.b	d0,obFrame(a0)				; set chain length frame based on its length
		; continue to CStom_Spikes to align Y-position...
; ---------------------------------------------------------------------------

CStom_Spikes:	; Routine 4
		movea.l	cstom_parent(a0),a1			; load parent metal block object
		moveq	#0,d0					; clear d0
		move.b	cstom_current(a1),d0			; get current extension length of block
		add.w	cstom_origY(a0),d0			; add initial Y-position
		move.w	d0,obY(a0)				; align child object with main metal block as it moves
; ---------------------------------------------------------------------------

CStom_Ceiling:	; Routine 6
	if FixBugs=0
		bsr.w	DisplaySprite				; display sprite
	endif

CStom_ChkDel:
		out_of_range.w	DeleteObject			; has object gone out of range? if yes, delete it
	if FixBugs
		; Objects shouldn't call DisplaySprite and DeleteObject on
		; the same frame or else cause a null-pointer dereference.
		bra.w	DisplaySprite				; display sprite
	else
		rts						; return
	endif

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to execute stomper movement behavior based on subtype
; ---------------------------------------------------------------------------

CStom_Types:
		move.b	obSubtype(a0),d0			; get stomper subtype
		andi.w	#$F,d0					; only read lower digit
		add.w	d0,d0					; double for word-based indexing
		move.w	CStom_TypeIndex(pc,d0.w),d1		; find entry in jump table
		jmp	CStom_TypeIndex(pc,d1.w)		; execute behavior for stomper subtype
; ===========================================================================
CStom_TypeIndex:dc.w CStom_SwitchActivated-CStom_TypeIndex	; $x0
		dc.w CStom_AutoStomp-CStom_TypeIndex		; $x1
		dc.w CStom_AutoStomp-CStom_TypeIndex		; $x2
		dc.w CStom_WaitForSonic-CStom_TypeIndex		; $x3
		dc.w CStom_AutoStomp-CStom_TypeIndex		; $x4
		dc.w CStom_WaitForSonic-CStom_TypeIndex		; $x5
		dc.w CStom_AutoStomp-CStom_TypeIndex		; $x6
; ===========================================================================

; Type 0 - Rises while switch object is pressed
CStom_SwitchActivated:
		lea	(f_switch).w,a2				; load switch statuses array
		moveq	#0,d0					; clear d0
		move.b	cstom_switch(a0),d0			; get trigger switch ID for stomper (0 or 1)
		tst.b	(a2,d0.w)				; has matching switch ID been pressed?
		beq.s	.falling				; if not, branch
		tst.w	(v_obj31ypos).w				; is a pushable block currently on top of the stomper? (bit 7, see PushB_Action)
		bpl.s	.checkRising				; if not, branch
		cmpi.b	#$10,cstom_current(a0)			; is stomper a little bit below reaching the ceiling?
		beq.s	.stop					; if yes, stop rising so pushable block doesn't get stuck in ceiling

	.checkRising:
		tst.w	cstom_current(a0)			; is stomper fully at ceiling?
		beq.s	.stop					; if yes, don't rise any further or play sound

		move.b	(v_vblank_byte).w,d0			; get current VBlank counter byte
		andi.b	#$F,d0					; only play rising sound every 16 frames
		bne.s	.rise					; brancch on other frames
		tst.b	obRender(a0)				; is stomper on screen?
		bpl.s	.rise					; if not, don't play rising sound
		move.w	#sfx_ChainRise,d0			; set rising chain sound
		jsr	(QueueSound2).l				; play it

	.rise:
		subi.w	#$80,cstom_current(a0)			; slowly rise stomper further
		bcc.s	CStom_UpdateBlockY			; if it hasn't hit minimum extension range yet, branch
		move.w	#0,cstom_current(a0)			; snap stomper to ceiling

	.stop:
		move.w	#0,obVelY(a0)				; reset falling speed
		bra.s	CStom_UpdateBlockY			; update Y-position based on current extension length
; ---------------------------------------------------------------------------

	.falling:
		move.w	cstom_length(a0),d1			; get max length of stomper
		cmp.w	cstom_current(a0),d1			; is stomper already at max length?
		beq.s	CStom_UpdateBlockY			; if yes, branch
		move.w	obVelY(a0),d0				; get current falling speed
		addi.w	#$70,obVelY(a0)				; make stomper fall faster
		add.w	d0,cstom_current(a0)			; add speed to current extension length

		cmp.w	cstom_current(a0),d1			; has stomper reached max length?
		bhi.s	CStom_UpdateBlockY			; if not, branch
		move.w	d1,cstom_current(a0)			; snap stomper to max length
		move.w	#0,obVelY(a0)				; stop stomper falling

		tst.b	obRender(a0)				; was stomper on screen as it hit max length?
		bpl.s	CStom_UpdateBlockY			; if not, don't play stomping sound
		move.w	#sfx_ChainStomp,d0			; set stomping sound
		jsr	(QueueSound2).l				; play it
		; continue to CStom_UpdateBlockY...
; ---------------------------------------------------------------------------

; CStom_Restart:
CStom_UpdateBlockY:
		moveq	#0,d0					; clear d0
		move.b	cstom_current(a0),d0			; get current extension length
		add.w	cstom_origY(a0),d0			; add initial Y-position
		move.w	d0,obY(a0)				; update Y-position based on extension length
		rts						; return
; ===========================================================================

; Types 1/2/4/6 - Rises and stomps on its own
CStom_AutoStomp:
		tst.w	cstom_rising(a0)			; is stomper currently rising?
		beq.s	.falling				; if not, branch
		tst.w	cstom_delay(a0)				; decrement delay before rising again
		beq.s	.risingSound				; if timer expired, branch
		subq.w	#1,cstom_delay(a0)			; decrement delay timer
		bra.s	.finish					; don't move stomper yet
; ---------------------------------------------------------------------------

	.risingSound:
		move.b	(v_vblank_byte).w,d0			; get current VBlank counter byte
		andi.b	#$F,d0					; only play rising sound every 16 frames
		bne.s	.rise					; brancch on other frames
		tst.b	obRender(a0)				; is stomper on screen?
		bpl.s	.rise					; if not, don't play rising sound
		move.w	#sfx_ChainRise,d0			; set rising chain sound
		jsr	(QueueSound2).l				; play it

	.rise:
		subi.w	#$80,cstom_current(a0)			; slowly rise stomper further
		bcc.s	.finish					; if it hasn't hit minimum extension range yet, branch
		move.w	#0,cstom_current(a0)			; snap stomper to ceiling
		move.w	#0,obVelY(a0)				; reset falling speed
		move.w	#0,cstom_rising(a0)			; clear rising flag
		bra.s	.finish					; begin stomping on next frame
; ---------------------------------------------------------------------------

	.falling:
		move.w	cstom_length(a0),d1			; get max length of stomper
		cmp.w	cstom_current(a0),d1			; is stomper already at max length?
		beq.s	.finish					; if yes, branch
		move.w	obVelY(a0),d0				; get current falling speed
		addi.w	#$70,obVelY(a0)				; make stomper fall faster
		add.w	d0,cstom_current(a0)			; add speed to current extension length

		cmp.w	cstom_current(a0),d1			; has stomper reached max length?
		bhi.s	.finish					; if not, branch
		move.w	d1,cstom_current(a0)			; snap stomper to max length
		move.w	#0,obVelY(a0)				; stop stomper falling
		move.w	#1,cstom_rising(a0)			; set flag that stomper rising
		move.w	#60,cstom_delay(a0)			; wait 1 second before rising again

		tst.b	obRender(a0)				; was stomper on screen as it hit max length?
		bpl.s	.finish					; if not, don't play stomping sound
		move.w	#sfx_ChainStomp,d0			; set stomping sound
		jsr	(QueueSound2).l				; play it

	.finish:
		bra.w	CStom_UpdateBlockY			; update Y-position based on current extension length
; ===========================================================================

; Types 3/5 - Increments subtype if Sonic is horizontally in range (to begin auto-stomp)
CStom_WaitForSonic:
		move.w	(v_player+obX).w,d0			; get Sonic's current X-position
		sub.w	obX(a0),d0				; calculate difference to stomper X-position
		bcc.s	.chkX					; if result is positive, branch
		neg.w	d0					; otherwise, make it positive
	.chkX:	cmpi.w	#144,d0					; is Sonic horizontally within 144px of stomper?
		bhs.s	.finish					; if not, branch
		addq.b	#1,obSubtype(a0)			; change subtype to next in list (always CStom_AutoStomp)

	.finish:
		bra.w	CStom_UpdateBlockY			; keep block Y-position in place until Sonic gets close

; End of function CStom_Types