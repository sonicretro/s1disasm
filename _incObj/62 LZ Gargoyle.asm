; ===========================================================================
; ---------------------------------------------------------------------------
; Object 62 - gargoyle head that spits fireballs (LZ)
; ---------------------------------------------------------------------------

Gargoyle:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Gar_Index(pc,d0.w),d1
		jsr	Gar_Index(pc,d1.w)
		bra.w	RememberState				; display sprite, or delete if out of range
; ===========================================================================
Gar_Index:	dc.w Gar_Main-Gar_Index
		dc.w Gar_MakeFire-Gar_Index
		dc.w Gar_FireBall-Gar_Index
		dc.w Gar_AniFire-Gar_Index
; ===========================================================================
Gar_SpitRate:	dc.b 30, 60, 90, 120, 150, 180, 210, 240
; ===========================================================================

Gar_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Gar_MakeFire
		move.l	#Map_Gar,obMap(a0)			; set mappings
		move.w	#ArtTile_LZ_Gargoyle|Tile_Pal3,obGfx(a0) ; set art tile and palette line
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#3,obPriority(a0)			; set sprite priority
		move.b	#32/2,obActWid(a0)			; set sprite display width

		move.b	obSubtype(a0),d0			; get object subtype
		andi.w	#$F,d0					; read only the lower digit
		move.b	Gar_SpitRate(pc,d0.w),obDelayAni(a0)	; set fireball spit rate (multiples of 30 frames)
		move.b	obDelayAni(a0),obTimeFrame(a0)		; set initial delay before spitting
		andi.b	#$F,obSubtype(a0)			; clear out upper subtype digit (pointless...)
; ---------------------------------------------------------------------------

Gar_MakeFire:	; Routine 2
		subq.b	#1,obTimeFrame(a0)			; decrement timer until spitting
		bne.s	.return					; if time remains, branch
		move.b	obDelayAni(a0),obTimeFrame(a0)		; reset spitting timer
		bsr.w	ChkObjectVisible			; is gargoyle head on screen?
		bne.s	.return					; if not, branch

		bsr.w	FindFreeObj				; find a free object slot
		bne.s	.return					; if object RAM is full, branch
		_move.b	#id_Gargoyle,obID(a1)			; load fireball object
		addq.b	#4,obRoutine(a1)			; use Gar_FireBall routine
		move.w	obX(a0),obX(a1)				; copy head's X-position
		move.w	obY(a0),obY(a1)				; copy head'S Y-position
		move.b	obRender(a0),obRender(a1)		; copy head's render flags
		move.b	obStatus(a0),obStatus(a1)		; copy head's status flags (X/Y-flip)

	.return:
		rts						; return
; ===========================================================================

Gar_FireBall:	; Routine 4
		addq.b	#2,obRoutine(a0)			; advance fireball to Gar_AniFire
		move.b	#16/2,obHeight(a0)			; set height
		move.b	#16/2,obWidth(a0)			; set width
		move.l	#Map_Gar,obMap(a0)			; set mappings
		move.w	#ArtTile_LZ_Gargoyle,obGfx(a0)		; set art tile (different palette line than head)
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority (behind head)
		move.b	#col_8x8|col_hurt,obColType(a0)		; make fireball harmful
		move.b	#16/2,obActWid(a0)			; set sprite display width
		move.b	#2,obFrame(a0)				; set to "fireball" frame
		addq.w	#8,obY(a0)				; adjust Y-position to make fireball come out of mouth

		move.w	#$200,obVelX(a0)			; move fireball to the right
		btst	#0,obStatus(a0)				; is gargoyle facing left?
		bne.s	.sound					; if not, branch
		neg.w	obVelX(a0)				; move fireball to the left instead

	.sound:
		move.w	#sfx_Fireball,d0			; set fireball spitting sound
		jsr	(QueueSound2).l				; play it
; ---------------------------------------------------------------------------

Gar_AniFire:	; Routine 6
		move.b	(v_framebyte).w,d0			; get current VBlank frame counter byte
		andi.b	#7,d0					; limit to 0-7
		bne.s	.moveAndCheckWall				; only change fireball frame every 8th frame
		bchg	#0,obFrame(a0)				; alternate between fireball frame 1 and 2

.moveAndCheckWall:
		bsr.w	SpeedToPos				; update fireball position

		btst	#0,obStatus(a0)				; is fireball moving left?
		bne.s	.isRight				; if not, branch
	.isLeft:
		moveq	#-8,d3					; check 8px ahead to the left
		bsr.w	ObjHitWallLeft				; get distance to nearest left wall
		tst.w	d1					; has fireball hit a wall to the left?
	if FixBugs
		bmi.s	.delete					; if yes, delete it
	else
		bmi.w	DeleteObject				; if yes, delete it
	endif
		rts						; return
; ---------------------------------------------------------------------------

	.isRight:
		moveq	#8,d3					; check 8px ahead to the right
		bsr.w	ObjHitWallRight				; get distance to nearest right wall
		tst.w	d1					; has fireball hit a wall to the right?
	if FixBugs
		bmi.s	.delete					; if yes, delete it
	else
		bmi.w	DeleteObject				; if yes, delete it
	endif
		rts						; return
; ---------------------------------------------------------------------------

	if FixBugs
		; Avoid returning to Gargoyle to prevent display-and-delete
		; and double-delete bugs.
	.delete:
		addq.l	#4,sp					; skip returning to "Gargoyle:" code
		bra.w	DeleteObject				; delete fireball
	endif

; ===========================================================================

Map_Gar:	include	"_maps/Gargoyle.asm"
