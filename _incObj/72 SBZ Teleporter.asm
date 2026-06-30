; ===========================================================================
; ---------------------------------------------------------------------------
; Object 72 - invisible teleporter system inside tubes (SBZ act 2)
; ---------------------------------------------------------------------------

Teleport:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Tele_Index(pc,d0.w),d1
		jsr	Tele_Index(pc,d1.w)

		out_of_range.s	.delete
		rts

	.delete:
		jmp	(DeleteObject).l

; ===========================================================================
Tele_Index:	dc.w Tele_Main-Tele_Index
		dc.w Tele_Action-Tele_Index
		dc.w Tele_PreBump-Tele_Index
		dc.w Tele_Teleporting-Tele_Index

tele_time:	equ objoff_2E	; remaining time Sonic should move in current direction 
tele_prebump:	equ objoff_32	; current pre-bump value before Sonic gets shot off (incremented by 2, triggers at $80)
tele_targetX:	equ objoff_36	; next X-position target
tele_targetY:	equ objoff_38	; next Y-position target
tele_current:	equ objoff_3A	; current entry in tele_entries (in multiples of 4)
tele_entries:	equ objoff_3B	; number of entries in teleporter target data (in multiples of 4)
tele_dataptr:	equ objoff_3C	; pointer to the teleporter target data for the current tube network
; ===========================================================================

Tele_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Tele_Action

		move.b	obSubtype(a0),d0			; get teleporter subtype
		add.w	d0,d0					; double for word-based indexing
		andi.w	#$1E,d0					; limit to sane values
		lea	Tele_Data(pc),a2			; load teleporter destination data array
		adda.w	(a2,d0.w),a2				; use offset table to advance to actual data for subtype
		move.w	(a2)+,tele_current(a0)			; set tele_current to 0 & load number of entries in teleporter data (times 4) to tele_entries 
		move.l	a2,tele_dataptr(a0)			; remember address in teleporter target data
		move.w	(a2)+,tele_targetX(a0)			; load first X-target
		move.w	(a2)+,tele_targetY(a0)			; load first Y-target
; ---------------------------------------------------------------------------

Tele_Action:	; Routine 2
		lea	(v_player).w,a1				; load Sonic player object
		move.w	obX(a1),d0				; get Sonic's current X-position
		sub.w	obX(a0),d0				; calculate difference to teleporter entrance X-position
		btst	#0,obStatus(a0)				; is teleporter entrance to the right?
		beq.s	.chkX					; if not, branch
		addi.w	#15,d0					; adjust X-trigger for right-side entrance
	.chkX:	cmpi.w	#16,d0					; is Sonic horizontally within 16px of the teleporter entrance?
		bhs.s	.return					; if not, branch

		move.w	obY(a1),d1				; get Sonic's current Y-position
		sub.w	obY(a0),d1				; calculate difference to teleporter entrance Y-position
		addi.w	#32,d1					; make vertical trigger size 32px up and down
		cmpi.w	#32*2,d1				; is Sonic vertically within 64px of the teleporter entrance?
		bhs.s	.return					; if not, branch

	if FixBugs
		; Fix being able to activate teleporters while in debug mode
		tst.w	(v_debuguse).w				; is debug mode active?
		bne.s	.return					; if yes, ignore teleporter
	endif
		tst.b	(f_playerctrl).w			; is Sonic already inside a teleporter? (Sonic override flags)
		bne.s	.return					; if yes, ignore it

		cmpi.b	#7,obSubtype(a0)			; is this the special 50-rings teleporter?
		bne.s	.activateTeleporter			; if not, skip ring requirement
		cmpi.w	#50,(v_rings).w				; do you have at least 50 rings?
		blo.s	.return					; if not, disable teleporter

	.activateTeleporter:
		addq.b	#2,obRoutine(a0)			; advance to Tele_PreBump
		move.b	#$81,(f_playerctrl).w			; set Sonic override flags (lock controls and disable object interaction)
		move.b	#id_Roll,obAnim(a1)			; use Sonic's rolling animation
		move.w	#$800,obInertia(a1)			; set to fast ground speed to use fast rolling animation
		move.w	#0,obVelX(a1)				; stop Sonic horizontally
		move.w	#0,obVelY(a1)				; stop Sonic vertically
		bclr	#5,obStatus(a0)				; clear teleporter's pushed flag
		bclr	#5,obStatus(a1)				; clear Sonic's pushing flag
		bset	#1,obStatus(a1)				; set Sonic in-air
		move.w	obX(a0),obX(a1)				; snap Sonic to teleporer entrance X-position
		move.w	obY(a0),obY(a1)				; snap Sonic to teleporter entrance Y-position
		clr.b	tele_prebump(a0)			; reset pre-bump value to 0

		move.w	#sfx_Roll,d0				; set Sonic rolling sound
		jsr	(QueueSound2).l				; play it

	.return:
		rts						; return
