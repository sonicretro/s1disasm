; ---------------------------------------------------------------------------
; Object 73 - Eggman (MZ)
; ---------------------------------------------------------------------------

BossMarble:
		moveq	#0,d0
		move.b	obRoutine(a0),d0			; copy object routine
		move.w	BossMarble_Index(pc,d0.w),d1		; use the object routine index and BossMarble_Index to calculate our offset
		jmp	BossMarble_Index(pc,d1.w)		; jump into the table and use our offset to pick a routine in the index to go to
; ===========================================================================
BossMarble_Index:
		dc.w BossMarble_Main-BossMarble_Index
		dc.w BossMarble_ShipMain-BossMarble_Index
		dc.w BossMarble_FaceMain-BossMarble_Index
		dc.w BossMarble_FlameMain-BossMarble_Index
		dc.w BossMarble_TubeMain-BossMarble_Index

BossMarble_ParentObj = objoff_34 				; Pointer to main boss controller
BossMarble_SineCounter = objoff_3F				; sine counter for bobbing motion
BossMarble_GenericTimer	= objoff_3C				; ; timer for how many frames to do an action, whether its wait for explosions, or to move in a direction

BossMarble_ObjData:
		dc.b 2,	0, 4					; routine number, animation, priority
		dc.b 4,	1, 4
		dc.b 6,	7, 4
		dc.b 8,	0, 3
; ===========================================================================

BossMarble_Main:	; Routine 0
		move.w	obX(a0),obBossX(a0)			; copy to boss position using scratch RAM (objoff_30 and 38 respectively)
		move.w	obY(a0),obBossY(a0)
		move.b	#col_48x48|col_boss,obColType(a0)	; set collision type: TTSS SSSS. T bits are for type, S is size of collision using table in sub ReactToItem.asm
		move.b	#8,obBossHits(a0) 			; set number of hits to 8
		lea	BossMarble_ObjData(pc),a2		; load routine data address into a2 (this does one less memory access than the GHZ boss, its faster and it seems the developers wanted to stick with PC-relative going forward)
		movea.l	a0,a1					; copy boss object address into a1 so that LoadBoss on pass 1 uses the main boss object.
		moveq	#3,d1					; 4 slots of ObjData, so to load properly we must loop 4 times
		bra.s	BossMarble_LoadBoss
; ===========================================================================

BossMarble_Loop:
		jsr	(FindNextFreeObj).l			; are there any free objects?
		bne.s	BossMarble_ShipMain			; no, leave early
		_move.b	#id_BossMarble,obID(a1)			; set object ID for this slot
		move.w	obX(a0),obX(a1)				; set object position to boss position
		move.w	obY(a0),obY(a1)

BossMarble_LoadBoss:
		bclr	#0,obStatus(a0)				; clear the x orientation bit
		clr.b	ob2ndRout(a1)				; clear second routine status (ShipIndex below)
		move.b	(a2)+,obRoutine(a1)			; load first objData byte and increment
		move.b	(a2)+,obAnim(a1)
		move.b	(a2)+,obPriority(a1)
		move.l	#Map_Eggman,obMap(a1)			; load mappings and graphics for the object
		move.w	#ArtTile_Eggman,obGfx(a1)
		move.b	#sprite_cam_field,obRender(a1)		; set the object to position based on where it is in the level and not a static position on screen
		move.b	#64/2,obActWid(a1)			; set collision to 20 pixel radius box

; objoff_34 is used here as a reference back to the main boss controller. 
; This is because when we are in ExecuteObjects, a0 is set to each object and sub objects own slot, so we need a way to find the original boss object.
; On the first loop, this copies the address to itself, but the other loops are what it was intended for.		
		move.l	a0,BossMarble_ParentObj(a1)			

		dbf	d1,BossMarble_Loop			; repeat sequence 3 more times

