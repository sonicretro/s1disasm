; ===========================================================================
; ---------------------------------------------------------------------------
; Object 5D - fans (SLZ)
; ---------------------------------------------------------------------------

Fan:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Fan_Index(pc,d0.w),d1
		jmp	Fan_Index(pc,d1.w)
; ===========================================================================
Fan_Index:	dc.w Fan_Main-Fan_Index
		dc.w Fan_Action-Fan_Index

fan_time:	equ objoff_30		; time between switching on/off
fan_switch:	equ objoff_32		; on/off switch
; ===========================================================================

Fan_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Fan_Action
		move.l	#Map_Fan,obMap(a0)			; set mappings
		move.w	#ArtTile_SLZ_Fan|Tile_Pal3,obGfx(a0)	; set art tile and palette line
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#32/2,obActWid(a0)			; set sprite display width
		move.b	#4,obPriority(a0)			; set sprite priority
; ---------------------------------------------------------------------------

Fan_Action:	; Routine 2
		btst	#1,obSubtype(a0)			; is object type 02/03 (always on)?
		bne.s	.blow					; if yes, branch
		subq.w	#1,fan_time(a0)				; subtract 1 from time delay
		bpl.s	.blow					; if time remains, branch
		move.w	#2*60,fan_time(a0)			; set delay to 2 seconds
		bchg	#0,fan_switch(a0)			; switch fan on/off
		beq.s	.blow					; if fan is off, branch
		move.w	#3*60,fan_time(a0)			; set delay to 3 seconds

.blow:
		tst.b	fan_switch(a0)				; is fan switched on?
		bne.w	.chkdel					; if not, branch
	if FixBugs
		; Fix fans affecting debug mode
		tst.w	(v_debuguse).w				; is debug mode active?
		bne.s	.animate				; if yes, branch
	endif

		lea	(v_player).w,a1				; load Sonic object
		move.w	obX(a1),d0				; get Sonic's X-position
		sub.w	obX(a0),d0				; calculate difference to fan's X-position
		btst	#0,obStatus(a0)				; is fan facing right?
		bne.s	.chksonic				; if yes, branch
		neg.w	d0					; negate difference for check
	.chksonic:
		addi.w	#$50,d0					; add $50 pixels for faraway check
		cmpi.w	#$A0+$50,d0				; is Sonic horizontally within $A0 pixels of the fan?
		bhs.s	.animate				; if not, branch

		move.w	obY(a1),d1				; get Sonic's Y-position
		addi.w	#$60,d1					; push vertical trigger range up by $60 pixels
		sub.w	obY(a0),d1				; calculate different to fan's Y-position
		blo.s	.animate				; branch if Sonic is above vertical trigger range
		cmpi.w	#$10+$60,d1				; is Sonic vertically within $10 pixels of the fan (below)?
		bhs.s	.animate				; branch if Sonic is below vertical trigger range

		; Sonic is in range of the fan
		subi.w	#$50,d0					; is Sonic within $50 pixels of fan's X-position?
		bhs.s	.faraway				; if not, branch
		not.w	d0					; make push force positive again
		add.w	d0,d0					; double push force below $50 pixels distance
	.faraway:
		addi.w	#$60,d0					; add base push force
		btst	#0,obStatus(a0)				; is fan facing right?
		bne.s	.right					; if yes, branch
		neg.w	d0					; negate push direction
	.right:
		neg.b	d0					; negate subpixel portion of push force (closer to fan = higher force)
		asr.w	#4,d0					; divide push force by $10
		btst	#0,obSubtype(a0)			; is fan facing right?
		beq.s	.movesonic				; if not, branch
		neg.w	d0					; negate push direction
	.movesonic:
		add.w	d0,obX(a1)				; add final push force to Sonic's X-position to push him away from the fan
; ---------------------------------------------------------------------------

.animate:
		subq.b	#1,obTimeFrame(a0)			; decrement delay until next frame
		bpl.s	.chkdel					; if time remains, branch
		move.b	#0,obTimeFrame(a0)			; reset delay to 1 frame
		addq.b	#1,obAniFrame(a0)			; advance to next frame
		cmpi.b	#3,obAniFrame(a0)			; has fourth frame been reached?
		blo.s	.noreset				; if not, branch
		move.b	#0,obAniFrame(a0)			; reset after 4 frames
	.noreset:
		moveq	#0,d0					; set base frame offset to 0
		btst	#0,obSubtype(a0)			; is this the cheeky backwards-blowing fan?
		beq.s	.noflip					; if not, branch
		moveq	#2,d0					; set base frame offset to 2 so fan spins backwards
	.noflip:
		add.b	obAniFrame(a0),d0			; add current frame offset to make fan spin
		move.b	d0,obFrame(a0)				; set new frame
; ---------------------------------------------------------------------------

.chkdel:
	if FixBugs
		; Objects shouldn't call DisplaySprite and DeleteObject in
		; the same frame or else cause a null-pointer dereference.
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif
; ===========================================================================

Map_Fan:	include	"_maps/Fan.asm"
