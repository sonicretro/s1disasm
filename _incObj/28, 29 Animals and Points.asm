; ===========================================================================
; ---------------------------------------------------------------------------
; Object 28 - Animals from destroyed badniks, prison capsules, and ending
; ---------------------------------------------------------------------------

Animals:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Anml_Index(pc,d0.w),d1
		jmp	Anml_Index(pc,d1.w)
; ===========================================================================
Anml_Index:	dc.w Anml_Main-Anml_Index		; 0  - init
		dc.w Anml_ChkFloor-Anml_Index		; 2  - wait for first floor hit after initial spawn

		; --- Animals spawned from broken badniks  ---
		dc.w Anml_NormalGravity-Anml_Index	; 4  - type 0: Pocky/bunny (GHZ/SBZ)
		dc.w Anml_SlowGravity-Anml_Index	; 6  - type 1: Cucky/chicken (SYZ/SBZ)
		dc.w Anml_NormalGravity-Anml_Index	; 8  - type 2: Pecky/penguin (LZ)
		dc.w Anml_NormalGravity-Anml_Index	; A  - type 3: Ricky/squirrel (MZ/LZ)
		dc.w Anml_NormalGravity-Anml_Index	; C  - type 4: Picky/pig (SYZ/SLZ)
		dc.w Anml_SlowGravity-Anml_Index	; E  - type 5: Flicky/bird (GHZ/SLZ)
		dc.w Anml_NormalGravity-Anml_Index	; 10 - type 6: Rocky/seal (MZ)

		; --- Animals spawned from post-boss prison capsules ---
		dc.w Anml_FromPrison-Anml_Index		; 12 - delay jumping out of prison capsule

		; --- Animals in the ending sequence ---
		dc.w Anml_End_FlyLeft-Anml_Index	; 14 - type 0A: Flicky/bird (type A)
		dc.w Anml_End_FlyLeft-Anml_Index	; 16 - type 0B: Flicky/bird (type B, unused)
		dc.w Anml_End_StayFace_Slow-Anml_Index	; 18 - type 0C: Flicky/bird (type C)
		dc.w Anml_End_HopLeft-Anml_Index	; 1A - type 0D: Pocky/bunny (type A)
		dc.w Anml_End_StayFace_Fast-Anml_Index	; 1C - type 0E: Pocky/bunny (type B)
		dc.w Anml_End_HopAround-Anml_Index	; 1E - type 0F: Pecky/penguin (type A)
		dc.w Anml_End_StayFace_Fast-Anml_Index	; 20 - type 10: Pecky/penguin (type B)
		dc.w Anml_End_HopAround-Anml_Index	; 22 - type 11: Rocky/seal
		dc.w Anml_End_StayFace_Fast-Anml_Index	; 24 - type 12: Picky/pig
		dc.w Anml_End_DoubleFly-Anml_Index	; 26 - type 13: Cucky/chicken
		dc.w Anml_End_DoubleHop-Anml_Index	; 28 - type 14: Ricky/squirrel

animal_doublehop:	equ objoff_29	; flag used for double hopping in ending sequence
animal_id:		equ objoff_30	; animal ID from Anml_VarIndex
animal_speedX:		equ objoff_32	; base animal X-speed
animal_speedY:		equ objoff_34	; base animal Y-speed
animal_prisondelay:	equ objoff_36	; delay before animal jumps out of prison capsule (set from object 3E)
animal_pointsframe:	equ objoff_3E	; carries over frame ID from combo collision response to actual points object
; ===========================================================================

; Configuration values for animals per zone, and their speeds.

Anml_VarIndex:	; two animal IDs per zone, must be "even/odd"
		dc.b 0,	5		; Green Hill Zone
		dc.b 2, 3		; Labyrinth Zone
		dc.b 6, 3		; Marble Zone
		dc.b 4, 5		; Star Light Zone
		dc.b 4, 1		; Spring Yard Zone
		dc.b 0, 1		; Scrap Brain Zone
		zonewarning Anml_VarIndex,2

