; ---------------------------------------------------------------------------
; Object 85 - Eggman (FZ)
; ---------------------------------------------------------------------------

BossFinal_Delete:
		jmp	(DeleteObject).l
; ===========================================================================

BossFinal:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	BossFinal_Index(pc,d0.w),d0
		jmp	BossFinal_Index(pc,d0.w)
; ===========================================================================
BossFinal_Index:
		dc.w BossFinal_Main-BossFinal_Index
		dc.w BossFinal_Eggman-BossFinal_Index
		dc.w BossFinal_Panel-BossFinal_Index
		dc.w BossFinal_Legs-BossFinal_Index
		dc.w BossFinal_Cockpit-BossFinal_Index
		dc.w BossFinal_EmptyShip-BossFinal_Index
		dc.w BossFinal_Flame-BossFinal_Index

BossFinal_ObjData:
		dc.w $100, $100, ArtTile_FZ_Eggman_No_Vehicle	; X pos, Y pos, VRAM setting
		dc.l Map_SEgg		; mappings pointer
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

BossFinal_ObjData2:
		dc.b 2,	0, 4, 64/2, 50/2	; routine num, animation, sprite priority, width, height
		dc.b 4,	0, 1, 36/2, 16/2
		dc.b 6,	0, 3, 0, 0
		dc.b 8,	0, 3, 0, 0
		dc.b $A, 0, 3, 64/2, 64/2
		dc.b $C, 0, 3, 0, 0
; ===========================================================================

BossFinal_Main:	; Routine 0
		lea	BossFinal_ObjData(pc),a2
		lea	BossFinal_ObjData2(pc),a3
		movea.l	a0,a1
		moveq	#5,d1
		bra.s	BossFinal_LoadBoss
; ===========================================================================

BossFinal_Loop:
		jsr	(FindNextFreeObj).l
		bne.s	loc_19E20

BossFinal_LoadBoss:
		move.b	#id_BossFinal,obID(a1)
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
		move.b	#sprite_cam_field,obRender(a1)
		bset	#sprite_rendered_bit,obRender(a0)
		move.l	a0,objoff_34(a1)
		dbf	d1,BossFinal_Loop

loc_19E20:
		lea	objoff_36(a0),a2
		jsr	(FindFreeObj).l
		bne.s	loc_19E5A
		move.b	#id_BossPlasma,obID(a1) ; load energy ball object
		move.w	a1,(a2)
		move.l	a0,objoff_34(a1)
		lea	objoff_38(a0),a2
		moveq	#0,d2
		moveq	#3,d1

loc_19E3E:
		jsr	(FindNextFreeObj).l
		bne.s	loc_19E5A
		move.w	a1,(a2)+
		move.b	#id_EggmanCylinder,obID(a1) ; load crushing cylinder object
		move.l	a0,objoff_34(a1)
		move.b	d2,obSubtype(a1)
		addq.w	#2,d2
		dbf	d1,loc_19E3E

loc_19E5A:
		move.w	#0,objoff_34(a0)
		move.b	#8,obBossHits(a0) ; set number of hits to 8
		move.w	#-1,objoff_30(a0)

BossFinal_Eggman:	; Routine 2
		moveq	#0,d0
		move.b	objoff_34(a0),d0
		move.w	BossFinal_Eggman_Index(pc,d0.w),d0
		jsr	BossFinal_Eggman_Index(pc,d0.w)
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
		tst.l	(v_plc_buffer).w
		bne.s	loc_19EA2
		cmpi.w	#boss_fz_x,(v_screenposx).w
		blo.s	loc_19EA2
		addq.b	#2,objoff_34(a0)

loc_19EA2:
		addq.l	#1,(v_random).w
		rts
; ===========================================================================

; loc_19EA8:
BossFinal_Eggman_Crush:
		tst.w	objoff_30(a0)
		bpl.s	loc_19F10
		clr.w	objoff_30(a0)
		jsr	(RandomNumber).l
		andi.w	#$C,d0
		move.w	d0,d1
		addq.w	#2,d1
		tst.l	d0		; is random result negative?
		bpl.s	loc_19EC6	; if not, branch
		exg.l	d1,d0		; swap, Eggman's target cylinder

