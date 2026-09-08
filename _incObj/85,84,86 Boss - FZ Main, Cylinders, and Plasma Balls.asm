; ===========================================================================
; ---------------------------------------------------------------------------
; Object 85 - Eggman (FZ)
; ---------------------------------------------------------------------------

BossFinal_Delete:
		jmp	(DeleteObject).l
; ===========================================================================

BossFinal:
		moveq	#0,d0
		move.b	obRoutine(a0),d0			; copy object routine
		move.w	BossFinal_Index(pc,d0.w),d0		; use the object routine index and BossFinal_Index to calculate our offset
		jmp	BossFinal_Index(pc,d0.w)		; jump into the table and use our offset to pick a routine in the index to go to
; ===========================================================================
BossFinal_Index:
		dc.w BossFinal_Main-BossFinal_Index
		dc.w BossFinal_Eggman-BossFinal_Index
		dc.w BossFinal_Panel-BossFinal_Index
		dc.w BossFinal_Legs-BossFinal_Index
		dc.w BossFinal_Cockpit-BossFinal_Index
		dc.w BossFinal_EmptyShip-BossFinal_Index
		dc.w BossFinal_Flame-BossFinal_Index

BossFinal_ChildCmd:		equ objoff_29			; offset used to send command to child objects, treated as a one-shot (cleared right after command is sent)
BossFinal_AttackState:		equ objoff_30			; offset used to store attack states so other sub-objects can see status
BossFinal_EscapeTimer:		equ objoff_30			; offset used to play the hit sound, wait, and then start exploding as Eggman is fleeing
BossFinal_ChildCounter:		equ objoff_32			; offset used to keep track of how many objects tied to the fight are still executing (for phase control). on the plasma launcher, -1 signifies the plasma phase is over
BossFinal_ParentObj:		equ objoff_34			; pointer to main boss controller, also used for incrementing object routine to save RAM
BossFinal_HitFlash:		equ objoff_35			; offset used to keep track of flashing frames (cylinder pointer overwrites the normally used offset of obBossFlash which is objoff_3E)
BossFinal_PlasmaPtr:		equ objoff_36			; pointer to plasma ball object
BossFinal_CylinderPtr:		equ objoff_38			; pointer to the start of the Cylinder address table, each entry is 2 bytes, so an 8 byte table ending at objoff_3F
; ===========================================================================

BossFinal_ObjData:
		; X pos, Y pos, VRAM setting
		; mappings pointer

		dc.w $100, $100, ArtTile_FZ_Eggman_No_Vehicle
		dc.l Map_SEgg

		dc.w boss_fz_x+$160, boss_fz_y+$80, ArtTile_FZ_Boss
		dc.l Map_EggCyl

		dc.w boss_fz_x+$290, boss_fz_y+$86, ArtTile_FZ_Eggman_Fleeing
		dc.l Map_FZLegs

		dc.w boss_fz_x+$290, boss_fz_y+$86, ArtTile_FZ_Eggman_No_Vehicle
		dc.l Map_SEgg

		dc.w boss_fz_x+$290, boss_fz_y+$86, ArtTile_Eggman
		dc.l Map_Eggman

		dc.w boss_fz_x+$290, boss_fz_y+$86, ArtTile_Eggman
		dc.l Map_Eggman
; ===========================================================================

BossFinal_ObjData2:
		; routine num, animation, sprite priority, width, height
		dc.b 2,	0, 4, 64/2, 50/2
		dc.b 4,	0, 1, 36/2, 16/2
	if FixBugs
		; Legs, cockpit, and flame were not given width or height, so sprite culling is iffy
		dc.b 6,	0, 3, 40/2, 24/2
		dc.b 8,	0, 3, 64/2, 56/2
		dc.b $A, 0, 3, 64/2, 64/2
		dc.b $C, 0, 3, 16/2, 6/2
	else
		dc.b 6,	0, 3, 0, 0
		dc.b 8,	0, 3, 0, 0
		dc.b $A, 0, 3, 64/2, 64/2
		dc.b $C, 0, 3, 0, 0
	endif
; ===========================================================================

BossFinal_Main:	; Routine 0
		lea	BossFinal_ObjData(pc),a2		; load boss object data part 1 and 2
		lea	BossFinal_ObjData2(pc),a3
		movea.l	a0,a1					; copy boss object address
		moveq	#6-1,d1					; set up loop
		bra.s	BossFinal_LoadBoss
; ===========================================================================

BossFinal_Loop:
		jsr	(FindNextFreeObj).l
		bne.s	BossFinal_Skip				; no free objects found, branch

BossFinal_LoadBoss:
		move.b	#id_BossFinal,obID(a1)			; copy boss ID and data, incrementing the table each time
		move.w	(a2)+,obX(a1)
		move.w	(a2)+,obY(a1)
		move.w	(a2)+,obGfx(a1)
		move.l	(a2)+,obMap(a1)
		move.b	(a3)+,obRoutine(a1)
		move.b	(a3)+,obAnim(a1)
		move.b	(a3)+,obPriority(a1)
	if Revision=0
		move.b	(a3)+,obWidth(a1)
	else
		move.b	(a3)+,obActWid(a1)
	endif
		move.b	(a3)+,obHeight(a1)
		move.b	#sprite_cam_field,obRender(a1)		; set render flags and bits
		bset	#sprite_rendered_bit,obRender(a0)
		move.l	a0,BossFinal_ParentObj(a1)		; copy main boss pointer to loaded object
		dbf	d1,BossFinal_Loop			; loop until entire table has been iterated through

; loc_19E20:
BossFinal_Skip:
		lea	BossFinal_PlasmaPtr(a0),a2		; load pointer location for plasma
		jsr	(FindFreeObj).l
		bne.s	.finalSetup				; no free objects found, branch
		move.b	#id_BossPlasma,obID(a1) 		; load plasma ball object
		move.w	a1,(a2)					; store truncated energy ball address
		move.l	a0,BossFinal_ParentObj(a1)		; copy main boss pointer to loaded object
		lea	BossFinal_CylinderPtr(a0),a2		; load pointer location for cylinder
		moveq	#0,d2					; set up cylinder object loop
		moveq	#4-1,d1

; loc_19E3E:
.loop:
		jsr	(FindNextFreeObj).l
		bne.s	.finalSetup				; no free objects found, branch
		move.w	a1,(a2)+				; copy truncated cylinder address and increment
		move.b	#id_EggmanCylinder,obID(a1) 		; load crushing cylinder object
		move.l	a0,BossFinal_ParentObj(a1)		; copy main boss pointer to loaded cylinder
		move.b	d2,obSubtype(a1)			; set cylinder number
		addq.w	#2,d2
		dbf	d1,.loop

; loc_19E5A:
.finalSetup:
		move.w	#0,BossFinal_ParentObj(a0)		; set pointer to itself to 0 for later use
		move.b	#8,obBossHits(a0) 			; set number of hits to 8
		move.w	#-1,BossFinal_AttackState(a0)		; set initial attack flag to -1

BossFinal_Eggman:	; Routine 2
		moveq	#0,d0
		move.b	BossFinal_ParentObj(a0),d0		; copy object routine using this offset, saves an offset
		move.w	BossFinal_Eggman_Index(pc,d0.w),d0	; use the object routine index and Eggman_Index to calculate our offset
		jsr	BossFinal_Eggman_Index(pc,d0.w)		; jump into the index table using the calculated offset
		jmp	(DisplaySprite).l
