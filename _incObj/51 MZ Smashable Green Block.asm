; ===========================================================================
; ---------------------------------------------------------------------------
; Object 51 - smashable green block (MZ)
; ---------------------------------------------------------------------------

SmashBlock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Smab_Index(pc,d0.w),d1
		jsr	Smab_Index(pc,d1.w)
		bra.w	RememberState
; ===========================================================================
Smab_Index:	dc.w Smab_Main-Smab_Index
		dc.w Smab_Solid-Smab_Index
		dc.w Smab_Fragment-Smab_Index

smab_sonani:	equ objoff_32		; backup of Sonic's current animation number
smab_combo:	equ objoff_34		; number of blocks hit + previous stuff
; ===========================================================================

Smab_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Smab_Solid
		move.l	#Map_Smab,obMap(a0)			; set mappings
		move.w	#ArtTile_MZ_Block|Tile_Pal3,obGfx(a0)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#32/2,obActWid(a0)			; set sprite display width
		move.b	#4,obPriority(a0)			; set sprite priority
	if FixBugs=0
		; This is very likely an unused leftover from a copy-paste job from Object 3C (GHZ smashable wall),
		; where this line was used to set the correct frame out of three. However, here it makes no sense,
		; as all it could ever do is use four sprite pieces for the unsmashed block for no reason.
		move.b	obSubtype(a0),obFrame(a0)		; set frame ID from subtype (0 = two sprite pieces // 1 = four sprite pieces, unused)
	endif
; ---------------------------------------------------------------------------

Smab_Solid:	; Routine 2
		move.w	(v_itembonus).w,smab_combo(a0)		; remember combo score chain
		move.b	(v_player+obAnim).w,smab_sonani(a0)	; remember Sonic's animation before calling SolidObject (because it can change it)

		move.w	#32/2+sonic_solid_width,d1
		move.w	#32/2,d2
		move.w	#34/2,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject				; check collision with Sonic and block
		btst	#3,obStatus(a0)				; has Sonic landed on the block?
		bne.s	.smash					; if yes, branch

	.return:
		rts						; return
; ===========================================================================

.smash:
		cmpi.b	#id_Roll,smab_sonani(a0)		; is Sonic in his rolling/jumping animation?
		bne.s	.return					; if not, don't smash block

		move.w	smab_combo(a0),(v_itembonus).w		; restore combo score chain

		bset	#2,obStatus(a1)				; set Sonic's rolling flag
		move.b	#sonic_roll_height,obHeight(a1)		; set Sonic to rolling height
		move.b	#sonic_roll_width,obWidth(a1)		; set Sonic to rolling width
		move.b	#id_Roll,obAnim(a1)			; keep Sonic rolling
		move.w	#-$300,obVelY(a1)			; rebound Sonic
		bset	#1,obStatus(a1)				; set Sonic's airborne flag
		bclr	#3,obStatus(a1)				; clear Sonic's on-platform flag
		move.b	#2,obRoutine(a1)			; force Sonic to Sonic_Control routine
		bclr	#3,obStatus(a0)				; clear block's stood-on flag
		clr.b	obSolid(a0)				; clear block's solidity status

		; There are two mapping frames for the smashable block, the first with two sprite pieces and the second with four.
		; They look identical on the surface, so during its normal state, the block is set to the first to save on sprites,
		; and it quickly gets swapped out with the four-piece frame on smash for a nicer fragmentation effect.
		move.b	#1,obFrame(a0)				; set to block frame with four sprite pieces for fragmentation
		lea	(Smab_Speeds).l,a4			; load broken fragment speed data
		moveq	#4-1,d1					; set number of fragments to load to 4
		move.w	#gravity,d2				; set counter-gravity for edge case in SmashObject
		bsr.w	SmashObject				; smash the block into four fragment objects (set to routine 4, Smab_Fragment)

		bsr.w	FindFreeObj				; find a free object slot for the points
		bne.s	Smab_Fragment				; if object RAM is full, branch
		_move.b	#id_Points,obID(a1)			; load floating points object
		move.w	obX(a0),obX(a1)				; use block's X-position
		move.w	obY(a0),obY(a1)				; use block's Y-position

		move.w	(v_itembonus).w,d2			; get combo-score chain before landing on floor again
		addq.w	#1*2,(v_itembonus).w			; increment bonus counter (2 because Smab_Scores is word-based)
		cmpi.w	#3*2,d2					; have fewer than 3 blocks broken?
		blo.s	.bonus					; if yes, branch
		moveq	#3*2,d2					; set cap for points to 1000
	.bonus:
		moveq	#0,d0					; clear d0 for word-based indexing
		move.w	Smab_Scores(pc,d2.w),d0			; load bonus points for current combo-score chain
		cmpi.w	#16*2,(v_itembonus).w			; have 16 blocks been smashed?
		blo.s	.givepoints				; if not, branch
		move.w	#1000,d0				; give 10000 points from that point onward
		moveq	#5*2,d2					; use frame 5 for points object (10000)
	.givepoints:
		jsr	(AddPoints).l				; add d0 to current points

		lsr.w	#1,d2					; make item bonus multiples of 1 again for frame ID
		move.b	d2,obFrame(a1)				; set frame ID for floating points object
		
		; continue to Smab_Fragment (root object has been converted to first fragment)...
; ---------------------------------------------------------------------------

Smab_Fragment:	; Routine 4
		bsr.w	SpeedToPos				; update fragment position based on speeds
		addi.w	#gravity,obVelY(a0)			; make fragment fall

	if FixBugs
		; Objects should not call DisplaySprite and DeleteObject on
		; the same frame or else cause a null-pointer dereference.
		; Also, fragments already queue themselves for display, so they should
		; not return to SmashBlock and get queued again through RememberState.
		addq.l	#4,sp					; don't return to SmashBlock
		tst.b	obRender(a0)				; has fragment gone offscreen?
		bpl.w	DeleteObject				; if yes, delete it
		bra.w	DisplaySprite				; otherwise, keep displaying fragment sprite
	else
		bsr.w	DisplaySprite				; display fragment sprite
		tst.b	obRender(a0)				; has fragment gone offscreen?
		bpl.w	DeleteObject				; if yes, delete it
		rts						; return to Points main routine
	endif

; ===========================================================================
Smab_Speeds:	;  x-speed, y-speed
		dc.w -$200, -$200 ; fragment 1
		dc.w -$100, -$100 ; fragment 2
		dc.w  $200, -$200 ; fragment 3
		dc.w  $100, -$100 ; fragment 4

Smab_Scores:	; points per smashed block /10
		dc.w  10	  ; 1st
		dc.w  20	  ; 2nd
		dc.w  50	  ; 3rd
		dc.w 100	  ; 4th - 15th
				  ; 16th and subsequent smashed blocks are hardcoded to 10000 points
; ===========================================================================

Map_Smab:	include	"_maps/Smashable Green Block.asm"
