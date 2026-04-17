; ---------------------------------------------------------------------------
; Animation script - burning grass that sits on the floor (MZ)
; ---------------------------------------------------------------------------

Ani_GFire:	offsetTable
		ptr .burn

.burn:		dc.b 5
		dc.b 0, 0|aniXFlip, 1, 1|aniXFlip
		dc.b afEnd
		even