Anml_Variables:	; horizontal speed, vertical speed, mappings
		dc.w -$200, -$400	; type 0: Pocky/bunny (GHZ/SBZ)
		dc.l Map_Animal1
		dc.w -$200, -$300	; type 1: Cucky/chicken (SYZ/SBZ)
		dc.l Map_Animal2
		dc.w -$180, -$300	; type 2: Pecky/penguin (LZ)
		dc.l Map_Animal1
		dc.w -$140, -$180	; type 3: Ricky/squirrel (MZ/LZ)
		dc.l Map_Animal2
		dc.w -$1C0, -$300	; type 4: Picky/pig (SYZ/SLZ)
		dc.l Map_Animal3
		dc.w -$300, -$400	; type 5: Flicky/bird (GHZ/SLZ)
		dc.l Map_Animal2
		dc.w -$280, -$380	; type 6: Rocky/seal (MZ)
		dc.l Map_Animal3

; ---------------------------------------------------------------------------

; Configuration values for the animals in the ending sequence.
; Each entry corresponds to one ending sequence animal,
; using subtype ID as index, starting at subtype $A.

Anml_EndSpeed:	; horizontal speed, vertical speed
		dc.w -$440, -$400		; 0A - Flicky/bird (type A)
		dc.w -$440, -$400		; 0B - Flicky/bird (type B, unused)
		dc.w -$440, -$400		; 0C - Flicky/bird (type C)
		dc.w -$300, -$400		; 0D - Pocky/bunny (type A)
		dc.w -$300, -$400		; 0E - Pocky/bunny (type B)
		dc.w -$180, -$300		; 0F - Pecky/penguin (type A)
		dc.w -$180, -$300		; 10 - Pecky/penguin (type B)
		dc.w -$140, -$180		; 11 - Rocky/seal
		dc.w -$1C0, -$300		; 12 - Picky/pig
		dc.w -$200, -$300		; 13 - Cucky/chicken
		dc.w -$280, -$380		; 14 - Ricky/squirrel

Anml_EndMap:	dc.l Map_Animal2		; 0A - Flicky/bird (type A)
		dc.l Map_Animal2		; 0B - Flicky/bird (type B, unused)
		dc.l Map_Animal2		; 0C - Flicky/bird (type C)
		dc.l Map_Animal1		; 0D - Pocky/bunny (type A)
		dc.l Map_Animal1		; 0E - Pocky/bunny (type B)
		dc.l Map_Animal1		; 0F - Pecky/penguin (type A)
		dc.l Map_Animal1		; 10 - Pecky/penguin (type B)
		dc.l Map_Animal2		; 11 - Rocky/seal
		dc.l Map_Animal3		; 12 - Picky/pig
		dc.l Map_Animal2		; 13 - Cucky/chicken
		dc.l Map_Animal3		; 14 - Ricky/squirrel

Anml_EndVram:	dc.w ArtTile_Ending_Flicky	; 0A - Flicky/bird (type A)
		dc.w ArtTile_Ending_Flicky      ; 0B - Flicky/bird (type B, unused)
		dc.w ArtTile_Ending_Flicky      ; 0C - Flicky/bird (type C)
		dc.w ArtTile_Ending_Rabbit      ; 0D - Pocky/bunny (type A)
		dc.w ArtTile_Ending_Rabbit      ; 0E - Pocky/bunny (type B)
		dc.w ArtTile_Ending_Penguin     ; 0F - Pecky/penguin (type A)
		dc.w ArtTile_Ending_Penguin     ; 10 - Pecky/penguin (type B)
		dc.w ArtTile_Ending_Seal        ; 11 - Rocky/seal
		dc.w ArtTile_Ending_Pig         ; 12 - Picky/pig
		dc.w ArtTile_Ending_Chicken     ; 13 - Cucky/chicken
		dc.w ArtTile_Ending_Squirrel    ; 14 - Ricky/squirrel
; ===========================================================================

