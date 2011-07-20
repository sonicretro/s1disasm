; ---------------------------------------------------------------------------
; Kosinski decompression algorithm

; input:
;	a0 = source address
;	a1 = destination address

; usage:
;	lea	(source).l,a0
;	lea	(destination).l,a1
;	bsr.w	KosDec
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


KosDec:

		subq.l	#2,sp	; make space for 2 bytes on the stack
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5	; get first description field
		moveq	#$F,d4	; set to loop for 16 bits

Kos_Loop:
		lsr.w	#1,d5	; shift bit into the c flag
		move	sr,d6
		dbf	d4,@chkbit
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5
		moveq	#$F,d4

	@chkbit:
		move	d6,ccr	; was the bit set?
		bcc.s	Kos_RLE	; if not, branch

		move.b	(a0)+,(a1)+ ; copy byte as-is
		bra.s	Kos_Loop
; ===========================================================================

Kos_RLE:				; XREF: KosDec
		moveq	#0,d3
		lsr.w	#1,d5	; get next bit
		move	sr,d6
		dbf	d4,@chkbit
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5
		moveq	#$F,d4

	@chkbit:
		move	d6,ccr	; was the bit set?
		bcs.s	Kos_SeparateRLE ; if yes, branch

		lsr.w	#1,d5	; shift bit into the x flag
		dbf	d4,@loop1
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5
		moveq	#$F,d4

	@loop1:
		roxl.w	#1,d3	; get high repeat count bit
		lsr.w	#1,d5
		dbf	d4,@loop2
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5
		moveq	#$F,d4

	@loop2:
		roxl.w	#1,d3	; get low repeat count bit
		addq.w	#1,d3	; increment repeat count
		moveq	#-1,d2
		move.b	(a0)+,d2 ; calculate offset
		bra.s	Kos_RLELoop
; ===========================================================================

Kos_SeparateRLE:			; XREF: Kos_RLE
		move.b	(a0)+,d0 ; get first byte
		move.b	(a0)+,d1 ; get second byte
		moveq	#-1,d2
		move.b	d1,d2
		lsl.w	#5,d2
		move.b	d0,d2	; calculate offset
		andi.w	#7,d1	; does a third byte need to be read?
		beq.s	Kos_SeparateRLE2 ; if yes, branch
		move.b	d1,d3	; copy repeat count
		addq.w	#1,d3	; increment

Kos_RLELoop:
		move.b	(a1,d2.w),d0 ; copy appropriate byte
		move.b	d0,(a1)+ ; repeat
		dbf	d3,Kos_RLELoop
		bra.s	Kos_Loop
; ===========================================================================

Kos_SeparateRLE2:			; XREF: Kos_SeparateRLE
		move.b	(a0)+,d1
		beq.s	Kos_Done ; 0 indicates end of compressed data
		cmpi.b	#1,d1
		beq.w	Kos_Loop ; 1 indicates new description to be read
		move.b	d1,d3	; otherwise, copy repeat count
		bra.s	Kos_RLELoop
; ===========================================================================

Kos_Done:				; XREF: Kos_SeparateRLE2
		addq.l	#2,sp	; restore stack pointer
		rts	
; End of function KosDec