BossMarble_ShipMain:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0			; load secondary routine index of current object slot into d0
		move.w	BossMarble_ShipIndex(pc,d0.w),d1	; use the secondary object routine index and ShipIndex to calculate our offset
		jsr	BossMarble_ShipIndex(pc,d1.w)		; jump into the table and use our offset to pick a routine in the index to go to
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l
; ---------------------------------------------------------------------------
; obStatus stores the logical bits, but obRender is visual bits, so this simply moves them from one to the other
; ---------------------------------------------------------------------------
		moveq	#sprite_xflip|sprite_yflip,d0		; move first two bits into d0
		and.b	obStatus(a0),d0				; AND with obStatus so now d0 contains X and Y logical flip bits only
		andi.b	#~(sprite_xflip|sprite_yflip),obRender(a0) ; clear the x and y flip
		or.b	d0,obRender(a0)				; OR the two together, so now DisplaySprite has X and Y orientation and above render bits
		jmp	(DisplaySprite).l
; ===========================================================================
BossMarble_ShipIndex:
		dc.w BMZ_ShipStart-BossMarble_ShipIndex
		dc.w BMZ_ShipMove-BossMarble_ShipIndex
		dc.w BMZ_Explode-BossMarble_ShipIndex
		dc.w BMZ_Recover-BossMarble_ShipIndex
		dc.w BMZ_Escape-BossMarble_ShipIndex
; ===========================================================================

; loc_18302:
BMZ_ShipStart:
		move.b	BossMarble_SineCounter(a0),d0
		addq.b	#2,BossMarble_SineCounter(a0)		; increment sine counter by 2 (to iterate through the sine table)
		jsr	(CalcSine).l				; unlike GHZ, this starts at 2 instead of 0
		asr.w	#2,d0					; shift right by 2 bits (divide by 4), keeping signed number status
		move.w	d0,obVelY(a0)				; offset Y position with sine value
		move.w	#-$100,obVelX(a0)			; set initial X speed (moving to the left)
		bsr.w	BossMove				
		cmpi.w	#boss_mz_x+$110,obBossX(a0)		; have we reached our bounds?
		bne.s	.continue				; no, keep going
		addq.b	#2,ob2ndRout(a0)			; increment routine counter by 2 (now in ShipMove)
		clr.b	obSubtype(a0)				; clear object subtype
		clr.l	obVelX(a0)				; stop moving horizontally

; loc_18334
.continue:
		jsr	(RandomNumber).l			; roll a random number
		move.b	d0,BossMarble_ParentObj(a0)		; use same object offset as pointer reference (except for a0) to store number

; loc_1833E
BMZ_ShipUpdate:
		move.w	obBossY(a0),obY(a0)			; copy to boss position using scratch RAM (objoff_30 and 38 respectively)
		move.w	obBossX(a0),obX(a0)
		cmpi.b	#4,ob2ndRout(a0)			; are we exploding or escaping?
		bhs.s	.exit					; if yes, branch
		tst.b	obStatus(a0)				; has Eggman's defeated flag been set (bit 7)?
		bmi.s	BMZ_Defeated				; if yes (negative number) branch
		tst.b	obColType(a0)				; is the boss hittable?
		bne.s	.exit					; if not, leave
		tst.b	obBossFlash(a0)				; is this a non-zero value (collision disabled if so, must mean boss is already flashing)
		bne.s	.flash					; we are flashing already, skip ahead
		move.b	#$28,obBossFlash(a0)			; set number of times to flash (for some reason 8 more than most bosses)
		move.w	#sfx_HitBoss,d0
		jsr	(QueueSound2).l				; play boss damage sound

; loc_18374
.flash:
		lea	(v_palette+$22).w,a1			; load 2nd palette, 2nd entry
		moveq	#0,d0					; move 0 (black) to d0
		tst.w	(a1)					; is the color here black? This is a cool trick, since tst will set its flags based on if the value is 0. What color is black? All 0s!
		bne.s	.writeColor				; if not black, already white, so branch
		move.w	#cWhite,d0				; move 0EEE (white) to d0

