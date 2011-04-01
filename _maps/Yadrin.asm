; ---------------------------------------------------------------------------
; Sprite mappings - Yadrin enemy (SYZ)
; ---------------------------------------------------------------------------
Map_Yad:	dc.w @walk0-Map_Yad, @walk1-Map_Yad
		dc.w @walk2-Map_Yad, @walk3-Map_Yad
		dc.w @walk4-Map_Yad, @walk5-Map_Yad
@walk0:		dc.b 5
		dc.b $F4, 8, 0,	0, $F4
		dc.b $FC, $E, 0, 3, $EC
		dc.b $EC, 4, 0,	$F, $FC
		dc.b $F4, 2, 0,	$11, $C
		dc.b 4,	9, 0, $31, $FC
@walk1:		dc.b 5
		dc.b $F4, 8, 0,	$14, $F4
		dc.b $FC, $E, 0, $17, $EC
		dc.b $EC, 4, 0,	$F, $FC
		dc.b $F4, 2, 0,	$11, $C
		dc.b 4,	9, 0, $31, $FC
@walk2:		dc.b 5
		dc.b $F4, 9, 0,	$23, $F4
		dc.b 4,	$D, 0, $29, $EC
		dc.b $EC, 4, 0,	$F, $FC
		dc.b $F4, 2, 0,	$11, $C
		dc.b 4,	9, 0, $31, $FC
@walk3:		dc.b 5
		dc.b $F4, 8, 0,	0, $F4
		dc.b $FC, $E, 0, 3, $EC
		dc.b $EC, 4, 0,	$F, $FC
		dc.b $F4, 2, 0,	$11, $C
		dc.b 4,	9, 0, $37, $FC
@walk4:		dc.b 5
		dc.b $F4, 8, 0,	$14, $F4
		dc.b $FC, $E, 0, $17, $EC
		dc.b $EC, 4, 0,	$F, $FC
		dc.b $F4, 2, 0,	$11, $C
		dc.b 4,	9, 0, $37, $FC
@walk5:		dc.b 5
		dc.b $F4, 9, 0,	$23, $F4
		dc.b 4,	$D, 0, $29, $EC
		dc.b $EC, 4, 0,	$F, $FC
		dc.b $F4, 2, 0,	$11, $C
		dc.b 4,	9, 0, $37, $FC
		even