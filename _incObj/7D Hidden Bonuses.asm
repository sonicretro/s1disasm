; ===========================================================================
; ---------------------------------------------------------------------------
; Object 7D - hidden points at the end of a level
; ---------------------------------------------------------------------------

HiddenBonus:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Bonus_Index(pc,d0.w),d1
		jmp	Bonus_Index(pc,d1.w)
; ===========================================================================
Bonus_Index:	dc.w Bonus_ChkTouch-Bonus_Index
		dc.w Bonus_Display-Bonus_Index

bonus_timelen:	equ objoff_30		; length of time to display bonus sprites
; ===========================================================================

Bonus_ChkTouch:	; Routine 0
		moveq	#$10,d2					; set trigger radius to $10px in all directions
		move.w	d2,d3					; backup
		add.w	d3,d3					; double radius to diameter
		lea	(v_player).w,a1				; load Sonic object

		move.w	obX(a1),d0				; get Sonic's X-position
		sub.w	obX(a0),d0				; calculate difference to points' X-position
		add.w	d2,d0					; add radius for check
		cmp.w	d3,d0					; has Sonic touched the points object on the X-axis?
		bhs.s	Bonus_ChkDel				; if not, branch

		move.w	obY(a1),d1				; get Sonic's Y-position
		sub.w	obY(a0),d1				; calculate difference to points' Y-position
		add.w	d2,d1					; add radius for check
		cmp.w	d3,d1					; has Sonic touched the points object on the Y-axis?
		bhs.s	Bonus_ChkDel				; if not, branch

		tst.w	(v_debuguse).w				; is debug mode currently on?
		bne.s	Bonus_ChkDel				; if yes, don't activate points
		tst.b	(f_bigring).w				; has Sonic jumped into a giant ring?
		bne.s	Bonus_ChkDel				; if yes, don't activate hidden points
; ---------------------------------------------------------------------------

Bonus_Touched:	; Sonic hit the invisible marker
		addq.b	#2,obRoutine(a0)			; advance to Bonus_Display
		move.l	#Map_Bonus,obMap(a0)			; set mappings
		move.w	#ArtTile_Hidden_Points|Tile_Prio,obGfx(a0) ; set art tile and priority flag
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#0,obPriority(a0)			; set to maximum sprite priority
		move.b	#32/2,obActWid(a0)			; set sprite display width

		move.b	obSubtype(a0),obFrame(a0)		; use subtype as frame ID 
		move.w	#120-1,bonus_timelen(a0)		; set display time to 2 seconds
		move.w	#sfx_Bonus,d0				; set bonus ding sound
		jsr	(QueueSound2).l				; play it

		moveq	#0,d0					; clear d0 for word-based addressing
		move.b	obSubtype(a0),d0			; get subtype of object (must not be 0)
		add.w	d0,d0					; double for word-based idnexing
		move.w	Bonus_Points(pc,d0.w),d0		; load bonus points from array
		jsr	(AddPoints).l				; add that value to score
; ---------------------------------------------------------------------------

Bonus_ChkDel:
		out_of_range.s	.delete				; has object gone offscreen? if yes, branch
		rts						; return

	.delete:
		jmp	(DeleteObject).l			; delete object

; ===========================================================================
Bonus_Points:	; Bonus points array
		dc.w 0		; subtype 00 - invalid
		dc.w 1000	; subtype 01 - 10000 points
		dc.w 100	; subtype 02 - 1000 points
	if FixBugs
		dc.w 10		; subtype 03 - 100 points
	else
		; This is the wrong number of points.
		dc.w 1		; subtype 03 - 10 points (should be 100)
	endif
; ===========================================================================

Bonus_Display:	; Routine 2
		subq.w	#1,bonus_timelen(a0)			; decrement display time
		bmi.s	.delete					; if time is zero, delete object
		out_of_range.s	.delete				; has objet gone offscreen? if yes, delete
		jmp	(DisplaySprite).l			; keep displaying object

	.delete:	
		jmp	(DeleteObject).l			; delete object
; ===========================================================================

Map_Bonus:	include	"_maps/Hidden Bonuses.asm"