loc_19EC6:
		lea	BossFinal_CylinderPairs(pc),a1
		move.w	(a1,d0.w),d0
		move.w	(a1,d1.w),d1
		move.w	d0,objoff_30(a0)
		moveq	#-1,d2
		move.w	objoff_38(a0,d0.w),d2
		movea.l	d2,a1
		move.b	#-1,objoff_29(a1)
		move.w	#-1,objoff_30(a1)
		move.w	objoff_38(a0,d1.w),d2
		movea.l	d2,a1
		move.b	#1,objoff_29(a1)
		move.w	#0,objoff_30(a1)
		move.w	#1,objoff_32(a0)
		clr.b	objoff_35(a0)
		move.w	#sfx_Rumbling,d0
		jsr	(QueueSound2).l	; play rumbling sound

loc_19F10:
		tst.w	objoff_32(a0)
		bmi.w	loc_19FA6
		bclr	#0,obStatus(a0)
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcs.s	loc_19F2E
		bset	#0,obStatus(a0)

loc_19F2E:
		move.w	#64/2+sonic_solid_width,d1
		move.w	#40/2,d2
		move.w	#40/2,d3
		move.w	obX(a0),d4
		jsr	(SolidObject).l
		tst.w	d4
		bgt.s	loc_19F50

loc_19F48:
		tst.b	objoff_35(a0)
		bne.s	loc_19F88
		bra.s	loc_19F96
; ===========================================================================

loc_19F50:
		addq.w	#7,(v_random).w
		cmpi.b	#id_Roll,(v_player+obAnim).w
		bne.s	loc_19F48
		move.w	#$300,d0
		btst	#0,obStatus(a0)
		bne.s	loc_19F6A
		neg.w	d0

loc_19F6A:
		move.w	d0,(v_player+obVelX).w
		tst.b	objoff_35(a0)
		bne.s	loc_19F88
	if FixBugs
		; Fix underflowing hit counter to 255 on defeat
		tst.b	obBossHits(a0)	; has the boss been defeated?
		beq.s	loc_19F9C	; if so, don't let it be hit again
	endif
		subq.b	#1,obBossHits(a0)
		move.b	#$64,objoff_35(a0)
		move.w	#sfx_HitBoss,d0
		jsr	(QueueSound2).l	; play boss damage sound

loc_19F88:
		subq.b	#1,objoff_35(a0)
		beq.s	loc_19F96
		move.b	#3,obAnim(a0)
		bra.s	loc_19F9C
; ===========================================================================

loc_19F96:
	if FixBugs
		tst.b	obBossHits(a0)	; has the boss been defeated?
		beq.s	loc_19F9C	; if so, don't reset to laugh animation
	endif
		move.b	#1,obAnim(a0)

loc_19F9C:
		lea	Ani_SEgg(pc),a1
		jmp	(AnimateSprite).l
; ===========================================================================

loc_19FA6:
		tst.b	obBossHits(a0)
		beq.s	loc_19FBC
		addq.b	#2,objoff_34(a0)
		move.w	#-1,objoff_30(a0)
		clr.w	objoff_32(a0)
		rts
; ===========================================================================

loc_19FBC:
	if Revision<>0
		moveq	#100,d0
		bsr.w	AddPoints
	endif
		move.b	#6,objoff_34(a0)
		move.w	#boss_fz_x+$170,obX(a0)
		move.w	#boss_fz_y+$2C,obY(a0)
		move.b	#40/2,obHeight(a0)
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
		moveq	#-1,d0
		move.w	objoff_36(a0),d0
		movea.l	d0,a1
		tst.w	objoff_30(a0)
		bpl.s	loc_1A000
		clr.w	objoff_30(a0)
		move.b	#-1,objoff_29(a1)
		bsr.s	loc_1A020

loc_1A000:
		moveq	#$F,d0
		and.w	(v_vblank_word).w,d0
		bne.s	loc_1A00A
		bsr.s	loc_1A020

loc_1A00A:
		tst.w	objoff_32(a0)
		beq.s	locret_1A01E
		subq.b	#2,objoff_34(a0)
		move.w	#-1,objoff_30(a0)
		clr.w	objoff_32(a0)

locret_1A01E:
		rts
; ===========================================================================

loc_1A020:
		move.w	#sfx_Electric,d0
		jmp	(QueueSound2).l	; play electricity sound
