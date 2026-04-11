LevelDataLoad:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#4,d0
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2
		move.l	a2,-(sp)
		addq.l	#4,a2
		movea.l	(a2)+,a0
		lea	(v_16x16).w,a1	; RAM address for 16x16 mappings
		move.w	#make_art_tile(ArtTile_Level,0,FALSE),d0
		bsr.w	EniDec
		movea.l	(a2)+,a0
		lea	(v_128x128).l,a1 ; RAM address for 128x128 mappings
		bsr.w	KosDec
		bsr.w	LevelLayoutLoad
		move.w	(a2)+,d0
		move.w	(a2),d0
		andi.w	#$FF,d0
		cmpi.w	#id_LZ_act4,(v_zone).w ; is level SBZ3 (LZ4)?
		bne.s	.notSBZ3	; if not, branch
		moveq	#palid_SBZ3,d0	; use SB3 palette

.notSBZ3:
		cmpi.w	#id_SBZ_act2,(v_zone).w ; is level SBZ2?
		beq.s	.isSBZorFZ	; if yes, branch
		cmpi.w	#id_FZ,(v_zone).w ; is level FZ?
		bne.s	.normalpal	; if not, branch

.isSBZorFZ:
		moveq	#palid_SBZ2,d0	; use SBZ2/FZ palette

.normalpal:
		bsr.w	PalLoad_Fade	; load palette (based on d0)
		movea.l	(sp)+,a2
		addq.w	#4,a2		; read number for 2nd PLC
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	.skipPLC	; if 2nd PLC is 0 (i.e. the ending sequence), branch
		bsr.w	AddPLC		; load pattern load cues

.skipPLC:
		rts	
; End of function LevelDataLoad

; ---------------------------------------------------------------------------
; Level layout loading subroutine
; ---------------------------------------------------------------------------


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

LevelLayoutLoad:
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#5,d0
		lea	(Level_Index).l,a0
		move.w	(a0,d0.w),d0
		lea	(a0,d0.w),a0
		lea	(v_lvllayout).w,a1
		bra.w	KosDec			; MJ: decompress layout
; End of function LevelLayoutLoad