; ---------------------------------------------------------------------------
; Sprite mappings - GHZ	bridge
; ---------------------------------------------------------------------------
Map_Bri:	dc.w M_Bri_Log-Map_Bri
		dc.w M_Bri_Stump-Map_Bri
		dc.w M_Bri_Rope-Map_Bri
M_Bri_Log:	dc.b 1
		dc.b $F8, 5, 0,	0, $F8	; log
M_Bri_Stump:	dc.b 2
		dc.b $F8, 4, 0,	4, $F0	; stump & rope
		dc.b 0,	$C, 0, 6, $F0
M_Bri_Rope:	dc.b 1
		dc.b $FC, 4, 0,	8, $F8	; rope only
		even