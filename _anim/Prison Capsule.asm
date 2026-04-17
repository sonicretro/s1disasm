; ---------------------------------------------------------------------------
; Animation script - prison capsule
; ---------------------------------------------------------------------------

Ani_Pri:	offsetTable
		ptr .switchflash
		ptr .switchflash ; redundant

.switchflash:	dc.b 2
		dc.b 1, 3
		dc.b afEnd
		even
