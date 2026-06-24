; ===========================================================================
; ---------------------------------------------------------------------------
; Object 36 - Spikes
; ---------------------------------------------------------------------------
spikes_origX:		equ objoff_30	; initial X-position
spikes_origY:		equ objoff_32	; initial Y-position
spikes_move_pos:	equ objoff_34	; delta position for moving spikes (0px to 32px)
spikes_move_direction:	equ objoff_36	; flag for last movement direction
spikes_move_delay:	equ objoff_38	; delay between spike movement
; ---------------------------------------------------------------------------

Spikes:
		moveq	#0,d0				; clear d0
		move.b	obRoutine(a0),d0		; get current object routine
		move.w	Spikes_Index(pc,d0.w),d1	; find entry in jump table
		jmp	Spikes_Index(pc,d1.w)		; jump there
; ===========================================================================
Spikes_Index:	dc.w Spikes_Main-Spikes_Index		; 0 - init
		dc.w Spikes_Solid-Spikes_Index		; 2 - main mode
; ===========================================================================
Spikes_Config:	; 	frame,	display and collision width/2
		dc.b	0,	40/2			; subtype $0x: 3 spikes, upright
		dc.b	1,	32/2			; subtype $1x: 3 spikes, sideways
		dc.b	2,	8/2			; subtype $2x: 1 spike,  upright
		dc.b	3,	56/2			; subtype $3x: 3 spikes, upright (wide)
		dc.b	4,	128/2			; subtype $4x: 6 spikes, upright (wide)
		dc.b	5,	32/2			; subtype $5x: 1 spike,  sideways
		; (More spike types could theoretically be added here...)
; ===========================================================================

Spikes_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)		; set to Spikes_Solid
		move.l	#Map_Spike,obMap(a0)		; load mappings
		move.w	#ArtTile_Spikes,obGfx(a0)	; set art tile
		ori.b	#sprite_cam_field,obRender(a0)	; set to playfield-positioning mode
		move.b	#4,obPriority(a0)		; set sprite priority

		move.b	obSubtype(a0),d0		; get spikes subtype
		andi.b	#$F,obSubtype(a0)		; clear upper nybble in subtype (lower nybble is for movement)
		andi.w	#$F0,d0				; only look at upper nybble for config array
		lea	(Spikes_Config).l,a1		; load spikes configuration array
		lsr.w	#4-1,d0				; shift to lower nybble and multiply by 2 (two bytes per entry)
		adda.w	d0,a1				; jump to entry in configuration array
		move.b	(a1)+,obFrame(a0)		; load frame ID
		move.b	(a1)+,obActWid(a0)		; load display and solidity width

		move.w	obX(a0),spikes_origX(a0)	; remember initial X-position (for despawning)
		move.w	obY(a0),spikes_origY(a0)	; remember initial Y-position
; ---------------------------------------------------------------------------

Spikes_Solid:	; Routine 2
		bsr.w	Spikes_Move			; make the spikes move depending on subtype

		move.w	#8/2,d2				; set collision height for singular sideways spikes
		cmpi.b	#5,obFrame(a0)			; is spikes type $5x? (1 spike, sideways)
		beq.s	Spikes_SideWays			; if yes, branch
		cmpi.b	#1,obFrame(a0)			; is spikes type $1x? (3 spikes, sideways)
		bne.s	Spikes_Upright			; if not, branch (spikes are upright)
		move.w	#40/2,d2			; set collision height for triple sideways spikes

Spikes_SideWays:
		; Spikes types $1x and $5x face sideways
		move.w	#32/2+sonic_solid_width,d1	; set collision width for sideways spikes
		move.w	d2,d3				; copy collision height to secondary height input
		addq.w	#1,d3				; secondary height is +1
		move.w	obX(a0),d4			; set base X-position for collision detection
		bsr.w	SolidObject			; check if Sonic touched the sideways spikes
	if FixBugs
		; Fix Spikes Backside Damage in Sonic 1
		; https://info.sonicretro.org/SCHG_How-to:Fix_Spikes_Backside_Damage_in_Sonic_1
		ble.w	Spikes_Display			; branch if not touched at all (0) or top/bottom touched (-1)
		move.w	(v_player+obX).w,d0		; load Sonic's X position into d0
		sub.w	obX(a0),d0			; subtract spikes' X position
		btst	#0,obStatus(a0)			; are spikes facing left? (X-flip flag clear)
		beq.s	.chkHurt			; if yes, branch
		neg.w	d0				; invert difference to check opposite end for right spikes
