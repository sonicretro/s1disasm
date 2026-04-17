; ---------------------------------------------------------------------------
; Animation script - Roller enemy (SYZ)
; ---------------------------------------------------------------------------

Ani_Roll:	offsetTable
		ptr .unfold
		ptr .fold
		ptr .roll

.unfold:	dc.b 15
		dc.b 2, 1
		dc.b 0
		dc.b afBack, 1
		even

.fold:		dc.b 15
		dc.b 1, 2
		dc.b afChange, 2
		even

.roll:		dc.b 3
		dc.b 3, 4, 2
		dc.b afEnd
		even
