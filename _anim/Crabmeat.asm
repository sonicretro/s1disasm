; ---------------------------------------------------------------------------
; Animation script - Crabmeat enemy
; ---------------------------------------------------------------------------

Ani_Crab:	offsetTable
		ptr .stand
		ptr .standslope
		ptr .standsloperev
		ptr .walk
		ptr .walkslope
		ptr .walksloperev
		ptr .firing
		ptr .ball

.stand:		dc.b 15
		dc.b 0
		dc.b afEnd
		even

.standslope:	dc.b 15
		dc.b 2
		dc.b afEnd
		even

.standsloperev:	dc.b 15
		dc.b 2|aniXFlip
		dc.b afEnd
		even

.walk:		dc.b 15
		dc.b 1, 1|aniXFlip, 0
		dc.b afEnd
		even

.walkslope:	dc.b 15
		dc.b 1|aniXFlip, 3, 2
		dc.b afEnd
		even

.walksloperev:	dc.b 15
		dc.b 1, 3|aniXFlip, 2|aniXFlip
		dc.b afEnd
		even

.firing:	dc.b 15
		dc.b 4
		dc.b afEnd
		even

.ball:		dc.b 1
		dc.b 5, 6
		dc.b afEnd
		even