; ===========================================================================
BossFinal_Eggman_Index:
		dc.w BossFinal_Eggman_Wait-BossFinal_Eggman_Index
		dc.w BossFinal_Eggman_Crush-BossFinal_Eggman_Index
		dc.w BossFinal_Eggman_Plasma-BossFinal_Eggman_Index
		dc.w BossFinal_Eggman_Fall-BossFinal_Eggman_Index
		dc.w BossFinal_Eggman_Run-BossFinal_Eggman_Index
		dc.w BossFinal_Eggman_Jump-BossFinal_Eggman_Index
		dc.w BossFinal_Eggman_Ship-BossFinal_Eggman_Index
		dc.w BossFinal_Eggman_Escape-BossFinal_Eggman_Index
; ===========================================================================

; loc_19E90:
BossFinal_Eggman_Wait:
		tst.l	(v_plc_buffer).w			; is art still being loaded?
		bne.s	.exit					; yes, come back later
		cmpi.w	#boss_fz_x,(v_screenposx).w		; has the screen reached the boss bounds?
		blo.s	.exit					; if not, branch
		addq.b	#2,BossFinal_ParentObj(a0)		; increment routine

; loc_19EA2:
.exit:
		addq.l	#1,(v_random).w				; seed the RNG for the fight
		rts
; ===========================================================================

; loc_19EA8:
BossFinal_Eggman_Crush:
		tst.w	BossFinal_AttackState(a0)		; has a cylinder pair to move already been picked? (see .loadSelectedPair)
		bpl.s	.checkPosition				; if yes, branch
		clr.w	BossFinal_AttackState(a0)		; clear
		jsr	(RandomNumber).l			; generate a random number and return
		andi.w	#$C,d0					; AND to keep the upper two bits of the lower word (this means it will be $0 $4 $8 or $C which is the starting entry of a pair in the cylinder table)
		move.w	d0,d1					; copy and add
		addq.w	#2,d1					; now points at 2nd cylinder in pair
		tst.l	d0					; is random result negative?
		bpl.s	.loadSelectedPair			; if not, branch
		exg.l	d1,d0					; swap the cylinder Eggman is hiding in

; loc_19EC6:
.loadSelectedPair:
		lea	BossFinal_CylinderPairs(pc),a1		; load data for cylinder pairs to move (which was calculated above)
		move.w	(a1,d0.w),d0				; load first cylinder in pair
		move.w	(a1,d1.w),d1				; load second cylinder in pair
		move.w	d0,BossFinal_AttackState(a0)		; set cylinder in which Eggman is hiding in (not actual object address yet) contains either 0 2 4 6
		moveq	#-1,d2					; set up for full address calculation ($FFFFFFFF)
		move.w	BossFinal_CylinderPtr(a0,d0.w),d2	; calculate cylinder object #1 address
		movea.l	d2,a1					; copy calculated address

; d0 will always be the Eggman cylinder. The cylinder that he is in swaps based on skipping the exg.l above
; if d0 contains $4 cylinder and d1 is $6 cylinder, but the random number was negative, then d0 would now contain cylinder $6.
; This controller is constantly set to the position of the Eggman cylinder down in EggmanCylinder routines, so that when it runs
; SolidObject, its hitbox is sitting at the Eggman cylinder. This is slightly backwards from other bosses, the cylinder objects write INTO the controller
; which is why nothing is different between the dummy cylinder, only the occupied cylinder writes up (this is why we are setting things up into a1 and NOT the controller a0)
		move.b	#-1,BossFinal_ChildCmd(a1)		; set command to move
		move.w	#-1,EggmanCylinder_HasEggman(a1)	; mark this cylinder as containing Eggman
		move.w	BossFinal_CylinderPtr(a0,d1.w),d2	; calculate cylinder object #2 address
		movea.l	d2,a1					; copy calculated address
		move.b	#1,BossFinal_ChildCmd(a1) 		; set command to move
		move.w	#0,EggmanCylinder_HasEggman(a1)		; mark this cylinder as empty
		move.w	#1,BossFinal_ChildCounter(a0)		; set cylinder object counter (to keep track of fight phase)
		clr.b	BossFinal_HitFlash(a0)			; clear damage flashing timer
		move.w	#sfx_Rumbling,d0
		jsr	(QueueSound2).l				; play rumbling sound

; loc_19F10:
.checkPosition:
		tst.w	BossFinal_ChildCounter(a0)      	; are all the cylinders done executing?
		bmi.w	.checkDefeat				; if so, branch
		bclr	#0,obStatus(a0)				; make Eggman face left
		move.w	(v_player+obX).w,d0			; get Sonic's X position
		sub.w	obX(a0),d0				; subtract cylinder X from Sonic's X
		bcs.s	.checkCollision				; negative, so keep Eggman facing left
		bset	#0,obStatus(a0)				; flip Eggman's directions

; loc_19F2E:
.checkCollision:
		move.w	#64/2+sonic_solid_width,d1		; set width of object + Sonic's width
		move.w	#40/2,d2				; set half height
		move.w	#40/2,d3				; set standing height
		move.w	obX(a0),d4				; set object X position
		jsr	(SolidObject).l				; calculate collision
		tst.w	d4					; is Sonic colliding with the side of the piston?
		bgt.s	.checkHit				; if yes, branch

; loc_19F48:
.checkFlash:
		tst.b	BossFinal_HitFlash(a0)			; is the boss currently flashing?
		bne.s	.updateFlash				; if yes, branch
		bra.s	.updateAnim				; if not, branch
; ===========================================================================

; loc_19F50:
.checkHit:
		addq.w	#7,(v_random).w				; seed RNG
		cmpi.b	#id_Roll,(v_player+obAnim).w		; is Sonic rolling/jumping?
		bne.s	.checkFlash				; if not, branch
		move.w	#$300,d0				; set up initial velocity
		btst	#0,obStatus(a0)				; is Eggman on the right?
		bne.s	.applyDamage				; if not, branch
		neg.w	d0					; flip velocity

; loc_19F6A:
.applyDamage:
		move.w	d0,(v_player+obVelX).w			; bounce Sonic back
		tst.b	BossFinal_HitFlash(a0)			; is the boss currently flashing?
		bne.s	.updateFlash				; if yes, branch
	if FixBugs
		; Fix underflowing hit counter to 255 on defeat
		tst.b	obBossHits(a0)				; has the boss been defeated?
		beq.s	.animate				; if so, don't let it be hit again
	endif
		subq.b	#1,obBossHits(a0) 			; decrement hits remaining
		move.b	#100,BossFinal_HitFlash(a0)		; set a flash timer for 100 frames
		move.w	#sfx_HitBoss,d0
		jsr	(QueueSound2).l				; play boss damage sound

; loc_19F88:
.updateFlash:
		subq.b	#1,BossFinal_HitFlash(a0)		; subtract 1 from flash timer
		beq.s	.updateAnim				; has flashing hit 0? if so branch
		move.b	#3,obAnim(a0)				; change animation
		bra.s	.animate
; ===========================================================================

.updateAnim:
	if FixBugs
		tst.b	obBossHits(a0)				; has the boss been defeated?
		beq.s	.animate				; if so, don't reset to laugh animation
	endif
		move.b	#1,obAnim(a0)

; loc_19F9C:
.animate:
		lea	Ani_SEgg(pc),a1
		jmp	(AnimateSprite).l
; ===========================================================================

