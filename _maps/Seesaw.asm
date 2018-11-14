; ---------------------------------------------------------------------------
; Sprite mappings - seesaws (SLZ)
; ---------------------------------------------------------------------------
Map_Seesaw_internal:
		dc.w @sloping-Map_Seesaw_internal
		dc.w @flat-Map_Seesaw_internal
		dc.w @sloping-Map_Seesaw_internal
		dc.w @flat-Map_Seesaw_internal
@sloping:	dc.b 7
		dc.b $D4, 6, 0,	0, $D3
		dc.b $DC, 6, 0,	6, $E3
		dc.b $E4, 4, 0,	$C, $F3
		dc.b $EC, $D, 0, $E, $F3
		dc.b $FC, 8, 0,	$16, $FB
		dc.b $F4, 6, 0,	6, $13
		dc.b $FC, 5, 0,	$19, $23
@flat:		dc.b 4
		dc.b $E6, $A, 0, $1D, $D0
		dc.b $E6, $A, 0, $23, $E8
		dc.b $E6, $A, 8, $23, 0
		dc.b $E6, $A, 8, $1D, $18
		even
