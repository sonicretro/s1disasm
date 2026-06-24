; ===========================================================================
; ---------------------------------------------------------------------------
; Object 34 - Zone Title Cards
; 
; Note that this file is just for the object logic itself.
; For the text mappings, refer to: _maps/Title Cards.asm
; ---------------------------------------------------------------------------

TitleCard:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Card_Index(pc,d0.w),d1
		jmp	Card_Index(pc,d1.w)
; ===========================================================================
Card_Index:	dc.w Card_LoadForZone-Card_Index
		dc.w Card_MoveIn-Card_Index
		dc.w Card_Wait-Card_Index
		dc.w Card_Wait-Card_Index

card_mainX:	equ	objoff_30	; target X-position for card while moving in
card_finalX:	equ	objoff_32	; target X-position for card while moving out
; ===========================================================================

; Card_CheckSBZ3:
Card_LoadForZone:	; Routine 0
		movea.l	a0,a1					; set this root object to become the level name card

		moveq	#0,d0					; clear d0 (zone is a byte, we need words)
		move.b	(v_zone).w,d0				; get current zone ID and use it as index for mappings and config data
		cmpi.w	#id_LZ_act4,(v_zone_act).w		; check if level is SBZ3 (LZ4)
		bne.s	.notLZ4					; if not, branch
		moveq	#5,d0					; use title card number 5 instead (SBZ)
	; Card_CheckFZ:
	.notLZ4:
		move.w	d0,d2					; d2 = frame ID to use
		cmpi.w	#id_FZ,(v_zone_act).w			; check if level is FZ
		bne.s	.notFZ					; if it isn't, branch
		moveq	#6,d0					; use FZ entry in Card_ConData (entry 6)
		moveq	#$B,d2					; use "FINAL" sprite mappings (frame ID $B)
	; Card_LoadConfig:
	.notFZ:
		lea	(Card_ConData).l,a3			; load card configuration data
		lsl.w	#4,d0					; multiply by $10 (number of bytes per zone entry)
		adda.w	d0,a3					; set pointer to configuration data for current zone
		lea	(Card_ItemData).l,a2			; load card item data
		moveq	#4-1,d1					; set to affect all four title card objects

Card_Loop:
		_move.b	#id_TitleCard,obID(a1)			; load another title card object
		move.w	(a3),obX(a1)				; load start x-position
		move.w	(a3)+,card_finalX(a1)			; load finish x-position (same as start)
		move.w	(a3)+,card_mainX(a1)			; load main target x-position
		move.w	(a2)+,obScreenY(a1)			; load fixed y-position
		move.b	(a2)+,obRoutine(a1)			; set initial routine number
		move.b	(a2)+,d0				; get frame ID
		bne.s	.frameIdSet				; if frame ID is non-zero, branch (i.e. not the level name)
		move.b	d2,d0					; for level name, use frame ID as set in d2 above
	; Card_ActNumber:
	.frameIdSet:
		cmpi.b	#7,d0					; is this the act number object?
		bne.s	.setupCardObject			; if not, branch
		add.b	(v_act).w,d0				; use appropriate act number frame ID for current act
		cmpi.b	#act4,(v_act).w				; check if on act 4 (for SBZ3/LZ4)
		bne.s	.setupCardObject			; if not, branch
		subq.b	#1,d0					; keep using "3" art for act number
	; Card_MakeSprite:
	.setupCardObject:
		move.b	d0,obFrame(a1)				; display frame number set in d0
		move.l	#Map_Card,obMap(a1)			; set mappings pointer
		move.w	#ArtTile_Title_Card|Tile_Prio,obGfx(a1)	; set art tile and sprite priority flag
		move.b	#240/2,obActWid(a1)			; set display width (redundant for screen-positioned sprites)
		move.b	#sprite_cam_screen,obRender(a1)		; set to screen-positioned sprite mode
		move.b	#0,obPriority(a1)			; set to highest sprite priority
		move.w	#1*60,obTimeFrame(a1)			; set time delay before moving out again to 1 second

		lea	object_size(a1),a1			; advance to next card object (all elements are back-to-back in RAM)
		dbf	d1,Card_Loop				; repeat sequence another 3 times
; ---------------------------------------------------------------------------

; Card_ChkPos:
Card_MoveIn:	; Routine 2
		moveq	#$10,d1					; set horizontal move-in speed
		move.w	card_mainX(a0),d0			; get target moving in X-position
		cmp.w	obX(a0),d0				; has item reached its target position?
		beq.s	.checkOffScreen				; if yes, branch
		bge.s	.updateXPos				; is item moving in from the left? if yes, branch
		neg.w	d1					; negate move-in direction if coming from the right
	; Card_Move:
	.updateXPos:
		add.w	d1,obX(a0)				; change card's x-position

	; Card_NoMove:
	.checkOffScreen:
		move.w	obX(a0),d0				; get current x-position of card
		bmi.s	.return					; if it's negative, don't display card
		cmpi.w	#$80+320+64,d0				; has card moved beyond $200 on x-axis (to the right)?
	if FixBugs
		; This stops the title cards from briefly appearing on the
		; opposite side of the screen if they happen to be long,
		; such as with Spring Yard. Taken from Knuckles in Sonic 2.
		bgt.s	.return					; if yes, branch
		cmpi.w	#$80-64+16,d0				; has card moved beyond $50 on the x-axis (to the left)?
		bgt.w	DisplaySprite				; if not, display card
	else
		bhs.s	.return					; if yes, branch
		bra.w	DisplaySprite				; display card
	endif

	; locret_C3D8:
	.return:
		rts						; don't display card
