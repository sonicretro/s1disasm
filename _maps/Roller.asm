; ---------------------------------------------------------------------------
; Sprite mappings - Roller enemy (SYZ)
; ---------------------------------------------------------------------------
Map_Roll:	dc.w M_Roll_Stand-Map_Roll
		dc.w M_Roll_Fold-Map_Roll
		dc.w M_Roll_Roll1-Map_Roll
		dc.w M_Roll_Roll2-Map_Roll
		dc.w M_Roll_Roll3-Map_Roll
M_Roll_Stand:	dc.b 2
		dc.b $DE, $E, 0, 0, $F0	; standing
		dc.b $F6, $E, 0, $C, $F0
M_Roll_Fold:	dc.b 2
		dc.b $E6, $E, 0, 0, $F0	; folding
		dc.b $FE, $D, 0, $18, $F0
M_Roll_Roll1:	dc.b 1
		dc.b $F0, $F, 0, $20, $F0 ; rolling
M_Roll_Roll2:	dc.b 1
		dc.b $F0, $F, 0, $30, $F0 ; rolling
M_Roll_Roll3:	dc.b 1
		dc.b $F0, $F, 0, $40, $F0 ; rolling
		even