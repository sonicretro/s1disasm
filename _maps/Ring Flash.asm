; ---------------------------------------------------------------------------
; Sprite mappings - flash effect when you collect the giant ring
; ---------------------------------------------------------------------------
Map_Flash:	dc.w byte_A084-Map_Flash, byte_A08F-Map_Flash
		dc.w byte_A0A4-Map_Flash, byte_A0B9-Map_Flash
		dc.w byte_A0CE-Map_Flash, byte_A0E3-Map_Flash
		dc.w byte_A0F8-Map_Flash, byte_A103-Map_Flash
byte_A084:	dc.b 2
		dc.b $E0, $F, 0, 0, 0
		dc.b 0,	$F, $10, 0, 0
byte_A08F:	dc.b 4
		dc.b $E0, $F, 0, $10, $F0
		dc.b $E0, 7, 0,	$20, $10
		dc.b 0,	$F, $10, $10, $F0
		dc.b 0,	7, $10,	$20, $10
byte_A0A4:	dc.b 4
		dc.b $E0, $F, 0, $28, $E8
		dc.b $E0, $B, 0, $38, 8
		dc.b 0,	$F, $10, $28, $E8
		dc.b 0,	$B, $10, $38, 8
byte_A0B9:	dc.b 4
		dc.b $E0, $F, 8, $34, $E0
		dc.b $E0, $F, 0, $34, 0
		dc.b 0,	$F, $18, $34, $E0
		dc.b 0,	$F, $10, $34, 0
byte_A0CE:	dc.b 4
		dc.b $E0, $B, 8, $38, $E0
		dc.b $E0, $F, 8, $28, $F8
		dc.b 0,	$B, $18, $38, $E0
		dc.b 0,	$F, $18, $28, $F8
byte_A0E3:	dc.b 4
		dc.b $E0, 7, 8,	$20, $E0
		dc.b $E0, $F, 8, $10, $F0
		dc.b 0,	7, $18,	$20, $E0
		dc.b 0,	$F, $18, $10, $F0
byte_A0F8:	dc.b 2
		dc.b $E0, $F, 8, 0, $E0
		dc.b 0,	$F, $18, 0, $E0
byte_A103:	dc.b 4
		dc.b $E0, $F, 0, $44, $E0
		dc.b $E0, $F, 8, $44, 0
		dc.b 0,	$F, $10, $44, $E0
		dc.b 0,	$F, $18, $44, 0
		even