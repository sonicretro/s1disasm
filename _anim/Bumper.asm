; ---------------------------------------------------------------------------
; Animation script - Bumper (SYZ)
; ---------------------------------------------------------------------------

Ani_Bump:	offsetTable
		ptr .idle
		ptr .touched

.idle:		dc.b 15
		dc.b 0
		dc.b afEnd
		even

.touched:	dc.b 3
		dc.b 1, 2, 1, 2
		dc.b afChange, 0
		even
