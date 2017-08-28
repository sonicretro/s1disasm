; ---------------------------------------------------------------------------
; Sprite mappings - SLZ	swinging platforms
; ---------------------------------------------------------------------------
Map_Swing_SLZ_internal:
		dc.w .block-Map_Swing_SLZ_internal
		dc.w .chain-Map_Swing_SLZ_internal
		dc.w .anchor-Map_Swing_SLZ_internal
.block:		dc.b 8
		dc.b $F0, $F, 0, 4, $E0
		dc.b $F0, $F, 8, 4, 0
		dc.b $F0, 5, 0,	$14, $D0
		dc.b $F0, 5, 8,	$14, $20
		dc.b $10, 4, 0,	$18, $E0
		dc.b $10, 4, 8,	$18, $10
		dc.b $10, 1, 0,	$1A, $F8
		dc.b $10, 1, 8,	$1A, 0
.chain:		dc.b 1
		dc.b $F8, 5, $40, 0, $F8
.anchor:	dc.b 1
		dc.b $F8, 5, 0,	$1C, $F8
		even