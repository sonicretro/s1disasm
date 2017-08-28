; ---------------------------------------------------------------------------
; Sprite mappings - switches (MZ, SYZ, LZ, SBZ)
; ---------------------------------------------------------------------------
Map_But_internal:
		dc.w byte_BEAC-Map_But_internal
		dc.w byte_BEB7-Map_But_internal
		dc.w byte_BEC2-Map_But_internal
		dc.w byte_BEB7-Map_But_internal
byte_BEAC:	dc.b 2
		dc.b $F5, 5, 0,	0, $F0
		dc.b $F5, 5, 8,	0, 0
byte_BEB7:	dc.b 2
		dc.b $F5, 5, 0,	4, $F0
		dc.b $F5, 5, 8,	4, 0
byte_BEC2:	dc.b 2
		dc.b $F5, 5, $FF, $FC, $F0
		dc.b $F5, 5, 7,	$FC, 0
		dc.b $F8, 5, 0,	0, $F8
		even