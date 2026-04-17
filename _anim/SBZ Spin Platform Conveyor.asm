; ---------------------------------------------------------------------------
; Animation script - platform on conveyor belt (SBZ)
; ---------------------------------------------------------------------------

Ani_SpinConvey:	offsetTable
		ptr .spin
		ptr .still

.spin:		dc.b 0
		dc.b 0, 1, 2, 3, 4
		dc.b 3|aniYFlip, 2|aniYFlip, 1|aniYFlip, 0|aniYFlip
		dc.b 1|aniXFlip|aniYFlip, 2|aniXFlip|aniYFlip, 3|aniXFlip|aniYFlip, 4|aniXFlip|aniYFlip
		dc.b 3|aniXFlip, 2|aniXFlip, 1|aniXFlip, 0
		dc.b afEnd
		even

.still:		dc.b 15
		dc.b 0
		dc.b afEnd
		even
