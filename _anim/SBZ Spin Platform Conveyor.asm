; ---------------------------------------------------------------------------
; Animation script - platform on conveyor belt (SBZ)
; ---------------------------------------------------------------------------
Ani_SpinConvey:	dc.w @spin-Ani_SpinConvey
		dc.w @still-Ani_SpinConvey
@spin:		dc.b 0,	0, 1, 2, 3, 4, $43, $42, $41, $40, $61,	$62, $63
		dc.b $64, $23, $22, $21, 0, afEnd
		even
@still:		dc.b $F, 0, afEnd
		even