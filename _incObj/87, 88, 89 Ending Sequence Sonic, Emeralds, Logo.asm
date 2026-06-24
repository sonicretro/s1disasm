; ===========================================================================
; ---------------------------------------------------------------------------
; Object 87 - Sonic on ending sequence.
; (Note that this object works strongly in tandem with End_MoveSonic.)
; ---------------------------------------------------------------------------

EndSonic:
		; This object uses ob2ndRout instead of the regular obRoutine, presumably
		; to avoid conflicts for when it gets swapped-in for the true Sonic object.
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	ESon_Index(pc,d0.w),d1
		jsr	ESon_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
ESon_Index:	dc.w ESon_Main-ESon_Index		; 0
		; --- Good Ending (6 emeralds) ---
		dc.w ESon_MakeEmeralds-ESon_Index	; 2
		dc.w ESon_Animate-ESon_Index		; 4
		dc.w ESon_LookUp-ESon_Index		; 6
		dc.w ESon_DeleteEmeralds-ESon_Index	; 8
		dc.w ESon_Animate-ESon_Index		; A
		dc.w ESon_MakeLogo-ESon_Index		; C
		dc.w ESon_Animate-ESon_Index		; E
		; --- Bad Ending (not all emeralds) ---
		dc.w ESon_BadEnding-ESon_Index		; 10
		dc.w ESon_Animate-ESon_Index		; 12

eson_time:	equ objoff_30		; time to wait between events (2 bytes)
; ===========================================================================

ESon_Main:	; Routine 0
		cmpi.b	#ss_emeralds_num,(v_emeralds).w		; do you have all 6 emeralds?
		beq.s	ESon_GoodEnding				; if yes, branch
		addi.b	#$10,ob2ndRout(a0)			; else, skip emerald sequence (set to ESon_BadEnding)
		move.w	#(3*60)+36,eson_time(a0)		; set time before leap to just over 3.5 seconds
		rts						; return
; ===========================================================================

ESon_GoodEnding:
		addq.b	#2,ob2ndRout(a0)			; advance to ESon_MakeEmeralds
		move.l	#Map_ESon,obMap(a0)			; set mappings
		move.w	#ArtTile_Ending_Sonic,obGfx(a0)		; set art tile
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		clr.b	obStatus(a0)				; clear X-flip flag
		move.b	#2,obPriority(a0)			; set sprite priority
		move.b	#0,obFrame(a0)				; set to "looking at emeralds" frame
		move.w	#(1*60)+20,eson_time(a0)		; set duration to look at emeralds to a bit under 1.5 seconds
; ---------------------------------------------------------------------------

ESon_MakeEmeralds:
		; Routine 2
		subq.w	#1,eson_time(a0)			; decrement timer to stare at hands
		bne.s	.return					; if time remains, branch

		addq.b	#2,ob2ndRout(a0)			; advance to ESon_Animate ($4)
		move.w	#(0<<8)+1,obAnim(a0)			; set to "hold" animation and restart it immediately
		move.b	#id_EndChaos,(v_endemeralds).w		; load ending sequence chaos emeralds objects

	.return:
		rts						; return
; ===========================================================================

ESon_LookUp:	; Routine 6
		cmpi.w	#$20*$100,((v_endemeralds+echa_radius)&$FFFFFF).l ; are emeralds spinning at maximum radius? (see ECha_Expand)
		bne.s	.return					; if not, wait until they are

		move.w	#1,(f_restart).w			; signal to End_ChkEmerald to start white screen flash
		move.w	#(1*60)+30,eson_time(a0)		; let white screen flash last for 1.5 seconds
		addq.b	#2,ob2ndRout(a0)			; advance to ESon_DeleteEmeralds

	.return:
		rts						; return
; ===========================================================================

ESon_DeleteEmeralds:
		; Routine 8
		subq.w	#1,eson_time(a0)			; decrement timer before deleting emeralds (screen flash)
		bne.s	.return					; if time remains, branch

		lea	(v_endemeralds).w,a1			; start address of ending emeralds
		move.w	#(v_endemeralds_end-v_endemeralds)/4-1,d1 ; delete all ending sequence emeralds
	.clear:	clr.l	(a1)+					; clear emerald object RAM
		dbf	d1,.clear				; loop until all emeralds have been deleted

		move.w	#1,(f_restart).w			; signal to End_SlowFade that emeralds have disappeared
		addq.b	#2,ob2ndRout(a0)			; advance to ESon_Animate ($A)
		move.b	#1,obAnim(a0)				; set Sonic to "confused" animation
		move.w	#1*60,eson_time(a0)			; time to stay on last frame after confused animation has finished (1 second)

	.return:
		rts						; return