; loc_19FA6:
.checkDefeat:
		tst.b	obBossHits(a0)				; has the boss been defeated?
		beq.s	.defeated				; if so, branch
		addq.b	#2,BossFinal_ParentObj(a0)		; increment object routine
		move.w	#-1,BossFinal_AttackState(a0) 		; reset attack state
		clr.w	BossFinal_ChildCounter(a0)		; clear counter
		rts
; ===========================================================================

; loc_19FBC:
.defeated:
	if Revision<>0
		moveq	#100,d0
		bsr.w	AddPoints
	endif
		move.b	#6,BossFinal_ParentObj(a0)		; set routine to BossFinal_Eggman_Fall
		move.w	#boss_fz_x+$170,obX(a0)			; set location to fall from
		move.w	#boss_fz_y+$2C,obY(a0)
		move.b	#40/2,obHeight(a0)			; set height of Eggman
		rts

; ===========================================================================
; word_19FD6:
BossFinal_CylinderPairs:
		; Possible permutations of the two cylinders that are activated at once.
		; Two words per pair, first one is (normally) the cylinder Eggman is hiding in.
		; 0 = top-left -- 2 = top-right -- 4 = bottom-left -- 6 bottom-right
		dc.w 0, 2
		dc.w 2, 4
		dc.w 4, 6
		dc.w 6, 0
; ===========================================================================

; loc_19FE6:
BossFinal_Eggman_Plasma:
		moveq	#-1,d0					; set up to calculate full address
		move.w	BossFinal_PlasmaPtr(a0),d0		; load table full of lower word pointers
		movea.l	d0,a1					; calculate full address
		tst.w	BossFinal_AttackState(a0)		; is the plasma currently active?
		bpl.s	.soundWait				; if yes, branch
		clr.w	BossFinal_AttackState(a0)		; clear state
		move.b	#-1,BossFinal_ChildCmd(a1)		; tell the launcher to fire plasma
		bsr.s	.playSound

; loc_1A000:
.soundWait:
		moveq	#$F,d0
		and.w	(v_vblank_word).w,d0			; AND the current frame to mask the lower 4 bits
		bne.s	.checkPlasma				; if we are not on a frame multiple of 16, branch
		bsr.s	.playSound				; branch to play electricity sound

; loc_1A00A:
.checkPlasma:
		tst.w	BossFinal_ChildCounter(a0)		; are objects still being executed? (plasma uses 0 as an active flag)
		beq.s	.exit					; if yes, plasma is still there, branch
		subq.b	#2,BossFinal_ParentObj(a0)		; go back a routine
		move.w	#-1,BossFinal_AttackState(a0) 		; set state to idle
		clr.w	BossFinal_ChildCounter(a0)		; clear

; .locret_1A01E:
.exit:
		rts
; ===========================================================================

; loc_1A020:
.playSound:
		move.w	#sfx_Electric,d0
		jmp	(QueueSound2).l				; play electricity sound
; ===========================================================================

; loc_1A02A:
BossFinal_Eggman_Fall:
	if Revision=0
		move.b	#96/2,obWidth(a0)
	else
		move.b	#96/2,obActWid(a0)			; set Eggman's width
	endif
		bset	#0,obStatus(a0)				; make him face to the right
		jsr	(SpeedToPos).l
		move.b	#6,obFrame(a0)				; set current frame
		addi.w	#$10,obVelY(a0)				; add to Y velocity
		cmpi.w	#boss_fz_y+$8C,obY(a0)			; has Eggman reached the Y location?
		blo.s	.skip					; if not, keep falling
		move.w	#boss_fz_y+$8C,obY(a0)			; snap to location
		addq.b	#2,BossFinal_ParentObj(a0)		; increment routine to BossFinal_Eggman_Run
	if Revision=0
		move.b	#64/2,obWidth(a0)
	else
		move.b	#64/2,obActWid(a0)			; set new width
	endif
		move.w	#$100,obVelX(a0)			; set rightward velocity
		move.w	#-$100,obVelY(a0)			; move upwards slightly (a little bounce)
		addq.b	#2,(v_dle_routine).w			; increment dynamic level event

.skip:
		bra.w	BossFinal_EggmanScreenScroll
; ===========================================================================

; loc_1A074:
BossFinal_Eggman_Run:
		bset	#0,obStatus(a0)				; set Eggman to face to the right
		move.b	#4,obAnim(a0)				; set animation
		jsr	(SpeedToPos).l
		addi.w	#$10,obVelY(a0)				; fall down after the initial bounce
		cmpi.w	#boss_fz_y+$93,obY(a0)			; has Eggman reached the Y location?
		blo.s	.runRight				; if not, branch
		move.w	#-$40,obVelY(a0)			; bounce upwards slightly

; loc_1A09A:
.runRight:
		move.w	#$400,obVelX(a0)			; move right faster
		move.w	obX(a0),d0				; copy current X position
		sub.w	(v_player+obX).w,d0			; calculate how close Sonic is to Eggman
		bpl.s	.slowDown				; is Eggman is to the right of Sonic, branch
		move.w	#$500,obVelX(a0)			; Sonic caught up, run faster
		bra.w	.checkPos
; ===========================================================================

; loc_1A0B4:
.slowDown:
		subi.w	#$70,d0					; subtract $70 from value distance
		bcs.s	.checkPos				; if negative, branch
		subi.w	#$100,obVelX(a0)			; slow down
		subq.w	#8,d0					; subtract 8
		bcs.s	.checkPos				; if negative, branch
		subi.w	#$100,obVelX(a0)			; slow down
		subq.w	#8,d0					; subtract 8
		bcs.s	.checkPos				; if negative, branch
		subi.w	#$80,obVelX(a0)				; slow down slightly less
		subq.w	#8,d0					; subtract 8
		bcs.s	.checkPos				; if negative, branch
		subi.w	#$80,obVelX(a0)				; slow down slightly less
		subq.w	#8,d0					; subtract 8
		bcs.s	.checkPos				; if negative, branch
		subi.w	#$80,obVelX(a0)				; slow down slightly less
		subi.w	#$38,d0					; subtract $38
		bcs.s	.checkPos				; if negative, branch
		clr.w	obVelX(a0)				; stop moving entirely

; loc_1A0F2:
.checkPos:
		cmpi.w	#boss_fz_x+$250,obX(a0)			; has Eggman reached this X position?
		blo.s	.exit					; if not, branch
		move.w	#boss_fz_x+$250,obX(a0)			; snap to location
		move.w	#$240,obVelX(a0)			; set rightward velocity for jump
		move.w	#-$4C0,obVelY(a0)			; set upward velocity for jump
		addq.b	#2,BossFinal_ParentObj(a0)		; increment routine to Eggman_Jump

; loc_1A15C:
.exit:
		bra.s	BossFinal_EggmanAnimate
; ===========================================================================

; loc_1A112:
BossFinal_Eggman_Jump:
		jsr	(SpeedToPos).l
		cmpi.w	#boss_fz_x+$290,obX(a0)			; has Eggman reached this X position?
		blo.s	.fall					; if not, branch
		clr.w	obVelX(a0)

; loc_1A124:
.fall:
		addi.w	#$34,obVelY(a0)				; start falling into ship
		tst.w	obVelY(a0)				; check the velocity
		bmi.s	.checkMovement				; if still moving upwards, branch
		cmpi.w	#boss_fz_y+$82,obY(a0)			; has Eggman reached this Y position?
		blo.s	.checkMovement				; he is higher than the Y position, branch
		move.w	#boss_fz_y+$82,obY(a0)			; set to position
		clr.w	obVelY(a0)				; stop moving vertically

