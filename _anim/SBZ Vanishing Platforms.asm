; ---------------------------------------------------------------------------
; Animation script - vanishing platforms (SBZ)
; ---------------------------------------------------------------------------
Ani_Van:	dc.w @vanish-Ani_Van
		dc.w @appear-Ani_Van
@vanish:	dc.b 7,	0, 1, 2, 3, afBack, 1
		even
@appear:	dc.b 7,	3, 2, 1, 0, afBack, 1
		even