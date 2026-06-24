; ===========================================================================
; ---------------------------------------------------------------------------
; Object 1E - Ball Hog enemy (SBZ)
; ---------------------------------------------------------------------------

BallHog:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Hog_Index(pc,d0.w),d1
		jmp	Hog_Index(pc,d1.w)
; ===========================================================================
Hog_Index:	dc.w Hog_Main-Hog_Index		; 0
		dc.w Hog_Action-Hog_Index	; 2

hog_launched:	equ objoff_32		; set if a cannonball has been launched this animation cycle
; ===========================================================================

Hog_Main:	; Routine 0
		move.b	#38/2,obHeight(a0)			; set height
		move.b	#16/2,obWidth(a0)			; set width
		move.l	#Map_Hog,obMap(a0)			; set mappings
		move.w	#ArtTile_Ball_Hog|Tile_Pal2,obGfx(a0)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.b	#col_24x36|col_badnik,obColType(a0)	; set ReactToItem type ($5)
		move.b	#24/2,obActWid(a0)			; set sprite display width

		; Make the Ball Hog fall until it has collided with the floor (while invisible)
		bsr.w	ObjectFall				; increase gravity and update position
		jsr	(ObjFloorDist).l			; get distance between Ball Hog and floor
		tst.w	d1					; has Ball Hog hit the floor?
		bpl.s	.hide					; if not, branch
		add.w	d1,obY(a0)				; match object's position with the floor
		move.w	#0,obVelY(a0)				; clear falling speed
		addq.b	#2,obRoutine(a0)			; advance to Hog_Action
	.hide:
		rts						; return (and do NOT display sprite yet)
; ===========================================================================

Hog_Action:	; Routine 2
		lea	(Ani_Hog).l,a1				; load animation script
		bsr.w	AnimateSprite				; animate Ball Hog

		cmpi.b	#1,obFrame(a0)				; is final frame in animation script (1) displayed?
		bne.s	.clearLaunchFlag			; if not, branch
		tst.b	hog_launched(a0)			; has a ball already been launched? (because it stays on frame ID 1 for 9 frames)
		beq.s	.launchBall				; if not, launch ball now
		bra.s	.display				; keep launch flag set
; ---------------------------------------------------------------------------

	.clearLaunchFlag:
		clr.b	hog_launched(a0)			; clear flag to launch another ball on next animation finish

	.display:
		bra.w	RememberState				; display sprite or delete if offscreen
; ---------------------------------------------------------------------------

.launchBall:
		move.b	#1,hog_launched(a0)			; set flag that cannonball has already been launched

		bsr.w	FindFreeObj				; find a free object slot
		bne.s	.finish					; if object RAM is full, branch
		_move.b	#id_Cannonball,obID(a1)			; load cannonball object ($20)
		move.w	obX(a0),obX(a1)				; copy X-position
		move.w	obY(a0),obY(a1)				; copy Y-position
		move.w	#-$100,obVelX(a1)			; make cannonball bounce to the left
		move.w	#0,obVelY(a1)				; set to no Y-speed by default
		moveq	#-4,d0					; align 4px to the left
		btst	#0,obStatus(a0)				; is Ball Hog facing right?
		beq.s	.alignX					; if not, branch
		neg.w	d0					; align 4px to the right instead
		neg.w	obVelX(a1)				; make cannonball bounce to the right instead
	.alignX:
		add.w	d0,obX(a1)				; align horizontally
		addi.w	#12,obY(a1)				; align vertically
		move.b	obSubtype(a0),obSubtype(a1)		; copy object type from Ball Hog (explosion timer in seconds)

	.finish:
		bra.s	.display				; branch to display


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 20 - cannonball that Ball Hog throws (SBZ)
; ---------------------------------------------------------------------------

Cannonball:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	CBal_Index(pc,d0.w),d1
		jmp	CBal_Index(pc,d1.w)
; ===========================================================================
CBal_Index:	dc.w CBal_Main-CBal_Index	; 0
		dc.w CBal_Bounce-CBal_Index	; 2

CBal_time:	equ objoff_30	; frames until the cannonball explodes
; ===========================================================================

