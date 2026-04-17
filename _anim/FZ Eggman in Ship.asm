; ---------------------------------------------------------------------------
; Animation script - Eggman while escaping after landing final hit (FZ)
; ---------------------------------------------------------------------------

Ani_FZEgg:	offsetTable
		ptr .exploding

.exploding:	dc.b 3
		dc.b 0, 1
		dc.b afEnd
		even
