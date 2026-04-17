; ---------------------------------------------------------------------------
; Animation script - geyser of lava (MZ)
; ---------------------------------------------------------------------------

Ani_Geyser:	offsetTable
		ptr .bubble1
		ptr .bubble2
		ptr .end
		ptr .bubble3
		ptr .blank
		ptr .bubble4

.bubble1:	dc.b 2
		dc.b 0, 1, 0, 1, 4, 5, 4, 5
		dc.b afRoutine
		even

.bubble2:	dc.b 2
		dc.b 2, 3
		dc.b afEnd
		even

.end:		dc.b 2
		dc.b 6, 7
		dc.b afEnd
		even

.bubble3:	dc.b 2
		dc.b 2, 3, 0, 1, 0, 1
		dc.b afRoutine
		even

.blank:		dc.b 15
		dc.b $13
		dc.b afEnd
		even

.bubble4:	dc.b 2
		dc.b $11, $12
		dc.b afEnd
		even
