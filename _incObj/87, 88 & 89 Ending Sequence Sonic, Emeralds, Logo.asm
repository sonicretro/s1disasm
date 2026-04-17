; ---------------------------------------------------------------------------
; Object 87 - Sonic on ending sequence
; ---------------------------------------------------------------------------

EndSonic:
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	ESon_Index(pc,d0.w),d1
		jsr	ESon_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
ESon_Index:	offsetTable
		ptr ESon_Main
		ptr ESon_MakeEmeralds
		ptr ESon_Animate
		ptr ESon_LookUp
		ptr ESon_ClrObjRam
		ptr ESon_Animate
		ptr ESon_MakeLogo
		ptr ESon_Animate
		ptr ESon_Leap
		ptr ESon_Animate

eson_time = objoff_30	; time to wait between events
; ===========================================================================

ESon_Main:	; Routine 0
		cmpi.b	#6,(v_emeralds).w ; do you have all 6 emeralds?
		beq.s	ESon_Main2	; if yes, branch
		addi.b	#$10,ob2ndRout(a0) ; else, skip emerald sequence
		move.w	#216,eson_time(a0)
		rts
; ===========================================================================

ESon_Main2:
		addq.b	#2,ob2ndRout(a0)
		move.l	#Map_ESon,obMap(a0)
		move.w	#ArtTile_Ending_Sonic,obGfx(a0)
		move.b	#4,obRender(a0)
		clr.b	obStatus(a0)
		move.b	#2,obPriority(a0)
		move.b	#0,obFrame(a0)
		move.w	#80,eson_time(a0) ; set duration for Sonic to pause

ESon_MakeEmeralds:
		; Routine 2
		subq.w	#1,eson_time(a0) ; subtract 1 from duration
		bne.s	ESon_Wait
		addq.b	#2,ob2ndRout(a0)
		move.w	#1,obAnim(a0)
		move.b	#id_EndChaos,(v_endemeralds).w ; load chaos emeralds objects

ESon_Wait:
		rts
; ===========================================================================

ESon_LookUp:	; Routine 6
		cmpi.w	#$2000,((v_endemeralds+echa_radius)&$FFFFFF).l
		bne.s	locret_5480
		move.w	#1,(f_restart).w ; set level to restart (causes flash)
		move.w	#90,eson_time(a0)
		addq.b	#2,ob2ndRout(a0)

locret_5480:
		rts
; ===========================================================================

ESon_ClrObjRam:
		; Routine 8
		subq.w	#1,eson_time(a0)
		bne.s	ESon_Wait2
		lea	(v_endemeralds).w,a1
		move.w	#(v_endemeralds_end-v_endemeralds)/4-1,d1

ESon_ClrLoop:
		clr.l	(a1)+
		dbf	d1,ESon_ClrLoop ; clear the object RAM
		move.w	#1,(f_restart).w
		addq.b	#2,ob2ndRout(a0)
		move.b	#1,obAnim(a0)
		move.w	#60,eson_time(a0)

ESon_Wait2:
		rts
; ===========================================================================

ESon_MakeLogo:	; Routine $C
		subq.w	#1,eson_time(a0)
		bne.s	ESon_Wait3
		addq.b	#2,ob2ndRout(a0)
		move.w	#180,eson_time(a0)
		move.b	#2,obAnim(a0)
		move.b	#id_EndSTH,(v_endlogo).w ; load "SONIC THE HEDGEHOG" object

ESon_Wait3:
		rts
; ===========================================================================

ESon_Animate:	; Rountine 4, $A, $E, $12
		lea	(Ani_ESon).l,a1
		jmp	(AnimateSprite).l
; ===========================================================================

ESon_Leap:	; Routine $10
		subq.w	#1,eson_time(a0)
		bne.s	ESon_Wait4
		addq.b	#2,ob2ndRout(a0)
		move.l	#Map_ESon,obMap(a0)
		move.w	#ArtTile_Ending_Sonic,obGfx(a0)
		move.b	#4,obRender(a0)
		clr.b	obStatus(a0)
		move.b	#2,obPriority(a0)
		move.b	#5,obFrame(a0)
		move.b	#2,obAnim(a0)	; use "leaping" animation
		move.b	#id_EndSTH,(v_endlogo).w ; load "SONIC THE HEDGEHOG" object
		bra.s	ESon_Animate
; ===========================================================================

ESon_Wait4:
		rts
; ===========================================================================

		include "_anim/Ending Sequence Sonic.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 88 - chaos emeralds on the ending sequence
; ---------------------------------------------------------------------------

EndChaos:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	ECha_Index(pc,d0.w),d1
		jsr	ECha_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
ECha_Index:	offsetTable
		ptr ECha_Main
		ptr ECha_Move

