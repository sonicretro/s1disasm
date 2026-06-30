; ===========================================================================
; ---------------------------------------------------------------------------
; Object 6A - pizza cutters and speeding saws (SBZ)
; ---------------------------------------------------------------------------

Saws:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Saw_Index(pc,d0.w),d1
		jmp	Saw_Index(pc,d1.w)
; ===========================================================================
Saw_Index:	dc.w Saw_Main-Saw_Index
		dc.w Saw_Action-Saw_Index

saw_origX:	equ objoff_3A		; original x-axis position
saw_origY:	equ objoff_38		; original y-axis position
saw_shot:	equ objoff_3D		; flag set when the speeding saw appears
; ===========================================================================

Saw_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Saw_Action
		move.l	#Map_Saw,obMap(a0)			; set mappings
		move.w	#ArtTile_SBZ_Saw|Tile_Pal3,obGfx(a0)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.b	#64/2,obActWid(a0)			; set sprite display width
		move.w	obX(a0),saw_origX(a0)			; remember initial X-position
		move.w	obY(a0),saw_origY(a0)			; remember initial Y-position

		cmpi.b	#3,obSubtype(a0)			; is object a pizza cutter? (subtype 0-2)
		bhs.s	Saw_Action				; if not, branch (speeding saw, subtype 3-4)
		move.b	#col_48x48_alt|col_hurt,obColType(a0)	; make pizza cutter harmful on touch
; ---------------------------------------------------------------------------

Saw_Action:	; Routine 2
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get saw subtype (0-4)
		andi.w	#7,d0					; limit to sane values
		add.w	d0,d0					; double for word-based indexing
		move.w	Saw_Types(pc,d0.w),d1			; find behavior type for current saw
		jsr	Saw_Types(pc,d1.w)			; execute behavior, then return ehre

		out_of_range.s	Saw_Delete,saw_origX(a0)	; has saw gone out of range? if yes, branch
		jmp	(DisplaySprite).l			; display saw sprite
; ---------------------------------------------------------------------------

Saw_Delete:
		jmp	(DeleteObject).l			; delete saw

; ===========================================================================
Saw_Types:
		dc.w Saw_Type0_PizzaStationary-Saw_Types	; 0 - pizza cutter (stationary)
		dc.w Saw_Type1_PizzaLeftRight-Saw_Types		; 1 - pizza cutter (moves left and right)
		dc.w Saw_Type2_PizzaUpDown-Saw_Types		; 2 - pizza cutter (moves up and down)
		dc.w Saw_Type3_SpeedingFromLeft-Saw_Types	; 3 - speeding saw (shot from the left)
		dc.w Saw_Type4_SpeedingFromRight-Saw_Types	; 4 - speeding saw (shot from the right)
; ===========================================================================

Saw_Type0_PizzaStationary:
		rts						; doesn't move at all
; ===========================================================================

Saw_Type1_PizzaLeftRight:
		move.w	#$60,d1					; adjustment offset for X-flipped saws (oscillation range * 2)
		moveq	#0,d0					; clear d0
		move.b	(v_oscillate+$E).w,d0			; get oscillatory value (frequency 2, middle value $30)
		btst	#0,obStatus(a0)				; is saw X-flipped?
		beq.s	.setX					; if not, branch
		neg.w	d0					; reverse oscillated offset direction
		add.w	d1,d0					; keep flipped saws in the same $60px range
	.setX:
		move.w	saw_origX(a0),d1			; get initial X-position of saw
		sub.w	d0,d1					; adjust by oscillated offset
		move.w	d1,obX(a0)				; move saw horizontally

	.animate:
		subq.b	#1,obTimeFrame(a0)			; decrement timer until frame change
		bpl.s	.sound					; if time remains, branch
		move.b	#3-1,obTimeFrame(a0)			; reset time between frame changes
		bchg	#0,obFrame(a0)				; alternate saw frames

	.sound:
		tst.b	obRender(a0)				; is saw on screen?
		bpl.s	.return					; if not, don't play sound
		move.w	(v_framecount).w,d0			; get current level frame counter
		andi.w	#$F,d0					; only play sound every 16 frames
		bne.s	.return					; branch otherwise
		move.w	#sfx_Saw,d0				; play saw buzzing sound
		jsr	(QueueSound2).l				; (this sound is programmed to not be interruptible by itself)

	.return:
		rts						; return
; ===========================================================================

Saw_Type2_PizzaUpDown:
		move.w	#$30,d1					; (unused, probably a leftover from copying subtype 1)
		moveq	#0,d0					; clear d0
		move.b	(v_oscillate+6).w,d0			; get oscillatory value (frequency 2, middle value $18)
		btst	#0,obStatus(a0)				; is saw X-flipped?
		beq.s	.setY					; if not, branch
		neg.w	d0					; reverse oscillated offset direction
		addi.w	#$60+$20,d0				; keep flipped saws in the same $60px range... plus an extra $20px
	.setY:
		move.w	saw_origY(a0),d1			; get initial Y-position of saw
		sub.w	d0,d1					; adjust by oscillated offset
		move.w	d1,obY(a0)				; move saw vertically

	.animate:
		subq.b	#1,obTimeFrame(a0)			; decrement timer until frame change
		bpl.s	.sound					; if time remains, branch
		move.b	#3-1,obTimeFrame(a0)			; reset time between frame changes
		bchg	#0,obFrame(a0)				; alternate saw frames

	.sound:
		tst.b	obRender(a0)				; is saw on screen?
		bpl.s	.return					; if not, don't play sound
		move.b	(v_oscillate+6).w,d0			; get current oscillation value for saw type
		cmpi.b	#$18,d0					; is oscillation value at middle?
		bne.s	.return					; if not, branch
		move.w	#sfx_Saw,d0				; play saw buzzing sound
		jsr	(QueueSound2).l				; (this sound is programmed to not be interruptible by itself)

	.return:
		rts						; return
