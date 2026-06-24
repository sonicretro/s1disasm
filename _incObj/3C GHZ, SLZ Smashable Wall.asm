; ===========================================================================
; ---------------------------------------------------------------------------
; Object 3C - smashable wall (GHZ, SLZ)
; ---------------------------------------------------------------------------

SmashWall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Smash_Index(pc,d0.w),d1
		jsr	Smash_Index(pc,d1.w)
		bra.w	RememberState
; ===========================================================================
Smash_Index:	dc.w Smash_Main-Smash_Index
		dc.w Smash_Solid-Smash_Index
		dc.w Smash_Fragment-Smash_Index

smash_speed:	equ objoff_30		; backup of Sonic's horizontal speed before hitting the wall
; ===========================================================================

Smash_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Smash_Solid
		move.l	#Map_Smash,obMap(a0)			; set mappings
		move.w	#ArtTile_GHZ_SLZ_Smashable_Wall|Tile_Pal3,obGfx(a0) ; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#32/2,obActWid(a0)			; set sprite display width
		move.b	#4,obPriority(a0)			; set sprite 
		move.b	obSubtype(a0),obFrame(a0)		; set frame ID from subtype (0 = left // 1 = middle // 2 = right)
; ---------------------------------------------------------------------------

Smash_Solid:	; Routine 2
		move.w	(v_player+obVelX).w,smash_speed(a0)	; remember Sonic's speed before calling SolidObject (because it can change it)

		move.w	#32/2+sonic_solid_width,d1
		move.w	#64/2,d2
		move.w	#64/2,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject				; check collision with Sonic and wall
		btst	#5,obStatus(a0)				; is Sonic pushing against the wall?
		bne.s	.chkroll				; if yes, branch

	.return:
		rts
; ===========================================================================

.chkroll:
		cmpi.b	#id_Roll,obAnim(a1)			; is Sonic rolling?
		bne.s	.return					; if not, don't smash

		move.w	smash_speed(a0),d0			; get Sonic's impact speed
		bpl.s	.chkspeed				; if positive, branch
		neg.w	d0					; make it positive for check
	.chkspeed:
		cmpi.w	#$480,d0				; was Sonic's impact speed $480 or higher?
		blo.s	.return					; if not, don't smash

		move.w	smash_speed(a0),obVelX(a1)		; restore Sonic's speed before SolidObject got called
		addq.w	#4,obX(a1)				; push Sonic to the right a bit for pseudo-seamless movement

		lea	(Smash_FragSpd1).l,a4			; use fragments that move right
		move.w	obX(a0),d0				; get wall's X-position
		cmp.w	obX(a1),d0				; has Sonic smashed the wall from the left?
		blo.s	.smash					; if yes, branch
		subq.w	#4*2,obX(a1)				; push Sonic to the left a bit for pseudo-seamless movement (and undo above addq)
		lea	(Smash_FragSpd2).l,a4			; use fragments that move left

	.smash:
		move.w	obVelX(a1),obInertia(a1)		; copy speed before impact to Sonic's ground speed
		bclr	#5,obStatus(a0)				; clear wall's pushed flag
		bclr	#5,obStatus(a1)				; clear Sonic's pushing flag

		moveq	#8-1,d1					; set number of fragments to load to 8 (number of sprite pieces in wall)
		move.w	#gravity*2,d2				; set counter-gravity for edge case in SmashObject
		bsr.s	SmashObject				; smash the block into four fragment objects (set to routine 4, Smash_Fragment)
		; continue to Smash_Fragment (root object has been converted to first fragment)...
; ---------------------------------------------------------------------------

Smash_Fragment:	; Routine 4
		bsr.w	SpeedToPos				; update fragment position based on speeds
		addi.w	#gravity*2,obVelY(a0)			; make fragment fall faster (double gravity)

	if FixBugs
		; Objects should not call DisplaySprite and DeleteObject on
		; the same frame or else cause a null-pointer dereference.
		; Also, fragments already queue themselves for display, so they should
		; not return to SmashWall and get queued again through RememberState.
		addq.l	#4,sp					; don't return to SmashWall
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
; This subroutine is shared with most other smashable objects. This object likely
; was the first one where it was used, hence it being sandwiched in between here.
		include	"_incObj/sub SmashObject.asm"

; ===========================================================================
; Smashed block fragment speeds used by GHZ smashable walls
; (x-move speed, y-move speed)

Smash_FragSpd1:	; breaking wall from the left
		dc.w  $400, -$500	
		dc.w  $600, -$100
		dc.w  $600,  $100
		dc.w  $400,  $500
		dc.w  $600, -$600
		dc.w  $800, -$200
		dc.w  $800,  $200
		dc.w  $600,  $600

Smash_FragSpd2:	; breaking wall from the right
		dc.w -$600, -$600
		dc.w -$800, -$200
		dc.w -$800,  $200
		dc.w -$600,  $600
		dc.w -$400, -$500
		dc.w -$600, -$100
		dc.w -$600,  $100
		dc.w -$400,  $500
; ===========================================================================

Map_Smash:	include	"_maps/Smashable Walls.asm"
