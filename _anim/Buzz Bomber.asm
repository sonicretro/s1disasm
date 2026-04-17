; ---------------------------------------------------------------------------
; Animation script - Buzz Bomber enemy (GHZ/MZ)
; ---------------------------------------------------------------------------

Ani_Buzz:	offsetTable
		ptr .fly1
		ptr .fly2
		ptr .fires

.fly1:		dc.b 1
		dc.b 0, 1
		dc.b afEnd
		even

.fly2:		dc.b 1
		dc.b 2, 3
		dc.b afEnd
		even

.fires:		dc.b 1
		dc.b 4, 5
		dc.b afEnd
		even
