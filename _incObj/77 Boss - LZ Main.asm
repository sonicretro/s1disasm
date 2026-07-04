; ---------------------------------------------------------------------------
; Object 77 - Eggman (LZ)
; ---------------------------------------------------------------------------

BossLabyrinth:
		moveq	#0,d0					
		move.b	obRoutine(a0),d0			; copy object routine		
		move.w	BossLabyrinth_Index(pc,d0.w),d1		; use the object routine and BossLabyrinth_Index to calculate our offset
		jmp	BossLabyrinth_Index(pc,d1.w)		; jump into the table and use our offset to pick a routine in the index to go to
; ===========================================================================
BossLabyrinth_Index:
		dc.w BossLabyrinth_Main-BossLabyrinth_Index
		dc.w BossLabyrinth_ShipMain-BossLabyrinth_Index
		dc.w BossLabyrinth_FaceMain-BossLabyrinth_Index
		dc.w BossLabyrinth_FlameMain-BossLabyrinth_Index


BossLabyrinth_ParentObj equ objoff_34				; pointer to main boss controller
BossLabyrinth_EarlyDefeatFlag equ objoff_3D			; simple flag used to see if boss has been defeated early
BossLabyrinth_SineCounter equ objoff_3F				; sine counter for bobbing motion
BossLabyrinth_GenericTimer equ objoff_3C			; generic timer, only used for a brief animation at the end of the fight

BossLabyrinth_ObjData:
		dc.b 2,	0					; routine number, animation (ship body)
		dc.b 4,	1					; face
		dc.b 6,	7					; thruster
; ===========================================================================

BossLabyrinth_Main:	; Routine 0
		move.w	#boss_lz_x+$30,obX(a0)			; set initial position
		move.w	#boss_lz_y+$500,obY(a0)
		move.w	obX(a0),obBossX(a0)			; copy position
		move.w	obY(a0),obBossY(a0)
		move.b	#col_48x48|col_boss,obColType(a0)	; set collision type
		move.b	#8,obBossHits(a0) 			; set number of hits to 8
		move.b	#4,obPriority(a0)			; set render priority
		lea	BossLabyrinth_ObjData(pc),a2		; load objdata table
		movea.l	a0,a1					; copy main boss object
		moveq	#2,d1					; set up a loop to loop 3 times
		bra.s	BossLabyrinth_LoadBoss
; ===========================================================================

BossLabyrinth_Loop:
		jsr	(FindNextFreeObj).l
		bne.s	BossLabyrinth_ShipMain
		_move.b	#id_BossLabyrinth,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)

BossLabyrinth_LoadBoss:
		bclr	#0,obStatus(a0)				; clear X flip
		clr.b	ob2ndRout(a1)				; clear secondary object routine
		move.b	(a2)+,obRoutine(a1)			; load objdata table into boss' copy routine table and increment
		move.b	(a2)+,obAnim(a1)			; load animation into boss' copy and increment
		move.b	obPriority(a0),obPriority(a1)		; copy priority
		move.l	#Map_Eggman,obMap(a1)			; set up mappings, graphics, and render style
		move.w	#ArtTile_Eggman,obGfx(a1)
		move.b	#sprite_cam_field,obRender(a1)
		move.b	#64/2,obActWid(a1)			; set object radius
		move.l	a0,BossLabyrinth_ParentObj(a1)		; copy boss object into parent object offset for copy
		dbf	d1,BossLabyrinth_Loop			; loop

BossLabyrinth_ShipMain:	; Routine 2
		lea	(v_player).w,a1				; load Sonic
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0			; copy object routine
		move.w	BossLabyrinth_ShipIndex(pc,d0.w),d1	; use the object routine and BossLabyrinth_ShipIndex to calculate our offset
		jsr	BossLabyrinth_ShipIndex(pc,d1.w)	; jump into the table and use our offset to pick a routine in the index to go to
		lea	(Ani_Eggman).l,a1			; load animations
		jsr	(AnimateSprite).l
		moveq	#sprite_xflip|sprite_yflip,d0		; move first 2 bits into d0			
		and.b	obStatus(a0),d0				; AND with obStatus so now d0 contains X and Y logical flip bits only
		andi.b	#~(sprite_xflip|sprite_yflip),obRender(a0) ; clear the x and y flip
		or.b	d0,obRender(a0)				; OR the two together, so now DisplaySprite has X and Y orientation and above render bits
		jmp	(DisplaySprite).l