; ===========================================================================

Saw_Type3_SpeedingFromLeft:
		tst.b	saw_shot(a0)				; has speeding saw already been shot?
		bne.s	Saw_Type3_SpeedingFromLeft_Shot		; if yes, branch

		move.w	(v_player+obX).w,d0			; get Sonic's current X-position
		subi.w	#192,d0					; spawn saw if Sonic is 192px to the right of it
		bcs.s	.hide					; if Sonic is close to left level edge, branch
		sub.w	obX(a0),d0				; subtract saw's X-position
		bcs.s	.hide					; if Sonic isn't in horizontal range, branch
		move.w	(v_player+obY).w,d0			; get Sonic's current Y-position
		subi.w	#128,d0					; check 128px above
		cmp.w	obY(a0),d0				; is Sonic within upper trigger zone?
		bhs.s	.return					; if not, branch
		addi.w	#128*2,d0				; check 128px below
		cmp.w	obY(a0),d0				; is Sonic within lower trigger zone?
		blo.s	.return					; if not, branch

		move.b	#1,saw_shot(a0)				; set flag to shoot speeding saw
		move.w	#$600,obVelX(a0)			; move speeding saw to the right (fast)
		move.b	#col_48x48_alt|col_hurt,obColType(a0)	; make saw harmful on touch
		move.b	#2,obFrame(a0)				; use speeding saw frames
		move.w	#sfx_Saw,d0				; set saw buzzing sound
		jsr	(QueueSound2).l				; play it

	.hide:
		addq.l	#4,sp					; skip returning to Saw_Action to avoid rendering sprite
	if FixBugs
		; The above line will properly avoid drawing the sprite, but it will
		; also prevent despawning the object, which can lead to memory leaks.
		out_of_range.w	Saw_Delete,saw_origX(a0)	; has saw gone out of range? if yes, delete it
	endif

	.return:
		rts						; return
; ---------------------------------------------------------------------------

Saw_Type3_SpeedingFromLeft_Shot:
		jsr	(SpeedToPos).l				; update speeding saw's position
		move.w	obX(a0),saw_origX(a0)			; update original X-position for offscreen check

		subq.b	#1,obTimeFrame(a0)			; decrement timer until frame change
		bpl.s	.return					; if time remains, branch
		move.b	#3-1,obTimeFrame(a0)			; reset time between frame changes
		bchg	#0,obFrame(a0)				; alternate saw frames

	.return:
		rts						; return
; ===========================================================================

Saw_Type4_SpeedingFromRight:
		tst.b	saw_shot(a0)				; has speeding saw already been shot?
		bne.s	Saw_Type4_SpeedingFromRight_Shot	; if yes, branch

		move.w	(v_player+obX).w,d0			; get Sonic's current X-position
		addi.w	#224,d0					; spawn saw if Sonic is 224px to the left of it
		sub.w	obX(a0),d0				; subtract saw's X-position
		bcc.s	.hide					; if Sonic isn't in horizontal range, branch
		move.w	(v_player+obY).w,d0			; get Sonic's current Y-position
		subi.w	#128,d0					; check 128px above
		cmp.w	obY(a0),d0				; is Sonic within upper trigger zone?
		bhs.s	.return					; if not, branch
		addi.w	#128*2,d0				; check 128px below
		cmp.w	obY(a0),d0				; is Sonic within lower trigger zone?
		blo.s	.return					; if not, branch

		move.b	#1,saw_shot(a0)				; set flag to shoot speeding saw
		move.w	#-$600,obVelX(a0)			; move speeding saw to the left (fast)
		move.b	#col_48x48_alt|col_hurt,obColType(a0)	; make saw harmful on touch
		move.b	#2,obFrame(a0)				; use speeding saw frames
		move.w	#sfx_Saw,d0				; set saw buzzing sound
		jsr	(QueueSound2).l				; play it

	.hide:
		addq.l	#4,sp					; skip returning to Saw_Action to avoid rendering sprite
	if FixBugs
		; See above.
		out_of_range.w	Saw_Delete,saw_origX(a0)	; has saw gone out of range? if yes, delete it
	endif

	.return:
		rts						; return
; ---------------------------------------------------------------------------

Saw_Type4_SpeedingFromRight_Shot:
		jsr	(SpeedToPos).l				; update speeding saw's position
		move.w	obX(a0),saw_origX(a0)			; update original X-position for offscreen check

		subq.b	#1,obTimeFrame(a0)			; decrement timer until frame change
		bpl.s	.return					; if time remains, branch
		move.b	#3-1,obTimeFrame(a0)			; reset time between frame changes
		bchg	#0,obFrame(a0)				; alternate saw frames

	.return:
		rts						; return

; ===========================================================================

Map_Saw:	include	"_maps/Saws and Pizza Cutters.asm"