echa_origX:	equ objoff_38	; x-axis centre of emerald circle (2 bytes)
echa_origY:	equ objoff_3A	; y-axis centre of emerald circle (2 bytes)
echa_radius:	equ objoff_3C	; radius (2 bytes)
echa_angle:	equ objoff_3E	; angle for rotation (2 bytes)
; ===========================================================================

ECha_Main:	; Routine 0
		cmpi.b	#2,(v_player+obFrame).w ; this isn't `fr_Wait1`: `v_player` is Object 88, which has its own frames
		beq.s	ECha_CreateEms
		addq.l	#4,sp
		rts
; ===========================================================================

ECha_CreateEms:
		move.w	(v_player+obX).w,obX(a0) ; match X position with Sonic
		move.w	(v_player+obY).w,obY(a0) ; match Y position with Sonic
		movea.l	a0,a1
		moveq	#0,d3
		moveq	#1,d2
		moveq	#5,d1

ECha_LoadLoop:
		move.b	#id_EndChaos,obID(a1) ; load chaos emerald object
		addq.b	#2,obRoutine(a1)
		move.l	#Map_ECha,obMap(a1)
		move.w	#ArtTile_Ending_Emeralds,obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#1,obPriority(a1)
		move.w	obX(a0),echa_origX(a1)
		move.w	obY(a0),echa_origY(a1)
		move.b	d2,obAnim(a1)
		move.b	d2,obFrame(a1)
		addq.b	#1,d2
		move.b	d3,obAngle(a1)
		addi.b	#$100/6,d3	; angle between each emerald
		lea	object_size(a1),a1
		dbf	d1,ECha_LoadLoop ; repeat 5 more times

ECha_Move:	; Routine 2
		move.w	echa_angle(a0),d0
		add.w	d0,obAngle(a0)
		move.b	obAngle(a0),d0
		jsr	(CalcSine).l
		moveq	#0,d4
		move.b	echa_radius(a0),d4
		muls.w	d4,d1
		asr.l	#8,d1
		muls.w	d4,d0
		asr.l	#8,d0
		add.w	echa_origX(a0),d1
		add.w	echa_origY(a0),d0
		move.w	d1,obX(a0)
		move.w	d0,obY(a0)

ECha_Expand:
		cmpi.w	#$2000,echa_radius(a0)
		beq.s	ECha_Rotate
		addi.w	#$20,echa_radius(a0) ; expand circle of emeralds

ECha_Rotate:
		cmpi.w	#$2000,echa_angle(a0)
		beq.s	ECha_Rise
		addi.w	#$20,echa_angle(a0) ; move emeralds around the centre

ECha_Rise:
		cmpi.w	#$140,echa_origY(a0)
		beq.s	ECha_End
		subq.w	#1,echa_origY(a0) ; make circle rise

ECha_End:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 89 - "SONIC THE HEDGEHOG" text on the ending sequence
; ---------------------------------------------------------------------------

EndSTH:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	ESth_Index(pc,d0.w),d1
	if Revision=0
		jmp	ESth_Index(pc,d1.w)
	else
		jsr	ESth_Index(pc,d1.w)
		jmp	(DisplaySprite).l
	endif
; ===========================================================================
ESth_Index:	offsetTable
		ptr ESth_Main
		ptr ESth_Move
		ptr ESth_GotoCredits

esth_time = objoff_30		; time until exit
; ===========================================================================

ESth_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#-$20,obX(a0)	; object starts outside the level boundary
		move.w	#$D8,obScreenY(a0)
		move.l	#Map_ESth,obMap(a0)
		move.w	#ArtTile_Ending_STH,obGfx(a0)
		move.b	#0,obRender(a0)
		move.b	#0,obPriority(a0)

ESth_Move:	; Routine 2
		cmpi.w	#$C0,obX(a0)	; has object reached $C0?
		beq.s	ESth_Delay	; if yes, branch
		addi.w	#$10,obX(a0)	; move object to the right
	if Revision=0
		bra.w	DisplaySprite
	else
		rts
	endif

ESth_Delay:
		addq.b	#2,obRoutine(a0)
	if Revision=0
		move.w	#120,esth_time(a0) ; set duration for delay (2 seconds)
	else
		move.w	#300,esth_time(a0) ; set duration for delay (5 seconds)
	endif

ESth_GotoCredits:
		; Routine 4
		subq.w	#1,esth_time(a0) ; subtract 1 from duration
		bpl.s	ESth_Wait
		move.b	#id_Credits,(v_gamemode).w ; exit to credits

ESth_Wait:
	if Revision=0
		bra.w	DisplaySprite
	else
		rts
	endif
; ===========================================================================

Map_ESon:	include	"_maps/Ending Sequence Sonic.asm"
Map_ECha:	include	"_maps/Ending Sequence Emeralds.asm"
Map_ESth:	include	"_maps/Ending Sequence STH.asm"