; ===========================================================================
BossLabyrinth_ShipIndex:
		dc.w BLZ_ShipStart-BossLabyrinth_ShipIndex
		dc.w BLZ_ShipMove1-BossLabyrinth_ShipIndex
		dc.w BLZ_ShipMove2-BossLabyrinth_ShipIndex
		dc.w BLZ_ShipMove3-BossLabyrinth_ShipIndex
		dc.w BLZ_ShipAtTop-BossLabyrinth_ShipIndex
		dc.w BLZ_ShipWait-BossLabyrinth_ShipIndex
		dc.w BLZ_Escape1-BossLabyrinth_ShipIndex
		dc.w BLZ_Escape2-BossLabyrinth_ShipIndex
; ===========================================================================

; loc_17F1E:
BLZ_ShipStart:
		move.w	obX(a1),d0				; copy object X
		cmpi.w	#boss_lz_x-$40,d0			; has the boss gone past this left boundary?
		blo.s	BLZ_MoveBoss				; if yes, branch
		move.w	#-$180,obVelY(a0)			; start rising up
		move.w	#$60,obVelX(a0)				; move a little to the right
		addq.b	#2,ob2ndRout(a0)			; advance routine

; loc_17F38:
BLZ_MoveBoss:
		bsr.w	BossMove
		move.w	obBossY(a0),obY(a0)			; move the boss and copy positions
		move.w	obBossX(a0),obX(a0)

; loc_17F48:
BLZ_ShipUpdate:
		tst.b	BossLabyrinth_EarlyDefeatFlag(a0)	; has Eggman been defeated while traversing upwards?
		bne.s	.defeated				; if yes, branch
		tst.b	obStatus(a0)				; has Eggman's defeated flag been set?
		bmi.s	.setDefeatFlag				; if yes, branch
		tst.b	obColType(a0)				; is the boss hittable?
		bne.s	.exit					; if not, leave
		tst.b	obBossFlash(a0)				; is this a non-zero value (collision disabled if so, must mean boss is already flashing)
		bne.s	.flash					; we are flashing already, skip ahead
		move.b	#$20,obBossFlash(a0)			; set number of times for ship to flash
		move.w	#sfx_HitBoss,d0
		jsr	(QueueSound2).l

; loc_17F70:
.flash:
		lea	(v_palette+$22).w,a1			; load 2nd palette, 2nd entry
		moveq	#0,d0					; move 0 (black)
		tst.w	(a1)					; is the color here black?
		bne.s	.writeColor				; if not black, already white, so branch
		move.w	#cWhite,d0				; move 0EEE (white)

; loc_17F7E:
.writeColor:
		move.w	d0,(a1)					; load color stored in d0
		subq.b	#1,obBossFlash(a0)			; subtract 1 from flash timer
		bne.s	.exit					; keep flashing if obBossFlash is not 0
		move.b	#col_48x48|col_boss,obColType(a0)	; restore collision, timer has hit 0

; locret_17F8C:
.exit:
		rts
; ===========================================================================

;loc_17F8E:
.defeated:
		bra.w	BossDefeated
; ===========================================================================

; loc_17F92:
.setDefeatFlag:
		moveq	#100,d0
		bsr.w	AddPoints
		move.b	#-1,BossLabyrinth_EarlyDefeatFlag(a0)	; set early defeat flag
		rts
; ===========================================================================

; loc_17FA0:
BLZ_ShipMove1:
		moveq	#-2,d0					; set condition counter
		cmpi.w	#boss_lz_x+$68,obBossX(a0)		; have we reached the first X boundary?
		blo.s	.checkY					; if not, branch to next check
		move.w	#boss_lz_x+$68,obBossX(a0)		; set X to target
		clr.w	obVelX(a0)				; stop moving horizontally
		addq.w	#1,d0					; increment condition counter

; loc_17FB6:
.checkY:
		cmpi.w	#boss_lz_y+$440,obBossY(a0)		; have we reached the first Y boundary?
		bgt.s	.checkConditions			; if not, branch
		move.w	#boss_lz_y+$440,obBossY(a0)		; set Y to target
		clr.w	obVelY(a0)				; stop moving vertically
		addq.w	#1,d0					; increment condition counter

; loc_17FCA:
.checkConditions:
		bne.s	.moveBoss				; have we met BOTH conditions? if not, branch and keep moving
		move.w	#$140,obVelX(a0)			; set X and Y velocity for next phase
		move.w	#-$200,obVelY(a0)
		addq.b	#2,ob2ndRout(a0)			; increment secondary routine index

; loc_17FDC:
.moveBoss:
		bra.w	BLZ_MoveBoss
