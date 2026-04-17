; ---------------------------------------------------------------------------
; Animation script - Yadrin enemy (SYZ)
; ---------------------------------------------------------------------------

Ani_Yad:	offsetTable
		ptr .stand
		ptr .walk

.stand:		dc.b 7
		dc.b 0
		dc.b afEnd
		even

.walk:		dc.b 7
		dc.b 0, 3, 1, 4, 0, 3, 2, 5
		dc.b afEnd
		even