; loc_18382
.writeColor:
		move.w	d0,(a1)					; load color stored in d0
		subq.b	#1,obBossFlash(a0)			; subtract 1 from flash timer
		bne.s	.exit					; keep flashing if obBossFlash is not 0
		move.b	#col_48x48|col_boss,obColType(a0)	; restore collision, the timer has hit 0

; locret_18390
.exit:
		rts
; ===========================================================================

; loc_18392
BMZ_Defeated:
		moveq	#100,d0
		bsr.w	AddPoints
		move.b	#4,ob2ndRout(a0)			; set object routine to BMZ_Recover
		move.w	#180,BossMarble_GenericTimer(a0)	; set the boss timer
		clr.w	obVelX(a0)				; stop moving horizontally
		rts
; ===========================================================================

; loc_183AA:
BMZ_ShipMove:
		moveq	#0,d0
		move.b	obSubtype(a0),d0			; move obSubtype
		move.w	BMZ_ShipMove_Index(pc,d0.w),d0		; use obSubtype and ShipMove_Index to calculate our offset
		jsr	BMZ_ShipMove_Index(pc,d0.w)		; jump into the table and use our offset to pick a routine in the index to go to
		andi.b	#6,obSubtype(a0)			; AND obSubtype with 6 to mask bits 2 and 3, the only bits needed to represent our 0 through 6 index (it seems they may have used this offset for other temp storage as well)
		bra.w	BMZ_ShipUpdate
; ===========================================================================
BMZ_ShipMove_Index: dc.w BMZ_ChgDir-BMZ_ShipMove_Index
		dc.w BMZ_DropFire-BMZ_ShipMove_Index
		dc.w BMZ_ChgDir-BMZ_ShipMove_Index
		dc.w BMZ_DropFire-BMZ_ShipMove_Index
; ===========================================================================

; loc_183CA:
BMZ_ChgDir:
		tst.w	obVelX(a0)				; are we currently moving horizontally?
		bne.s	.skip					; if yes, branch
		moveq	#$40,d0					; set up downward velocity
		cmpi.w	#boss_mz_y+$1C,obBossY(a0)		; where are we in relation to this Y position?
		beq.s	.swoop					; right at the target, start swooping
		bcs.s	.above					; above the target, keep d0 positive to move down
		neg.w	d0					; below the target, negate to move up

; loc_183DE
.above:
		move.w	d0,obVelY(a0)
		bra.w	BossMove
; ===========================================================================

; loc_183E6
.swoop:
		move.w	#$200,obVelX(a0)			; set horizontal velocity
		move.w	#$100,obVelY(a0)			; set vertical velocity
		btst	#0,obStatus(a0)				; are we facing to the right?
		bne.s	.skip					; if yes, keep positive x
		neg.w	obVelX(a0)				; no, flip leftward

; loc_183FE
.skip:
		cmpi.b	#$18,obBossFlash(a0)			; has Eggman recently been hit? (this adds a short delay of flashing, then starts moving again)
		bhs.s	BossMarble_MakeLava			; if yes, freeze movement
		bsr.w	BossMove				; if no, keep moving
		subq.w	#4,obVelY(a0)				; subtract y velocity to make his swoop do a U shape

BossMarble_MakeLava:
		subq.b	#1,BossMarble_ParentObj(a0)		; subtract 1 from the random number storage
		bcc.s	.checkRight				; has the frame countdown spawn timer expired? if not, branch
		jsr	(FindFreeObj).l				; timer has expired, find a free object slot
		bne.s	.generateTimer				; no free objects, leave early
		_move.b	#id_LavaBall,obID(a1) 			; load lava ball object
		move.w	#boss_mz_y+$D8,obY(a1)			; set Y position to initially spawn from
		jsr	(RandomNumber).l
		andi.l	#$FFFF,d0				; mask to keep lower word only
		divu.w	#$50,d0					; divide by $50, remainder is in upper word, result is in lower (remainder is 0 to $4F)
		swap	d0					; swap so our remainder is now in lower word
		addi.w	#boss_mz_x+$78,d0			; add the X offset to far left boundary to "clamp" to the lava pool range
		move.w	d0,obX(a1)				; set x position to calculated position
		lsr.b	#7,d1					; shift whatever is in d1's first byte over by 7, to contain only 0 or 1