; ===========================================================================

Tele_PreBump:	; Routine 4
		lea	(v_player).w,a1				; load Sonic player object
		move.b	tele_prebump(a0),d0			; get current bump value
		addq.b	#2,tele_prebump(a0)			; increment bump value
		jsr	(CalcSine).l				; get sine for current bump value
		asr.w	#5,d0					; divide sine result by $20
		move.w	obY(a0),d2				; get teleporter entrance Y-position
		sub.w	d0,d2					; subtract adjusted sine result
		move.w	d2,obY(a1)				; make Sonic bump up and down in teleporter

		cmpi.b	#$80,tele_prebump(a0)			; has bump value advanced to a full bump?
		bne.s	.return					; if not, branch
		bsr.w	Tele_NextDirection			; begin teleportation
		addq.b	#2,obRoutine(a0)			; advance to Tele_Teleporting
		move.w	#sfx_Teleport,d0			; play teleport sound
		jsr	(QueueSound2).l				; (in later games, this is a generic dash sound)

	.return:
		rts						; return
; ===========================================================================

; Tele_Bend:
Tele_Teleporting: ; Routine 6
		addq.l	#4,sp					; skip returning to "Teleporter:" routine to avoid out-of-range deletion
		lea	(v_player).w,a1				; load Sonic player object

		subq.b	#1,tele_time(a0)			; decrement timer for Sonic to travel in current direction
		bpl.s	.continueInTube				; if time remains, continue that direction

	.targetReached:
		move.w	tele_targetX(a0),obX(a1)		; snap Sonic to target X-position
		move.w	tele_targetY(a0),obY(a1)		; snap Sonic to target Y-position

		moveq	#0,d1					; clear d1
		move.b	tele_current(a0),d1			; get current index in teleporter target data
		addq.b	#4,d1					; advance to next index (4 bytes per entry)
		cmp.b	tele_entries(a0),d1			; has final entry been completed?
		blo.s	.nextTubeBend				; if not, branch
		moveq	#0,d1					; clear d1 again (redundant at this point)
		bra.s	.exitTeleporter				; make Sonic exit the teleporter
; ---------------------------------------------------------------------------

	.nextTubeBend:
		move.b	d1,tele_current(a0)			; update index to teleporter target data to next index
		movea.l	tele_dataptr(a0),a2			; load pointer to teleporter target data
		move.w	(a2,d1.w),tele_targetX(a0)		; get next target X-position
		move.w	2(a2,d1.w),tele_targetY(a0)		; get next target Y-position
		bra.w	Tele_NextDirection			; set new movement direction for Sonic for bend
; ---------------------------------------------------------------------------

	.continueInTube:
		; Note: This is a direct copy of SpeedToPos, targeting a1 instead of a0.
		move.l	obX(a1),d2				; get Sonic's X-axis position
		move.l	obY(a1),d3				; get Sonic's Y-axis position
		move.w	obVelX(a1),d0				; load Sonic's horizontal speed
		ext.l	d0					; extend speed to longword
		asl.l	#8,d0					; shift speed up a byte (16.16 fixed point)
		add.l	d0,d2					; add speed to X-axis position
		move.w	obVelY(a1),d0				; load Sonic's vertical speed
		ext.l	d0					; extend speed to longword
		asl.l	#8,d0					; shift speed up a byte (16.16 fixed point)
		add.l	d0,d3					; add speed to Y-axis position
		move.l	d2,obX(a1)				; update Sonic's X-axis position
		move.l	d3,obY(a1)				; update Sonic's Y-axis position
		rts						; return
; ---------------------------------------------------------------------------

	.exitTeleporter:
		andi.w	#$7FF,obY(a1)				; wrap Sonic vertically (SBZ2 is a Y-wrapping level)
		clr.b	obRoutine(a0)				; reset teleporter back to Tele_Main
		clr.b	(f_playerctrl).w			; clear Sonic control override flags
		move.w	#0,obVelX(a1)				; stop Sonic horizontally
		move.w	#$200,obVelY(a1)			; move Sonic down a bit to quickly land on floor again
		rts						; return


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to set Sonic's speed & direction in a teleport pipe,
; called at start and whenever a bend is hit.
; ---------------------------------------------------------------------------

