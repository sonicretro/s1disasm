; ---------------------------------------------------------------------------
; Object 4A - special stage entry from beta
; ---------------------------------------------------------------------------

VanishSonic:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Van_Index(pc,d0.w),d1
		jmp	Van_Index(pc,d1.w)
; ===========================================================================
Van_Index:	dc.w Van_Main-Van_Index
		dc.w Van_RmvSonic-Van_Index
		dc.w Van_LoadSonic-Van_Index

van_time:	= $30		; time for Sonic to disappear
; ===========================================================================

Van_Main:	; Routine 0
		tst.l	(v_plc_buffer).w ; are pattern load cues empty?
		beq.s	@isempty	; if yes, branch
		rts	

	@isempty:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Vanish,obMap(a0)
		move.b	#4,obRender(a0)
		move.b	#1,obPriority(a0)
		move.b	#$38,obActWid(a0)
		move.w	#$541,obGfx(a0)
		move.w	#120,van_time(a0) ; set time for Sonic's disappearance to 2 seconds

Van_RmvSonic:	; Routine 2
		move.w	(v_player+obX).w,obX(a0)
		move.w	(v_player+obY).w,obY(a0)
		move.b	(v_player+obStatus).w,obStatus(a0)
		lea	(Ani_Vanish).l,a1
		jsr	AnimateSprite
		cmpi.b	#2,obFrame(a0)
		bne.s	@display
		tst.b	(v_player).w
		beq.s	@display
		move.b	#0,(v_player).w	; remove Sonic
		sfx	sfx_SSGoal	; play Special Stage "GOAL" sound

	@display:
		jmp	DisplaySprite
; ===========================================================================

Van_LoadSonic:	; Routine 4
		subq.w	#1,van_time(a0)	; subtract 1 from time
		bne.s	@wait		; if time remains, branch
		move.b	#id_SonicPlayer,(v_player).w ; load Sonic object
		jmp	DeleteObject

	@wait:
		rts	