CBal_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to CBal_Bounce
		move.b	#14/2,obHeight(a0)			; set height
		move.l	#Map_Hog,obMap(a0)			; set mappings
		move.w	#ArtTile_Ball_Hog|Tile_Pal2,obGfx(a0)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#3,obPriority(a0)			; set sprite priority (above Ball Hog)
		move.b	#col_12x12|col_hurt,obColType(a0)	; set ReactToItem type ($87)
		move.b	#16/2,obActWid(a0)			; set sprite display width

		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; get subtype value set from Ball Hog
		mulu.w	#60,d0					; multiply by 60 frames (1 second)
		move.w	d0,CBal_time(a0)			; set explosion time

		move.b	#4,obFrame(a0)				; set to ball frame
; ---------------------------------------------------------------------------

CBal_Bounce:	; Routine 2
		jsr	(ObjectFall).l				; make cannonball fall and update position

		tst.w	obVelY(a0)				; is cannonball still going upwards?
		bmi.s	CBal_ChkExplode				; if yes, branch
		jsr	(ObjFloorDist).l			; get distance to floor
		tst.w	d1					; has cannonball hit the floor?
		bpl.s	CBal_ChkExplode				; if not, branch

		add.w	d1,obY(a0)				; align cannonball to floor
		move.w	#-$300,obVelY(a0)			; bounce upwards

		tst.b	d3					; check floor angle returned by ObjFloorDist
		beq.s	CBal_ChkExplode				; if ball landed on a flat surface, branch (keep old direction)
		bmi.s	.ascending				; if ball landed on an ascending (to the right) surface, branch
	.descending:
		tst.w	obVelX(a0)				; was ball already going to the right?
		bpl.s	CBal_ChkExplode				; if yes, branch
		neg.w	obVelX(a0)				; move ball to the right now
		bra.s	CBal_ChkExplode				; skip over

	.ascending:
		tst.w	obVelX(a0)				; was ball already going to the left?
		bmi.s	CBal_ChkExplode				; if yes, branch
		neg.w	obVelX(a0)				; move ball to the left now
; ---------------------------------------------------------------------------

CBal_ChkExplode:
		subq.w	#1,CBal_time(a0)			; decrement explosion timer
		bpl.s	CBal_Animate				; if time remains, branch

	if FixBugs=0
		; This is a leftover from the front-facing prototype Ball Hogs, where the
		; dropped cannonballs would spawn a small explosion instead of the regular one.
		; However, after setting the ID, it immediately gets replaced again with the
		; normal explosions, making this object (and its associated graphics) go unused.
		; The small explosion is technically also used by the Buzz Bomber's missiles,
		; but also goes completely unused because the relevant flag is never set
		; and no graphics are ever loaded into VRAM (would be "Nem_UnkExplode").
		_move.b	#id_UnusedExplosion,obID(a0)		; change cannonball into to small explosion ($24)
	endif
		_move.b	#id_Explosion,obID(a0)			; change cannonball into a normal explosion ($3F)
		move.b	#0,obRoutine(a0)			; reset routine counter
		bra.w	Explosion				; jump to explosion code
; ===========================================================================

CBal_Animate:
		subq.b	#1,obTimeFrame(a0)			; decrement animation delay
		bpl.s	.display				; if time remains, branch
		move.b	#6-1,obTimeFrame(a0)			; reset animation delay
		bchg	#0,obFrame(a0)				; alternate between frame ID 4 and 5 (black and red ball)

.display:
	if FixBugs
		move.w	(v_limitbtm2).w,d0			; get current lower level boundary
		addi.w	#224,d0					; add screen height
		cmp.w	obY(a0),d0				; has cannonball fallen off the level?
		blo.w	DeleteObject				; if yes, delete it
		bra.w	DisplaySprite				; otherwise, keep displaying sprite
	else
		; Moved to prevent a display-and-delete bug.
		bsr.w	DisplaySprite				; display cannonball sprite
		move.w	(v_limitbtm2).w,d0			; get current lower level boundary
		addi.w	#224,d0					; add screen height
		cmp.w	obY(a0),d0				; has cannonball fallen off the level?
		blo.w	DeleteObject				; if yes, delete it
		rts						; return
	endif