; Anml_Ending: <-- old misnomer!
Anml_Main:	; Routine 0
		tst.b	obSubtype(a0)				; did animal come from a destroyed enemy?
		beq.w	Anml_FromEnemy				; if yes, branch

		; Animal was placed in-level with a custom subtype (Ending Sequence)
		moveq	#0,d0					; clear d0
		move.b	obSubtype(a0),d0			; move object type to d0
		add.w	d0,d0					; double for word-based indexing
		move.b	d0,obRoutine(a0)			; set result as routine counter (Anml_End_FlyLeft to Anml_End_DoubleHop)
		subi.w	#$14,d0					; make 0-based (routine $14 is first end animal routine)
		move.w	Anml_EndVram(pc,d0.w),obGfx(a0)		; set art tile for ending animal
		add.w	d0,d0					; double again for long-based addressing
		move.l	Anml_EndMap(pc,d0.w),obMap(a0)		; set mappings for ending animal
		lea	Anml_EndSpeed(pc),a1			; load speed values array
		move.w	(a1,d0.w),animal_speedX(a0)		; load horizontal speed
		move.w	(a1,d0.w),obVelX(a0)			; set it to current speed too
		move.w	2(a1,d0.w),animal_speedY(a0)		; load vertical speed
		move.w	2(a1,d0.w),obVelY(a0)			; set it to current speed too

		move.b	#24/2,obHeight(a0)			; set height
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		bset	#sprite_xflip_bit,obRender(a0)		; set X-flip flag (face left)
		move.b	#6,obPriority(a0)			; set sprite priority (very low)
		move.b	#16/2,obActWid(a0)			; set sprite display width
		move.b	#8-1,obTimeFrame(a0)			; initial animation delay for flying animals (slow gravity)
		bra.w	DisplaySprite				; display animal
; ===========================================================================

Anml_FromEnemy:
		addq.b	#2,obRoutine(a0)			; advance to Anml_ChkFloor

		bsr.w	RandomNumber				; get random number to select animal to spawn
		andi.w	#1,d0					; limit to two choices
		moveq	#0,d1					; clear d1
		move.b	(v_zone).w,d1				; get current zone ID
		add.w	d1,d1					; double for word-based addressing
		add.w	d0,d1					; add random result
		lea	Anml_VarIndex(pc),a1			; load animal IDs array
		move.b	(a1,d1.w),d0				; get animal ID for zone (animal 0 or 1)
		move.b	d0,animal_id(a0)			; remember animal ID
		lsl.w	#3,d0					; multiply by 8 bytes per Anml_Variables entry
		lea	Anml_Variables(pc),a1			; load animal variables array
		adda.w	d0,a1					; advance to data for current animal
		move.w	(a1)+,animal_speedX(a0)			; load horizontal speed
		move.w	(a1)+,animal_speedY(a0)			; load vertical speed
		move.l	(a1)+,obMap(a0)				; load mappings
		move.w	#ArtTile_Animal_1,obGfx(a0)		; VRAM setting for animal 0
		btst	#0,animal_id(a0)			; is 0th animal used? (even number)
		beq.s	.setupAnimal				; if yes, branch
		move.w	#ArtTile_Animal_2,obGfx(a0)		; VRAM setting for animal 1

	.setupAnimal:
		move.b	#24/2,obHeight(a0)			; set height
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		bset	#sprite_xflip_bit,obRender(a0)		; set X-flip flag
		move.b	#6,obPriority(a0)			; set sprite priority (very low)
		move.b	#16/2,obActWid(a0)			; set sprite display width
		move.b	#8-1,obTimeFrame(a0)			; initial animation delay for flying animals (slow gravity)
		move.b	#2,obFrame(a0)				; set initial frame to ".flap2"
		move.w	#-$400,obVelY(a0)			; launch animal upwards initially

		tst.b	(v_bossstatus).w			; is this animal from a prison capsule?
		bne.s	.fromPrison				; if yes, don't load points object
		bsr.w	FindFreeObj				; find a free object slot
		bne.s	.display				; if object RAM is full, branch
		_move.b	#id_Points,obID(a1)			; load points object
		move.w	obX(a0),obX(a1)				; copy X-position
		move.w	obY(a0),obY(a1)				; copy Y-position
		move.w	animal_pointsframe(a0),d0		; get carried-over frame ID from gray explosion object
		lsr.w	#1,d0					; value was provided doubled, halve it
		move.b	d0,obFrame(a1)				; set result as points frame ID (100, 200, 500, 1000...)

	.display:
		bra.w	DisplaySprite				; display animal
; ---------------------------------------------------------------------------

	.fromPrison:
		move.b	#$12,obRoutine(a0)			; advance to Anml_FromPrison
		clr.w	obVelX(a0)				; don't initially move horizontally
		bra.w	DisplaySprite				; display animal
; ===========================================================================

