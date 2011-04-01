; ---------------------------------------------------------------------------
; Sprite mappings - vanishing platforms	(SBZ)
; ---------------------------------------------------------------------------
Map_VanP:	dc.w @whole-Map_VanP, @half-Map_VanP
		dc.w @quarter-Map_VanP, @gone-Map_VanP
@whole:		dc.b 1
		dc.b $F8, $F, 0, 0, $F0
@half:		dc.b 1
		dc.b $F8, 7, 0,	$10, $F8
@quarter:	dc.b 1
		dc.b $F8, 3, 0,	$18, $FC
@gone:		dc.b 0
		even