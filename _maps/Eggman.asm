; ---------------------------------------------------------------------------
; Sprite mappings - Eggman (boss levels)
; ---------------------------------------------------------------------------
Map_Eggman:	dc.w @ship-Map_Eggman, @facenormal1-Map_Eggman
		dc.w @facenormal2-Map_Eggman, @facelaugh1-Map_Eggman
		dc.w @facelaugh2-Map_Eggman, @facehit-Map_Eggman
		dc.w @facepanic-Map_Eggman, @facedefeat-Map_Eggman
		dc.w @flame1-Map_Eggman, @flame2-Map_Eggman
		dc.w @blank-Map_Eggman, @escapeflame1-Map_Eggman
		dc.w @escapeflame2-Map_Eggman
@ship:		dc.b 6
		dc.b $EC, 1, 0,	$A, $E4
		dc.b $EC, 5, 0,	$C, $C
		dc.b $FC, $E, $20, $10,	$E4
		dc.b $FC, $E, $20, $1C,	4
		dc.b $14, $C, $20, $28,	$EC
		dc.b $14, 0, $20, $2C, $C
@facenormal1:	dc.b 2
		dc.b $E4, 4, 0,	0, $F4
		dc.b $EC, $D, 0, 2, $EC
@facenormal2:	dc.b 2
		dc.b $E4, 4, 0,	0, $F4
		dc.b $EC, $D, 0, $35, $EC
@facelaugh1:	dc.b 3
		dc.b $E4, 8, 0,	$3D, $F4
		dc.b $EC, 9, 0,	$40, $EC
		dc.b $EC, 5, 0,	$46, 4
@facelaugh2:	dc.b 3
		dc.b $E4, 8, 0,	$4A, $F4
		dc.b $EC, 9, 0,	$4D, $EC
		dc.b $EC, 5, 0,	$53, 4
@facehit:	dc.b 3
		dc.b $E4, 8, 0,	$57, $F4
		dc.b $EC, 9, 0,	$5A, $EC
		dc.b $EC, 5, 0,	$60, 4
@facepanic:	dc.b 3
		dc.b $E4, 4, 0,	$64, 4
		dc.b $E4, 4, 0,	0, $F4
		dc.b $EC, $D, 0, $35, $EC
@facedefeat:	dc.b 4
		dc.b $E4, 9, 0,	$66, $F4
		dc.b $E4, 8, 0,	$57, $F4
		dc.b $EC, 9, 0,	$5A, $EC
		dc.b $EC, 5, 0,	$60, 4
@flame1:	dc.b 1
		dc.b 4,	5, 0, $2D, $22
@flame2:	dc.b 1
		dc.b 4,	5, 0, $31, $22
@blank:		dc.b 0
@escapeflame1:	dc.b 2
		dc.b 0,	8, 1, $2A, $22
		dc.b 8,	8, $11,	$2A, $22
@escapeflame2:	dc.b 2
		dc.b $F8, $B, 1, $2D, $22
		dc.b 0,	1, 1, $39, $3A
		even