; loc_912A:
Anml_ChkFloor:	; Routine 2
		tst.b	obRender(a0)				; has animal gone offscreen?
		bpl.w	DeleteObject				; if yes, delete it

		bsr.w	ObjectFall				; make animal fall and update position
		tst.w	obVelY(a0)				; is animal still going upwards?
		bmi.s	.display				; if yes, skip ground collision check

		jsr	(ObjFloorDist).l			; get distance to floor
		tst.w	d1					; has animal hit the floor?
		bpl.s	.display				; if not, branch
		add.w	d1,obY(a0)				; align animal to floor
		move.w	animal_speedX(a0),obVelX(a0)		; reset to base X-speed
		move.w	animal_speedY(a0),obVelY(a0)		; reset to base Y-speed
		move.b	#1,obFrame(a0)				; set initial frame to ".flap1"

		move.b	animal_id(a0),d0			; get animal ID
		add.b	d0,d0					; double for word-based routine numbers
		addq.b	#4,d0					; skip over Anml_Main and Anml_ChkFloor routines
		move.b	d0,obRoutine(a0)			; advance to routine for this animal (Anml_NormalGravity or Anml_SlowGravity)

		tst.b	(v_bossstatus).w			; is this animal from a prison capsule?
		beq.s	.display				; if not, branch
		btst	#4,(v_vblank_byte).w			; reverse prison escape direction every 16-32 frames in a 32 frame window
		beq.s	.display				; branch on other frames
		neg.w	obVelX(a0)				; invert X-direction (hop left and right on floor)
		bchg	#sprite_xflip_bit,obRender(a0)		; flip X-orientation

	.display:
		bra.w	DisplaySprite				; display animal

; ===========================================================================
; ---------------------------------------------------------------------------
; Type 0 animals: normal gravity, animate on floor hit
; ---------------------------------------------------------------------------

; loc_9184: ; Anml_Type0:
Anml_NormalGravity: ; Routine 4/8/A/C/10
		bsr.w	ObjectFall				; make animal fall and update position
		move.b	#1,obFrame(a0)				; use frame 1 while going up
		tst.w	obVelY(a0)				; is animal going down?
		bmi.s	.chkDel					; if not, branch
		move.b	#0,obFrame(a0)				; use frame 0 while going down

		jsr	(ObjFloorDist).l			; get distance to floor
		tst.w	d1					; has animal hit the floor?
		bpl.s	.chkDel					; if not, branch
		add.w	d1,obY(a0)				; align animal to floor
		move.w	animal_speedY(a0),obVelY(a0)		; make animal bounce upwards again

	.chkDel:
		tst.b	obSubtype(a0)				; is this an ending sequence animal?
		bne.s	Anml_End_ChkDel				; if yes, use alternate offscreen handler
		tst.b	obRender(a0)				; has animal gone offscreen?
		bpl.w	DeleteObject				; if yes, delete it
		bra.w	DisplaySprite				; otherwise, display it

; ===========================================================================
; ---------------------------------------------------------------------------
; Type 1 animals: reduced gravity, animate every other frame
; ---------------------------------------------------------------------------

; loc_91C0: ; Anml_Type1:
Anml_SlowGravity: ; Routine 6/E
		bsr.w	SpeedToPos				; update animal position
		addi.w	#$18,obVelY(a0)				; make animal fall (slowly)
		tst.w	obVelY(a0)				; is animal going down?
		bmi.s	.animate				; if not, branch

		jsr	(ObjFloorDist).l			; get distance to floor
		tst.w	d1					; has animal hit the floor?
		bpl.s	.animate				; if not, branch
		add.w	d1,obY(a0)				; align animal to floor
		move.w	animal_speedY(a0),obVelY(a0)		; make animal bounce upwards again

		tst.b	obSubtype(a0)				; is this an ending sequence animal?
		beq.s	.animate				; if not, branch
		cmpi.b	#$A,obSubtype(a0)			; is this a Flicky (bird) type A?
		beq.s	.animate				; if yes, keep it moving to the left
		neg.w	obVelX(a0)				; invert X-direction (hop left and right on floor)
		bchg	#sprite_xflip_bit,obRender(a0)		; flip X-orientation

	.animate:
		subq.b	#1,obTimeFrame(a0)			; decrement animation delay
		bpl.s	.chkDel					; if time remains, branch
		move.b	#2-1,obTimeFrame(a0)			; change sprite every two frames
		addq.b	#1,obFrame(a0)				; go to next sprite
		andi.b	#1,obFrame(a0)				; alternate between sprite 0 and 1

	.chkDel:
		tst.b	obSubtype(a0)				; is this an ending sequence animal?
		bne.s	Anml_End_ChkDel				; if yes, use alternate offscreen handler
		tst.b	obRender(a0)				; has animal gone offscreen?
		bpl.w	DeleteObject				; if yes, delete it
		bra.w	DisplaySprite				; otherwise, display it
