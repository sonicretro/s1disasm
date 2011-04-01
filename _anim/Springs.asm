; ---------------------------------------------------------------------------
; Animation script - springs
; ---------------------------------------------------------------------------
Ani_Spring:	dc.w byte_DD02-Ani_Spring
		dc.w byte_DD0E-Ani_Spring
byte_DD02:	dc.b 0,	1, 0, 0, 2, 2, 2, 2, 2,	2, 0, afRoutine
byte_DD0E:	dc.b 0,	4, 3, 3, 5, 5, 5, 5, 5,	5, 3, afRoutine
		even