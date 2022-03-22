; ---------------------------------------------------------------------------
; Object 7C - flash effect when	you collect the	giant ring
; ---------------------------------------------------------------------------

RingFlash:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Flash_Index(pc,d0.w),d1
		jmp	Flash_Index(pc,d1.w)
; ===========================================================================
Flash_Index:	dc.w Flash_Main-Flash_Index
		dc.w Flash_ChkDel-Flash_Index
		dc.w Flash_Delete-Flash_Index
; ===========================================================================

Flash_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Flash,obMap(a0)
		move.w	#$2462,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#0,obPriority(a0)
		move.b	#$20,obActWid(a0)
		move.b	#$FF,obFrame(a0)

Flash_ChkDel:	; Routine 2
		bsr.s	Flash_Collect
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Flash_Collect:
		subq.b	#1,obTimeFrame(a0)
		bpl.s	locret_9F76
		move.b	#1,obTimeFrame(a0)
		addq.b	#1,obFrame(a0)
		cmpi.b	#8,obFrame(a0)	; has animation	finished?
		bcc.s	Flash_End	; if yes, branch
		cmpi.b	#3,obFrame(a0)	; is 3rd frame displayed?
		bne.s	locret_9F76	; if not, branch
		movea.l	$3C(a0),a1	; get parent object address
		move.b	#6,obRoutine(a1) ; delete parent object
		move.b	#id_Null,(v_player+obAnim).w ; make Sonic invisible
		move.b	#1,(f_bigring).w ; stop	Sonic getting bonuses
		clr.b	(v_invinc).w	; remove invincibility
		clr.b	(v_shield).w	; remove shield

locret_9F76:
		rts	
; ===========================================================================

Flash_End:
		addq.b	#2,obRoutine(a0)
		move.w	#0,(v_player).w ; remove Sonic object
		addq.l	#4,sp
		rts	
; End of function Flash_Collect

; ===========================================================================

Flash_Delete:	; Routine 4
		bra.w	DeleteObject
