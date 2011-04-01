; ---------------------------------------------------------------------------
; Sprite mappings - solid blocks and blocks that fall from the ceiling (MZ)
; ---------------------------------------------------------------------------
Map_Brick:	dc.w @brick-Map_Brick
@brick:		dc.b 1
		dc.b $F0, $F, 0, 1, $F0
		even