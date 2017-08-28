; ---------------------------------------------------------------------------
; Sprite mappings - fire balls (MZ, SLZ)
; ---------------------------------------------------------------------------
Map_Fire_internal:
		dc.w .vertical1-Map_Fire_internal
		dc.w .vertical2-Map_Fire_internal
		dc.w .vertcollide-Map_Fire_internal
		dc.w .horizontal1-Map_Fire_internal
		dc.w .horizontal2-Map_Fire_internal
		dc.w .horicollide-Map_Fire_internal
.vertical1:	dc.b 1
		dc.b $E8, 7, 0,	0, $F8
.vertical2:	dc.b 1
		dc.b $E8, 7, 0,	8, $F8
.vertcollide:	dc.b 1
		dc.b $F0, 6, 0,	$10, $F8
.horizontal1:	dc.b 1
		dc.b $F8, $D, 0, $16, $E8
.horizontal2:	dc.b 1
		dc.b $F8, $D, 0, $1E, $E8
.horicollide:	dc.b 1
		dc.b $F8, 9, 0,	$26, $F0
		even