; ===========================================================================

; loc_9224:
Anml_End_ChkDel:
		move.w	obX(a0),d0				; get animal's X-position
		sub.w	(v_player+obX).w,d0			; subtract Sonic's X-position
		blo.s	.display				; if Sonic is to the right of the animal, branch
		subi.w	#320+64,d0				; check if Sonic has passed the animal to the left ($180)
		bpl.s	.display				; if not, branch
		tst.b	obRender(a0)				; is animal still on screen?
		bpl.w	DeleteObject				; if not, delete it

	.display:
		bra.w	DisplaySprite				; display animal

; ===========================================================================
; ---------------------------------------------------------------------------
; Delay animals hopping out of prison capsule
; ---------------------------------------------------------------------------

; loc_9240:
Anml_FromPrison: ; Routine 12
		tst.b	obRender(a0)				; has animal gone offscreen?
		bpl.w	DeleteObject				; if yes, delete it
		subq.w	#1,animal_prisondelay(a0)		; decrement delay before animal jumps out of capsule
		bne.w	.display				; if time remains
		move.b	#2,obRoutine(a0)			; set animal to Anml_ChkFloor to make it start moving
		move.b	#3,obPriority(a0)			; set sprite priority to be above prison

	.display:
		bra.w	DisplaySprite				; display animal

; ===========================================================================
; ---------------------------------------------------------------------------
; Movement behavior for Ending Sequence animals
; ---------------------------------------------------------------------------

; loc_9260:
Anml_End_FlyLeft: ; Routine 14/16
		bsr.w	Anml_CheckCloseToSonic			; has ending animal moved into view yet?
		bhs.s	.chkDel					; if not, branch

		move.w	animal_speedX(a0),obVelX(a0)		; start moving animal horizontally
		move.w	animal_speedY(a0),obVelY(a0)		; start moving animal vertically
		move.b	#$E,obRoutine(a0)			; set to Anml_SlowGravity
		bra.w	Anml_SlowGravity			; go there immediately
; ---------------------------------------------------------------------------

	.chkDel:
		bra.w	Anml_End_ChkDel				; handle offscreen delete
; ===========================================================================

; loc_9280:
Anml_End_StayFace_Slow:	; Routine 18
		bsr.w	Anml_CheckCloseToSonic			; has ending animal moved into view yet?
		bpl.s	.chkDel					; if not, branch

		clr.w	obVelX(a0)				; don't move horizontally
		clr.w	animal_speedX(a0)			; ''
		bsr.w	SpeedToPos				; update position
		addi.w	#$18,obVelY(a0)				; make animal fall (slowly)
		bsr.w	Anml_End_Bounce				; bounce and animate animal
		bsr.w	Anml_End_FaceSonic			; keep facing Sonic

		subq.b	#1,obTimeFrame(a0)			; decrement animation delay
		bpl.s	.chkDel					; if time remains, branch
		move.b	#2-1,obTimeFrame(a0)			; change sprite every two frames
		addq.b	#1,obFrame(a0)				; go to next sprite
		andi.b	#1,obFrame(a0)				; alternate between sprite 0 and 1

	.chkDel:
		bra.w	Anml_End_ChkDel				; handle offscreen delete
; ===========================================================================

; loc_92BA:
Anml_End_HopLeft: ; Routine 1A
		bsr.w	Anml_CheckCloseToSonic			; has ending animal moved into view yet?
		bpl.s	Anml_End_DoubleHop.chkDel		; if not, branch (using a foreign branch)

		move.w	animal_speedX(a0),obVelX(a0)		; set X-speed (always leftwards)
		move.w	animal_speedY(a0),obVelY(a0)		; set Y-speed
		move.b	#4,obRoutine(a0)			; set to Anml_NormalGravity
		bra.w	Anml_NormalGravity			; go there immediately
