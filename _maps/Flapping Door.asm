; ---------------------------------------------------------------------------
; Sprite mappings - flapping door (LZ)
; ---------------------------------------------------------------------------
Map_Flap_internal:
		dc.w @closed-Map_Flap_internal
		dc.w @halfway-Map_Flap_internal
		dc.w @open-Map_Flap_internal
@closed:	dc.b 2
		dc.b $E0, 7, 0,	0, $F8
		dc.b 0,	7, $10,	0, $F8
@halfway:	dc.b 2
		dc.b $DA, $F, 0, 8, $FB
		dc.b 6,	$F, $10, 8, $FB
@open:		dc.b 2
		dc.b $D8, $D, 0, $18, 0
		dc.b $18, $D, $10, $18,	0
		even