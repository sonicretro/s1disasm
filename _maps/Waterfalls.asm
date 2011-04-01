; ---------------------------------------------------------------------------
; Sprite mappings - waterfalls (LZ)
; ---------------------------------------------------------------------------
Map_WFall:	dc.w @vertnarrow-Map_WFall, @cornerwide-Map_WFall
		dc.w @cornermedium-Map_WFall, @cornernarrow-Map_WFall
		dc.w @cornermedium2-Map_WFall, @cornernarrow2-Map_WFall
		dc.w @cornernarrow3-Map_WFall, @vertwide-Map_WFall
		dc.w @diagonal-Map_WFall, @splash1-Map_WFall
		dc.w @splash2-Map_WFall, @splash3-Map_WFall
@vertnarrow:	dc.b 1
		dc.b $F0, 7, 0,	0, $F8
@cornerwide:	dc.b 2
		dc.b $F8, 4, 0,	8, $FC
		dc.b 0,	8, 0, $A, $F4
@cornermedium:	dc.b 2
		dc.b $F8, 0, 0,	8, 0
		dc.b 0,	4, 0, $D, $F8
@cornernarrow:	dc.b 1
		dc.b $F8, 1, 0,	$F, 0
@cornermedium2:	dc.b 2
		dc.b $F8, 0, 0,	8, 0
		dc.b 0,	4, 0, $D, $F8
@cornernarrow2:	dc.b 1
		dc.b $F8, 1, 0,	$11, 0
@cornernarrow3:	dc.b 1
		dc.b $F8, 1, 0,	$13, 0
@vertwide:	dc.b 1
		dc.b $F0, 7, 0,	$15, $F8
@diagonal:	dc.b 2
		dc.b $F8, $C, 0, $1D, $F6
		dc.b 0,	$C, 0, $21, $E8
@splash1:	dc.b 2
		dc.b $F0, $B, 0, $25, $E8
		dc.b $F0, $B, 0, $31, 0
@splash2:	dc.b 2
		dc.b $F0, $B, 0, $3D, $E8
		dc.b $F0, $B, 0, $49, 0
@splash3:	dc.b 2
		dc.b $F0, $B, 0, $55, $E8
		dc.b $F0, $B, 0, $61, 0
		even