.chkHurt:	tst.w	d0				; is Sonic touching the "pointy" end of the spikes?
		bgt.s	Spikes_Display			; if not, make spike harmless (backside touched)
		bra.s	Spikes_Hurt			; otherwise, trigger damage
	else
		btst	#3,obStatus(a0)			; is Sonic standing on top of the sideways spikes?
		bne.s	Spikes_Display			; if yes, treat as solid platform (no damage)
		cmpi.w	#1,d4				; has Sonic touched the side of the spikes?
		beq.s	Spikes_Hurt			; if yes, trigger damage
		bra.s	Spikes_Display			; otherwise, make spikes harmless
	endif
; ===========================================================================

Spikes_Upright:
		; Spikes types $0x, $2x, $3x and $4x face up or down
		moveq	#0,d1				; clear d1
		move.b	obActWid(a0),d1			; use display width as damage trigger width
		addi.w	#sonic_solid_width,d1		; add Sonic's collision width to trigger width
		move.w	#32/2,d2			; set collision height for upright spikes
		move.w	#(32/2)+1,d3			; secondary collision height is +1
		move.w	obX(a0),d4			; set base X-position for collision detection
		bsr.w	SolidObject			; check if Sonic touched the spikes
	if FixBugs
		; Fix Spikes Backside Damage in Sonic 1
		; https://info.sonicretro.org/SCHG_How-to:Fix_Spikes_Backside_Damage_in_Sonic_1
		btst	#3,obStatus(a0)			; does Sonic stand on the spikes? (landing on it after taking damage)
		bne.s	.chkAnyway			; if yes, check for collision anyway
		tst.w	d4				; check response value from SolidObject
		bge.s	Spikes_Display			; branch if not touched at all (0) or touched from the sides (+1)
.chkAnyway:	move.w	(v_player+obY).w,d0		; load Sonic's Y position into d0
		sub.w	obY(a0),d0			; subtract spikes' Y position
		btst	#1,obStatus(a0)			; are spikes facing up? (Y-flip flag clear)
		beq.s	.chkHurt			; if yes, branch
		neg.w	d0				; invert difference to check opposite end for upside-down spikes
.chkHurt:	tst.w	d0				; is Sonic touching the "pointy" end of the spikes?
		bgt.s	Spikes_Display			; if not, make spike harmless (backside touched)
	else
		btst	#3,obStatus(a0)			; is Sonic standing on top of the spikes?
		bne.s	Spikes_Hurt			; if yes, trigger damage
		tst.w	d4				; check response value from SolidObject
		bpl.s	Spikes_Display			; branch if not touched at all (0) or touched from the sides (+1)
	endif

Spikes_Hurt:
		tst.b	(v_invinc).w			; is Sonic invincible?
		bne.s	Spikes_Display			; if so, skip getting hurt
	if FixBugs
		; (Proper) Spike Bug Fix
		; https://info.sonicretro.org/SCHG_How-to:Change_Spike_behavior_in_Sonic_1
		tst.w	(v_player+flashtime).w		; is Sonic flashing after being hurt?
		bne.s	Spikes_Display			; if so, skip getting hurt
	endif
		move.l	a0,-(sp)			; backup spikes RAM location
		movea.l	a0,a2				; move spikes RAM location to a2
		lea	(v_player).w,a0			; load Sonic player object to a0
		cmpi.b	#4,obRoutine(a0)		; is Sonic currently in a hurt state or dying?
		bhs.s	Spikes_NoHurt			; if yes, avoid taking damage (restore a0 first)

	if Revision<>2|FixBugs
		move.l	obY(a0),d3			; get Sonic's Y-position (with subpixels)
		move.w	obVelY(a0),d0			; get Sonic's Y-velocity
		ext.l	d0				; extend velocity to longword
		asl.l	#8,d0				; shift velocity to upper word (16.16 fixed point)
	else
		; --- REVXB ("Revision 2") Spike Bug Fix ---
		; REVXB is a mod of REV01 created for Sonic Mega Collection (2002), and
		; the only change made is this dirty spike bug fix. The above code was
		; relocated to unused vector entries at the start of the ROM (see "loc_E0"). 
		; Consider enabling "FixBugs" for a clean solution (see above).
		tst.w	flashtime(a0)			; is Sonic flashing after being hurt?
		bne.s	Spikes_NoHurt			; if so, skip getting hurt
		jmp	(Rev02_SpikeBugFix).l		; this is a copy of the above code that was pushed aside for this
; loc_D5A2:
Rev02_SpikeBugFix_Return:
	endif
		sub.l	d0,d3				; subtract Y-velocity from Sonic's Y-position
		move.l	d3,obY(a0)			; set that as new Y-position
		jsr	(HurtSonic).l			; trigger damage on Sonic