; This line may trick you at first sight, but it actually serves two purposes. It is important to note that
; this instruction is a move.w with an immediate size of a byte. This means that the immediate actually gets zero-extended
; to $00FF. Object offsets in Sonic 1 are a single byte in size. The 68000 is also big endian, meaning the high byte gets written first. 
; 00 gets written to objoff_28 (obSubtype) and FF gets written to objoff_29 which is used for a single check to adjust render priority in 14 Lava Ball.asm
; So, this is NOT setting the subtype to FF, rather it is writing two bytes used for the lava flame in one instruction to save some time.
		move.w	#$FF,obSubtype(a1)


; loc_1844A
.generateTimer:
		jsr	(RandomNumber).l			; use d1 as a pseudo-random seeder for d0
		andi.b	#$1F,d0					; mask to $1F			
		addi.b	#$40,d0					; add $40, forcing range to be $40-$5F
		move.b	d0,BossMarble_ParentObj(a0)		; store new countdown timer

; loc_1845C
.checkRight:
		btst	#0,obStatus(a0)				; are we facing to the right?
		beq.s	.checkLeft				; no, branch
		cmpi.w	#boss_mz_x+$110,obBossX(a0)		; are we at the right side of the screen?
		blt.s	.exit					; if not, branch
		move.w	#boss_mz_x+$110,obBossX(a0)		; set x position to rightmost side of the screen (clamp)
		bra.s	.rise				
; ===========================================================================

; loc_18474
.checkLeft:
		cmpi.w	#boss_mz_x+$30,obBossX(a0)		; are we at the left side of the screen?
		bgt.s	.exit					; if not, branch
		move.w	#boss_mz_x+$30,obBossX(a0)		; set x position to leftmost side of the screen (clamp)

; loc_18482
.rise:
		clr.w	obVelX(a0)				; stop horizontal movement
		move.w	#-$180,obVelY(a0)			; start rising upwards
		cmpi.w	#boss_mz_y+$1C,obBossY(a0)		; are we high enough?
		bhs.s	.advance				; if not, branch
		neg.w	obVelY(a0)				; yes, we are above target, go down

; loc_18498
.advance:
		addq.b	#2,obSubtype(a0)			; increment to go to next routine

; locret_1849C
.exit:
		rts
; ===========================================================================

; BossMarble_MakeLava2:
BMZ_DropFire:
		bsr.w	BossMove
		move.w	obBossY(a0),d0				; copy y position to d0
		subi.w	#boss_mz_y+$1C,d0			; subtract y position with upper bound
		bgt.s	.exit					; still rising upwards, exit
		move.w	#boss_mz_y+$1C,d0			; reached the upper bound (clamp)
		tst.w	obVelY(a0)				; are we moving vertically at all?
		beq.s	.skip					; if not, branch
		clr.w	obVelY(a0)				; stop vertical movement
		move.w	#80,BossMarble_GenericTimer(a0)		; set a timer for 80 frames
		bchg	#0,obStatus(a0)				; flip direction so that his back is to the screen bound
		jsr	(FindFreeObj).l				; are there any free objects?
		bne.s	.skip					; no, leave early
		move.w	obBossX(a0),obX(a1)			; copy boss positions to object positions
		move.w	obBossY(a0),obY(a1)
		addi.w	#$18,obY(a1)				; set offset to lower object
		move.b	#id_BossFire,obID(a1)			; load lava ball object
		move.b	#1,obSubtype(a1)			; set subtype to 1

; loc_184EA
.skip:
		subq.w	#1,BossMarble_GenericTimer(a0)		; has the timer hit 0?
		bne.s	.exit					; if not, branch
		addq.b	#2,obSubtype(a0)			; increment the routine counter