; loc_1A142:
.checkMovement:
		move.w	obVelX(a0),d0				; copy X velocity
		or.w	obVelY(a0),d0				; OR with Y velocity
		bne.s	BossFinal_EggmanAnimate			; if he is moving at all, branch
		addq.b	#2,BossFinal_ParentObj(a0)		; increment routine to Eggman_Ship
		move.w	#-$180,obVelY(a0)			; move upwards
		move.b	#1,obBossHits(a0) 			; set number of escaping Eggman hits to 1

; .skip:
BossFinal_EggmanAnimate:
		lea	Ani_SEgg(pc),a1
		jsr	(AnimateSprite).l

; loc_1A166:
BossFinal_EggmanScreenScroll:
		cmpi.w	#boss_fz_end,(v_limitright2).w		; have we finished scrolling to the right?
		bge.s	.setCollision				; if yes, branch
		addq.w	#2,(v_limitright2).w			; keep unlocking the screen by 2 pixels

.setCollision:
		cmpi.b	#$C,BossFinal_ParentObj(a0)		; are we in routine $C (ship)?
		bge.s	.exit					; if yes, branch
		move.w	#32/2+sonic_solid_width,d1		; set ship width + Sonic width
		move.w	#224/2,d2				; set half height
		move.w	#226/2,d3				; set standing height
		move.w	obX(a0),d4				; copy current X position
		jmp	(SolidObject).l
; ===========================================================================

; locret_1A190:
.exit:
		rts
; ===========================================================================

; loc_1A192:
BossFinal_Eggman_Ship:
		move.l	#Map_Eggman,obMap(a0)			; set mappings and art, as well as animation state
		move.w	#ArtTile_Eggman,obGfx(a0)
		move.b	#0,obAnim(a0)
		bset	#0,obStatus(a0)				; face to the right
		jsr	(SpeedToPos).l
		cmpi.w	#boss_fz_y+$34,obY(a0)			; has this Y position been reached?
		bhs.s	.exit					; if not (lower), branch
		move.w	#$180,obVelX(a0)			; set velocity
		move.w	#-$18,obVelY(a0)
		move.b	#col_48x48|col_boss,obColType(a0)	; set collision type
		addq.b	#2,BossFinal_ParentObj(a0)		; increment routine

; loc_1A1D0:
.exit:
		bra.w	BossFinal_EggmanAnimate
; ===========================================================================

; loc_1A1D4:
BossFinal_Eggman_Escape:
		bset	#0,obStatus(a0)				; face to the right
		jsr	(SpeedToPos).l
		tst.w	BossFinal_EscapeTimer(a0)		; has the invincibility timer expired?
		bne.s	.shipHover				; if not, branch
		tst.b	obColType(a0)				; is Eggman's collision enabled?
		bne.s	.watchEggman				; yes, branch
		move.w	#30,BossFinal_EscapeTimer(a0) 		; set a timer for 30 frames
		move.w	#sfx_HitBoss,d0
		jsr	(QueueSound2).l				; play boss damage sound

; loc_1A1FC:
.shipHover:
		subq.w	#1,BossFinal_EscapeTimer(a0)		; decrement timer
		bne.s	.watchEggman				; if timer is above 0, branch
		tst.b	obStatus(a0)				; has Eggman been defeated?
		bpl.s	.setCollision				; if not, branch
		move.w	#$60,obVelY(a0)				; set a slow downward descent

	if FixBugs
		; While this bug isn't obvious due to the bugfix below, it is technically still there.
		; A condition can be met where the exploding cockpit disappears, which then means the explosions do.
		; This allows for the hit sound to start playing every 30 seconds again audibly, since now collision has been disabled
		; and every time we fall through the above checks, we reset the timer and let it decrement, and there are no explosions to
		; override the hit sound. The timer can be forced to always be -1 which will only cause it to decrement from 30 to 0 one time.
		move.w	#-1,BossFinal_EscapeTimer(a0) 		; disable timer
	endif
		bra.s	.watchEggman
; ===========================================================================

; loc_1A210:
.setCollision:
		move.b	#col_48x48|col_boss,obColType(a0)

; loc_1A216:
.watchEggman:
		cmpi.w	#boss_fz_end+$90,(v_player+obX).w	; has Sonic reached this X check?
		blt.s	.ledge					; if not, branch
		move.b	#1,(f_lockctrl).w			; lock controls
		move.w	#0,(v_jpadhold2).w			; clear button inputs
		clr.w	(v_player+obInertia).w			; stop Sonic moving
		tst.w	obVelY(a0)				; is Eggman going down?
		bpl.s	.ending					; if yes, branch
		move.w	#btnUp<<8,(v_jpadhold2).w 		; make Sonic look up if Eggman got away

; loc_1A23A:
.ledge:
		cmpi.w	#boss_fz_end+$E0,(v_player+obX).w	; has Sonic reached the ledge?
		blt.s	.ending					; if not, branch
		move.w	#boss_fz_end+$E0,(v_player+obX).w	; set Sonic to the ledge

; loc_1A248:
.ending:
		cmpi.w	#boss_fz_end+$200,obX(a0)		; has Eggman reached the edge of the boundary?
		blo.s	.exit					; if not, branch
		tst.b	obRender(a0)				; is Eggman fully off screen?
		bmi.s	.exit					; if not, branch
		move.b	#id_Ending,(v_gamemode).w		; set game mode to Ending
	if FixBugs
		; Avoid returning to BossFinal_Eggman to prevent a display-and-delete bug.
		addq.l	#4,sp
	endif
		bra.w	BossFinal_Delete
; ===========================================================================

; loc_1A260:
.exit:
		bra.w	BossFinal_EggmanAnimate
; ===========================================================================

; loc_1A264:
BossFinal_Flame: ; Routine $C
		movea.l	BossFinal_ParentObj(a0),a1		; copy main controller
		move.b	(a1),d0					; copy first byte of parent object
		cmp.b	(a0),d0					; is the object ID (first byte) the same as our own byte?
		bne.w	BossFinal_Delete			; if not, branch
		move.b	#7,obAnim(a0)				; set animation state to 7 (default invisible state for flame)
		cmpi.b	#$C,BossFinal_ParentObj(a1)		; are we in routine $C (Eggman_Ship)?
		bge.s	.checkMove				; if yes (or higher), branch
		bra.s	BossFinal_Display
; ===========================================================================

; loc_1A280:
.checkMove:
		tst.w	obVelX(a1)				; are we currently moving?
		beq.s	.skip					; no, don't display
		move.b	#$B,obAnim(a0)				; yes, display flame

; loc_1A28C:
.skip:
		lea	Ani_Eggman(pc),a1
		jsr	(AnimateSprite).l

; loc_1A296:
BossFinal_FlamePos:
		movea.l	BossFinal_ParentObj(a0),a1		; copy main controller
		move.w	obX(a1),obX(a0)				; copy X and Y of ship
		move.w	obY(a1),obY(a0)

; loc_1A2A6
BossFinal_Display:
		movea.l	BossFinal_ParentObj(a0),a1		; copy main controller
		move.b	obStatus(a1),obStatus(a0)		; copy boss status to flame status
		moveq	#sprite_xflip|sprite_yflip,d0		; set a mask for both flip bits
		and.b	obStatus(a0),d0				; AND obstatus with those flip bits
		andi.b	#~(sprite_xflip|sprite_yflip),obRender(a0) ; clear the x and y flip
		or.b	d0,obRender(a0)				; OR the two together, so now DisplaySprite has X and Y orientation and above render bits
		jmp	(DisplaySprite).l
