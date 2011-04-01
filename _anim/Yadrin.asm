; ---------------------------------------------------------------------------
; Animation script - Yadrin enemy
; ---------------------------------------------------------------------------
Ani_Yad:	dc.w @stand-Ani_Yad
		dc.w @walk-Ani_Yad

@stand:		dc.b 7,	0, afEnd
		even
@walk:		dc.b 7,	0, 3, 1, 4, 0, 3, 2, 5,	afEnd
		even