; ===========================================================================

; loc_1A02A:
BossFinal_Eggman_Fall:
	if Revision=0
		move.b	#96/2,obWidth(a0)
	else
		move.b	#96/2,obActWid(a0)
	endif
		bset	#0,obStatus(a0)
		jsr	(SpeedToPos).l
		move.b	#6,obFrame(a0)
		addi.w	#$10,obVelY(a0)
		cmpi.w	#boss_fz_y+$8C,obY(a0)
		blo.s	loc_1A070
		move.w	#boss_fz_y+$8C,obY(a0)
		addq.b	#2,objoff_34(a0)
	if Revision=0
		move.b	#64/2,obWidth(a0)
	else
		move.b	#64/2,obActWid(a0)
	endif
		move.w	#$100,obVelX(a0)
		move.w	#-$100,obVelY(a0)
		addq.b	#2,(v_dle_routine).w

loc_1A070:
		bra.w	loc_1A166
; ===========================================================================

; loc_1A074:
BossFinal_Eggman_Run:
		bset	#0,obStatus(a0)
		move.b	#4,obAnim(a0)
		jsr	(SpeedToPos).l
		addi.w	#$10,obVelY(a0)
		cmpi.w	#boss_fz_y+$93,obY(a0)
		blo.s	loc_1A09A
		move.w	#-$40,obVelY(a0)

loc_1A09A:
		move.w	#$400,obVelX(a0)
		move.w	obX(a0),d0
		sub.w	(v_player+obX).w,d0
		bpl.s	loc_1A0B4
		move.w	#$500,obVelX(a0)
		bra.w	loc_1A0F2
; ===========================================================================

loc_1A0B4:
		subi.w	#$70,d0
		bcs.s	loc_1A0F2
		subi.w	#$100,obVelX(a0)
		subq.w	#8,d0
		bcs.s	loc_1A0F2
		subi.w	#$100,obVelX(a0)
		subq.w	#8,d0
		bcs.s	loc_1A0F2
		subi.w	#$80,obVelX(a0)
		subq.w	#8,d0
		bcs.s	loc_1A0F2
		subi.w	#$80,obVelX(a0)
		subq.w	#8,d0
		bcs.s	loc_1A0F2
		subi.w	#$80,obVelX(a0)
		subi.w	#$38,d0
		bcs.s	loc_1A0F2
		clr.w	obVelX(a0)

loc_1A0F2:
		cmpi.w	#boss_fz_x+$250,obX(a0)
		blo.s	loc_1A110
		move.w	#boss_fz_x+$250,obX(a0)
		move.w	#$240,obVelX(a0)
		move.w	#-$4C0,obVelY(a0)
		addq.b	#2,objoff_34(a0)

loc_1A110:
		bra.s	loc_1A15C
; ===========================================================================

; loc_1A112:
BossFinal_Eggman_Jump:
		jsr	(SpeedToPos).l
		cmpi.w	#boss_fz_x+$290,obX(a0)
		blo.s	loc_1A124
		clr.w	obVelX(a0)

loc_1A124:
		addi.w	#$34,obVelY(a0)
		tst.w	obVelY(a0)
		bmi.s	loc_1A142
		cmpi.w	#boss_fz_y+$82,obY(a0)
		blo.s	loc_1A142
		move.w	#boss_fz_y+$82,obY(a0)
		clr.w	obVelY(a0)

loc_1A142:
		move.w	obVelX(a0),d0
		or.w	obVelY(a0),d0
		bne.s	loc_1A15C
		addq.b	#2,objoff_34(a0)
		move.w	#-$180,obVelY(a0)
		move.b	#1,obBossHits(a0) ; set number of escaping Eggman hits to 1

loc_1A15C:
		lea	Ani_SEgg(pc),a1
		jsr	(AnimateSprite).l

loc_1A166:
		cmpi.w	#boss_fz_end,(v_limitright2).w
		bge.s	loc_1A172
		addq.w	#2,(v_limitright2).w

loc_1A172:
		cmpi.b	#$C,objoff_34(a0)
		bge.s	locret_1A190
		move.w	#32/2+sonic_solid_width,d1
		move.w	#224/2,d2
		move.w	#226/2,d3
		move.w	obX(a0),d4
		jmp	(SolidObject).l
