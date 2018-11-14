; ---------------------------------------------------------------------------
; Sprite mappings - vanishing platforms	(SBZ)
; ---------------------------------------------------------------------------
Map_VanP_internal:
		dc.w @whole-Map_VanP_internal
		dc.w @half-Map_VanP_internal
		dc.w @quarter-Map_VanP_internal
		dc.w @gone-Map_VanP_internal
@whole:		dc.b 1
		dc.b $F8, $F, 0, 0, $F0
@half:		dc.b 1
		dc.b $F8, 7, 0,	$10, $F8
@quarter:	dc.b 1
		dc.b $F8, 3, 0,	$18, $FC
@gone:		dc.b 0
		even