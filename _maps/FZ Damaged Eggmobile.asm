; ---------------------------------------------------------------------------
; Sprite mappings - Eggman in broken eggmobile (FZ)
; ---------------------------------------------------------------------------
Map_FZDamaged:	dc.w @damage1-Map_FZDamaged
		dc.w @damage2-Map_FZDamaged
@damage1:	dc.b 6
		dc.b $E4, 8, 0,	$20, $F4
		dc.b $EC, $D, 0, $23, $E4
		dc.b $EC, 9, 0,	$2B, 4
		dc.b $FC, 5, $20, $3A, $E4
		dc.b $FC, $E, $20, $3E,	4
		dc.b $14, 4, $20, $4A, 4
@damage2:	dc.b 6
		dc.b $E4, $A, 0, $31, $F4
		dc.b $EC, 5, 0,	$23, $E4
		dc.b $EC, 9, 0,	$2B, 4
		dc.b $FC, 5, $20, $3A, $E4
		dc.b $FC, $E, $20, $3E,	4
		dc.b $14, 4, $20, $4A, 4
		even