; ===========================================================================

locret_1A190:
		rts
; ===========================================================================

; loc_1A192:
BossFinal_Eggman_Ship:
		move.l	#Map_Eggman,obMap(a0)
		move.w	#ArtTile_Eggman,obGfx(a0)
		move.b	#0,obAnim(a0)
		bset	#0,obStatus(a0)
		jsr	(SpeedToPos).l
		cmpi.w	#boss_fz_y+$34,obY(a0)
		bhs.s	loc_1A1D0
		move.w	#$180,obVelX(a0)
		move.w	#-$18,obVelY(a0)
		move.b	#col_48x48|col_boss,obColType(a0)
		addq.b	#2,objoff_34(a0)

loc_1A1D0:
		bra.w	loc_1A15C
; ===========================================================================

; loc_1A1D4:
BossFinal_Eggman_Escape:
		bset	#0,obStatus(a0)
		jsr	(SpeedToPos).l
		tst.w	objoff_30(a0)
		bne.s	loc_1A1FC
		tst.b	obColType(a0)
		bne.s	loc_1A216
		move.w	#$1E,objoff_30(a0)
		move.w	#sfx_HitBoss,d0
		jsr	(QueueSound2).l	; play boss damage sound

loc_1A1FC:
		subq.w	#1,objoff_30(a0)
		bne.s	loc_1A216
		tst.b	obStatus(a0)
		bpl.s	loc_1A210
		move.w	#$60,obVelY(a0)
		bra.s	loc_1A216
; ===========================================================================

loc_1A210:
		move.b	#col_48x48|col_boss,obColType(a0)

loc_1A216:
		cmpi.w	#boss_fz_end+$90,(v_player+obX).w
		blt.s	loc_1A23A
		move.b	#1,(f_lockctrl).w	; lock controls
		move.w	#0,(v_jpadhold2).w	; clear button inputs
		clr.w	(v_player+obInertia).w	; stop Sonic moving
		tst.w	obVelY(a0)		; is Eggman going down?
		bpl.s	loc_1A248		; if yes, branch
		move.w	#btnUp<<8,(v_jpadhold2).w ; make Sonic look up if Eggman got away

loc_1A23A:
		cmpi.w	#boss_fz_end+$E0,(v_player+obX).w
		blt.s	loc_1A248
		move.w	#boss_fz_end+$E0,(v_player+obX).w

loc_1A248:
		cmpi.w	#boss_fz_end+$200,obX(a0)
		blo.s	loc_1A260
		tst.b	obRender(a0)
		bmi.s	loc_1A260
		move.b	#id_Ending,(v_gamemode).w
	if FixBugs
		; Avoid returning to BossFinal_Eggman to prevent a
		; display-and-delete bug.
		addq.l	#4,sp
	endif
		bra.w	BossFinal_Delete
; ===========================================================================

loc_1A260:
		bra.w	loc_1A15C
; ===========================================================================

; loc_1A264:
BossFinal_Flame: ; Routine 4
		movea.l	objoff_34(a0),a1
		move.b	(a1),d0
		cmp.b	(a0),d0
		bne.w	BossFinal_Delete
		move.b	#7,obAnim(a0)
		cmpi.b	#$C,objoff_34(a1)
		bge.s	loc_1A280
		bra.s	loc_1A2A6
; ===========================================================================

loc_1A280:
		tst.w	obVelX(a1)
		beq.s	loc_1A28C
		move.b	#$B,obAnim(a0)

loc_1A28C:
		lea	Ani_Eggman(pc),a1
		jsr	(AnimateSprite).l

loc_1A296:
		movea.l	objoff_34(a0),a1
		move.w	obX(a1),obX(a0)
		move.w	obY(a1),obY(a0)

loc_1A2A6:
		movea.l	objoff_34(a0),a1
		move.b	obStatus(a1),obStatus(a0)
		moveq	#sprite_xflip|sprite_yflip,d0
		and.b	obStatus(a0),d0
		andi.b	#~(sprite_xflip|sprite_yflip),obRender(a0)
		or.b	d0,obRender(a0)
		jmp	(DisplaySprite).l
; ===========================================================================

