; ===========================================================================
; ---------------------------------------------------------------------------
; Object 45 - unused sideways spiked metal stomper from beta version (MZ)
; ---------------------------------------------------------------------------

SideStomp:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	SStom_Index(pc,d0.w),d1
		jmp	SStom_Index(pc,d1.w)
; ===========================================================================
SStom_Index:	dc.w SStom_Main-SStom_Index		; 0
		dc.w SStom_MainBlock-SStom_Index	; 2
		dc.w SStom_Spikes-SStom_Index		; 4
		dc.w SStom_WallBracket-SStom_Index	; 6
		dc.w SStom_Pole-SStom_Index		; 8

sstom_origX:	equ objoff_30	; initial X-position per child object
sstom_currentX:	equ objoff_32	; current relative X-offset for stomping (8.8 fixed)
sstom_length:	equ objoff_34	; stomper length sset from SStom_Len
sstom_retract:	equ objoff_36	; flag set if stomper is currently slowly retracting
sstom_delay:	equ objoff_38	; delay after stomper has fully extended before retracting
sstom_origX_2:	equ objoff_3A	; initial X-position for parent
sstom_parent:	equ objoff_3C	; parent stomper object (main block)

; ===========================================================================
SStom_Var:	;	routine	 x-pos	frame
		dc.b	2,  	 4,	0	; main block
		dc.b	4,	-$1C,	1	; spikes
		dc.b	8,	 $34,	3	; pole
		dc.b	6,	 $28,	2	; wall bracket
		
SStom_Len:	; Consider reducing the "long" size to $9000, along with the fixing the mappings
		; to fix the pole being too short. The full length is too large.
		dc.w $3800	; subtype 00 - short length
		dc.w $A000	; subtype 01 - long length
		dc.w $5000	; subtype 02 - medium length
; ===========================================================================

SStom_Main:	; Routine 0
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get subtype (0-2)
		add.w	d0,d0					; double for word-based indexing
		move.w	SStom_Len(pc,d0.w),d2			; get stomper length for subtype

		lea	(SStom_Var).l,a2			; get child objects setup values array
		movea.l	a0,a1					; write first block into current RAM location
		moveq	#4-1,d1					; load four objects
		bra.s	.makeStomper				; first object doesn't need a new RAM slot
; ===========================================================================

	.loop:
		bsr.w	FindNextFreeObj				; find a free object slot
		bne.s	.adjustParentSize			; if object RAM is full, branch

	.makeStomper:
		move.b	(a2)+,obRoutine(a1)			; load routine number from SStom_Var
		_move.b	#id_SideStomp,obID(a1)			; load another stomper object
		move.w	obY(a0),obY(a1)				; copy Y-position from parent
		move.b	(a2)+,d0				; load relative X-position from SStom_Var
		ext.w	d0					; extend to word
		add.w	obX(a0),d0				; add base X-position
		move.w	d0,obX(a1)				; set child X-position
		move.l	#Map_SStom,obMap(a1)			; set mappings
		move.w	#ArtTile_MZ_Spike_Stomper,obGfx(a1)	; set art tile
		move.b	#sprite_cam_field,obRender(a1)		; set to playfield-positioned mode
		move.w	obX(a1),sstom_origX(a1)			; remember initial X-position for child
		move.w	obX(a0),sstom_origX_2(a1)		; remember initial X-position from parent
		move.b	obSubtype(a0),obSubtype(a1)		; copy subtype from parent
		move.b	#64/2,obActWid(a1)			; set sprite display width
		move.w	d2,sstom_length(a1)			; set stomper length
		move.b	#4,obPriority(a1)			; set sprite priority

		cmpi.b	#1,(a2)					; is this child object the spikes? (frame ID 1)
		bne.s	.notspikes				; if not, branch
		move.b	#col_32x48|col_hurt,obColType(a1)	; use harmful collision type

	.notspikes:
		move.b	(a2)+,obFrame(a1)			; set frame ID for child
		move.l	a0,sstom_parent(a1)			; remember parent address
		dbf	d1,.loop				; repeat 3 times

		move.b	#3,obPriority(a1)			; make wall bracket a higher priority

	.adjustParentSize:
		move.b	#32/2,obActWid(a0)			; use a smaller sprite display width for main block
; ---------------------------------------------------------------------------

; SStom_Solid:
SStom_MainBlock: ; Routine 2
		move.w	obX(a0),-(sp)				; backup X-position before calling SStom_Move
		bsr.w	SStom_Move

		move.w	#24/2+sonic_solid_width,d1		; collision width
		move.w	#64/2,d2				; collision height (initial)
		move.w	#64/2,d3				; collision height (stood-on)
		move.w	(sp)+,d4				; restore previous X-position as SolidObject input
		bsr.w	SolidObject				; make the main block of the stomper solid

	if FixBugs=0
		; This has been moved to prevent a display-after-free bug.
		bsr.w	DisplaySprite				; display stomper main block
	endif
		bra.w	SStom_ChkDel				; delete object if it went out of range