; ===========================================================================

; loc_1A2C6:
BossFinal_Cockpit: ; Routine 8
		movea.l	BossFinal_ParentObj(a0),a1		; copy main controller
		move.b	(a1),d0					; copy first byte of parent object
		cmp.b	(a0),d0					; is the object ID (first byte) the same as our own byte?
		bne.w	BossFinal_Delete			; if not, branch
		cmpi.l	#Map_Eggman,obMap(a1)			; are the mappings currently set to Eggman?
		beq.s	.escapeFace				; if yes, branch
		move.b	#$A,obFrame(a0)				; set cockpit frame
		bra.s	BossFinal_Display
; ===========================================================================

; loc_1A2E4:
.escapeFace:
		move.b	#1,obAnim(a0)				; set face to normal
		tst.b	obBossHits(a1)				; are any boss hits left?
		ble.s	.explode				; if not, branch
		move.b	#6,obAnim(a0)				; set face to panic/escape
		move.l	#Map_Eggman,obMap(a0)			; copy mappings and art
		move.w	#ArtTile_Eggman,obGfx(a0)
		lea	Ani_Eggman(pc),a1
		jsr	(AnimateSprite).l
		bra.w	BossFinal_FlamePos
; ===========================================================================

; loc_1A312:
.explode:
	if FixBugs=0
		; If you let Eggman go off screen, then move to the right, his cockpit is missing.
		; This is the only one of his sub objects to test for render flags to delete, since
		; his ship stays alive no matter what until it has reached the rightmost part of the level
		; Adding this, along with properly denoting object widths and heights up in the bugfixed ObjData2
		; fixes this bug as well as Eggman getting hidden off screen way too early
		tst.b	obRender(a0)				; has the cockpit left the screen?
		bpl.w	BossFinal_Delete			; if so, branch
	endif
		bsr.w	BossDefeated				; spawn explosions
		move.b	#2,obPriority(a0)			; set priority to 2 in order to overwrite old cockpit, but re-use a few un-damaged cockpit tiles in the middle of the ship
		move.b	#0,obAnim(a0)				; set object animation to 0
		move.l	#Map_FZDamaged,obMap(a0)		; copy damaged mappings and art
		move.w	#ArtTile_FZ_Eggman_Fleeing,obGfx(a0)
		lea	Ani_FZEgg(pc),a1
		jsr	(AnimateSprite).l
		bra.w	BossFinal_FlamePos
; ===========================================================================

; loc_1A346:
BossFinal_Legs:	; Routine 6
		bset	#0,obStatus(a0)				; make legs face to the right
		movea.l	BossFinal_ParentObj(a0),a1		; copy main controller
		cmpi.l	#Map_Eggman,obMap(a1)			; are we in the non-exploding/damaged state?
		beq.s	.legsPosition				; if so, branch
		bra.w	BossFinal_Display			; if not, skip
; ===========================================================================

; loc_1A35E:
.legsPosition:
		move.w	obX(a1),obX(a0)				; copy X and Y of ship
		move.w	obY(a1),obY(a0)
		tst.b	obTimeFrame(a0)				; is there any time left on the animation
		bne.s	.wait					; if so, branch
		move.b	#$14,obTimeFrame(a0)			; no animation time has been set, set it now

; loc_1A376:
.wait:
		subq.b	#1,obTimeFrame(a0)			; decrement timer
		bgt.s	.exit					; if timer still above 0, branch
		addq.b	#1,obFrame(a0)				; increment leg frame
		cmpi.b	#2,obFrame(a0)				; are we on frame 2?
		bgt.w	BossFinal_Delete			; if so, branch

; loc_1A38A:
.exit:
		bra.w	BossFinal_FlamePos
; ===========================================================================

; loc_1A38E:
BossFinal_Panel:	; Routine 4
		move.b	#$B,obFrame(a0)				; set frame
		move.w	(v_player+obX).w,d0			; copy player X
		sub.w	obX(a0),d0				; subtract object position from Sonic's
		bcs.s	.display				; if negative, branch (Sonic is to the left of the object)
		tst.b	obRender(a0)				; is the panel on screen?
		bpl.w	BossFinal_Delete			; if not, branch

; loc_1A3A6:
.display:
		jmp	(DisplaySprite).l
; ===========================================================================

; loc_1A3AC:
BossFinal_EmptyShip: ; Routine $A
		move.b	#0,obFrame(a0)				; set frame to 0
		bset	#0,obStatus(a0)				; face to the right
		movea.l	BossFinal_ParentObj(a0),a1		; copy main controller
		cmpi.b	#$C,BossFinal_ParentObj(a1)		; are we in routine $C (ship)? (this is using the offset OF the parent object, not the actual parent object address itself)
		bne.s	.display				; if not, branch
		cmpi.l	#Map_Eggman,obMap(a1)			; are we in the non-exploding/damaged state?
		beq.w	BossFinal_Delete			; if so, branch

; loc_1A3D0:
.display:
		bra.w	BossFinal_Display
; ===========================================================================


		include	"_anim/FZ Eggman in Ship.asm"
Map_FZDamaged:	include	"_maps/FZ Damaged Eggmobile.asm"
Map_FZLegs:	include	"_maps/FZ Eggmobile Legs.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 84 - cylinder Eggman hides in (FZ)
; ---------------------------------------------------------------------------

EggmanCylinder_Delete:
		jmp	(DeleteObject).l
; ===========================================================================

EggmanCylinder:
		moveq	#0,d0
		move.b	obRoutine(a0),d0			; copy object routine
		move.w	EggmanCylinder_Index(pc,d0.w),d0	; use the object routine index and EggmanCylinder_Index to calculate our offset
		jmp	EggmanCylinder_Index(pc,d0.w)		; jump into the table and use our offset to pick a routine in the index to go to
; ===========================================================================
EggmanCylinder_Index:
		dc.w EggmanCylinder_Main-EggmanCylinder_Index
		dc.w EggmanCylinder_Action-EggmanCylinder_Index
		dc.w EggmanCylinder_Move-EggmanCylinder_Index

EggmanCylinder_HasEggman:	equ objoff_30			; offset used to denote which cylinder in the attacking pair Eggman is hiding in (-1 = Eggman present, 0 = decoy cylinder)
EggmanCylinder_BaseY:		equ objoff_38			; offset used for the base Y position as a fixed-point value
EggmanCylinder_Displacement:	equ objoff_3C			; offset used for a vertical displacement for the cylinder
EggmanCylinder_FracDisplace:	equ objoff_3E			; offset that gets written to when doing vertical displacement, ends up being sub pixel values
; ===========================================================================

EggmanCylinder_PosData:
		dc.w boss_fz_x+$80,  boss_fz_y+$110
		dc.w boss_fz_x+$100, boss_fz_y+$110
		dc.w boss_fz_x+$40,  boss_fz_y-$50
		dc.w boss_fz_x+$C0,  boss_fz_y-$50
; ===========================================================================