; ===========================================================================

; loc_92D6:
Anml_End_DoubleHop: ; Routine 28
		bsr.w	ObjectFall				; make animal fall (normal gravity) and update position

		move.b	#1,obFrame(a0)				; set to "flapping" frame while going up
		tst.w	obVelY(a0)				; is animal falling down?
		bmi.s	.chkDel					; if not, branch
		move.b	#0,obFrame(a0)				; use "dropping" frame while going down

		jsr	(ObjFloorDist).l			; get distance to floor
		tst.w	d1					; has animal hit the floor?
		bpl.s	.chkDel					; if not, branch
		not.b	animal_doublehop(a0)			; flip double-hop flag
		bne.s	.bounce					; if flag is set now, do not invert direction this time
		neg.w	obVelX(a0)				; invert X-direction (hop left and right on floor)
		bchg	#sprite_xflip_bit,obRender(a0)		; flip X-orientation

	.bounce:
		add.w	d1,obY(a0)				; align animal to floor
		move.w	animal_speedY(a0),obVelY(a0)		; bounce animal upwards
; ---------------------------------------------------------------------------

.chkDel:
		bra.w	Anml_End_ChkDel				; handle offscreen delete

; Compatibility with ASM68K
Anml_End_DoubleHop.chkDel: equ .chkDel
; ===========================================================================

; loc_9314:
Anml_End_StayFace_Fast: ; Routine 1C/20/24
		bsr.w	Anml_CheckCloseToSonic			; has ending animal moved into view yet?
		bpl.s	.chkDel					; if not, branch

		clr.w	obVelX(a0)				; don't move horizontally
		clr.w	animal_speedX(a0)			; ''
		bsr.w	ObjectFall				; make animal fall (normal gravity) and update position
		bsr.w	Anml_End_Bounce				; bounce and animate animal
		bsr.w	Anml_End_FaceSonic			; keep facing Sonic

	.chkDel:
		bra.w	Anml_End_ChkDel				; handle offscreen delete
; ===========================================================================

; loc_9332:
Anml_End_HopAround: ; Routine 1E/22
		bsr.w	Anml_CheckCloseToSonic			; has ending animal moved into view yet?
		bpl.s	.chkDel					; if not, branch

		bsr.w	ObjectFall				; make animal fall (normal gravity) and update position

		move.b	#1,obFrame(a0)				; set to "flapping" frame while going up
		tst.w	obVelY(a0)				; is animal falling down?
		bmi.s	.chkDel					; if not, branch
		move.b	#0,obFrame(a0)				; use "dropping" frame while going down

		jsr	(ObjFloorDist).l			; get distance to floor
		tst.w	d1					; has animal hit the floor?
		bpl.s	.chkDel					; if not, branch
		neg.w	obVelX(a0)				; invert X-direction (hop left and right on floor)
		bchg	#sprite_xflip_bit,obRender(a0)		; flip X-orientation
		add.w	d1,obY(a0)				; align animal to floor
		move.w	animal_speedY(a0),obVelY(a0)		; bounce animal upwards

	.chkDel:
		bra.w	Anml_End_ChkDel				; handle offscreen delete
; ===========================================================================

; loc_9370:
Anml_End_DoubleFly: ; Routine 26
		bsr.w	Anml_CheckCloseToSonic			; has ending animal moved into view yet?
		bpl.s	.chkDel					; if not, branch

		bsr.w	SpeedToPos				; update position
		addi.w	#$18,obVelY(a0)				; make animal fall (slowly)
		tst.w	obVelY(a0)				; is animal going down?
		bmi.s	.animate				; if not, branch

		jsr	(ObjFloorDist).l			; get distance to floor
		tst.w	d1					; has animal hit the floor?
		bpl.s	.animate				; if not, branch
		not.b	animal_doublehop(a0)			; flip double-hop flag
		bne.s	.bounce					; if flag is set now, do not invert direction this time
		neg.w	obVelX(a0)				; invert X-direction (hop left and right on floor)
		bchg	#sprite_xflip_bit,obRender(a0)		; flip X-orientation

	.bounce:
		add.w	d1,obY(a0)				; align animal to floor
		move.w	animal_speedY(a0),obVelY(a0)		; bounce animal upwards

	.animate:
		subq.b	#1,obTimeFrame(a0)			; decrement animation delay
		bpl.s	.chkDel					; if time remains, branch
		move.b	#2-1,obTimeFrame(a0)			; change sprite every two frames
		addq.b	#1,obFrame(a0)				; go to next sprite
		andi.b	#1,obFrame(a0)				; alternate between sprite 0 and 1

	.chkDel:
		bra.w	Anml_End_ChkDel				; handle offscreen delete

