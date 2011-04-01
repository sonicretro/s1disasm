; ---------------------------------------------------------------------------
; Animation script - Roller enemy
; ---------------------------------------------------------------------------
Ani_Roll:	dc.w A_Roll_Unfold-Ani_Roll
		dc.w A_Roll_Fold-Ani_Roll
		dc.w A_Roll_Roll-Ani_Roll
A_Roll_Unfold:	dc.b $F, 2, 1, 0, afBack, 1
A_Roll_Fold:	dc.b $F, 1, 2, afChange, 2
		even
A_Roll_Roll:	dc.b 3,	3, 4, 2, afEnd
		even