EggmanCylinder_Main:	; Routine 0
		lea	EggmanCylinder_PosData(pc),a1		; load cylinder position data table
		moveq	#0,d0
		move.b	obSubtype(a0),d0			; load cylinder number (set when boss was loaded)
		add.w	d0,d0					; double it to set up word based indexing
		adda.w	d0,a1					; add to position data table to find proper cylinder position
		move.b	#sprite_cam_field,obRender(a0)		; set render bits
		bset	#sprite_rendered_bit,obRender(a0)
		bset	#sprite_customheight_bit,obRender(a0)	; set to use actual object height rather than default of 32 pixels
		move.w	#ArtTile_FZ_Boss,obGfx(a0)		; load art and mappings
		move.l	#Map_EggCyl,obMap(a0)
		move.w	(a1)+,obX(a0)				; copy position and increment
		move.w	(a1),obY(a0)				; copy Y and don't increment yet
		move.w	(a1)+,EggmanCylinder_BaseY(a0)		; store same Y as a base position and increment
	if FixBugs=0
		; These are likely the result of the developers fumbling obWidth and
		; obActWidth, which wasn't completely fixed until REV01.
		move.b	#64/2,obHeight(a0)
		move.b	#192/2,obWidth(a0)
	endif
		move.b	#64/2,obActWid(a0)
		move.b	#192/2,obHeight(a0)
		move.b	#3,obPriority(a0)			; set priority
		addq.b	#2,obRoutine(a0)			; increment routine

; loc_1A4CE:
EggmanCylinder_Action: ; Routine 2
		cmpi.b	#2,obSubtype(a0)			; is this a floor cylinder?
		ble.s	.checkAction				; if yes, branch
		bset	#sprite_yflip_bit,obRender(a0)		; ceiling cylinder, flip Y

; loc_1A4DC:
.checkAction:
		clr.l	EggmanCylinder_Displacement(a0)		; clear vertical displacement offset
		tst.b	BossFinal_ChildCmd(a0)			; are we ready to move?
		beq.s	EggmanCylinder_UpdatePos		; if not, branch ahead so we don't start moving
		addq.b	#2,obRoutine(a0)

; loc_1A4EA:
EggmanCylinder_UpdatePos:
		move.l	EggmanCylinder_Displacement(a0),d0	; copy how far we have traveled
		move.l	EggmanCylinder_BaseY(a0),d1		; copy base position
		add.l	d0,d1					; current position
		swap	d1					; swap so that base pixels are in lower word
		move.w	d1,obY(a0)				; set base pixels to object Y
		cmpi.b	#4,obRoutine(a0)			; are we ready to go to the move routine?
		bne.s	.calcFloorFrame				; if not, branch
		tst.w	EggmanCylinder_HasEggman(a0)		; is this cylinder the one holding Eggman? -1 yes, 0 is decoy
		bpl.s	.calcFloorFrame				; if not (0), branch
		moveq	#-$A,d0					; floor cylinder, move 10 pixels up from origin
		cmpi.b	#2,obSubtype(a0)			; is it a floor cylinder?
		ble.s	.setPosition				; if yes (0 or 2) branch
		moveq	#$E,d0					; must be ceiling, move 14 pixels down

; loc_1A514:
.setPosition:
		add.w	d0,d1					; add offset + cylinder position
		movea.l	BossFinal_ParentObj(a0),a1		; copy Eggman object address
		move.w	d1,obY(a1)				; write into Eggman's Y and X (now Eggman's code in BossFinal_Eggman_Crush will run and set his hitbox and check for his collision)
		move.w	obX(a0),obX(a1)

; loc_1A524:
.calcFloorFrame:
		move.w	#64/2+sonic_solid_width,d1		; set up collision and jsr to SolidObject to calculate hitbox
		move.w	#192/2,d2
		move.w	#194/2,d3
		move.w	obX(a0),d4
		jsr	(SolidObject).l
		moveq	#0,d0					; set initial sprite frame
		move.w	EggmanCylinder_Displacement(a0),d1	; copy the pixel half only (3C to 3D offset) first runthrough this is 0 due to the clr.l above
		bpl.s	.calcCeilingFrame			; if positive (ceiling) branch
		neg.w	d1					; negative (floor) so make it positive
		subq.w	#8,d1					; have we traveled 8 pixels yet?
		bcs.s	.checkOffscreen				; no (there was a carry) so branch
		addq.b	#1,d0					; increment sprite frame
		asr.w	#4,d1					; divide by 16
		add.w	d1,d0					; add sprite frame to division result (this means every 16 pixels a new frame is loaded, EXCEPT after the first 8 pixels a new frame is loaded)
		bra.s	.checkOffscreen
; ===========================================================================

; loc_1A550:
.calcCeilingFrame:
		subi.w	#$27,d1					; have we traveled 39 pixels yet?
		bcs.s	.checkOffscreen				; no (there was a carry) so branch
		addq.b	#1,d0					; increment sprite frame
		asr.w	#4,d1					; divide by 16
		add.w	d1,d0					; add sprite frame to division result (this means every 16 pixels a new frame is loaded, EXCEPT after the first 39 pixels a new frame is loaded)