; loc_1A2C6:
BossFinal_Cockpit: ; Routine 6
		movea.l	objoff_34(a0),a1
		move.b	(a1),d0
		cmp.b	(a0),d0
		bne.w	BossFinal_Delete
		cmpi.l	#Map_Eggman,obMap(a1)
		beq.s	loc_1A2E4
		move.b	#$A,obFrame(a0)
		bra.s	loc_1A2A6
; ===========================================================================

loc_1A2E4:
		move.b	#1,obAnim(a0)
		tst.b	obBossHits(a1)
		ble.s	loc_1A312
		move.b	#6,obAnim(a0)
		move.l	#Map_Eggman,obMap(a0)
		move.w	#ArtTile_Eggman,obGfx(a0)
		lea	Ani_Eggman(pc),a1
		jsr	(AnimateSprite).l
		bra.w	loc_1A296
; ===========================================================================

loc_1A312:
		tst.b	obRender(a0)
		bpl.w	BossFinal_Delete
		bsr.w	BossDefeated
		move.b	#2,obPriority(a0)
		move.b	#0,obAnim(a0)
		move.l	#Map_FZDamaged,obMap(a0)
		move.w	#ArtTile_FZ_Eggman_Fleeing,obGfx(a0)
		lea	Ani_FZEgg(pc),a1
		jsr	(AnimateSprite).l
		bra.w	loc_1A296
; ===========================================================================

; loc_1A346:
BossFinal_Legs:	; Routine 8
		bset	#0,obStatus(a0)
		movea.l	objoff_34(a0),a1
		cmpi.l	#Map_Eggman,obMap(a1)
		beq.s	loc_1A35E
		bra.w	loc_1A2A6
; ===========================================================================

loc_1A35E:
		move.w	obX(a1),obX(a0)
		move.w	obY(a1),obY(a0)
		tst.b	obTimeFrame(a0)
		bne.s	loc_1A376
		move.b	#$14,obTimeFrame(a0)

loc_1A376:
		subq.b	#1,obTimeFrame(a0)
		bgt.s	loc_1A38A
		addq.b	#1,obFrame(a0)
		cmpi.b	#2,obFrame(a0)
		bgt.w	BossFinal_Delete

loc_1A38A:
		bra.w	loc_1A296
; ===========================================================================

; loc_1A38E:
BossFinal_Panel:	; Routine $A
		move.b	#$B,obFrame(a0)
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcs.s	loc_1A3A6
		tst.b	obRender(a0)
		bpl.w	BossFinal_Delete

loc_1A3A6:
		jmp	(DisplaySprite).l
; ===========================================================================

; loc_1A3AC:
BossFinal_EmptyShip: ; Routine $C
		move.b	#0,obFrame(a0)
		bset	#0,obStatus(a0)
		movea.l	objoff_34(a0),a1
		cmpi.b	#$C,objoff_34(a1)
		bne.s	loc_1A3D0
		cmpi.l	#Map_Eggman,obMap(a1)
		beq.w	BossFinal_Delete

loc_1A3D0:
		bra.w	loc_1A2A6
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
		move.b	obRoutine(a0),d0
		move.w	EggmanCylinder_Index(pc,d0.w),d0
		jmp	EggmanCylinder_Index(pc,d0.w)
; ===========================================================================
EggmanCylinder_Index:
		dc.w EggmanCylinder_Main-EggmanCylinder_Index
		dc.w EggmanCylinder_Action-EggmanCylinder_Index
		dc.w EggmanCylinder_Move-EggmanCylinder_Index

EggmanCylinder_PosData:
		dc.w boss_fz_x+$80,  boss_fz_y+$110
		dc.w boss_fz_x+$100, boss_fz_y+$110
		dc.w boss_fz_x+$40,  boss_fz_y-$50
		dc.w boss_fz_x+$C0,  boss_fz_y-$50
; ===========================================================================

EggmanCylinder_Main:	; Routine
		lea	EggmanCylinder_PosData(pc),a1
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		adda.w	d0,a1
		move.b	#sprite_cam_field,obRender(a0)
		bset	#sprite_rendered_bit,obRender(a0)
		bset	#sprite_customheight_bit,obRender(a0)
		move.w	#ArtTile_FZ_Boss,obGfx(a0)
		move.l	#Map_EggCyl,obMap(a0)
		move.w	(a1)+,obX(a0)
		move.w	(a1),obY(a0)
		move.w	(a1)+,obBossY(a0)
	if FixBugs=0
		; These are likely the result of the developers fumbling obWidth and
		; obActWidth, which wasn't completely fixed until REV01.
		move.b	#64/2,obHeight(a0)
		move.b	#192/2,obWidth(a0)
	endif
		move.b	#64/2,obActWid(a0)
		move.b	#192/2,obHeight(a0)
		move.b	#3,obPriority(a0)
		addq.b	#2,obRoutine(a0)

