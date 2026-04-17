; ---------------------------------------------------------------------------
; Animation script - Sonic on the ending sequence
; ---------------------------------------------------------------------------

Ani_ESon:	offsetTable
		ptr .hold
		ptr .confused
		ptr .leap

.hold:		dc.b 3
		dc.b 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 2
		dc.b af2ndRoutine
		even

.confused:	dc.b 5
		dc.b 3, 4, 3, 4, 3, 4, 3
		dc.b af2ndRoutine
		even

.leap:		dc.b 3
		dc.b 5, 5, 5, 6
		dc.b 7
		dc.b afBack, 1
		even
