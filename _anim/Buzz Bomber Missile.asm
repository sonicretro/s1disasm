; ---------------------------------------------------------------------------
; Animation script - missile that Buzz Bomber enemy throws (GHZ/MZ)
; ---------------------------------------------------------------------------

Ani_Missile:	offsetTable
		ptr .flare
		ptr .missile

.flare:		dc.b 7
		dc.b 0, 1
		dc.b afRoutine
		even

.missile:	dc.b 1
		dc.b 2, 3
		dc.b afEnd
		even
