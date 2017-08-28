; ---------------------------------------------------------------------------
; Sprite mappings - blocks that	Robotnik picks up (SYZ)
; ---------------------------------------------------------------------------
Map_BossBlock_internal:
		dc.w .wholeblock-Map_BossBlock_internal
		dc.w .topleft-Map_BossBlock_internal
		dc.w .topright-Map_BossBlock_internal
		dc.w .bottomleft-Map_BossBlock_internal
		dc.w .bottomright-Map_BossBlock_internal
.wholeblock:	dc.b 2
		dc.b $F0, $D, 0, $71, $F0
		dc.b 0,	$D, 0, $79, $F0
		dc.b 0
.topleft:	dc.b 1
		dc.b $F8, 5, 0,	$71, $F8
.topright:	dc.b 1
		dc.b $F8, 5, 0,	$75, $F8
.bottomleft:	dc.b 1
		dc.b $F8, 5, 0,	$79, $F8
.bottomright:	dc.b 1
		dc.b $F8, 5, 0,	$7D, $F8
		even