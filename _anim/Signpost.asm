; ---------------------------------------------------------------------------
; Animation script - signpost
; ---------------------------------------------------------------------------

Ani_Sign:	offsetTable
		ptr .eggman
		ptr .spin1
		ptr .spin2
		ptr .sonic

.eggman:	dc.b 15
		dc.b 0
		dc.b afEnd
		even

.spin1:		dc.b 1
		dc.b 0, 1, 2, 3
		dc.b afEnd
		even

.spin2:		dc.b 1
		dc.b 4, 1, 2, 3
		dc.b afEnd
		even

.sonic:		dc.b 15
		dc.b 4
		dc.b afEnd
		even
