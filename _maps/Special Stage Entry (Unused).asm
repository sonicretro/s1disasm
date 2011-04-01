; ---------------------------------------------------------------------------
; Sprite mappings - special stage entry	from beta
; ---------------------------------------------------------------------------
Map_Vanish:	dc.w @flash1-Map_Vanish, @flash2-Map_Vanish
		dc.w @flash3-Map_Vanish, @sparkle1-Map_Vanish
		dc.w @sparkle2-Map_Vanish, @sparkle3-Map_Vanish
		dc.w @sparkle4-Map_Vanish, @blank-Map_Vanish
@flash1:	dc.b 3
		dc.b $F8, 0, 0,	0, 8
		dc.b 0,	4, 0, 1, 0
		dc.b 8,	0, $10,	0, 8
@flash2:	dc.b 3
		dc.b $F0, $D, 0, 3, $F0
		dc.b 0,	$C, 0, $B, $F0
		dc.b 8,	$D, $10, 3, $F0
@flash3:	dc.b 5
		dc.b $E4, $E, 0, $F, $F4
		dc.b $EC, 2, 0,	$1B, $EC
		dc.b $FC, $C, 0, $1E, $F4
		dc.b 4,	$E, $10, $F, $F4
		dc.b 4,	1, $10,	$1B, $EC
@sparkle1:	dc.b 9
		dc.b $F0, 8, 0,	$22, $F8
		dc.b $F8, $E, 0, $25, $F0
		dc.b $10, 8, 0,	$31, $F0
		dc.b 0,	5, 0, $34, $10
		dc.b $F8, 0, 8,	$25, $10
		dc.b $F0, 0, $18, $36, $18
		dc.b $F8, 0, $18, $25, $20
		dc.b 0,	0, 8, $25, $28
		dc.b $F8, 0, 0,	$25, $30
@sparkle2:	dc.b $12
		dc.b 0,	0, $18,	$25, $F0
		dc.b $F8, 4, 0,	$38, $F8
		dc.b $F0, 0, 0,	$26, 8
		dc.b 0,	0, 0, $25, 0
		dc.b 8,	0, $18,	$25, $F8
		dc.b $10, 0, $10, $26, 0
		dc.b 8,	0, $10,	$38, 8
		dc.b $F8, 0, 0,	$29, $10
		dc.b 0,	0, 0, $26, $10
		dc.b 0,	0, 0, $2D, $18
		dc.b 8,	0, 8, $26, $18
		dc.b 8,	0, 0, $29, $20
		dc.b $F8, 0, 0,	$26, $20
		dc.b $F8, 0, 0,	$2D, $28
		dc.b 0,	0, 0, $3A, $28
		dc.b $F8, 0, $18, $26, $30
		dc.b 0,	0, $10,	$25, $38
		dc.b $F8, 0, $10, $25, $40
@sparkle3:	dc.b $11
		dc.b $F8, 0, 8,	$25, 0
		dc.b $F0, 0, 0,	$38, $10
		dc.b $10, 0, 8,	$25, 0
		dc.b 0,	0, $18,	$25, $10
		dc.b 8,	0, $10,	$25, $18
		dc.b $F8, 0, $18, $25, $20
		dc.b 0,	0, $10,	$26, $28
		dc.b $F8, 0, $10, $25, $30
		dc.b 0,	0, 0, $25, $30
		dc.b 8,	0, 8, $25, $30
		dc.b 0,	0, 8, $26, $38
		dc.b 8,	0, 0, $29, $38
		dc.b $F8, 0, 8,	$26, $40
		dc.b 0,	0, 0, $2D, $40
		dc.b $F8, 0, 8,	$25, $48
		dc.b 0,	0, 0, $25, $48
		dc.b 0,	0, $10,	$25, $50
@sparkle4:	dc.b 9
		dc.b $FC, 0, 8,	$26, $30
		dc.b 4,	0, 8, $25, $28
		dc.b 4,	0, $10,	$27, $38
		dc.b 4,	0, 8, $26, $40
		dc.b $FC, 0, $10, $25, $40
		dc.b $FC, 0, $10, $26, $48
		dc.b $C, 0, 8, $27, $48
		dc.b 4,	0, $18,	$26, $50
		dc.b 4
@blank:		dc.b 0,	8, $27,	$58, 0
		even