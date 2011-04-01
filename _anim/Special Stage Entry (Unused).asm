; ---------------------------------------------------------------------------
; Animation script - special stage entry effect from beta
; ---------------------------------------------------------------------------
Ani_Vanish:	dc.w @vanish-Ani_Vanish
@vanish:	dc.b 5,	0, 1, 0, 1, 0, 7, 1, 7,	2, 7, 3, 7, 4, 7, 5, 7, 6, 7, afRoutine
		even