; ---------------------------------------------------------------------------
; Animation script - springs
; ---------------------------------------------------------------------------

Ani_Spring:	offsetTable
		ptr .updown
		ptr .leftright

.updown:	dc.b 0
		dc.b 1, 0, 0, 2, 2, 2, 2, 2, 2, 0
		dc.b afRoutine
		even

.leftright:	dc.b 0
		dc.b 4, 3, 3, 5, 5, 5, 5, 5, 5, 3
		dc.b afRoutine
		even