; ===========================================================================

Card_Wait:	; Routine 4/6
		tst.w	obTimeFrame(a0)				; is time remaining zero?
		beq.s	Card_MoveOut				; if yes, move out card
		subq.w	#1,obTimeFrame(a0)			; subtract 1 from time
		bra.w	DisplaySprite				; display card
; ===========================================================================

; Card_ChkPos2:
Card_MoveOut:
		tst.b	obRender(a0)				; is card off screen?
		bpl.s	Card_ChangeArt				; if yes, branch

		moveq	#2*$10,d1				; set horizontal move-out speed (twice as fast as moving in)
		move.w	card_finalX(a0),d0			; get target moving-out X-position
		cmp.w	obX(a0),d0				; has card reached the finish position?
		beq.s	Card_ChangeArt				; if yes, branch
		bge.s	.updateXPos				; is item moving out to the right? if yes, branch
		neg.w	d1					; negate move-out direction if exiting to the left
	; Card_Move2:
	.updateXPos:
		add.w	d1,obX(a0)				; change card's x-position

	; .checkOffScreen:
		move.w	obX(a0),d0				; get current x-position of card
		bmi.s	.return					; if it's negative, don't display
		cmpi.w	#$80+320+64,d0				; has card moved beyond $200 on x-axis (to the right)?
	if FixBugs
		; See above.
		bgt.s	.return					; if yes, branch
		cmpi.w	#$80-64+16,d0				; has card moved beyond $50 on the x-axis (to the left)?
		bgt.w	DisplaySprite				; if not, display card
	else
		bhs.s	.return					; if yes, branch
		bra.w	DisplaySprite				; display card
	endif

	; locret_C412:
	.return:
		rts						; don't display card
; ===========================================================================

Card_ChangeArt:
		; The title cards take up too much VRAM space to fit in with everything else,
		; so space for the explosion and animals graphics is used up by them. Once
		; the cards have moved out, this is where these graphics get loaded again.
		cmpi.b	#4,obRoutine(a0)			; is this the level name title card object?
		bne.s	Card_Delete				; if not, branch (art should only get loaded once)

		moveq	#plcid_Explode,d0			; load explosion patterns
		jsr	(AddPLC).l				; add to pattern load cues
		moveq	#0,d0					; clear d0 (zone is a byte, we need words)
		move.b	(v_zone).w,d0				; get current zone ID
		addi.w	#plcid_GHZAnimals,d0			; add base animal PLC ID (entries are arranged in order)
		jsr	(AddPLC).l				; load animal patterns for current zone

	Card_Delete:
		bra.w	DeleteObject				; delete title card object
; ===========================================================================


; ===========================================================================
; ---------------------------------------------------------------------------
; Title card element setup data. Format:
; - Y-position
; - base routine number
; - frame ID
; ---------------------------------------------------------------------------
Card_ItemData:
		; Level Name
		dc.w $D0
		dc.b 2
		dc.b 0	; dynamic frame ID (see Card_Loop)

		; ZONE
		dc.w $E4
		dc.b 2
		dc.b 6

		; ACT
		dc.w $EA
		dc.b 2
		dc.b 7

		; Oval
		dc.w $E0
		dc.b 2
		dc.b $A

; ---------------------------------------------------------------------------
; Title card start and target X-positioning data. Format:
; - 2 words per item (start X-position, target X-position)
; - 4 items per level (GREEN HILL, ZONE, ACT X, oval)
; For FZ, the start and target position is identical, so it doesn't move.
; ---------------------------------------------------------------------------
Card_ConData:	;    Name       ZONE        ACT        Oval
		dc.w $000,$120, -$104,$13C, $414,$154, $214,$154 ; GHZ
		dc.w $000,$120, -$10C,$134, $40C,$14C, $20C,$14C ; LZ
		dc.w $000,$120, -$120,$120, $3F8,$138, $1F8,$138 ; MZ
		dc.w $000,$120, -$104,$13C, $414,$154, $214,$154 ; SLZ
		dc.w $000,$120, -$0FC,$144, $41C,$15C, $21C,$15C ; SYZ
		dc.w $000,$120, -$0FC,$144, $41C,$15C, $21C,$15C ; SBZ
		zonewarning Card_ConData,$10
		dc.w $000,$120, -$11C,$124, $3EC,$3EC, $1EC,$12C ; FZ
; ===========================================================================