;locret_184F4
.exit:
		rts
; ===========================================================================

; loc_184F6:
BMZ_Explode:
		subq.w	#1,BossMarble_GenericTimer(a0)		; has the timer reached 0?
		bmi.s	.transition				; if yes, branch
		bra.w	BossDefeated				; explosions still going
; ===========================================================================

; loc_18500
.transition:
		bset	#0,obStatus(a0)				; set x flip bit so we face right
		bclr	#7,obStatus(a0)				; clear the defeated flag
		clr.w	obVelX(a0)				; stop horizontal movement
		addq.b	#2,ob2ndRout(a0)			; increment the routine counter
		move.w	#-38,BossMarble_GenericTimer(a0)	; set a timer for 38 frames
		tst.b	(v_bossstatus).w			; has boss been marked as defeated?
		bne.s	.skip					; yes, skip
		move.b	#1,(v_bossstatus).w			; no, mark it as defeated but not capsule open
		clr.w	obVelY(a0)				; stop vertical movement

; locret_1852A
.skip:
		rts
; ===========================================================================

; loc_1852C:
BMZ_Recover:
		addq.w	#1,BossMarble_GenericTimer(a0)		; has the timer reached 0?
		beq.s	.doneFalling				; if yes, branch
		bpl.s	.timerPositive				; if the timer is larger than 0, branch
		cmpi.w	#boss_mz_y+$60,obBossY(a0)		; have we reached the y boundary?
		bhs.s	.doneFalling				; if yes, branch
		addi.w	#$18,obVelY(a0)				; no, keep falling
		bra.s	.exit
; ===========================================================================

; loc_18544
.doneFalling:
		clr.w	obVelY(a0)				; stop vertical movement
		clr.w	BossMarble_GenericTimer(a0)		; clear the timer
		bra.s	.exit
; ===========================================================================

.timerPositive:
		cmpi.w	#48,BossMarble_GenericTimer(a0)		; has the timer reached 48 frames?
		blo.s	.rise					; if not, branch
		beq.s	.playMusic				; stop and play music
		cmpi.w	#56,BossMarble_GenericTimer(a0)		; has the timer reached 56 frames?
		blo.s	.exit					; if not, branch
		addq.b	#2,ob2ndRout(a0)			; increment routine counter
		bra.s	.exit
; ===========================================================================

; loc_18566
.rise:
		subq.w	#8,obVelY(a0)				; slow down, eventually causing him to rise
		bra.s	.exit
; ===========================================================================

.playMusic:
		clr.w	obVelY(a0)				; stop rising
		move.w	#bgm_MZ,d0
		jsr	(QueueSound1).l				; play MZ music

; loc_1857A
.exit:
		bsr.w	BossMove
		bra.w	BMZ_ShipUpdate
; ===========================================================================

; loc_18582:
BMZ_Escape:
		move.w	#$500,obVelX(a0)			; move to the right quickly
		move.w	#-$40,obVelY(a0)			; move up a little bit
		cmpi.w	#boss_mz_end,(v_limitright2).w		; have we finished scrolling to the right (reached level bounds)?
		bhs.s	.checkOffScreen				; if yes, branch
		addq.w	#2,(v_limitright2).w			; keep unlocking the bounds of the screen by 2 pixels 
		bra.s	.flee
; ===========================================================================

; loc_1859C
.checkOffScreen:
		tst.b	obRender(a0)				; has Eggman left the screen (is bit 7 clear)?
		bpl.s	BossMarble_ShipDel			; yes, bit 7 is cleared, so we can delete the object (this leverages signed numbers!)

; loc_185A2
.flee:
		bsr.w	BossMove
		bra.w	BMZ_ShipUpdate
; ===========================================================================

BossMarble_ShipDel:
	if FixBugs
		; Avoid returning to BossMarble_ShipMain to prevent a
		; display-and-delete bug.
		addq.l	#4,sp
	endif
		jmp	(DeleteObject).l
; ===========================================================================

