; ---------------------------------------------------------------------------
; Animation script - flapping door (LZ)
; ---------------------------------------------------------------------------

Ani_Flap:	offsetTable
		ptr .opening
		ptr .closing

.opening:	dc.b 3
		dc.b 0, 1
		dc.b 2
		dc.b afBack, 1
		even

.closing:	dc.b 3
		dc.b 2, 1
		dc.b 0
		dc.b afBack, 1
		even
