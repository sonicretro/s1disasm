; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
; ---------------------------------------------------------------------------

DisplaySprite:
		lea	(v_spritequeue).w,a1			; load sprite priority layer buffer
		move.w	obPriority(a0),d0			; d0 = priority level * $100 (lower byte ignored)
		lsr.w	#8-spritelayer_size_bits,d0		; d0 = priority level * spritequeue_layersize (lower bits ignored)
		andi.w	#spritelayer_size*(spritelayer_num-1),d0 ; mask to possible offset starts per layer ($80*7=$380)
		adda.w	d0,a1					; jump to start of appropriate priority layer
		cmpi.w	#spritelayer_size-2,(a1)		; is this sprite priority layer full? ($7E bytes)
		bhs.s	.return					; if yes, drop queuing this sprite
		addq.w	#2,(a1)					; increment sprite counter
		adda.w	(a1),a1					; jump to empty position
		move.w	a0,(a1)					; insert RAM address for object

	.return:
		rts						; return
; End of function DisplaySprite

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to display a 2nd sprite/object, when a1 is the object RAM
; ---------------------------------------------------------------------------

; DisplaySprite1: <-- old misnomer
DisplaySprite2:
		lea	(v_spritequeue).w,a2			; load sprite priority layer buffer
		move.w	obPriority(a1),d0			; d0 = priority level * $100 (lower byte ignored)
		lsr.w	#8-spritelayer_size_bits,d0		; d0 = priority level * spritequeue_layersize (lower bits ignored)
		andi.w	#spritelayer_size*(spritelayer_num-1),d0 ; mask to possible offset starts per layer ($80*7=$380)
		adda.w	d0,a2					; jump to start of appropriate priority layer
		cmpi.w	#spritelayer_size-2,(a2)		; is this sprite priority layer full? ($7E bytes)
		bhs.s	.return					; if yes, drop queuing this sprite
		addq.w	#2,(a2)					; increment sprite counter
		adda.w	(a2),a2					; jump to empty position
		move.w	a1,(a2)					; insert RAM address for object

	.return:
		rts						; return
; End of function DisplaySprite2
