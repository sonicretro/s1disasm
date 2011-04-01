; ---------------------------------------------------------------------------
; Animation script - flapping door (LZ)
; ---------------------------------------------------------------------------
Ani_Flap:	dc.w @opening-Ani_Flap
		dc.w @closing-Ani_Flap
@opening:	dc.b 3,	0, 1, 2, afBack, 1
@closing:	dc.b 3,	2, 1, 0, afBack, 1
		even