BossMarble_FaceMain:	; Routine 4
		moveq	#0,d0
		moveq	#1,d1					; set facenormal1 animation
		movea.l	BossMarble_ParentObj(a0),a1		; load the main boss controller
		move.b	ob2ndRout(a1),d0			; load boss phase
		subq.w	#2,d0					; go back one routine
		bne.s	.checkSpecial				; were we at DropFire? if not, branch
		btst	#1,obSubtype(a1)			; are we on index 2 or 6?
		beq.s	.checkHitState				; if not, we are ChgDir, branch
		tst.w	obVelY(a1)				; are we moving vertically?
		bne.s	.checkHitState				; if yes, branch
		moveq	#4,d1					; set animation to facelaugh
		bra.s	.writeAnim
; ===========================================================================

; loc_185D2
.checkSpecial:
		subq.b	#2,d0					; are we in Recover or Escape state (if we looped around, we are negative, so must be in Recover or Escape)
		bmi.s	.checkHitState				; no, check if we have collided with Sonic
		moveq	#$A,d1					; set defeated animation
		bra.s	.writeAnim
; ===========================================================================

; loc_185DA
.checkHitState:
		tst.b	obColType(a1)				; is the boss currently being hit?
		bne.s	.checkSonicState			; if not, check Sonic's state
		moveq	#5,d1					; set animation to facehit
		bra.s	.writeAnim
; ===========================================================================

.checkSonicState:
		cmpi.b	#4,(v_player+obRoutine).w		; is Sonic in his hurt state?
		blo.s	.writeAnim				; if not, branch
		moveq	#4,d1					; set animation to facelaugh

; loc_185EE
.writeAnim:
		move.b	d1,obAnim(a0)				; move animation state into obAnim
; ----------------------------------------------------------------------------
; The below line checks: are we in the escape state? 
; 8-2-2-4=0, so if we are in the escape state this is true, any other state would not result in a 0. If all this confuses you, review the _Index code throughout this file.
; ----------------------------------------------------------------------------		
		subq.b	#4,d0
		bne.s	.skip					; we are not escaping, display normally
		move.b	#6,obAnim(a0)				; set animation state to facepanic
		tst.b	obRender(a0)				; has Eggman's face left the screen?
		bpl.s	BossMarble_FaceDel			; yes, delete his face

; loc_18602
.skip:
		bra.s	BossMarble_Display
; ===========================================================================

BossMarble_FaceDel:
		jmp	(DeleteObject).l
; ===========================================================================

BossMarble_FlameMain:; Routine 6
		move.b	#7,obAnim(a0)				; set animation state to 7 (default invisible state for flame)
		movea.l	BossMarble_ParentObj(a0),a1		; load main boss controller
		cmpi.b	#8,ob2ndRout(a1)			; are we in the Escape state?
		blt.s	.checkMove				; no, check movement
		move.b	#$B,obAnim(a0)				; set thruster animation for takeoff
		tst.b	obRender(a0)				; what is our screen status?
		bpl.s	BossMarble_FlameDel			; off screen, delete
		bra.s	BMZ_FlameDisp				; on screen, display
; ===========================================================================

; loc_1862A
.checkMove:
		tst.w	obVelX(a1)				; are we currently moving?
		beq.s	BMZ_FlameDisp				; no, don't display flame
		move.b	#8,obAnim(a0)				; yes, display flame

; loc_18636
BMZ_FlameDisp:
		bra.s	BossMarble_Display
; ===========================================================================

BossMarble_FlameDel:
		jmp	(DeleteObject).l
; ===========================================================================

BossMarble_Display:
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l

; loc_1864A
BossMarble_SetBits:
		movea.l	BossMarble_ParentObj(a0),a1		; load main boss controller
		move.w	obX(a1),obX(a0)				; copy positions
		move.w	obY(a1),obY(a0)
		move.b	obStatus(a1),obStatus(a0)		; move object status to boss object status
		moveq	#sprite_xflip|sprite_yflip,d0		; move first 2 bits into d0
		and.b	obStatus(a0),d0				; AND with obStatus so now do contains X and Y logical flip bits only
		andi.b	#~(sprite_xflip|sprite_yflip),obRender(a0) ; clear the X and Y flip
		or.b	d0,obRender(a0)				; OR the two together, so now DisplaySprite has X and Y orientation and above render bits
		jmp	(DisplaySprite).l
