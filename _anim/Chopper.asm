; ---------------------------------------------------------------------------
; Animation script - Chopper enemy (GHZ)
; ---------------------------------------------------------------------------

Ani_Chop:	offsetTable
		ptr .slow
		ptr .fast
		ptr .still

.slow:		dc.b 7
		dc.b 0, 1
		dc.b afEnd
		even

.fast:		dc.b 3
		dc.b 0, 1
		dc.b afEnd
		even

.still:		dc.b 7
		dc.b 0
		dc.b afEnd
		even
