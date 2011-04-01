; ---------------------------------------------------------------------------
; Sprite mappings - collapsing floors (MZ, SLZ,	SBZ)
; ---------------------------------------------------------------------------
Map_CFlo:	dc.w byte_874E-Map_CFlo, byte_8763-Map_CFlo
		dc.w byte_878C-Map_CFlo, byte_87A1-Map_CFlo
byte_874E:	dc.b 4
		dc.b $F8, $D, 0, 0, $E0	; MZ and SBZ blocks
		dc.b 8,	$D, 0, 0, $E0
		dc.b $F8, $D, 0, 0, 0
		dc.b 8,	$D, 0, 0, 0
byte_8763:	dc.b 8
		dc.b $F8, 5, 0,	0, $E0
		dc.b $F8, 5, 0,	0, $F0
		dc.b $F8, 5, 0,	0, 0
		dc.b $F8, 5, 0,	0, $10
		dc.b 8,	5, 0, 0, $E0
		dc.b 8,	5, 0, 0, $F0
		dc.b 8,	5, 0, 0, 0
		dc.b 8,	5, 0, 0, $10
byte_878C:	dc.b 4
		dc.b $F8, $D, 0, 0, $E0	; SLZ blocks
		dc.b 8,	$D, 0, 8, $E0
		dc.b $F8, $D, 0, 0, 0
		dc.b 8,	$D, 0, 8, 0
byte_87A1:	dc.b 8
		dc.b $F8, 5, 0,	0, $E0
		dc.b $F8, 5, 0,	4, $F0
		dc.b $F8, 5, 0,	0, 0
		dc.b $F8, 5, 0,	4, $10
		dc.b 8,	5, 0, 8, $E0
		dc.b 8,	5, 0, $C, $F0
		dc.b 8,	5, 0, 8, 0
		dc.b 8,	5, 0, $C, $10
		even