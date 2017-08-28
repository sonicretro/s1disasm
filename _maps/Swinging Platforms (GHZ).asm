; ---------------------------------------------------------------------------
; Sprite mappings - GHZ	and MZ swinging	platforms
; ---------------------------------------------------------------------------
Map_Swing_GHZ_internal:
		dc.w @block-Map_Swing_GHZ_internal
		dc.w @chain-Map_Swing_GHZ_internal
		dc.w @anchor-Map_Swing_GHZ_internal
@block:		dc.b 2
		dc.b $F8, 9, 0,	4, $E8
		dc.b $F8, 9, 0,	4, 0
@chain:		dc.b 1
		dc.b $F8, 5, 0,	0, $F8
@anchor:	dc.b 1
		dc.b $F8, 5, 0,	$A, $F8
		even