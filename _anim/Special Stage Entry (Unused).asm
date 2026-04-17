; ---------------------------------------------------------------------------
; Animation script - special stage entry effect from beta (unused)
; ---------------------------------------------------------------------------

Ani_Vanish:	offsetTable
		ptr .vanish

.vanish:	dc.b 5
		dc.b 0, 1, 0, 1, 0, 7, 1, 7, 2, 7, 3, 7, 4, 7, 5, 7, 6, 7
		dc.b afRoutine
		even