; ===========================================================================
; Various subroutines for the ending sequence animals...

; ---------------------------------------------------------------------------
; Subroutine to set animal frame depending on whether it's going up or down,
; and make it bounce up again when it hits the floor
; ---------------------------------------------------------------------------

; loc_93C4:
Anml_End_Bounce:
		move.b	#1,obFrame(a0)				; set to "flapping" frame while going up
		tst.w	obVelY(a0)				; is animal falling down?
		bmi.s	.return					; if not, branch
		move.b	#0,obFrame(a0)				; use "dropping" frame while going down

		jsr	(ObjFloorDist).l			; get distance to floor
		tst.w	d1					; has animal hit the floor?
		bpl.s	.return					; if not, branch
		add.w	d1,obY(a0)				; align animal to floor
		move.w	animal_speedY(a0),obVelY(a0)		; bounce animal upwards again

	.return:
		rts						; return
; End of function Anml_End_Bounce


; ---------------------------------------------------------------------------
; Subroutine to make animal face Sonic through X-flip flag
; ---------------------------------------------------------------------------

; loc_93EC:
Anml_End_FaceSonic:
		bset	#sprite_xflip_bit,obRender(a0)		; make animal face left
		move.w	obX(a0),d0				; get animal's X-position
		sub.w	(v_player+obX).w,d0			; is Sonic to the right of the animal?
		bhs.s	.return					; if not, branch
		bclr	#sprite_xflip_bit,obRender(a0)		; make animal face right
	.return:
		rts						; return
; End of function Anml_End_FaceSonic


; ---------------------------------------------------------------------------
; Subroutine to check if Sonic is more than 184px to the right of animal
; ---------------------------------------------------------------------------

; sub_9404:
Anml_CheckCloseToSonic:
		move.w	(v_player+obX).w,d0			; get Sonic's X-position
		sub.w	obX(a0),d0				; subtract X-position of animal
		subi.w	#(320/2)+24,d0				; check if Sonic is 184px to the right of the animal (i.e. just barely on screen)
		rts						; result in CCR
; End of function Anml_CheckCloseToSonic



; ===========================================================================
; ---------------------------------------------------------------------------
; Object 29 - points that appear from destroyed badniks and other places
; ---------------------------------------------------------------------------

Points:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Poi_Index(pc,d0.w),d1
	if FixBugs
		; Objects shouldn't call DisplaySprite and DeleteObject on
		; the same frame or else cause a null-pointer dereference.
		jmp	Poi_Index(pc,d1.w)
	else
		jsr	Poi_Index(pc,d1.w)
		bra.w	DisplaySprite
	endif
; ===========================================================================
Poi_Index:	dc.w Poi_Main-Poi_Index
		dc.w Poi_Slower-Poi_Index
; ===========================================================================

Poi_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Poi_Slower
		move.l	#Map_Points,obMap(a0)			; set mappings
		move.w	#ArtTile_Points|Tile_Pal2,obGfx(a0)	; set art tile and palette
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#1,obPriority(a0)			; set sprite priority (above Sonic)
		move.b	#16/2,obActWid(a0)			; set display width
		move.w	#-$300,obVelY(a0)			; move points object upwards
; ---------------------------------------------------------------------------

Poi_Slower:	; Routine 2
		tst.w	obVelY(a0)				; has point object stopped moving up?
		bpl.w	DeleteObject				; if yes, delete it
		bsr.w	SpeedToPos				; update position based on velocity
		addi.w	#$18,obVelY(a0)				; reduce upward speed
	if FixBugs
		bra.w	DisplaySprite				; display points object
	else
		rts						; return to top Points routine for display
	endif

; ===========================================================================

Map_Animal1:	include	"_maps/Animals 1.asm"
Map_Animal2:	include	"_maps/Animals 2.asm"
Map_Animal3:	include	"_maps/Animals 3.asm"
Map_Points:	include	"_maps/Points.asm"
