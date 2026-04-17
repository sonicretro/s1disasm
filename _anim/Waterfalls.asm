; ---------------------------------------------------------------------------
; Animation script - waterfall (LZ)
; ---------------------------------------------------------------------------

Ani_WFall:	offsetTable
		ptr .splash

.splash:	dc.b 5
		dc.b 9, $A, $B
		dc.b afEnd
		even
