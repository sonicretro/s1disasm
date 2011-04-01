; ---------------------------------------------------------------------------
; Sprite mappings - Robotnik on	the "TRY AGAIN"	and "END" screens
; ---------------------------------------------------------------------------
Map_EEgg:	dc.w M_EEgg_Try1-Map_EEgg, M_EEgg_Try2-Map_EEgg
		dc.w M_EEgg_Try3-Map_EEgg, M_EEgg_Try4-Map_EEgg
		dc.w M_EEgg_End1-Map_EEgg, M_EEgg_End2-Map_EEgg
		dc.w M_EEgg_End3-Map_EEgg, M_EEgg_End4-Map_EEgg
M_EEgg_Try1:	dc.b 8
		dc.b $E9, 5, 0,	0, $F0
		dc.b $F9, $C, 0, 4, $E0
		dc.b $E9, 4, 0,	8, 0
		dc.b $F1, $D, 0, $A, 0
		dc.b 1,	6, 0, $23, $F0
		dc.b 1,	6, 8, $23, 0
		dc.b $18, 4, 0,	$29, $EC
		dc.b $18, 4, 8,	$29, 4
M_EEgg_Try2:	dc.b 8
		dc.b $E8, $D, 0, $12, $E0
		dc.b $F8, 8, 0,	$1A, $E8
		dc.b $E8, 5, 8,	0, 0
		dc.b $F8, $C, 8, 4, 0
		dc.b 0,	6, 0, $1D, $F0
		dc.b 0,	6, 8, $1D, 0
		dc.b $18, 4, 0,	$29, $EC
		dc.b $18, 4, 8,	$29, 4
M_EEgg_Try3:	dc.b 8
		dc.b $E9, 4, 8,	8, $F0
		dc.b $F1, $D, 8, $A, $E0
		dc.b $E9, 5, 8,	0, 0
		dc.b $F9, $C, 8, 4, 0
		dc.b 1,	6, 0, $23, $F0
		dc.b 1,	6, 8, $23, 0
		dc.b $18, 4, 0,	$29, $EC
		dc.b $18, 4, 8,	$29, 4
M_EEgg_Try4:	dc.b 8
		dc.b $E8, 5, 0,	0, $F0
		dc.b $F8, $C, 0, 4, $E0
		dc.b $E8, $D, 8, $12, 0
		dc.b $F8, 8, 8,	$1A, 0
		dc.b 0,	6, 0, $1D, $F0
		dc.b 0,	6, 8, $1D, 0
		dc.b $18, 4, 0,	$29, $EC
		dc.b $18, 4, 8,	$29, 4
M_EEgg_End1:	dc.b $C
		dc.b $ED, $A, 0, $2B, $E8
		dc.b $F5, 0, 0,	$34, $E0
		dc.b 5,	4, 0, $35, $F0
		dc.b $D, 8, 0, $37, $E8
		dc.b $ED, $A, 8, $2B, 0
		dc.b $F5, 0, 8,	$34, $18
		dc.b 5,	4, 8, $35, 0
		dc.b $D, 8, 8, $37, 0
		dc.b $10, $D, 0, $73, $E0
		dc.b $10, $D, 0, $7B, 0
		dc.b $1C, $C, 0, $5B, $E0
		dc.b $1C, $C, 8, $5B, 0
M_EEgg_End2:	dc.b $A
		dc.b $D2, 7, 0,	$3A, $F0
		dc.b $DA, 0, 0,	$42, $E8
		dc.b $F2, 7, 0,	$43, $F0
		dc.b $D2, 7, 8,	$3A, 0
		dc.b $DA, 0, 8,	$42, $10
		dc.b $F2, 7, 8,	$43, 0
		dc.b $10, $D, 0, $67, $E8
		dc.b $10, 5, 0,	$6F, 8
		dc.b $1C, $C, 0, $5F, $E0
		dc.b $1C, $C, 8, $5F, 0
M_EEgg_End3:	dc.b $A
		dc.b $C4, $B, 0, $4B, $E8
		dc.b $E4, 8, 0,	$57, $E8
		dc.b $EC, 0, 0,	$5A, $F0
		dc.b $C4, $B, 8, $4B, 0
		dc.b $E4, 8, 8,	$57, 0
		dc.b $EC, 0, 8,	$5A, 8
		dc.b $10, $D, 0, $67, $E8
		dc.b $10, 5, 0,	$6F, 8
		dc.b $1C, $C, 0, $63, $E0
		dc.b $1C, $C, 8, $63, 0
M_EEgg_End4:	dc.b $C
		dc.b $F4, $A, 0, $2B, $E8
		dc.b $FC, 0, 0,	$34, $E0
		dc.b $C, 4, 0, $35, $F0
		dc.b $14, 8, 0,	$37, $E8
		dc.b $F4, $A, 8, $2B, 0
		dc.b $FC, 0, 8,	$34, $18
		dc.b $C, 4, 8, $35, 0
		dc.b $14, 8, 8,	$37, 0
		dc.b $18, $C, 0, $83, $E0
		dc.b $18, $C, 0, $87, 0
		dc.b $1C, $C, 0, $5B, $E0
		dc.b $1C, $C, 8, $5B, 0
		even