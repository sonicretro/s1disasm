; ---------------------------------------------------------------------------
; Animation script - Basaran enemy (MZ)
; ---------------------------------------------------------------------------

Ani_Bas:	offsetTable
		ptr .still
		ptr .fall
		ptr .fly

.still:		dc.b 15
		dc.b 0
		dc.b afEnd
		even

.fall:		dc.b 15
		dc.b 1
		dc.b afEnd
		even

.fly:		dc.b 3
		dc.b 1, 2, 3, 2
		dc.b afEnd
		even
