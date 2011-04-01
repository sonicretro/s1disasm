; ---------------------------------------------------------------------------
; Animation script - Chopper enemy
; ---------------------------------------------------------------------------
Ani_Chop:	dc.w @slow-Ani_Chop
		dc.w @fast-Ani_Chop
		dc.w @still-Ani_Chop
@slow:		dc.b 7,	0, 1, afEnd
@fast:		dc.b 3,	0, 1, afEnd
@still:		dc.b 7,	0, afEnd
		even