; loc_CF20:
Spikes_NoHurt:
		movea.l	(sp)+,a0			; restore spikes RAM location to a0

Spikes_Display:
	if FixBugs
		; Objects shouldn't call DisplaySprite and DeleteObject in
		; the same frame or else cause a null-pointer dereference.
		out_of_range.w	DeleteObject,spikes_origX(a0) ; check if spikes are offscreen and delete them if so
		bra.w	DisplaySprite			; display spikes sprite
	else
		bsr.w	DisplaySprite			; display spikes sprite
		out_of_range.w	DeleteObject,spikes_origX(a0) ; check if spikes are offscreen and delete them if so
		rts					; return
	endif


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to move spikes, based on subtype
; ---------------------------------------------------------------------------

; Spikes_Type0x:
Spikes_Move:
		moveq	#0,d0				; clear d0
		move.b	obSubtype(a0),d0		; get spikes subtype (lower nybble only)
		add.w	d0,d0				; double for word-based indexing
		move.w	Spik_TypeIndex(pc,d0.w),d1	; find entry in jump table
		jmp	Spik_TypeIndex(pc,d1.w)		; jump there
; ===========================================================================
Spik_TypeIndex:	dc.w Spikes_Type0-Spik_TypeIndex	; subtype $x0: static
		dc.w Spikes_Type1-Spik_TypeIndex	; subtype $x1: moving up/down
		dc.w Spikes_Type2-Spik_TypeIndex	; subtype $x2: moving left/right
		; (More spike movement types could theoretically be added here...)
; ===========================================================================

Spikes_Type0:	; static
		rts					; no movement
; ---------------------------------------------------------------------------

Spikes_Type1:	; moving up/down
		bsr.w	Spikes_WaitAndMove		; delay or update position delta
		moveq	#0,d0				; clear d0
		move.b	spikes_move_pos(a0),d0		; read only upper byte of position delta
		add.w	spikes_origY(a0),d0		; add initial Y-position
		move.w	d0,obY(a0)			; set new Y-position to move the spikes vertically
		rts					; return
; ---------------------------------------------------------------------------

Spikes_Type2:	; moving left/right
		bsr.w	Spikes_WaitAndMove		; delay or update position delta
		moveq	#0,d0				; clear d0
		move.b	spikes_move_pos(a0),d0		; read only upper byte of position delta
		add.w	spikes_origX(a0),d0		; add initial X-position
		move.w	d0,obX(a0)			; set new X-position to move the spikes horizontally
		rts					; return
; End of function Spikes_Move

; ---------------------------------------------------------------------------
; Subroutine to delay spikes movement or update position delta after delay
; ---------------------------------------------------------------------------

Spikes_WaitAndMove:
		tst.w	spikes_move_delay(a0)		; is time delay = zero?
		beq.s	.doSpikesMove			; if yes, move spikes
		subq.w	#1,spikes_move_delay(a0)	; subtract 1 from time delay
		bne.s	.return				; if time remains, branch
		tst.b	obRender(a0)			; are spikes off-screen?
		bpl.s	.return				; if yes, don't play sound
		move.w	#sfx_SpikesMove,d0		; set "spikes moving" sound
		jsr	(QueueSound2).l			; play it
		bra.s	.return				; return (could've been an rts)
; ---------------------------------------------------------------------------

	.doSpikesMove:
		tst.w	spikes_move_direction(a0)	; have spikes already moved in?
		beq.s	.retractSpikes			; if yes, retract them instead

		subi.w	#8*$100,spikes_move_pos(a0)	; move in by 8px
		bhs.s	.return				; if still moving in, branch
		move.w	#0,spikes_move_pos(a0)		; fix position delta to 0px
		move.w	#0,spikes_move_direction(a0)	; set to retract spikes on next run
		move.w	#60,spikes_move_delay(a0)	; set time delay to 1 second
		bra.s	.return				; return (could've been an rts)
; ---------------------------------------------------------------------------

	.retractSpikes:
		addi.w	#8*$100,spikes_move_pos(a0)	; move out by 8px
		cmpi.w	#32*$100,spikes_move_pos(a0)	; has target retraction of 32px been reached?
		blo.s	.return				; if still moving out, branch
		move.w	#32*$100,spikes_move_pos(a0)	; fix position delta to 32px
		move.w	#1,spikes_move_direction(a0)	; set to move in spikes again on next run
		move.w	#60,spikes_move_delay(a0)	; set time delay to 1 second

	.return:
		rts					; return
; End of function Spikes_WaitAndMove
; ===========================================================================

Map_Spike:	include	"_maps/Spikes.asm"
