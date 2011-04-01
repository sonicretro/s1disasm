; ---------------------------------------------------------------------------
; Animation script - "TM" and "PRESS START BUTTON" on the title screen
; ---------------------------------------------------------------------------
Ani_PSBTM:	dc.w @flash-Ani_PSBTM
@flash:		dc.b $1F, 0, 1,	afEnd
		even