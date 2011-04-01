; ---------------------------------------------------------------------------
; Sprite mappings - advancing wall of lava (MZ)
; ---------------------------------------------------------------------------
Map_LWall:	dc.w byte_F538-Map_LWall
		dc.w byte_F566-Map_LWall
		dc.w byte_F594-Map_LWall
		dc.w byte_F5C2-Map_LWall
		dc.w byte_F5F0-Map_LWall
byte_F538:	dc.b 9
		dc.b $E0, $F, 0, $60, $20
		dc.b 0,	$F, 0, $70, $3C
		dc.b 0,	$F, $FF, $2A, $20
		dc.b $E0, $F, $FF, $2A,	0
		dc.b 0,	$F, $FF, $2A, 0
		dc.b $E0, $F, $FF, $2A,	$E0
		dc.b 0,	$F, $FF, $2A, $E0
		dc.b $E0, $F, $FF, $2A,	$C0
		dc.b 0,	$F, $FF, $2A, $C0
byte_F566:	dc.b 9
		dc.b $E0, $F, 0, $70, $20
		dc.b 0,	$F, 0, $80, $3C
		dc.b 0,	$F, $FF, $2A, $20
		dc.b $E0, $F, $FF, $2A,	0
		dc.b 0,	$F, $FF, $2A, 0
		dc.b $E0, $F, $FF, $2A,	$E0
		dc.b 0,	$F, $FF, $2A, $E0
		dc.b $E0, $F, $FF, $2A,	$C0
		dc.b 0,	$F, $FF, $2A, $C0
byte_F594:	dc.b 9
		dc.b $E0, $F, 0, $80, $20
		dc.b 0,	$F, 0, $70, $3C
		dc.b 0,	$F, $FF, $2A, $20
		dc.b $E0, $F, $FF, $2A,	0
		dc.b 0,	$F, $FF, $2A, 0
		dc.b $E0, $F, $FF, $2A,	$E0
		dc.b 0,	$F, $FF, $2A, $E0
		dc.b $E0, $F, $FF, $2A,	$C0
		dc.b 0,	$F, $FF, $2A, $C0
byte_F5C2:	dc.b 9
		dc.b $E0, $F, 0, $70, $20
		dc.b 0,	$F, 0, $60, $3C
		dc.b 0,	$F, $FF, $2A, $20
		dc.b $E0, $F, $FF, $2A,	0
		dc.b 0,	$F, $FF, $2A, 0
		dc.b $E0, $F, $FF, $2A,	$E0
		dc.b 0,	$F, $FF, $2A, $E0
		dc.b $E0, $F, $FF, $2A,	$C0
		dc.b 0,	$F, $FF, $2A, $C0
byte_F5F0:	dc.b 8
		dc.b $E0, $F, $FF, $2A,	$20
		dc.b 0,	$F, $FF, $2A, $20
		dc.b $E0, $F, $FF, $2A,	0
		dc.b 0,	$F, $FF, $2A, 0
		dc.b $E0, $F, $FF, $2A,	$E0
		dc.b 0,	$F, $FF, $2A, $E0
		dc.b $E0, $F, $FF, $2A,	$C0
		dc.b 0,	$F, $FF, $2A, $C0
		even