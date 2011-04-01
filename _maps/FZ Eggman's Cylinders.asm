; ---------------------------------------------------------------------------
; Sprite mappings - cylinders Eggman hides in (FZ)
; ---------------------------------------------------------------------------
Map_EggCyl:	dc.w @flat-Map_EggCyl, @extending1-Map_EggCyl
		dc.w @extending2-Map_EggCyl, @extending3-Map_EggCyl
		dc.w @extending4-Map_EggCyl, @extendedfully-Map_EggCyl
		dc.w @extendedfully-Map_EggCyl, @extendedfully-Map_EggCyl
		dc.w @extendedfully-Map_EggCyl, @extendedfully-Map_EggCyl
		dc.w @extendedfully-Map_EggCyl, @controlpanel-Map_EggCyl
@flat:		dc.b 6
		dc.b $A0, $D, $40, 0, $E0
		dc.b $A0, $D, $48, 0, 0
		dc.b $B0, $C, $20, 8, $E0
		dc.b $B0, $C, $20, $C, 0
		dc.b $B8, $F, $40, $10,	$E0
		dc.b $B8, $F, $48, $10,	0
@extending1:	dc.b 8
		dc.b $A0, $D, $40, 0, $E0
		dc.b $A0, $D, $48, 0, 0
		dc.b $B0, $C, $20, 8, $E0
		dc.b $B0, $C, $20, $C, 0
		dc.b $B8, $F, $40, $10,	$E0
		dc.b $B8, $F, $48, $10,	0
		dc.b $D8, $F, $40, $20,	$E0
		dc.b $D8, $F, $48, $20,	0
@extending2:	dc.b $A
		dc.b $A0, $D, $40, 0, $E0
		dc.b $A0, $D, $48, 0, 0
		dc.b $B0, $C, $20, 8, $E0
		dc.b $B0, $C, $20, $C, 0
		dc.b $B8, $F, $40, $10,	$E0
		dc.b $B8, $F, $48, $10,	0
		dc.b $D8, $F, $40, $20,	$E0
		dc.b $D8, $F, $48, $20,	0
		dc.b $F8, $F, $40, $30,	$E0
		dc.b $F8, $F, $48, $30,	0
@extending3:	dc.b $C
		dc.b $A0, $D, $40, 0, $E0
		dc.b $A0, $D, $48, 0, 0
		dc.b $B0, $C, $20, 8, $E0
		dc.b $B0, $C, $20, $C, 0
		dc.b $B8, $F, $40, $10,	$E0
		dc.b $B8, $F, $48, $10,	0
		dc.b $D8, $F, $40, $20,	$E0
		dc.b $D8, $F, $48, $20,	0
		dc.b $F8, $F, $40, $30,	$E0
		dc.b $F8, $F, $48, $30,	0
		dc.b $18, $F, $40, $40,	$E0
		dc.b $18, $F, $48, $40,	0
@extending4:	dc.b $D
		dc.b $A0, $D, $40, 0, $E0
		dc.b $A0, $D, $48, 0, 0
		dc.b $B0, $C, $20, 8, $E0
		dc.b $B0, $C, $20, $C, 0
		dc.b $B8, $F, $40, $10,	$E0
		dc.b $B8, $F, $48, $10,	0
		dc.b $D8, $F, $40, $20,	$E0
		dc.b $D8, $F, $48, $20,	0
		dc.b $F8, $F, $40, $30,	$E0
		dc.b $F8, $F, $48, $30,	0
		dc.b $18, $F, $40, $40,	$E0
		dc.b $18, $F, $48, $40,	0
		dc.b $38, $F, $40, $50,	$F0
@extendedfully:	dc.b $E
		dc.b $A0, $D, $40, 0, $E0
		dc.b $A0, $D, $48, 0, 0
		dc.b $B0, $C, $20, 8, $E0
		dc.b $B0, $C, $20, $C, 0
		dc.b $B8, $F, $40, $10,	$E0
		dc.b $B8, $F, $48, $10,	0
		dc.b $D8, $F, $40, $20,	$E0
		dc.b $D8, $F, $48, $20,	0
		dc.b $F8, $F, $40, $30,	$E0
		dc.b $F8, $F, $48, $30,	0
		dc.b $18, $F, $40, $40,	$E0
		dc.b $18, $F, $48, $40,	0
		dc.b $38, $F, $40, $50,	$F0
		dc.b $58, $F, $40, $50,	$F0
@controlpanel:	dc.b 2
		dc.b $F8, 4, 0,	$68, $F0
		dc.b 0,	$C, 0, $6A, $F0
		even