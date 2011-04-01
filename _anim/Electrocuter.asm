; ---------------------------------------------------------------------------
; Animation script - electrocution orbs (SBZ)
; ---------------------------------------------------------------------------
Ani_Elec:	dc.w byte_161CC-Ani_Elec
		dc.w byte_161D0-Ani_Elec
byte_161CC:	dc.b 7,	0, afEnd
		even
byte_161D0:	dc.b 0,	1, 1, 1, 2, 3, 3, 4, 4,	4, 5, 5, 5, 0, afChange, 0
		even