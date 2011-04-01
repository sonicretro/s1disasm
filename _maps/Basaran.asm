; ---------------------------------------------------------------------------
; Sprite mappings - Basaran enemy (MZ)
; ---------------------------------------------------------------------------
Map_Bas:	dc.w @still-Map_Bas, @fly1-Map_Bas
		dc.w @fly2-Map_Bas, @fly3-Map_Bas
@still:		dc.b 1
		dc.b $F4, 6, 0,	0, $F8
@fly1:		dc.b 3
		dc.b $F2, $E, 0, 6, $F4
		dc.b $A, 4, 0, $12, $FC
		dc.b 2,	0, 0, $27, $C
@fly2:		dc.b 4
		dc.b $F8, 4, 0,	$14, $F8
		dc.b 0,	$C, 0, $16, $F0
		dc.b 8,	4, 0, $1A, 0
		dc.b 0,	0, 0, $28, $C
@fly3:		dc.b 4
		dc.b $F6, 9, 0,	$1C, $F5
		dc.b 6,	8, 0, $22, $F4
		dc.b $E, 4, 0, $25, $F4
		dc.b $FE, 0, 0,	$27, $C
		even