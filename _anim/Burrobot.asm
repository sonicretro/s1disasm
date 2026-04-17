; ---------------------------------------------------------------------------
; Animation script - Burrobot enemy (LZ)
; ---------------------------------------------------------------------------

Ani_Burro:	offsetTable
		ptr .walk1
		ptr .walk2
		ptr .digging
		ptr .fall

.walk1:		dc.b 3
		dc.b 0, 6
		dc.b afEnd
		even

.walk2:		dc.b 3
		dc.b 0, 1
		dc.b afEnd
		even

.digging:	dc.b 3
		dc.b 2, 3
		dc.b afEnd
		even

.fall:		dc.b 3
		dc.b 4
		dc.b afEnd
		even
