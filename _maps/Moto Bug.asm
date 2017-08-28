; ---------------------------------------------------------------------------
; Sprite mappings - Moto Bug enemy (GHZ)
; ---------------------------------------------------------------------------
Map_Moto_internal:
		dc.w .moto1-Map_Moto_internal
		dc.w .moto2-Map_Moto_internal
		dc.w .moto3-Map_Moto_internal
		dc.w .smoke1-Map_Moto_internal
		dc.w .smoke2-Map_Moto_internal
		dc.w .smoke3-Map_Moto_internal
		dc.w .blank-Map_Moto_internal
.moto1:		dc.b 4
		dc.b $F0, $D, 0, 0, $EC
		dc.b 0,	$C, 0, 8, $EC
		dc.b $F8, 1, 0,	$C, $C
		dc.b 8,	8, 0, $E, $F4
.moto2:		dc.b 4
		dc.b $F1, $D, 0, 0, $EC
		dc.b 1,	$C, 0, 8, $EC
		dc.b $F9, 1, 0,	$C, $C
		dc.b 9,	8, 0, $11, $F4
.moto3:		dc.b 5
		dc.b $F0, $D, 0, 0, $EC
		dc.b 0,	$C, 0, $14, $EC
		dc.b $F8, 1, 0,	$C, $C
		dc.b 8,	4, 0, $18, $EC
		dc.b 8,	4, 0, $12, $FC
.smoke1:	dc.b 1
		dc.b $FA, 0, 0,	$1A, $10
.smoke2:	dc.b 1
		dc.b $FA, 0, 0,	$1B, $10
.smoke3:	dc.b 1
		dc.b $FA, 0, 0,	$1C, $10
.blank:		dc.b 0
		even