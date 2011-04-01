; ---------------------------------------------------------------------------
; Animation script - lava balls
; ---------------------------------------------------------------------------
Ani_Fire:	dc.w @vertical-Ani_Fire
		dc.w @vertcollide-Ani_Fire
		dc.w @horizontal-Ani_Fire
		dc.w @horicollide-Ani_Fire
@vertical:	dc.b 5,	0, $20,	1, $21,	afEnd
@vertcollide:	dc.b 5,	2, afRoutine
		even
@horizontal:	dc.b 5,	3, $43,	4, $44,	afEnd
@horicollide:	dc.b 5,	5, afRoutine
		even