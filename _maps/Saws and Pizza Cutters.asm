; ---------------------------------------------------------------------------
; Sprite mappings - ground saws	and pizza cutters (SBZ)
; ---------------------------------------------------------------------------
Map_Saw:	dc.w @pizzacutter1-Map_Saw, @pizzacutter2-Map_Saw
		dc.w @groundsaw1-Map_Saw, @groundsaw2-Map_Saw
@pizzacutter1:	dc.b 7
		dc.b $C4, 1, 0,	$20, $FC
		dc.b $D4, 1, 0,	$20, $FC
		dc.b $E4, 3, 0,	$20, $FC
		dc.b $E0, $F, 0, 0, $E0
		dc.b $E0, $F, 8, 0, 0
		dc.b 0,	$F, $10, 0, $E0
		dc.b 0,	$F, $18, 0, 0
@pizzacutter2:	dc.b 7
		dc.b $C4, 1, 0,	$20, $FC
		dc.b $D4, 1, 0,	$20, $FC
		dc.b $E4, 3, 0,	$20, $FC
		dc.b $E0, $F, 0, $10, $E0
		dc.b $E0, $F, 8, $10, 0
		dc.b 0,	$F, $10, $10, $E0
		dc.b 0,	$F, $18, $10, 0
@groundsaw1:	dc.b 4
		dc.b $E0, $F, 0, 0, $E0
		dc.b $E0, $F, 8, 0, 0
		dc.b 0,	$F, $10, 0, $E0
		dc.b 0,	$F, $18, 0, 0
@groundsaw2:	dc.b 4
		dc.b $E0, $F, 0, $10, $E0
		dc.b $E0, $F, 8, $10, 0
		dc.b 0,	$F, $10, $10, $E0
		dc.b 0,	$F, $18, $10, 0
		even