; ===========================================================================

SStom_Pole:	; Routine 8
		movea.l	sstom_parent(a0),a1			; load parent object (main block)
		move.b	sstom_currentX(a1),d0			; get upper byte of current stomper extension range
		addi.b	#$10,d0					; update pole frame in the middle of $20px
		lsr.b	#5,d0					; use a new frame every $20px
		addq.b	#3,d0					; pole frames start at frame ID 3
		move.b	d0,obFrame(a0)				; set pole frame depending on expansion range
		; continue to SStom_Spikes to align pole X-position...
; ---------------------------------------------------------------------------

SStom_Spikes:	; Routine 4
		movea.l	sstom_parent(a0),a1			; load parent object (main block)
		moveq	#0,d0					; clear d0
		move.b	sstom_currentX(a1),d0			; get upper byte of current stomper extension range
		neg.w	d0					; stomper moves to the left
		add.w	sstom_origX(a0),d0			; add initial X-position
		move.w	d0,obX(a0)				; update X-position
; ---------------------------------------------------------------------------

; SStom_Display:
SStom_WallBracket: ; Routine 6
	if FixBugs=0
		bsr.w	DisplaySprite				; just display wall bracket
	endif
; ---------------------------------------------------------------------------

SStom_ChkDel:
		out_of_range.w	DeleteObject,sstom_origX_2(a0)	; has object gone out of range? if yes, delete it
	if FixBugs
		; This has been moved to prevent a display-after-free bug.
		bra.w	DisplaySprite				; display object
	else
		rts						; return
	endif

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to move the sideways metal stomper.
; 
; Seeing how expansive the setup is despite only ever using the same
; behavior type, it's likely that more sideways stomper variations
; were planned per subtype before the object was ultimately scrapped.
; ---------------------------------------------------------------------------

SStom_Move:
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get subtype (0-2)
		add.w	d0,d0					; double for word-based indexing
		move.w	SStom_Move_Index(pc,d0.w),d1		; find index in jump table (they're all the same...)
		jmp	SStom_Move_Index(pc,d1.w)		; jump there to move stomper

; ===========================================================================
SStom_Move_Index:
		dc.w SStom_MoveStomper-SStom_Move_Index		; 0 - short
		dc.w SStom_MoveStomper-SStom_Move_Index		; 1 - long
	if FixBugs
		; An entry for subtype 02 is missing, despite being defined in SStom_Len.
		dc.w SStom_MoveStomper-SStom_Move_Index		; 2 - medium
	endif
; ===========================================================================

SStom_MoveStomper:
		tst.w	sstom_retract(a0)			; is stomper set to retract?
		beq.s	.stomp					; if not, branch

		tst.w	sstom_delay(a0)				; is delay before retracting expired?
		beq.s	.retract				; if yes, branch to retract stomper
		subq.w	#1,sstom_delay(a0)			; decrement retraction delay
		bra.s	.setXPosition				; update stomper X-position
; ---------------------------------------------------------------------------

.retract:
		subi.w	#$80,sstom_currentX(a0)			; slowly retract stomper
		bcc.s	.setXPosition				; has stomper fully retracted? if not, branch

		move.w	#0,sstom_currentX(a0)			; fix stomper extension range to 0
		move.w	#0,obVelX(a0)				; stop stomper moving
		move.w	#0,sstom_retract(a0)			; clear retraction flag to stomp again
		bra.s	.setXPosition				; update stomper X-position
; ---------------------------------------------------------------------------

.stomp:
		move.w	sstom_length(a0),d1			; get target extension length for stomper
		cmp.w	sstom_currentX(a0),d1			; has stomper reached target extension length?
		beq.s	.setXPosition				; if yes, branch

		move.w	obVelX(a0),d0				; get current stomp speed
		addi.w	#$70,obVelX(a0)				; speed up stomper stomping
		add.w	d0,sstom_currentX(a0)			; add speed to current extension length (8.8 fixed)

		cmp.w	sstom_currentX(a0),d1			; has stomper reached target position?
		bhi.s	.setXPosition				; if not, branch
		move.w	d1,sstom_currentX(a0)			; fix stomper to target extension range
		move.w	#0,obVelX(a0)				; stop stomper
		move.w	#1,sstom_retract(a0)			; set retraction flag
		move.w	#60,sstom_delay(a0)			; wait 1 second before retracting
; ---------------------------------------------------------------------------

	.setXPosition:
		moveq	#0,d0					; clear d0
		move.b	sstom_currentX(a0),d0			; get upper byte of current extension range
		neg.w	d0					; extend stomper to the left
		add.w	sstom_origX(a0),d0			; add initial X-position
		move.w	d0,obX(a0)				; set updated X-position
		rts						; return
; End of function SStom_Move
