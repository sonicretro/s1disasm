; ---------------------------------------------------------------------------
; Animation script - lava balls
; ---------------------------------------------------------------------------

Ani_Fire:	offsetTable
		ptr .vertical
		ptr .vertcollide
		ptr .horizontal
		ptr .horicollide

.vertical:	dc.b 5
		dc.b 0, 0|aniXFlip, 1, 1|aniXFlip
		dc.b afEnd
		even

.vertcollide:	dc.b 5
		dc.b 2
		dc.b afRoutine
		even

.horizontal:	dc.b 5
		dc.b 3, 3|aniYFlip, 4, 4|aniYFlip
		dc.b afEnd
		even

.horicollide:	dc.b 5
		dc.b 5
		dc.b afRoutine
		even