; ===========================================================================

; loc_17FE0:
BLZ_ShipMove2:
		moveq	#-2,d0					; set condition counter
		cmpi.w	#boss_lz_x+$90,obBossX(a0)		; have we reached the second X boundary?
		blo.s	.checkY					; if not, branch to next check
		move.w	#boss_lz_x+$90,obBossX(a0)		; set X to target
		clr.w	obVelX(a0)				; stop moving horizontally
		addq.w	#1,d0					; increment condition counter

; loc_17FF6:
.checkY:
		cmpi.w	#boss_lz_y+$400,obBossY(a0)		; have we reached the second Y boundary?
		bgt.s	.checkConditions			; if not, branch
		move.w	#boss_lz_y+$400,obBossY(a0)		; set Y to target
		clr.w	obVelY(a0)				; stop moving vertically
		addq.w	#1,d0					; increment condition counter

; loc_1800A:
.checkConditions:
		bne.s	.moveBoss				; have we met BOTH conditions? if not, branch and keep moving
		move.w	#-$180,obVelY(a0)			; set Y velocity only for next phase
		addq.b	#2,ob2ndRout(a0)			; increment secondary routine index
		clr.b	BossLabyrinth_SineCounter(a0)		; clear vertical bob 

; loc_1801A:
.moveBoss:
		bra.w	BLZ_MoveBoss
; ===========================================================================

; loc_1801E:
BLZ_ShipMove3:
		cmpi.w	#boss_lz_y+$40,obBossY(a0)		; have we reached the third Y boundary?
		bgt.s	.setDirection				; if not, branch
		move.w	#boss_lz_y+$40,obBossY(a0)		; set Y to target
		move.w	#$140,obVelX(a0)			; set X and Y velocity for next phase, moving right and up
		move.w	#-$80,obVelY(a0)
		tst.b	BossLabyrinth_EarlyDefeatFlag(a0)	; has Eggman been defeated while ascending?
		beq.s	.moveBoss				; if not, branch
		asl.w	obVelX(a0)				; double X and Y velocity
		asl.w	obVelY(a0)

; loc_18046:
.moveBoss:
		addq.b	#2,ob2ndRout(a0)			; increment secondary routine index
		bra.w	BLZ_MoveBoss				
; ===========================================================================

; loc_1804E:
.setDirection:
		bset	#0,obStatus(a0)				; make Eggman face to the right
		addq.b	#2,BossLabyrinth_SineCounter(a0)	; increment sine counter
		move.b	BossLabyrinth_SineCounter(a0),d0	; copy and go to calculate vertical bob
		jsr	(CalcSine).l
		tst.w	d1					; check cosine sign
		bpl.s	.trackDistance				; if positive, we are moving to the right
		bclr	#0,obStatus(a0)				; if negative, we are moving to the left, so make Eggman face left

; loc_1806C:
.trackDistance:
		asr.w	#4,d0					; scale sine down (divide by 4)
		swap	d0					; move to high word
		clr.w	d0					; clear lower word
		add.l	obBossX(a0),d0				; add to boss X as a 32-bit fixed point
		swap	d0					; get the integer part back
		move.w	d0,obX(a0)				; apply oscillated X position
		move.w	obVelY(a0),d0				; copy Y velocity
		move.w	(v_player+obY).w,d1			; copy Sonic's Y position
		sub.w	obY(a0),d1				; subtract Eggman's Y with Sonic's Y to get a distance value
		bcs.s	.calcSpeed				; if there is a carry (aka negative) branch
		subi.w	#72,d1					; subtract 72 pixels from distance value
		bcs.s	.calcSpeed				; if there is a carry (aka negative) branch
		asr.w	#1,d0					; divide velocity by 2
		subi.w	#40,d1					; subtract 40 pixels from distance value
		bcs.s	.calcSpeed				; if there is a carry (aka negative) branch
		asr.w	#1,d0					; divide velocity again by 2 (now quarter velocity)
		subi.w	#40,d1					; subtract 40 pixels again
		bcs.s	.calcSpeed				; if there is a carry (aka negative) branch
		moveq	#0,d0					; remove all velocity

; loc_180A2:
.calcSpeed:
		ext.l	d0					; sign extend to long
		asl.l	#8,d0					; convert to fixed-point sub-pixel units
		tst.b	BossLabyrinth_EarlyDefeatFlag(a0)	; has Eggman been defeated while ascending?
		beq.s	.setSpeed				; if yes, branch
		add.l	d0,d0					; defeated early, double the speed