; ===========================================================================

BossMarble_TubeMain:	; Routine 8
		movea.l	BossMarble_ParentObj(a0),a1		; load main boss controller
		cmpi.b	#8,ob2ndRout(a1)			; are we currently in Escape state?
		bne.s	.skip					; if not, branch
		tst.b	obRender(a0)				; has the tube left the screen?
		bpl.s	BossMarble_TubeDel			; if so, branch

; loc_18688
.skip:
		move.l	#Map_BossItems,obMap(a0)		; load item mappings
		move.w	#ArtTile_Eggman_Weapons|Tile_Pal2,obGfx(a0) ; load weapons and pick the palette line
		move.b	#4,obFrame(a0)				; set frame to tube (found in Boss Items.asm)
		bra.s	BossMarble_SetBits				
; ===========================================================================

BossMarble_TubeDel:
		jmp	(DeleteObject).l


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 74 - lava that Eggman drops (MZ)
; ---------------------------------------------------------------------------

BossFire:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	BossFire_Index(pc,d0.w),d0
	if FixBugs
		; DisplaySprite has been moved to avoid a display-after-free bug.
		jmp	BossFire_Index(pc,d0.w)
	else
		jsr	BossFire_Index(pc,d0.w)
		jmp	(DisplaySprite).l
	endif
; ===========================================================================
BossFire_Index:	dc.w BossFire_Main-BossFire_Index
		dc.w BossFire_Action-BossFire_Index
		dc.w BossFire_TempFire-BossFire_Index
		dc.w BossFire_TempFireDel-BossFire_Index
; ===========================================================================

BossFire_Main:	; Routine 0
		move.b	#16/2,obHeight(a0)
		move.b	#16/2,obWidth(a0)
		move.l	#Map_Fire,obMap(a0)
		move.w	#ArtTile_MZ_Fireball,obGfx(a0)
		move.b	#sprite_cam_field,obRender(a0)
		move.b	#5,obPriority(a0)
		move.w	obY(a0),obBossY(a0)
		move.b	#16/2,obActWid(a0)
		addq.b	#2,obRoutine(a0)
		tst.b	obSubtype(a0)
		bne.s	loc_1870A
		move.b	#col_16x16|col_hurt,obColType(a0)
		addq.b	#2,obRoutine(a0)
		bra.w	BossFire_TempFire
; ===========================================================================

loc_1870A:
		move.b	#$1E,objoff_29(a0)
		move.w	#sfx_Fireball,d0
		jsr	(QueueSound2).l	; play lava sound

BossFire_Action:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	BossFire_Index2(pc,d0.w),d0
		jsr	BossFire_Index2(pc,d0.w)
		jsr	(SpeedToPos).l
		lea	(Ani_Fire).l,a1
		jsr	(AnimateSprite).l
		cmpi.w	#boss_mz_y+$D8,obY(a0)
		bhi.s	BossFire_Delete
	if FixBugs
		; DisplaySprite has been moved to avoid a display-after-free bug.
		jmp	(DisplaySprite).l
	else
		rts
	endif
; ===========================================================================

BossFire_Delete:
		jmp	(DeleteObject).l
; ===========================================================================
BossFire_Index2:dc.w BossFire_Drop-BossFire_Index2
		dc.w BossFire_MakeFlame-BossFire_Index2
		dc.w BossFire_Duplicate-BossFire_Index2
		dc.w BossFire_FallEdge-BossFire_Index2
; ===========================================================================

