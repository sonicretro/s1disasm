; ---------------------------------------------------------------------------
; Animation script - Sonic on the title screen
; ---------------------------------------------------------------------------

Ani_TSon:	offsetTable
		ptr .titlesonic

.titlesonic:	dc.b 7
		dc.b 0, 1, 2, 3, 4, 5 ; popping up
		dc.b 6, 7 ; finger wagging loop
		dc.b afBack, 2
		even