; loc_180AE:
.setSpeed:
		add.l	d0,obBossY(a0)				; apply velocity to Y position
		move.w	obBossY(a0),obY(a0)			; copy Y
		bra.w	BLZ_ShipUpdate
; ===========================================================================

; loc_180BC:
BLZ_ShipAtTop:
		moveq	#-2,d0					; set condition counter
		cmpi.w	#boss_lz_x+$16C,obBossX(a0)		; have we reached the fourth X boundary?
		blo.s	.checkY					; if not, branch
		move.w	#boss_lz_x+$16C,obBossX(a0)		; set X to target
		clr.w	obVelX(a0)				; stop moving horizontally
		addq.w	#1,d0					; increment condition counter

; loc_180D2:
.checkY:
		cmpi.w	#boss_lz_y,obBossY(a0)			; have we reached the fourth (top) Y boundary?
		bgt.s	.checkConditions			; if not, branch
		move.w	#boss_lz_y,obBossY(a0)			; set Y to target
		clr.w	obVelY(a0)				; stop moving vertically
		addq.w	#1,d0					; increment condition counter

; loc_180E6:
.checkConditions:
		bne.s	.moveBoss				; have we met BOTH conditions? if not, branch and keep moving
		addq.b	#2,ob2ndRout(a0)			; increment secound routine counter
		bclr	#0,obStatus(a0)				; clear X flip (face to the left)

; loc_180F2:
.moveBoss:
		bra.w	BLZ_MoveBoss
; ===========================================================================

; loc_180F6:
BLZ_ShipWait:
		tst.b	BossLabyrinth_EarlyDefeatFlag(a0)	; has Eggman been defeated while ascending?
		bne.s	.startEscape				; if not, branch
		cmpi.w	#boss_lz_x+$E8,obX(a1)			; has Sonic reached this horizontal check?
		blt.s	.skip					; if not, branch
		cmpi.w	#boss_lz_y+$30,obY(a1)			; has Sonic reached this vertical check?
		bgt.s	.skip					; if not, branch
		move.b	#50,BossLabyrinth_GenericTimer(a0)	; set a timer for 50 frames

; loc_18112:
.startEscape:
		move.w	#bgm_LZ,d0
		jsr	(QueueSound1).l				; play LZ music
	if Revision<>0
		clr.b	(f_lockscreen).w
	endif
		bset	#0,obStatus(a0)				; face to the right
		addq.b	#2,ob2ndRout(a0)			; increment second routine counter

; loc_18126:
.skip:
		bra.w	BLZ_MoveBoss
; ===========================================================================

; loc_1812A:
BLZ_Escape1:
		tst.b	BossLabyrinth_EarlyDefeatFlag(a0)	; has Eggman been defeated while ascending?
		bne.s	.escape					; if not, branch
		subq.b	#1,BossLabyrinth_GenericTimer(a0)	; subtract 1 from timer
		bne.s	.exit					; if timer is not 0, branch

; loc_18136:
.escape:
		clr.b	BossLabyrinth_GenericTimer(a0)		; clear the timer
		move.w	#$400,obVelX(a0)			; escape quickly to the right and slightly up
		move.w	#-$40,obVelY(a0)
		clr.b	BossLabyrinth_EarlyDefeatFlag(a0)	; clear the early defeat flag
		addq.b	#2,ob2ndRout(a0)			; increment second routine counter

; loc_1814E:
.exit:
		bra.w	BLZ_MoveBoss
; ===========================================================================

; loc_18152:
BLZ_Escape2:
		cmpi.w	#boss_lz_end,(v_limitright2).w		; have we finished scrolling to the right (reached level bounds)?
		bhs.s	.checkOffscreen				; if so, branch
		addq.w	#2,(v_limitright2).w			; keep unlocking the bounds of the screen by 2 pixels
		bra.s	.flee
; ===========================================================================

;loc_18160:
.checkOffscreen:
		tst.b	obRender(a0)				; has Eggman left the screen (is bit 7 clear)?		
		bpl.s	BossLabyrinth_ShipDel			; yes, bit 7 is cleared, so we can delete the object (this leverages signed numbers!)

; loc_18166:
.flee:
		bra.w	BLZ_MoveBoss
; ===========================================================================

BossLabyrinth_ShipDel:
	if FixBugs
		; Avoid returning to BossLabyrinth_ShipMain to prevent a
		; display-and-delete bug.
		addq.l	#4,sp
	endif
		jmp	(DeleteObject).l
; ===========================================================================

