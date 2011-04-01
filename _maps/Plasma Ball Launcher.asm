; ---------------------------------------------------------------------------
; Sprite mappings - energy ball	launcher (FZ)
; ---------------------------------------------------------------------------
Map_PLaunch:	dc.w @red-Map_PLaunch
		dc.w @white-Map_PLaunch
		dc.w @sparking1-Map_PLaunch
		dc.w @sparking2-Map_PLaunch
@red:		dc.b 1
		dc.b $F8, 5, 0,	$6E, $F8
@white:		dc.b 1
		dc.b $F8, 5, 0,	$76, $F8
@sparking1:	dc.b 1
		dc.b $F8, 5, 0,	$72, $F8
@sparking2:	dc.b 1
		dc.b $F8, 5, $10, $72, $F8
		even