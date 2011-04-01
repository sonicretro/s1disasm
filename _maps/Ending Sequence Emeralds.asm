; ---------------------------------------------------------------------------
; Sprite mappings - chaos emeralds on the ending sequence
; ---------------------------------------------------------------------------
Map_ECha:	dc.w M_ECha_1-Map_ECha, M_ECha_2-Map_ECha
		dc.w M_ECha_3-Map_ECha, M_ECha_4-Map_ECha
		dc.w M_ECha_5-Map_ECha, M_ECha_6-Map_ECha
		dc.w M_ECha_7-Map_ECha
M_ECha_1:	dc.b 1
		dc.b $F8, 5, 0,	0, $F8
M_ECha_2:	dc.b 1
		dc.b $F8, 5, 0,	4, $F8
M_ECha_3:	dc.b 1
		dc.b $F8, 5, $40, $10, $F8
M_ECha_4:	dc.b 1
		dc.b $F8, 5, $20, $18, $F8
M_ECha_5:	dc.b 1
		dc.b $F8, 5, $40, $14, $F8
M_ECha_6:	dc.b 1
		dc.b $F8, 5, 0,	8, $F8
M_ECha_7:	dc.b 1
		dc.b $F8, 5, 0,	$C, $F8
		even