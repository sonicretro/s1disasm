; ---------------------------------------------------------------------------
; Animation script - water splash (LZ)
; ---------------------------------------------------------------------------
Ani_Splash:	dc.w @splash-Ani_Splash
@splash:	dc.b 4,	0, 1, 2, afRoutine
		even