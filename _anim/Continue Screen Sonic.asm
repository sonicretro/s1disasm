; ---------------------------------------------------------------------------
; Animation script - Sonic on the continue screen
; ---------------------------------------------------------------------------

Ani_CSon:	offsetTable
		ptr .onfloor

.onfloor:	dc.b 4
		dc.b 1, 1, 1, 1, 2, 2, 2, 3, 3
		dc.b afEnd
		even
