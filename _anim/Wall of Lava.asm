; ---------------------------------------------------------------------------
; Animation script - advancing wall of lava (MZ act 2)
; ---------------------------------------------------------------------------

Ani_LWall:	offsetTable
		ptr .lavawall

.lavawall:	dc.b 9
		dc.b 0, 1, 2, 3
		dc.b afEnd
		even
