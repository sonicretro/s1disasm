; ---------------------------------------------------------------------------
; Subroutine to	queue a sound into buffer 1, often used for BGM

; input:
;	d0 = track to play
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


QueueSound1:
		move.b	d0,(v_snddriver_ram.v_soundqueue0).w
		rts	
; End of function QueueSound1

; ---------------------------------------------------------------------------
; Subroutine to	queue a sound into buffer 2, often used for SFX
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


QueueSound2:
		move.b	d0,(v_snddriver_ram.v_soundqueue1).w
		rts	
; End of function QueueSound2

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	queue a sound into buffer 3, unused and broken.
; Enabling "FixBugs" will make this usable.
; ---------------------------------------------------------------------------

QueueSound3:
		move.b	d0,(v_snddriver_ram.v_soundqueue2).w
		rts	
