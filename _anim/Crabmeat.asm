; ---------------------------------------------------------------------------
; Animation script - Crabmeat enemy
; ---------------------------------------------------------------------------
Ani_Crab:	dc.w @stand-Ani_Crab, @standslope-Ani_Crab, @standsloperev-Ani_Crab
		dc.w @walk-Ani_Crab, @walkslope-Ani_Crab, @walksloperev-Ani_Crab
		dc.w @firing-Ani_Crab, @ball-Ani_Crab
@stand:		dc.b $F, 0, afEnd
		even
@standslope:	dc.b $F, 2, afEnd
		even
@standsloperev:	dc.b $F, $22, afEnd
		even
@walk:		dc.b $F, 1, $21, 0, afEnd
		even
@walkslope:	dc.b $F, $21, 3, 2, afEnd
		even
@walksloperev:	dc.b $F, 1, $23, $22, afEnd
		even
@firing:	dc.b $F, 4, afEnd
		even
@ball:		dc.b 1,	5, 6, afEnd
		even