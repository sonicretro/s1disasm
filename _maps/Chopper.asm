; ---------------------------------------------------------------------------
; Sprite mappings - Chopper enemy (GHZ)
; ---------------------------------------------------------------------------
Map_Chop_internal:
		dc.w @mouthshut-Map_Chop_internal
		dc.w @mouthopen-Map_Chop_internal
@mouthshut:	dc.b 1
		dc.b $F0, $F, 0, 0, $F0
@mouthopen:	dc.b 1
		dc.b $F0, $F, 0, $10, $F0
		even