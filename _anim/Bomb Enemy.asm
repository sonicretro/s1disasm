; ---------------------------------------------------------------------------
; Animation script - Bomb enemy (SLZ/SBZ)
; ---------------------------------------------------------------------------

Ani_Bomb:	offsetTable
		ptr .stand
		ptr .walk
		ptr .activated
		ptr .fuse
		ptr .shrapnel

.stand:		dc.b 19
		dc.b 1, 0
		dc.b afEnd
		even

.walk:		dc.b 19
		dc.b 5, 4, 3, 2
		dc.b afEnd
		even

.activated:	dc.b 19
		dc.b 7, 6
		dc.b afEnd
		even

.fuse:		dc.b 3
		dc.b 8, 9
		dc.b afEnd
		even

.shrapnel:	dc.b 3
		dc.b $A, $B
		dc.b afEnd
		even