; ===========================================================================

ESon_MakeLogo:	; Routine $C
		subq.w	#1,eson_time(a0)			; decrement timer for Sonic to stay on last confusion frame
		bne.s	.return					; if time remains, branch

		addq.b	#2,ob2ndRout(a0)			; advance to ESon_Animate ($E, no longer advances past that)
		move.w	#3*60,eson_time(a0)			; unused (?) timer set to 3 seconds
		move.b	#2,obAnim(a0)				; set Sonic to "leap at screen" animation
		move.b	#id_EndSTH,(v_endlogo).w		; load "SONIC THE HEDGEHOG" object

	.return:
		rts						; return
; ===========================================================================

ESon_Animate:	; Rountine 4, $A, $E, $12
		lea	(Ani_ESon).l,a1				; load animation script
		jmp	(AnimateSprite).l			; (most of these animations are set up to increase ob2ndRout on finish!)
; ===========================================================================

ESon_BadEnding:	; Routine $10
		subq.w	#1,eson_time(a0)			; decrement time before leap
		bne.s	.return					; if time remains, branch

		addq.b	#2,ob2ndRout(a0)			; advance to ESon_Animate ($12, doesn't advance past that)
		move.l	#Map_ESon,obMap(a0)			; set mappings
		move.w	#ArtTile_Ending_Sonic,obGfx(a0)		; set art tile
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		clr.b	obStatus(a0)				; clear any X/Y-flip flags
		move.b	#2,obPriority(a0)			; set sprite priority
		move.b	#5,obFrame(a0)				; use first "leaping" frame
		move.b	#2,obAnim(a0)				; set Sonic to "leap at screen" animation
		move.b	#id_EndSTH,(v_endlogo).w		; load "SONIC THE HEDGEHOG" object
		bra.s	ESon_Animate				; execute new animation immediately

	.return:
		rts						; return

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
ECha_Index:	dc.w ECha_Main-ECha_Index	; 0
		dc.w ECha_Move-ECha_Index	; 2

echa_origX:	equ objoff_38		; x-axis center of emerald circle (2 bytes)
echa_origY:	equ objoff_3A		; y-axis center of emerald circle (2 bytes)
echa_radius:	equ objoff_3C		; radius (2 bytes)
echa_angle:	equ objoff_3E		; angle for rotation (2 bytes)
; ===========================================================================