; loc_1A4CE:
EggmanCylinder_Action: ; Routine 2
		cmpi.b	#2,obSubtype(a0)
		ble.s	loc_1A4DC
		bset	#sprite_yflip_bit,obRender(a0)

loc_1A4DC:
		clr.l	objoff_3C(a0)
		tst.b	objoff_29(a0)
		beq.s	loc_1A4EA
		addq.b	#2,obRoutine(a0)

loc_1A4EA:
		move.l	objoff_3C(a0),d0
		move.l	obBossY(a0),d1
		add.l	d0,d1
		swap	d1
		move.w	d1,obY(a0)
		cmpi.b	#4,obRoutine(a0)
		bne.s	loc_1A524
		tst.w	objoff_30(a0)
		bpl.s	loc_1A524
		moveq	#-$A,d0
		cmpi.b	#2,obSubtype(a0)
		ble.s	loc_1A514
		moveq	#$E,d0

loc_1A514:
		add.w	d0,d1
		movea.l	objoff_34(a0),a1
		move.w	d1,obY(a1)
		move.w	obX(a0),obX(a1)

loc_1A524:
		move.w	#64/2+sonic_solid_width,d1
		move.w	#192/2,d2
		move.w	#194/2,d3
		move.w	obX(a0),d4
		jsr	(SolidObject).l
		moveq	#0,d0
		move.w	objoff_3C(a0),d1
		bpl.s	loc_1A550
		neg.w	d1
		subq.w	#8,d1
		bcs.s	loc_1A55C
		addq.b	#1,d0
		asr.w	#4,d1
		add.w	d1,d0
		bra.s	loc_1A55C
; ===========================================================================

loc_1A550:
		subi.w	#$27,d1
		bcs.s	loc_1A55C
		addq.b	#1,d0
		asr.w	#4,d1
		add.w	d1,d0

loc_1A55C:
		move.b	d0,obFrame(a0)
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bmi.s	loc_1A578
		subi.w	#$140,d0
		bmi.s	loc_1A578
		tst.b	obRender(a0)
		bpl.w	EggmanCylinder_Delete

loc_1A578:
		jmp	(DisplaySprite).l
; ===========================================================================

; loc_1A57E:
EggmanCylinder_Move: ; Routine 4
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		move.w	EggmanCylinder_Move_Index(pc,d0.w),d0
		jsr	EggmanCylinder_Move_Index(pc,d0.w)
		bra.w	loc_1A4EA
; ===========================================================================
EggmanCylinder_Move_Index:
		dc.w EggmanCylinder_Bottom-EggmanCylinder_Move_Index	; bottom left
		dc.w EggmanCylinder_Bottom-EggmanCylinder_Move_Index	; bottom right
		dc.w EggmanCylinder_Top-EggmanCylinder_Move_Index	; top left
		dc.w EggmanCylinder_Top-EggmanCylinder_Move_Index	; top right
; ===========================================================================

; loc_1A598:
EggmanCylinder_Bottom:
		tst.b	objoff_29(a0)
		bne.s	loc_1A5D4
		movea.l	objoff_34(a0),a1
		tst.b	obBossHits(a1)
		bne.s	loc_1A5B4
		bsr.w	BossDefeated
		subi.l	#$10000,objoff_3C(a0)

loc_1A5B4:
		addi.l	#$20000,objoff_3C(a0)
		bcc.s	locret_1A602
		clr.l	objoff_3C(a0)
		movea.l	objoff_34(a0),a1
		subq.w	#1,objoff_32(a1)
		clr.w	objoff_30(a1)
		subq.b	#2,obRoutine(a0)
		rts
; ===========================================================================

loc_1A5D4:
		cmpi.w	#-$10,objoff_3C(a0)
		bge.s	loc_1A5E4
		subi.l	#$28000,objoff_3C(a0)

