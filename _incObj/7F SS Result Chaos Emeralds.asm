; ---------------------------------------------------------------------------
; Object 7F - chaos emeralds from the special stage results screen
; ---------------------------------------------------------------------------

SSRChaos:				; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	SSRC_Index(pc,d0.w),d1
		jmp	SSRC_Index(pc,d1.w)
; ===========================================================================
SSRC_Index:	dc.w SSRC_Main-SSRC_Index
		dc.w SSRC_Flash-SSRC_Index

; ---------------------------------------------------------------------------
; X-axis positions for chaos emeralds
; ---------------------------------------------------------------------------
SSRC_PosData:	dc.w $110, $128, $F8, $140, $E0, $158
; ===========================================================================

SSRC_Main:	; Routine 0
		movea.l	a0,a1
		lea	(SSRC_PosData).l,a2
		moveq	#0,d2
		moveq	#0,d1
		move.b	(v_emeralds).w,d1 ; d1 is number of emeralds
		subq.b	#1,d1		; subtract 1 from d1
		bcs.w	DeleteObject	; if you have 0	emeralds, branch

	SSRC_Loop:
		move.b	#id_SSRChaos,0(a1)
		move.w	(a2)+,obX(a1)	; set x-position
		move.w	#$F0,obScreenY(a1) ; set y-position
		lea	(v_emldlist).w,a3 ; check which emeralds you have
		move.b	(a3,d2.w),d3
		move.b	d3,obFrame(a1)
		move.b	d3,obAnim(a1)
		addq.b	#1,d2
		addq.b	#2,obRoutine(a1)
		move.l	#Map_SSRC,obMap(a1)
		move.w	#$8541,obGfx(a1)
		move.b	#0,obRender(a1)
		lea	$40(a1),a1	; next object
		dbf	d1,SSRC_Loop	; loop for d1 number of	emeralds

SSRC_Flash:	; Routine 2
		move.b	obFrame(a0),d0
		move.b	#6,obFrame(a0)	; load 6th frame (blank)
		cmpi.b	#6,d0
		bne.s	SSRC_Display
		move.b	obAnim(a0),obFrame(a0) ; load visible frame

	SSRC_Display:
		bra.w	DisplaySprite