; ---------------------------------------------------------------------------
; Animation script - flamethrower (SBZ)
; ---------------------------------------------------------------------------
Ani_Bump:	dc.w byte_EAF4-Ani_Bump
		dc.w byte_EAF8-Ani_Bump
byte_EAF4:	dc.b $F, 0, afEnd
		even
byte_EAF8:	dc.b 3,	1, 2, 1, 2, afChange, 0
		even