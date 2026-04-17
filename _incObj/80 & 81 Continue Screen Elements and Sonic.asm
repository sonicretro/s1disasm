; ---------------------------------------------------------------------------
; Object 80 - Continue screen elements
; ---------------------------------------------------------------------------

ContScrItem:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	CSI_Index(pc,d0.w),d1
		jmp	CSI_Index(pc,d1.w)
; ===========================================================================
CSI_Index:	offsetTable
		ptr CSI_Main
		ptr CSI_Display
		ptr CSI_MakeMiniSonic
		ptr CSI_ChkDel
; ===========================================================================

CSI_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_ContScr,obMap(a0)
		move.w	#ArtTile_Continue_Sonic|Tile_Prio,obGfx(a0)
		move.b	#0,obRender(a0)
		move.b	#$3C,obActWid(a0)
		move.w	#$120,obX(a0)
		move.w	#$C0,obScreenY(a0)
		move.w	#0,(v_rings).w	; clear rings

CSI_Display:	; Routine 2
		jmp	(DisplaySprite).l
; ===========================================================================

CSI_MiniSonicPos:
		dc.w $116, $12A, $102, $13E, $EE, $152, $DA, $166, $C6
		dc.w $17A, $B2,	$18E, $9E, $1A2, $8A

CSI_MakeMiniSonic:
		; Routine 4
		movea.l	a0,a1
		lea	(CSI_MiniSonicPos).l,a2
		moveq	#0,d1
		move.b	(v_continues).w,d1
		subq.b	#2,d1
		bcc.s	CSI_MoreThan1
		jmp	(DeleteObject).l	; cancel if you have 0-1 continues

CSI_MoreThan1:
		moveq	#1,d3
		cmpi.b	#14,d1		; do you have fewer than 16 continues
		blo.s	CSI_FewerThan16	; if yes, branch

		moveq	#0,d3
		moveq	#14,d1		; cap at 15 mini-Sonics

CSI_FewerThan16:
		move.b	d1,d2
		andi.b	#1,d2

CSI_MiniSonicLoop:
		_move.b	#id_ContScrItem,obID(a1) ; load mini-Sonic object
		move.w	(a2)+,obX(a1)	; use above data for x-axis position
		tst.b	d2		; do you have an even number of continues?
		beq.s	CSI_Even	; if yes, branch
		subi.w	#$A,obX(a1)	; shift mini-Sonics slightly to the right

CSI_Even:
		move.w	#$D0,obScreenY(a1)
		move.b	#6,obFrame(a1)
		move.b	#6,obRoutine(a1)
		move.l	#Map_ContScr,obMap(a1)
		move.w	#ArtTile_Mini_Sonic|Tile_Prio,obGfx(a1)
		move.b	#0,obRender(a1)
		lea	object_size(a1),a1
		dbf	d1,CSI_MiniSonicLoop ; repeat for number of continues

		lea	-object_size(a1),a1
		move.b	d3,obSubtype(a1)

CSI_ChkDel:	; Routine 6
		tst.b	obSubtype(a0)	; do you have 16 or more continues?
		beq.s	CSI_Animate	; if yes, branch
		cmpi.b	#6,(v_player+obRoutine).w ; is Sonic running?
		blo.s	CSI_Animate	; if not, branch
		move.b	(v_vblank_byte).w,d0
		andi.b	#1,d0
		bne.s	CSI_Animate
		tst.w	(v_player+obVelX).w ; is Sonic running?
		bne.s	CSI_Delete	; if yes, goto delete
		rts

CSI_Animate:
		move.b	(v_vblank_byte).w,d0
		andi.b	#$F,d0
		bne.s	CSI_Display2
		bchg	#0,obFrame(a0)

CSI_Display2:
		jmp	(DisplaySprite).l
; ===========================================================================

CSI_Delete:
		jmp	(DeleteObject).l

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 81 - Sonic on the continue screen
; ---------------------------------------------------------------------------

ContSonic:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	CSon_Index(pc,d0.w),d1
		jsr	CSon_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
CSon_Index:	offsetTable
		ptr CSon_Main
		ptr CSon_ChkLand
		ptr CSon_Animate
		ptr CSon_Run
; ===========================================================================

CSon_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$A0,obX(a0)
		move.w	#$C0,obY(a0)
		move.l	#Map_Sonic,obMap(a0)
		move.w	#ArtTile_Sonic,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#2,obPriority(a0)
		move.b	#id_Float3,obAnim(a0) ; use "floating" animation
		move.w	#$400,obVelY(a0) ; make Sonic fall from above

CSon_ChkLand:	; Routine 2
		cmpi.w	#$1A0,obY(a0)	; has Sonic landed yet?
		bne.s	CSon_ShowFall	; if not, branch

		addq.b	#2,obRoutine(a0)
		clr.w	obVelY(a0)	; stop Sonic falling
		move.l	#Map_ContScr,obMap(a0)
		move.w	#ArtTile_Continue_Sonic|Tile_Prio,obGfx(a0)
		move.b	#id_Walk,obAnim(a0)
		bra.s	CSon_Animate

CSon_ShowFall:
		jsr	(SpeedToPos).l
		jsr	(Sonic_Animate).l
		jmp	(Sonic_LoadGfx).l
; ===========================================================================

CSon_Animate:	; Routine 4
		tst.b	(v_jpadpress1).w ; is Start button pressed?
		bmi.s	CSon_GetUp	; if yes, branch
		lea	(Ani_CSon).l,a1
		jmp	(AnimateSprite).l

CSon_GetUp:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Sonic,obMap(a0)
		move.w	#ArtTile_Sonic,obGfx(a0)
		move.b	#id_Float4,obAnim(a0) ; use "getting up" animation
		clr.w	obInertia(a0)
		subq.w	#8,obY(a0)
		move.b	#bgm_Fade,d0
		bsr.w	QueueSound2 ; fade out music

CSon_Run:	; Routine 6
		cmpi.w	#$800,obInertia(a0) ; check Sonic's inertia
		bne.s	CSon_AddInertia	; if too low, branch
		move.w	#$1000,obVelX(a0) ; move Sonic to the right
		bra.s	CSon_ShowRun

CSon_AddInertia:
		addi.w	#$20,obInertia(a0) ; increase inertia

CSon_ShowRun:
		jsr	(SpeedToPos).l
		jsr	(Sonic_Animate).l
		jmp	(Sonic_LoadGfx).l
; ===========================================================================

		include	"_anim/Continue Screen Sonic.asm"

Map_ContScr:	include	"_maps/Continue Screen.asm"
