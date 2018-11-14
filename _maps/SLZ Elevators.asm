; ---------------------------------------------------------------------------
; Sprite mappings - platforms that move	when you stand on them (SLZ)
; ---------------------------------------------------------------------------
Map_Elev_internal:
		dc.w @elevator-Map_Elev_internal
@elevator:	dc.b 3
		dc.b $F8, $F, 0, $41, $D8
		dc.b $F8, $F, 0, $41, $F8
		dc.b $F8, 7, 0,	$41, $18
		even