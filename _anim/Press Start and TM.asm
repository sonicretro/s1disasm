; ---------------------------------------------------------------------------
; Animation script - "PRESS START BUTTON" on the title screen (and "TM")
; ---------------------------------------------------------------------------

Ani_PSBTM:	offsetTable
		ptr .psbflash

.psbflash:	dc.b 31
		dc.b 0, 1
		dc.b afEnd
		even