ECha_Main:	; Routine 0
		; (This isn't fr_Wait1: v_player is Object 88, which has its own frames.)
		cmpi.b	#2,(v_player+obFrame).w			; is Sonic on final frame in "hold" animation?
		beq.s	ECha_CreateEms				; if yes, branch
		addq.l	#4,sp					; don't return to EndChaos to skip calling DisplaySprite
		rts						; return
; ===========================================================================

ECha_CreateEms:
		move.w	(v_player+obX).w,obX(a0)		; match X position with Sonic
		move.w	(v_player+obY).w,obY(a0)		; match Y position with Sonic
		movea.l	a0,a1
		moveq	#0,d3					; set initial angle variance between emeralds
		moveq	#1,d2					; start at animation and frame ID 1 (0 is flashing white frame)
		moveq	#ss_emeralds_num-1,d1			; load one object per emerald (6)

	.loopLoadEmeralds:
		move.b	#id_EndChaos,obID(a1)			; load chaos emerald object
		addq.b	#2,obRoutine(a1)			; set to ECha_Move
		move.l	#Map_ECha,obMap(a1)			; set mappings
		move.w	#ArtTile_Ending_Emeralds,obGfx(a1)	; set art tile
		move.b	#sprite_cam_field,obRender(a1)		; set to playfield-positioned mode
		move.b	#1,obPriority(a1)			; set sprite priority (above Sonic)
		move.w	obX(a0),echa_origX(a1)			; remember initial X-position for spinning animation
		move.w	obY(a0),echa_origY(a1)			; remember initial Y-position for spinning animation
		move.b	d2,obAnim(a1)				; set animation (unused here?)
		move.b	d2,obFrame(a1)				; use current emerald color frame
		addq.b	#1,d2					; advance to next frame for next color
		move.b	d3,obAngle(a1)				; set angle variance for this emerald
		addi.b	#$100/ss_emeralds_num,d3		; increase angle variance between each emerald

		lea	object_size(a1),a1			; advance to next object RAM slot ($40)
		dbf	d1,.loopLoadEmeralds			; repeat until all emeralds have been loaded
; ---------------------------------------------------------------------------

ECha_Move:	; Routine 2
		move.w	echa_angle(a0),d0			; get current emerald angle increment value
		add.w	d0,obAngle(a0)				; add to current angle to make emeralds spin even faster
		move.b	obAngle(a0),d0				; get new angle
		jsr	(CalcSine).l				; calculate sine and cosine values for this angle
		moveq	#0,d4					; clear d4
		move.b	echa_radius(a0),d4			; get current radius value
		muls.w	d4,d1					; multiply cosine part by radius to widen it
		asr.l	#8,d1					; shift result down a byte
		muls.w	d4,d0					; multiply sine part by radius to widen it
		asr.l	#8,d0					; shift result down a byte
		add.w	echa_origX(a0),d1			; add original X-position
		add.w	echa_origY(a0),d0			; add original Y-position
		move.w	d1,obX(a0)				; set new spinning X-position
		move.w	d0,obY(a0)				; set new spinning Y-position

ECha_Expand:
		cmpi.w	#$20*$100,echa_radius(a0)		; are emeralds already spinning at max radius?
		beq.s	ECha_Rotate				; if yes, don't increase it further
		addi.w	#$20,echa_radius(a0)			; expand radius of spinning emeralds

ECha_Rotate:
		cmpi.w	#$20*$100,echa_angle(a0)		; are emeralds already spinning at max angle?
		beq.s	ECha_Rise				; if yes, don't increase it further
		addi.w	#$20,echa_angle(a0)			; expand angle of spinning emeralds

ECha_Rise:
		cmpi.w	#$140,echa_origY(a0)			; have emeralds reached final Y-position
		beq.s	ECha_End				; if yes, don't raise them further
		subq.w	#1,echa_origY(a0)			; make circle rise

ECha_End:
		rts						; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 89 - "SONIC THE HEDGEHOG" text on the ending sequence.
; 
; In REV01, this object got adjusted to consolidate its calls to
; DisplaySprite to a single spot (though this didn't alter behavior).
; Also, the time to stay on the text was increased from 2 to 5 seconds.
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
ESth_Index:	dc.w ESth_Main-ESth_Index		; 0
		dc.w ESth_Move-ESth_Index		; 2
		dc.w ESth_GotoCredits-ESth_Index	; 4

esth_time:	equ objoff_30		; time to stay on the text before exiting to credits (2 bytes)
; ===========================================================================

ESth_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to ESth_Move
		move.w	#$80-$A0,obX(a0)			; object starts outside the visible screen space
		move.w	#$80+$58,obScreenY(a0)			; set fixed Y-position
		move.l	#Map_ESth,obMap(a0)			; set mappings
		move.w	#ArtTile_Ending_STH,obGfx(a0)		; set art tile
		move.b	#sprite_cam_screen,obRender(a0)		; set to screen-positioned mode
		move.b	#0,obPriority(a0)			; set to maximum sprite priority
; ---------------------------------------------------------------------------

ESth_Move:	; Routine 2
		cmpi.w	#$80+$40,obX(a0)			; has object reached $40 in visible screen space? ($C0)
		beq.s	ESth_Delay				; if yes, branch
		addi.w	#$10,obX(a0)				; move object to the right
	if Revision=0
		bra.w	DisplaySprite				; display sprite
	else
		rts						; sprite is displayed in EndSTH
	endif
; ---------------------------------------------------------------------------

ESth_Delay:
		addq.b	#2,obRoutine(a0)			; advance to ESth_GotoCredits
	if Revision=0
		move.w	#2*60,esth_time(a0)			; set duration for delay (2 seconds)
	else
		move.w	#5*60,esth_time(a0)			; set duration for delay (5 seconds)
	endif
; ---------------------------------------------------------------------------

ESth_GotoCredits:
		; Routine 4
		subq.w	#1,esth_time(a0)			; decrement time delay before going to credits
		bpl.s	ESth_Wait				; if time remains, branch
		move.b	#id_Credits,(v_gamemode).w		; exit to credits game mode (this is a trigger for End_MainLoop)

ESth_Wait:
	if Revision=0
		bra.w	DisplaySprite				; display sprite
	else
		rts						; sprite is displayed in EndSTH
	endif
; ===========================================================================

Map_ESon:	include	"_maps/Ending Sequence Sonic.asm"
Map_ECha:	include	"_maps/Ending Sequence Emeralds.asm"
Map_ESth:	include	"_maps/Ending Sequence STH.asm"