BossFire_Drop:
		bset	#1,obStatus(a0)
		subq.b	#1,objoff_29(a0)
		bpl.s	locret_18780
		move.b	#col_16x16|col_hurt,obColType(a0)
		clr.b	obSubtype(a0)
		addi.w	#$18,obVelY(a0)
		bclr	#1,obStatus(a0)
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_18780
		addq.b	#2,ob2ndRout(a0)

locret_18780:
		rts
; ===========================================================================

BossFire_MakeFlame:
		subq.w	#2,obY(a0)
		bset	#7,obGfx(a0)
		move.w	#$A0,obVelX(a0)
		clr.w	obVelY(a0)
		move.w	obX(a0),obBossX(a0)
		move.w	obY(a0),obBossY(a0)
		move.b	#3,objoff_29(a0)
		jsr	(FindNextFreeObj).l
		bne.s	loc_187CA
		lea	(a1),a3
		lea	(a0),a2
		moveq	#3,d0

BossFire_Loop:
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		move.l	(a2)+,(a3)+
		dbf	d0,BossFire_Loop

		neg.w	obVelX(a1)
		addq.b	#2,ob2ndRout(a1)

loc_187CA:
		addq.b	#2,ob2ndRout(a0)
		rts
; ===========================================================================

BossFire_Duplicate2:
		jsr	(FindNextFreeObj).l
		bne.s	locret_187EE
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#id_BossFire,obID(a1)
		move.w	#$67,obSubtype(a1)

locret_187EE:
		rts
; End of function BossFire_Duplicate2

; ===========================================================================

BossFire_Duplicate:
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	loc_18826
		move.w	obX(a0),d0
		cmpi.w	#boss_mz_x+$140,d0
		bgt.s	loc_1882C
		move.w	obBossX(a0),d1
		cmp.w	d0,d1
		beq.s	loc_1881E
		andi.w	#$10,d0
		andi.w	#$10,d1
		cmp.w	d0,d1
		beq.s	loc_1881E
		bsr.s	BossFire_Duplicate2
		move.w	obX(a0),objoff_32(a0)

loc_1881E:
		move.w	obX(a0),obBossX(a0)
		rts
; ===========================================================================

loc_18826:
		addq.b	#2,ob2ndRout(a0)
		rts
; ===========================================================================

loc_1882C:
		addq.b	#2,obRoutine(a0)
		rts
; ===========================================================================

BossFire_FallEdge:
		bclr	#1,obStatus(a0)
		addi.w	#$24,obVelY(a0)	; make flame fall
		move.w	obX(a0),d0
		sub.w	objoff_32(a0),d0
		bpl.s	loc_1884A
		neg.w	d0

loc_1884A:
		cmpi.w	#$12,d0
		bne.s	loc_18856
		bclr	#7,obGfx(a0)

loc_18856:
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_1887E
		subq.b	#1,objoff_29(a0)
		beq.s	BossFire_Delete2
		clr.w	obVelY(a0)
		move.w	objoff_32(a0),obX(a0)
		move.w	obBossY(a0),obY(a0)
		bset	#7,obGfx(a0)
		subq.b	#2,ob2ndRout(a0)

locret_1887E:
		rts
; ===========================================================================

BossFire_Delete2:
	if FixBugs
		; Do not return to BossFire_Action, to avoid double-delete
		; and display-and-delete bugs.
		addq.l	#4,sp
	endif
		jmp	(DeleteObject).l
; ===========================================================================

; loc_18886:
BossFire_TempFire: ; Routine 4
		bset	#7,obGfx(a0)
		subq.b	#1,objoff_29(a0)
		bne.s	BossFire_Animate
		move.b	#1,obAnim(a0)
		subq.w	#4,obY(a0)
		clr.b	obColType(a0)

BossFire_Animate:
		lea	(Ani_Fire).l,a1
	if FixBugs
		; DisplaySprite has been moved to avoid a display-after-free bug.
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
	else
		jmp	(AnimateSprite).l
	endif
; ===========================================================================

; BossFire_Delete3:
BossFire_TempFireDel:	; Routine 6
		jmp	(DeleteObject).l
