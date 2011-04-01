; ---------------------------------------------------------------------------
; Sprite mappings - metal stomping blocks on chains (MZ)
; ---------------------------------------------------------------------------
Map_CStom:	dc.w @wideblock-Map_CStom
		dc.w @spikes-Map_CStom
		dc.w @ceiling-Map_CStom
		dc.w @chain1-Map_CStom
		dc.w @chain2-Map_CStom
		dc.w @chain3-Map_CStom
		dc.w @chain4-Map_CStom
		dc.w @chain5-Map_CStom
		dc.w @chain5-Map_CStom
		dc.w @mediumblock-Map_CStom
		dc.w @smallblock-Map_CStom
@wideblock:	dc.b 5
		dc.b $F4, 6, 0,	0, $C8
		dc.b $F4, $A, 0, 6, $D8
		dc.b $EC, $F, 0, $F, $F0
		dc.b $F4, $A, 8, 6, $10
		dc.b $F4, 6, 8,	0, $28
@spikes:	dc.b 5
		dc.b $F0, 3, $12, $1F, $D4
		dc.b $F0, 3, $12, $1F, $E8
		dc.b $F0, 3, $12, $1F, $FC
		dc.b $F0, 3, $12, $1F, $10
		dc.b $F0, 3, $12, $1F, $24
@ceiling:	dc.b 1
		dc.b $DC, $F, $10, $F, $F0
@chain1:	dc.b 2
		dc.b 0,	1, 0, $3F, $FC
		dc.b $10, 1, 0,	$3F, $FC
@chain2:	dc.b 4
		dc.b $E0, 1, 0,	$3F, $FC
		dc.b $F0, 1, 0,	$3F, $FC
		dc.b 0,	1, 0, $3F, $FC
		dc.b $10, 1, 0,	$3F, $FC
@chain3:	dc.b 6
		dc.b $C0, 1, 0,	$3F, $FC
		dc.b $D0, 1, 0,	$3F, $FC
		dc.b $E0, 1, 0,	$3F, $FC
		dc.b $F0, 1, 0,	$3F, $FC
		dc.b 0,	1, 0, $3F, $FC
		dc.b $10, 1, 0,	$3F, $FC
@chain4:	dc.b 8
		dc.b $A0, 1, 0,	$3F, $FC
		dc.b $B0, 1, 0,	$3F, $FC
		dc.b $C0, 1, 0,	$3F, $FC
		dc.b $D0, 1, 0,	$3F, $FC
		dc.b $E0, 1, 0,	$3F, $FC
		dc.b $F0, 1, 0,	$3F, $FC
		dc.b 0,	1, 0, $3F, $FC
		dc.b $10, 1, 0,	$3F, $FC
@chain5:	dc.b $A
		dc.b $80, 1, 0,	$3F, $FC
		dc.b $90, 1, 0,	$3F, $FC
		dc.b $A0, 1, 0,	$3F, $FC
		dc.b $B0, 1, 0,	$3F, $FC
		dc.b $C0, 1, 0,	$3F, $FC
		dc.b $D0, 1, 0,	$3F, $FC
		dc.b $E0, 1, 0,	$3F, $FC
		dc.b $F0, 1, 0,	$3F, $FC
		dc.b 0,	1, 0, $3F, $FC
		dc.b $10, 1, 0,	$3F, $FC
@mediumblock:	dc.b 5
		dc.b $F4, 6, 0,	0, $D0
		dc.b $F4, $A, 0, 6, $E0
		dc.b $F4, $A, 8, 6, 8
		dc.b $F4, 6, 8,	0, $20
		dc.b $EC, $F, 0, $F, $F0
@smallblock:	dc.b 1
		dc.b $EC, $F, 0, $2F, $F0
		even
