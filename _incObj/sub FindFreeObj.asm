; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to find a free object space
; 
; output:
;	a1 = free position in object RAM
;	CCR Z-flag = set if slot was found, clear if RAM is full
; ---------------------------------------------------------------------------

FindFreeObj:
		lea	(v_lvlobjspace).w,a1			; start address for object RAM
		move.w	#(v_lvlobjend-v_lvlobjspace)/object_size-1,d0 ; check entire dynamic object RAM

FFree_Loop:
		tst.b	obID(a1)				; is object RAM slot empty?
		beq.s	FFree_Found				; if yes, exit and use that slot
		lea	object_size(a1),a1			; go to next object RAM slot
		dbf	d0,FFree_Loop				; repeat up to 95 times

FFree_Found:
		rts						; return with result in a1
; End of function FindFreeObj

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to find a free object space AFTER the current one
; 
; input:
; 	a0 = base object pointer
; 
; output:
;	a1 = free position in object RAM
;	CCR Z-flag = set if slot was found, clear if RAM is full
; ---------------------------------------------------------------------------

FindNextFreeObj:
		movea.l	a0,a1					; get RAM location of parent object
		move.w	#v_lvlobjend&$FFFF,d0			; get end location of object RAM (16-bit)
		sub.w	a0,d0					; d0 = remaining RAM after parent object
		lsr.w	#6,d0					; divide by $40 (object_size)
		subq.w	#1,d0					; minus 1 for dbf
		bcs.s	NFree_Found				; if underflowed, parent object is at the end of RAM, quit

NFree_Loop:
		tst.b	obID(a1)				; is object RAM slot empty?
		beq.s	NFree_Found				; if yes, exit and use that slot
		lea	object_size(a1),a1			; go to next object RAM slot
		dbf	d0,NFree_Loop				; repeat for all free object RAM slots after parent

NFree_Found:
		rts						; return with result in a1
; End of function FindNextFreeObj
