; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to check if an object has gone off screen:
; - If it hasn't, queue the sprite for display.
; - If it has, try to find the relevant entry in the respawn table to clear
;   the respawn block flag (i.e. remember its state), and delete the object.
; ---------------------------------------------------------------------------

RememberState:
		out_of_range.w	.offscreen			; check if object is off-screen, branch if so
		bra.w	DisplaySprite				; object is on-screen, display sprite
; ---------------------------------------------------------------------------

.offscreen:
		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0 (obRespawnNo is a byte)
		move.b	obRespawnNo(a0),d0			; get object's respawn table index number
		beq.s	.delete					; if it doesn't have one, branch
		bclr	#7,2(a2,d0.w)				; clear respawn block flag so object can spawn again

	.delete:
		bra.w	DeleteObject				; delete the object
; End of function RememberState