; loc_1A55C:
.checkOffscreen:
		move.b	d0,obFrame(a0)				; set sprite frame
		move.w	(v_player+obX).w,d0			; copy Sonic's X
		sub.w	obX(a0),d0				; subtract Sonic's X and cylinder X
		bmi.s	.exit					; Sonic is left of cylinder, branch
		subi.w	#$140,d0				; subtract 320 (a screen's width) from Sonic's position
		bmi.s	.exit					; Sonic is still within a screen's width to the cylinder, branch
		tst.b	obRender(a0)				; is the cylinder currently on screen?
		bpl.w	EggmanCylinder_Delete			; if not, branch (you can't move back left post-Eggman defeat so this is a guaranteed way to delete the cylinders)

; loc_1A578:
.exit:
		jmp	(DisplaySprite).l
; ===========================================================================

; loc_1A57E:
EggmanCylinder_Move: ; Routine 4
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		move.w	EggmanCylinder_Move_Index(pc,d0.w),d0	; use the object subtype and Move_Index to calculate our offset and determine top or bottom cylinder
		jsr	EggmanCylinder_Move_Index(pc,d0.w)	; jump (but return) into the table and use our offset to pick a routine
		bra.w	EggmanCylinder_UpdatePos		; when done, go and update cylinder position
; ===========================================================================
EggmanCylinder_Move_Index:
		dc.w EggmanCylinder_Bottom-EggmanCylinder_Move_Index	; bottom left
		dc.w EggmanCylinder_Bottom-EggmanCylinder_Move_Index	; bottom right
		dc.w EggmanCylinder_Top-EggmanCylinder_Move_Index	; top left
		dc.w EggmanCylinder_Top-EggmanCylinder_Move_Index	; top right
; ===========================================================================

; loc_1A598:
EggmanCylinder_Bottom:
		tst.b	BossFinal_ChildCmd(a0)			; are we currently attacking?
		bne.s	.extend					; if yes, branch
		movea.l	BossFinal_ParentObj(a0),a1		; copy Eggman's address
		tst.b	obBossHits(a1)				; are there any hits left?
		bne.s	.retract				; if yes, branch
		bsr.w	BossDefeated
		subi.l	#$10000,EggmanCylinder_Displacement(a0)	; retract cylinder at half speed (from 2px to 1px speed)

; loc_1A5B4:
.retract:
		addi.l	#$20000,EggmanCylinder_Displacement(a0)	; retract at 2px a frame
		bcc.s	.exit					; have we reached home (was there a carry)? if not, branch
		clr.l	EggmanCylinder_Displacement(a0)		; clear displacement and go right back to 0
		movea.l	BossFinal_ParentObj(a0),a1		; copy Eggman's address
		subq.w	#1,BossFinal_ChildCounter(a1)		; tell Eggman an object is done executing
		clr.w	BossFinal_AttackState(a1)		; clear attack state so that new cylinder pair can eventually be picked again
		subq.b	#2,obRoutine(a0)			; go back to the Action routine
		rts
; ===========================================================================

; loc_1A5D4:
.extend:
		cmpi.w	#-$10,EggmanCylinder_Displacement(a0)	; has the cylinder traveled more than 16 pixels?
		bge.s	.checkExtension				; if not, branch
		subi.l	#$28000,EggmanCylinder_Displacement(a0)	; yes, add 2.5px of speed

; loc_1A5E4:
.checkExtension:
		subi.l	#$8000,EggmanCylinder_Displacement(a0)	; base value of 0.5px a frame
		cmpi.w	#-$A0,EggmanCylinder_Displacement(a0)	; has the full extension been reached?
		bgt.s	.exit					; if not, branch
		clr.w	EggmanCylinder_FracDisplace(a0)		; clear fractional movement
		move.w	#-$A0,EggmanCylinder_Displacement(a0)	; snap to full extension
		clr.b	BossFinal_ChildCmd(a0)			; clear attacking flag

; locret_1A602:
.exit:
		rts
; ===========================================================================

; loc_1A604:
EggmanCylinder_Top:
		bset	#sprite_yflip_bit,obRender(a0)		; flip sprite to face downwards
		tst.b	BossFinal_ChildCmd(a0)			; are we currently attacking?
		bne.s	.extend					; if yes, branch
		movea.l	BossFinal_ParentObj(a0),a1		; copy Eggman's address
		tst.b	obBossHits(a1)				; are there any hits left?
		bne.s	.retract				; if yes, branch
		bsr.w	BossDefeated
		addi.l	#$10000,EggmanCylinder_Displacement(a0)	; retract cylinder at half speed (from 2px to 1px speed)

; loc_1A626:
.retract:
		subi.l	#$20000,EggmanCylinder_Displacement(a0)	; retract 2px a frame
		bcc.s	.exit					; have we reached home (was there a carry)? if not, branch
		clr.l	EggmanCylinder_Displacement(a0) 	; clear displacement and go right back to 0
		movea.l	BossFinal_ParentObj(a0),a1		; copy Eggman's address
		subq.w	#1,BossFinal_ChildCounter(a1)		; tell Eggman an object is done executing
		clr.w	BossFinal_AttackState(a1)		; clear attack state so that new cylinder pair can eventually be picked again
		subq.b	#2,obRoutine(a0)			; go back to the Action routine
		rts
; ===========================================================================

; loc_1A646:
.extend:
		cmpi.w	#$10,EggmanCylinder_Displacement(a0)	; has the cylinder traveled more than 16 pixels?
		blt.s	.checkExtension				; if not, branch
		addi.l	#$28000,EggmanCylinder_Displacement(a0)	; yes, add 2.5px of speed

; loc_1A656:
.checkExtension:
		addi.l	#$8000,EggmanCylinder_Displacement(a0)	; base value of 0.5px a frame
		cmpi.w	#$A0,EggmanCylinder_Displacement(a0)	; has the full extension been reached?
		blt.s	.exit					; if not, branch
		clr.w	EggmanCylinder_FracDisplace(a0)		; clear fractional movement
		move.w	#$A0,EggmanCylinder_Displacement(a0)	; snap to full extension
		clr.b	BossFinal_ChildCmd(a0)			; clear attacking flag

; locret_1A674
.exit:
		rts
; ===========================================================================

Map_EggCyl:	include	"_maps/FZ Eggman's Cylinders.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 86 - energy balls (FZ)
; ---------------------------------------------------------------------------

BossPlasma:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	BossPlasma_Index(pc,d0.w),d0		; use the object routine index and BossPlasma_Index to calculate our offset
		jmp	BossPlasma_Index(pc,d0.w)		; jump into the table and use our offset to pick a routine
; ===========================================================================
BossPlasma_Index:
		dc.w BossPlasma_Main-BossPlasma_Index
		dc.w BossPlasma_Generator-BossPlasma_Index
		dc.w BossPlasma_MakeBalls-BossPlasma_Index
		dc.w BossPlasma_Finish-BossPlasma_Index
		dc.w BossPlasma_Balls-BossPlasma_Index

BossPlasma_TargetX:		equ objoff_30			; offset used to keep track of the target X position in each ball phase, re-used once to set up X spread offsets when first spawning
BossPlasma_BallsAlive:		equ objoff_38			; offset used to keep track of how many plasma balls are still alive
; ===========================================================================

BossPlasma_Main:	; Routine 0
		move.w	#boss_fz_x+$138,obX(a0)			; set initial X and Y
		move.w	#boss_fz_y+$2C,obY(a0)
		move.w	#ArtTile_FZ_Boss,obGfx(a0)		; load art and mappings
		move.l	#Map_PLaunch,obMap(a0)
		move.b	#0,obAnim(a0)				; set initial animation frame
		move.b	#3,obPriority(a0)			; set priority, width, and height
		move.b	#16/2,obWidth(a0)
		move.b	#16/2,obHeight(a0)
		move.b	#sprite_cam_field,obRender(a0)		; set render bits
		bset	#sprite_rendered_bit,obRender(a0)
		addq.b	#2,obRoutine(a0)			; increment routine

BossPlasma_Generator:; Routine 2
		movea.l	BossFinal_ParentObj(a0),a1		; copy Eggman's address
		cmpi.b	#6,BossFinal_ParentObj(a1)		; are we in routine 6 (Fall routine)?
		bne.s	.checkStatus				; if not, branch
		move.b	#id_Explosion,obID(a0)			; change object to explosion
		move.b	#0,obRoutine(a0)			; set object routine of new explosion object
		jmp	(DisplaySprite).l
; ===========================================================================

; loc_1A850:
.checkStatus:
		move.b	#0,obAnim(a0)				; set animation to 0
		tst.b	BossFinal_ChildCmd(a0)			; has the controller told us to attack?
		beq.s	BossPlasma_Collision			; if not, branch
		addq.b	#2,obRoutine(a0)			; increment to MakeBalls
		move.b	#1,obAnim(a0)				; set animation to 1
		move.b	#62,obSubtype(a0)			; use offset to set a timer

; loc_1A86C:
BossPlasma_Collision:
		move.w	#16/2+sonic_solid_width,d1		; set up collision
		move.w	#16/2,d2
		move.w	#34/2,d3
		move.w	obX(a0),d4
		jsr	(SolidObject).l
		move.w	(v_player+obX).w,d0			; copy Sonic's X
		sub.w	obX(a0),d0				; subtract with plasma's X
		bmi.s	.display				; if Sonic is to the left of the plasma, branch
		subi.w	#$140,d0				; subtract 320 (a screen's width) from Sonic's position
		bmi.s	.display				; Sonic is within a screen's width, branch
		tst.b	obRender(a0)				; is the plasma currently on screen?
		bpl.w	EggmanCylinder_Delete			; if so, branch

; loc_1A89A:
.display:
		lea	Ani_PLaunch(pc),a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================

BossPlasma_MakeBalls:; Routine 4
		tst.b	BossFinal_ChildCmd(a0)			; are we currently attacking?
		beq.w	.checkStatus				; if not, branch
		clr.b	BossFinal_ChildCmd(a0)			; clear flag so it only runs once

	if UnusedOptimization=0
; Seemingly dead code here as a2 is never used anywhere, possibly an old table lookup?
		add.w	BossPlasma_TargetX(a0),d0
		andi.w	#$1E,d0
		adda.w	d0,a2
	endif

		addq.w	#4,BossPlasma_TargetX(a0)		; increment spread offset (to spread the ball out horizontally when spawning)
		clr.w	BossFinal_ChildCounter(a0)		; clear ball counter
		moveq	#3,d2					; set to loop 4 times

; BossPlasma_Loop:
.loop:
		jsr	(FindNextFreeObj).l
		bne.w	.checkStatus				; no free objects found, branch
		move.b	#id_BossPlasma,obID(a1)			; set object ID to plasma
		move.w	obX(a0),obX(a1)				; copy position
		move.w	#boss_fz_y+$2C,obY(a1)			; set Y location
		move.b	#8,obRoutine(a1)			; set routine to Balls
		move.w	#ArtTile_FZ_Boss|Tile_Pal2,obGfx(a1)	; copy art and mappings
		move.l	#Map_Plasma,obMap(a1)
		move.b	#24/2,obHeight(a1)			; copy height and collisions
		move.b	#24/2,obWidth(a1)
		move.b	#col_none,obColType(a1)
		move.b	#3,obPriority(a1)			; set priority
		move.w	#62,obSubtype(a1)			; set timer and also zero out ChildCmd
		move.b	#sprite_cam_field,obRender(a1)		; set render bits
		bset	#sprite_rendered_bit,obRender(a1)
		move.l	a0,BossFinal_ParentObj(a1)		; copy parent object address
		jsr	(RandomNumber).l
		move.w	BossFinal_ChildCounter(a0),d1		; copy back since RandomNumber also uses d1
	if FixBugs
		; compensation for the fix in BossPlasma_Drop
		muls.w	#-$59,d1				; spacing for balls
	else
		muls.w	#-$4F,d1
	endif
		addi.w	#boss_fz_x+$128,d1			; start at the rightmost position
		andi.w	#$1F,d0					; AND to keep 5 bits of the random number (0-31)
		subi.w	#$10,d0					; subtract by 16 to center it
		add.w	d1,d0					; set ball offset
		move.w	d0,BossPlasma_TargetX(a1)		; store the ball's target X
		addq.w	#1,BossFinal_ChildCounter(a0)		; count this ball
		move.w	BossFinal_ChildCounter(a0),BossPlasma_BallsAlive(a0) ; copy counter
		dbf	d2,.loop				; repeat sequence 3 more times

; loc_1A954:
.checkStatus:
		tst.w	BossFinal_ChildCounter(a0)		; are there still balls that need to reach their X position before dropping? (modified down in Plasma_Balls)
		bne.s	.exit					; if yes, exit
		addq.b	#2,obRoutine(a0)			; increment to Finish

; loc_1A95E:
.exit:
		bra.w	BossPlasma_Collision
; ===========================================================================

; loc_1A962:
BossPlasma_Finish: ; Routine 6
		move.b	#2,obAnim(a0)				; set animation type for launcher
		tst.w	BossPlasma_BallsAlive(a0)		; are there any balls still alive?
		bne.s	.exit					; if yes, exit
		move.b	#2,obRoutine(a0)			; set routine to Generator
		movea.l	BossFinal_ParentObj(a0),a1		; copy Eggman's address
		move.w	#-1,BossFinal_ChildCounter(a1)		; relay signal that balls are all gone

; loc_1A97E:
.exit:
		bra.w	BossPlasma_Collision
; ===========================================================================

; loc_1A982:
BossPlasma_Balls: ; Routine 8
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	BossPlasma_Index2(pc,d0.w),d0		; use the object routine index and BossPlasma_Index2 to calculate our offset
		jsr	BossPlasma_Index2(pc,d0.w)		; jump into the table and use our offset to pick a routine
		lea	Ani_Plasma(pc),a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================
BossPlasma_Index2:
		dc.w BossPlasma_Spread-BossPlasma_Index2
		dc.w BossPlasma_Drop-BossPlasma_Index2
		dc.w BossPlasma_Move-BossPlasma_Index2
; ===========================================================================

; loc_1A9A6:
BossPlasma_Spread:
		move.w	BossPlasma_TargetX(a0),d0		; copy target X
		sub.w	obX(a0),d0				; subtract distance from generator to target
		asl.w	#4,d0					; multiply by 16
		move.w	d0,obVelX(a0)				; set that as velocity
		move.w	#180,obSubtype(a0)			; set a timer for 180 frames
		addq.b	#2,ob2ndRout(a0)			; increment to Drop
		rts
; ===========================================================================

; loc_1A9C0:
BossPlasma_Drop:
		tst.w	obVelX(a0)				; are we currently set to move?
		beq.s	.aim					; if not, branch
		jsr	(SpeedToPos).l				; calculate movement
		move.w	obX(a0),d0				; copy current X
		sub.w	BossPlasma_TargetX(a0),d0		; subtract current X from target X
		bcc.s	.aim					; have we reached the target starting X? if not, branch (moving from right to left so if there is no carry, then too far left)
		clr.w	obVelX(a0)				; target reached, stop
	if FixBugs
		sub.w	d0,obX(a0)
	else
		; this is intended to keep the leftmost energy ball in bounds,
		; but it actually pushes it FURTHER to the left
		add.w	d0,obX(a0)
	endif
		movea.l	BossFinal_ParentObj(a0),a1
		subq.w	#1,BossFinal_ChildCounter(a1)

; loc_1A9E6:
.aim:
		move.b	#0,obAnim(a0)				; set animation type to hovering
		subq.w	#1,obSubtype(a0)			; decrement timer
		bne.s	.exit					; not ready to drop yet, exit
		addq.b	#2,ob2ndRout(a0)			; increment routine to Move
		move.b	#1,obAnim(a0)				; set animation type to attacking
		move.b	#col_24x24|col_hurt,obColType(a0)	; enable collision
		move.w	#180,obSubtype(a0)			; set another timer for 180 frames
		moveq	#0,d0
		move.w	(v_player+obX).w,d0			; copy Sonic's X
		sub.w	obX(a0),d0				; subtract ball position
		move.w	d0,obVelX(a0)				; aim in the direction of Sonic
		move.w	#$140,obVelY(a0)			; start falling downwards

; locret_1AA1C:
.exit:
		rts
; ===========================================================================

; loc_1AA1E:
BossPlasma_Move:
		jsr	(SpeedToPos).l
		cmpi.w	#boss_fz_y+$D0,obY(a0)			; have we reached the bottom of the screen?
		bhs.s	.deleteChild				; if yes, branch
		subq.w	#1,obSubtype(a0)			; decrement timer
		beq.s	.deleteChild				; has timer hit 0? if so, branch
		rts
; ===========================================================================

; loc_1AA34:
.deleteChild:
		movea.l	BossFinal_ParentObj(a0),a1		; copy ball launcher's address
		subq.w	#1,BossPlasma_BallsAlive(a1)		; decrement ball count
	if FixBugs
		; Avoid returning to BossPlasma_Balls to prevent a display-and-delete bug.
		addq.l	#4,sp
	endif
		bra.w	EggmanCylinder_Delete
; ===========================================================================

		include	"_anim/Plasma Ball Launcher.asm"
Map_PLaunch:	include	"_maps/Plasma Ball Launcher.asm"
		include	"_anim/Plasma Balls.asm"
Map_Plasma:	include	"_maps/Plasma Balls.asm"
