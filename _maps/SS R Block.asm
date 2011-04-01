; ---------------------------------------------------------------------------
; Sprite mappings - special stage "R" block
; ---------------------------------------------------------------------------
Map_SS_R:	dc.w byte_1B912-Map_SS_R, byte_1B918-Map_SS_R
		dc.w byte_1B91E-Map_SS_R
byte_1B912:	dc.b 1
		dc.b $F4, $A, 0, 0, $F4
byte_1B918:	dc.b 1
		dc.b $F4, $A, 0, 9, $F4
byte_1B91E:	dc.b 0
		even