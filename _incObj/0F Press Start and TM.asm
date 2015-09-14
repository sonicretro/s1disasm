; ---------------------------------------------------------------------------
; Object 0F - "PRESS START BUTTON" and "TM" from title screen
; ---------------------------------------------------------------------------

PSBTM:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	PSB_Index(pc,d0.w),d1
		jsr	PSB_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
PSB_Index:	dc.w PSB_Main-PSB_Index
		dc.w PSB_PrsStart-PSB_Index
		dc.w PSB_Exit-PSB_Index
; ===========================================================================

PSB_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$D0,obX(a0)
		move.w	#$130,obScreenY(a0)
		move.l	#Map_PSB,obMap(a0)
		move.w	#$200,obGfx(a0)
		cmpi.b	#2,obFrame(a0)	; is object "PRESS START"?
		bcs.s	PSB_PrsStart	; if yes, branch

		addq.b	#2,obRoutine(a0)
		cmpi.b	#3,obFrame(a0)	; is the object	"TM"?
		bne.s	PSB_Exit	; if not, branch

		move.w	#$2510,obGfx(a0) ; "TM" specific code
		move.w	#$170,obX(a0)
		move.w	#$F8,obScreenY(a0)

PSB_Exit:	; Routine 4
		rts	
; ===========================================================================

PSB_PrsStart:	; Routine 2
		lea	(Ani_PSBTM).l,a1
		bra.w	AnimateSprite	; "PRESS START" is animated