loc_1A5E4:
		subi.l	#$8000,objoff_3C(a0)
		cmpi.w	#-$A0,objoff_3C(a0)
		bgt.s	locret_1A602
		clr.w	objoff_3E(a0)
		move.w	#-$A0,objoff_3C(a0)
		clr.b	objoff_29(a0)

locret_1A602:
		rts
; ===========================================================================

; loc_1A604:
EggmanCylinder_Top:
		bset	#sprite_yflip_bit,obRender(a0)
		tst.b	objoff_29(a0)
		bne.s	loc_1A646
		movea.l	objoff_34(a0),a1
		tst.b	obBossHits(a1)
		bne.s	loc_1A626
		bsr.w	BossDefeated
		addi.l	#$10000,objoff_3C(a0)

loc_1A626:
		subi.l	#$20000,objoff_3C(a0)
		bcc.s	locret_1A674
		clr.l	objoff_3C(a0)
		movea.l	objoff_34(a0),a1
		subq.w	#1,objoff_32(a1)
		clr.w	objoff_30(a1)
		subq.b	#2,obRoutine(a0)
		rts
; ===========================================================================

loc_1A646:
		cmpi.w	#$10,objoff_3C(a0)
		blt.s	loc_1A656
		addi.l	#$28000,objoff_3C(a0)

loc_1A656:
		addi.l	#$8000,objoff_3C(a0)
		cmpi.w	#$A0,objoff_3C(a0)
		blt.s	locret_1A674
		clr.w	objoff_3E(a0)
		move.w	#$A0,objoff_3C(a0)
		clr.b	objoff_29(a0)

locret_1A674:
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
		move.w	BossPlasma_Index(pc,d0.w),d0
		jmp	BossPlasma_Index(pc,d0.w)
; ===========================================================================
BossPlasma_Index:
		dc.w BossPlasma_Main-BossPlasma_Index
		dc.w BossPlasma_Generator-BossPlasma_Index
		dc.w BossPlasma_MakeBalls-BossPlasma_Index
		dc.w BossPlasma_Finish-BossPlasma_Index
		dc.w BossPlasma_Balls-BossPlasma_Index
; ===========================================================================

BossPlasma_Main:	; Routine 0
		move.w	#boss_fz_x+$138,obX(a0)
		move.w	#boss_fz_y+$2C,obY(a0)
		move.w	#ArtTile_FZ_Boss,obGfx(a0)
		move.l	#Map_PLaunch,obMap(a0)
		move.b	#0,obAnim(a0)
		move.b	#3,obPriority(a0)
		move.b	#16/2,obWidth(a0)
		move.b	#16/2,obHeight(a0)
		move.b	#sprite_cam_field,obRender(a0)
		bset	#sprite_rendered_bit,obRender(a0)
		addq.b	#2,obRoutine(a0)

BossPlasma_Generator:; Routine 2
		movea.l	objoff_34(a0),a1
		cmpi.b	#6,objoff_34(a1)
		bne.s	loc_1A850
		move.b	#id_Explosion,obID(a0)
		move.b	#0,obRoutine(a0)
		jmp	(DisplaySprite).l
; ===========================================================================

loc_1A850:
		move.b	#0,obAnim(a0)
		tst.b	objoff_29(a0)
		beq.s	loc_1A86C
		addq.b	#2,obRoutine(a0)
		move.b	#1,obAnim(a0)
		move.b	#$3E,obSubtype(a0)

loc_1A86C:
		move.w	#16/2+sonic_solid_width,d1
		move.w	#16/2,d2
		move.w	#34/2,d3
		move.w	obX(a0),d4
		jsr	(SolidObject).l
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bmi.s	loc_1A89A
		subi.w	#$140,d0
		bmi.s	loc_1A89A
		tst.b	obRender(a0)
		bpl.w	EggmanCylinder_Delete

loc_1A89A:
		lea	Ani_PLaunch(pc),a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================

BossPlasma_MakeBalls:; Routine 4
		tst.b	objoff_29(a0)
		beq.w	loc_1A954
		clr.b	objoff_29(a0)
		add.w	objoff_30(a0),d0
		andi.w	#$1E,d0
		adda.w	d0,a2
		addq.w	#4,objoff_30(a0)
		clr.w	objoff_32(a0)
		moveq	#3,d2

