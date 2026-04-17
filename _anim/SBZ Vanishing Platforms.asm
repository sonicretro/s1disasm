; ---------------------------------------------------------------------------
; Animation script - vanishing platforms (SBZ)
; ---------------------------------------------------------------------------

Ani_Van:	offsetTable
		ptr .vanish
		ptr .appear

.vanish:	dc.b 7
		dc.b 0, 1, 2
		dc.b 3
		dc.b afBack, 1
		even

.appear:	dc.b 7
		dc.b 3, 2, 1
		dc.b 0
		dc.b afBack, 1
		even
