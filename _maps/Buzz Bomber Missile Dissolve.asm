; ---------------------------------------------------------------------------
; Sprite mappings - buzz bomber missile vanishing
; ---------------------------------------------------------------------------
Map_MisDissolve:dc.w byte_8EAE-Map_MisDissolve, byte_8EB4-Map_MisDissolve
		dc.w byte_8EBA-Map_MisDissolve, byte_8EC0-Map_MisDissolve
byte_8EAE:	dc.b 1
		dc.b $F4, $A, 0, 0, $F4
byte_8EB4:	dc.b 1
		dc.b $F4, $A, 0, 9, $F4
byte_8EBA:	dc.b 1
		dc.b $F4, $A, 0, $12, $F4
byte_8EC0:	dc.b 1
		dc.b $F4, $A, 0, $1B, $F4
		even