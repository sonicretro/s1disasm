; ---------------------------------------------------------------------------
; Animation script - doors (SBZ)
; ---------------------------------------------------------------------------

Ani_ADoor:	offsetTable
		ptr .close
		ptr .open

.close:		dc.b 0
		dc.b 8, 7, 6, 5, 4, 3, 2, 1
		dc.b 0
		dc.b afBack, 1
		even

.open:		dc.b 0
		dc.b 0, 1, 2, 3, 4, 5, 6, 7
		dc.b 8
		dc.b afBack, 1
		even
