; ---------------------------------------------------------------------------
; Sprite mappings - special stage breakable glass blocks and red-white blocks
; ---------------------------------------------------------------------------
Map_SS_Glass:	dc.w byte_1B928-Map_SS_Glass, byte_1B92E-Map_SS_Glass
		dc.w byte_1B934-Map_SS_Glass, byte_1B93A-Map_SS_Glass
byte_1B928:	dc.b 1
		dc.b $F4, $A, 0, 0, $F4
byte_1B92E:	dc.b 1
		dc.b $F4, $A, 8, 0, $F4
byte_1B934:	dc.b 1
		dc.b $F4, $A, $18, 0, $F4
byte_1B93A:	dc.b 1
		dc.b $F4, $A, $10, 0, $F4
		even