; sub_1681C: Tele_Move:
Tele_NextDirection:
		moveq	#0,d0					; clear d0 for X-difference
		move.w	#$1000,d2				; move Sonic horizontally at speed $1000 to the right
		move.w	tele_targetX(a0),d0			; get next teleport X-target
		sub.w	obX(a1),d0				; calculate difference to Sonic's current X-position
		bge.s	.getYDirection				; is Sonic's next target to the right or directly above? if yes, branch
		neg.w	d0					; negate X-difference
		neg.w	d2					; negate X-speed to move to the left instead

	.getYDirection:
		moveq	#0,d1					; clear d1 for Y-difference
		move.w	#$1000,d3				; move Sonic vertically at speed $1000 downwards
		move.w	tele_targetY(a0),d1			; get next teleport Y-target
		sub.w	obY(a1),d1				; calculate difference to Sonic's current Y-position
		bge.s	.checkHorizOrVert			; is Sonic's next target below or leveled? if yes, branch
		neg.w	d1					; negate Y-difference
		neg.w	d3					; negate Y-speed to move upwards instead

	.checkHorizOrVert:
		cmp.w	d0,d1					; is X-distance greater than Y-distance?
		bcs.s	Tele_NextDirection_X				; if yes, branch

; Tele_NextDirection_Y:
		moveq	#0,d1					; clear d1 again
		move.w	tele_targetY(a0),d1			; get next teleport Y-target
		sub.w	obY(a1),d1				; calculate difference to Sonic's current Y-position
		swap	d1					; move into upper word
		divs.w	d3,d1					; divide by $1000 or -$1000

		moveq	#0,d0					; clear d0 again
		move.w	tele_targetX(a0),d0			; get next teleport X-target 
		sub.w	obX(a1),d0				; calculate difference to Sonic's current X-position
		beq.s	.setSpeeds				; if next X-target is the same as Sonic's current X-position, branch
		swap	d0					; move into upper word
		divs.w	d1,d0					; divide by earlier division result

	.setSpeeds:
		move.w	d0,obVelX(a1)				; set new X-speed
		move.w	d3,obVelY(a1)				; set new Y-speed

		tst.w	d1					; is next tele_time already positive?
		bpl.s	.setTravelTime				; if yes, branch
		neg.w	d1					; make it positive otherwise
	.setTravelTime:
		move.w	d1,tele_time(a0)			; set travel time until next target
		rts						; return
; ===========================================================================

Tele_NextDirection_X:
		moveq	#0,d0					; clear d1 again
		move.w	tele_targetX(a0),d0			; get next teleport X-target
		sub.w	obX(a1),d0				; calculate difference to Sonic's current X-position
		swap	d0					; move into upper word
		divs.w	d2,d0					; divide by $1000 or -$1000

		moveq	#0,d1					; clear d1 again
		move.w	tele_targetY(a0),d1			; get next teleport Y-target
		sub.w	obY(a1),d1				; calculate difference to Sonic's current Y-position
		beq.s	.y_match				; if next Y-target is the same as Sonic's current Y-position, branch
		swap	d1					; move into upper word
		divs.w	d0,d1					; divide by earlier division result

	.y_match:
		move.w	d1,obVelY(a1)				; set new Y-speed
		move.w	d2,obVelX(a1)				; set new X-speed

		tst.w	d0					; is next tele_time already positive?
		bpl.s	.setTravelTime				; if yes, branch
		neg.w	d0					; make it positive otherwise
	.setTravelTime:
		move.w	d0,tele_time(a0)			; set travel time until next target
		rts						; return
; End of function Tele_NextDirection


; ===========================================================================
; Teleporter target data for each tube in a tube network, per subtype.
; Format:
; 	dc.w number of entries (times 4)
; 	dc.w target X-position, target Y-position
;	dc.w ...

Tele_Data:	dc.w .type00-Tele_Data
		dc.w .type01-Tele_Data
		dc.w .type02-Tele_Data
		dc.w .type03-Tele_Data
		dc.w .type04-Tele_Data
		dc.w .type05-Tele_Data
		dc.w .type06-Tele_Data
		dc.w .type07-Tele_Data

.type00:	dc.w 1*4
		dc.w $794, $98C

.type01:	dc.w 1*4
		dc.w $94, $38C

.type02:	dc.w 7*4
		dc.w $794, $2E8
		dc.w $7A4, $2C0
		dc.w $7D0, $2AC
		dc.w $858, $2AC
		dc.w $884, $298
		dc.w $894, $270
		dc.w $894, $190

.type03:	dc.w 1*4
		dc.w $894, $690

.type04:	dc.w 7*4
		dc.w $1194, $470
		dc.w $1184, $498
		dc.w $1158, $4AC
		dc.w $FD0, $4AC
		dc.w $FA4, $4C0
		dc.w $F94, $4E8
		dc.w $F94, $590

.type05:	dc.w 1*4
		dc.w $1294, $490

.type06:	dc.w 7*4
		dc.w $1594, $FFE8
		dc.w $1584, $FFC0
		dc.w $1560, $FFAC
		dc.w $14D0, $FFAC
		dc.w $14A4, $FF98
		dc.w $1494, $FF70
		dc.w $1494, $FD90

.type07:	dc.w 1*4
		dc.w $894, $90