BossLabyrinth_FaceMain:	; Routine 4
		movea.l	BossLabyrinth_ParentObj(a0),a1		; load the main boss controller
		move.b	(a1),d0					; copy object ID
		cmp.b	(a0),d0					; does the face have the same object ID as the boss (aka boss has been deleted offscreen)?
		bne.s	BossLabyrinth_FaceDel			; if not, branch
		moveq	#0,d0
		move.b	ob2ndRout(a1),d0
		moveq	#1,d1
	if FixBugs
		; we want to check the defeat flag offset of the boss controller and not the face object, so
		; a1 must be checked for this condition instead of the face object itself (a0) for the defeat animation
		; to properly display
		tst.b   BossLabyrinth_EarlyDefeatFlag(a1)	; has Eggman been defeated while ascending?
	else
		tst.b	BossLabyrinth_EarlyDefeatFlag(a0)	; check the defeat flag, except a0 contains the face object and not the boss so this value will always be 0
	endif	
		beq.s	.checkHitState				; if not, branch
		moveq	#$A,d1					; set animation to defeated
		bra.s	.writeAnim				; write animation
; ===========================================================================

; loc_1818C:
.checkHitState:
		tst.b	obColType(a1)				; is the boss currently being hit?
		bne.s	.checkSonicState			; if not, check Sonic's state
		moveq	#5,d1					; set animation to facehit
		bra.s	.writeAnim				
; ===========================================================================

; loc_18196:
.checkSonicState:
		cmpi.b	#4,(v_player+obRoutine).w		; is Sonic in his hurt state?
		blo.s	.writeAnim				; if not, branch
		moveq	#4,d1					; set animation to facelaugh

; loc_181A0:
.writeAnim:
		move.b	d1,obAnim(a0)				; move animation state so that animation can execute		
		cmpi.b	#$E,d0					; are we currently in Escape2?
		bne.s	.skip					; if not, branch
		move.b	#6,obAnim(a0)				; set animation to facenormal2
		tst.b	obRender(a0)				; has Eggman's face left the screen?
		bpl.s	BossLabyrinth_FaceDel			; yes, delete his face

.skip:
		bra.s	BossLabyrinth_Display
; ===========================================================================

BossLabyrinth_FaceDel:
		jmp	(DeleteObject).l
; ===========================================================================

BossLabyrinth_FlameMain:; Routine 6
		move.b	#7,obAnim(a0)				; set animation state to 7 (default invisible state for flame)
		movea.l	BossLabyrinth_ParentObj(a0),a1		; load main boss controller
		move.b	(a1),d0					; copy object ID
		cmp.b	(a0),d0					; does the flame have the same object ID as the boss (aka boss has been deleted offscreen)?
		bne.s	BossLabyrinth_FlameDel			; if not, branch
		cmpi.b	#$E,ob2ndRout(a1)			; are we currently in Escape2?
		bne.s	.skip					; if not, branch
		move.b	#$B,obAnim(a0)				; set thruster animation for taking off
		tst.b	obRender(a0)				; what is our screen status?
		bpl.s	BossLabyrinth_FlameDel			; off screen, delete (bit 7 would be 1 if we were on screen, therefore a negative number due to sign)
		bra.s	.skip					; on screen, display
; ===========================================================================
		tst.w	obVelX(a1)				; are we currently moving?
		beq.s	.skip					; no, don't display flame
		move.b	#8,obAnim(a0)				; yes, display flame

; loc_181F0:
.skip:
		bra.s	BossLabyrinth_Display
; ===========================================================================

BossLabyrinth_FlameDel:
		jmp	(DeleteObject).l
; ===========================================================================

BossLabyrinth_Display:
		lea	(Ani_Eggman).l,a1			; load animations and run them
		jsr	(AnimateSprite).l
		movea.l	BossLabyrinth_ParentObj(a0),a1		; load main boss controller
		move.w	obX(a1),obX(a0)				; move positions to rendered positions
		move.w	obY(a1),obY(a0)
		move.b	obStatus(a1),obStatus(a0)		; move object status to boss status
		moveq	#sprite_xflip|sprite_yflip,d0		; move first 2 bits into d0			
		and.b	obStatus(a0),d0				; AND with obStatus so now d0 contains X and Y logical flip bits only
		andi.b	#~(sprite_xflip|sprite_yflip),obRender(a0) ; clear the x and y flip
		or.b	d0,obRender(a0)				; OR the two together, so now DisplaySprite has X and Y orientation and above render bits
		jmp	(DisplaySprite).l