BossPlasma_Loop:
		jsr	(FindNextFreeObj).l
		bne.w	loc_1A954
		move.b	#id_BossPlasma,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	#boss_fz_y+$2C,obY(a1)
		move.b	#8,obRoutine(a1)
		move.w	#ArtTile_FZ_Boss|Tile_Pal2,obGfx(a1)
		move.l	#Map_Plasma,obMap(a1)
		move.b	#24/2,obHeight(a1)
		move.b	#24/2,obWidth(a1)
		move.b	#col_none,obColType(a1)
		move.b	#3,obPriority(a1)
		move.w	#$3E,obSubtype(a1)
		move.b	#sprite_cam_field,obRender(a1)
		bset	#sprite_rendered_bit,obRender(a1)
		move.l	a0,objoff_34(a1)
		jsr	(RandomNumber).l
		move.w	objoff_32(a0),d1
	if FixBugs
		; compensation for the fix in BossPlasma_Drop
		muls.w	#-$59,d1
	else
		muls.w	#-$4F,d1
	endif
		addi.w	#boss_fz_x+$128,d1
		andi.w	#$1F,d0
		subi.w	#$10,d0
		add.w	d1,d0
		move.w	d0,objoff_30(a1)
		addq.w	#1,objoff_32(a0)
		move.w	objoff_32(a0),objoff_38(a0)
		dbf	d2,BossPlasma_Loop	; repeat sequence 3 more times

loc_1A954:
		tst.w	objoff_32(a0)
		bne.s	loc_1A95E
		addq.b	#2,obRoutine(a0)

loc_1A95E:
		bra.w	loc_1A86C
; ===========================================================================

; loc_1A962:
BossPlasma_Finish: ; Routine 6
		move.b	#2,obAnim(a0)
		tst.w	objoff_38(a0)
		bne.s	loc_1A97E
		move.b	#2,obRoutine(a0)
		movea.l	objoff_34(a0),a1
		move.w	#-1,objoff_32(a1)

loc_1A97E:
		bra.w	loc_1A86C
; ===========================================================================

; loc_1A982:
BossPlasma_Balls: ; Routine 8
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	BossPlasma_Index2(pc,d0.w),d0
		jsr	BossPlasma_Index2(pc,d0.w)
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
		move.w	objoff_30(a0),d0
		sub.w	obX(a0),d0
		asl.w	#4,d0
		move.w	d0,obVelX(a0)
		move.w	#$B4,obSubtype(a0)
		addq.b	#2,ob2ndRout(a0)
		rts
; ===========================================================================

; loc_1A9C0:
BossPlasma_Drop:
		tst.w	obVelX(a0)
		beq.s	loc_1A9E6
		jsr	(SpeedToPos).l
		move.w	obX(a0),d0
		sub.w	objoff_30(a0),d0
		bcc.s	loc_1A9E6
		clr.w	obVelX(a0)
	if FixBugs
		sub.w	d0,obX(a0)
	else
		; this is intended to keep the leftmost energy ball in bounds,
		; but it actually pushes it FURTHER to the left
		add.w	d0,obX(a0)
	endif
		movea.l	objoff_34(a0),a1
		subq.w	#1,objoff_32(a1)

loc_1A9E6:
		move.b	#0,obAnim(a0)
		subq.w	#1,obSubtype(a0)
		bne.s	locret_1AA1C
		addq.b	#2,ob2ndRout(a0)
		move.b	#1,obAnim(a0)
		move.b	#col_24x24|col_hurt,obColType(a0)
		move.w	#$B4,obSubtype(a0)
		moveq	#0,d0
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		move.w	d0,obVelX(a0)
		move.w	#$140,obVelY(a0)

locret_1AA1C:
		rts
; ===========================================================================

; loc_1AA1E:
BossPlasma_Move:
		jsr	(SpeedToPos).l
		cmpi.w	#boss_fz_y+$D0,obY(a0)
		bhs.s	loc_1AA34
		subq.w	#1,obSubtype(a0)
		beq.s	loc_1AA34
		rts
; ===========================================================================

loc_1AA34:
		movea.l	objoff_34(a0),a1
		subq.w	#1,objoff_38(a1)
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
