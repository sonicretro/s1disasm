; ---------------------------------------------------------------------------
; Sprite mappings - energy balls (FZ)
; ---------------------------------------------------------------------------
Map_Plasma_internal:
		dc.w .fuzzy1-Map_Plasma_internal
		dc.w .fuzzy2-Map_Plasma_internal
		dc.w .white1-Map_Plasma_internal
		dc.w .white2-Map_Plasma_internal
		dc.w .white3-Map_Plasma_internal
		dc.w .white4-Map_Plasma_internal
		dc.w .fuzzy3-Map_Plasma_internal
		dc.w .fuzzy4-Map_Plasma_internal
		dc.w .fuzzy5-Map_Plasma_internal
		dc.w .fuzzy6-Map_Plasma_internal
		dc.w .blank-Map_Plasma_internal
.fuzzy1:	dc.b 2
		dc.b $F0, $D, 0, $7A, $F0
		dc.b 0,	$D, $18, $7A, $F0
.fuzzy2:	dc.b 2
		dc.b $F4, 6, 0,	$82, $F4
		dc.b $F4, 2, $18, $82, 4
.white1:	dc.b 2
		dc.b $F8, 4, 0,	$88, $F8
		dc.b 0,	4, $10,	$88, $F8
.white2:	dc.b 2
		dc.b $F8, 4, 0,	$8A, $F8
		dc.b 0,	4, $10,	$8A, $F8
.white3:	dc.b 2
		dc.b $F8, 4, 0,	$8C, $F8
		dc.b 0,	4, $10,	$8C, $F8
.white4:	dc.b 2
		dc.b $F4, 6, 0,	$8E, $F4
		dc.b $F4, 2, $18, $8E, 4
.fuzzy3:	dc.b 1
		dc.b $F8, 5, 0,	$94, $F8
.fuzzy4:	dc.b 1
		dc.b $F8, 5, 0,	$98, $F8
.fuzzy5:	dc.b 2
		dc.b $F0, $D, 8, $7A, $F0
		dc.b 0,	$D, $10, $7A, $F0
.fuzzy6:	dc.b 2
		dc.b $F4, 6, $10, $82, $F4
		dc.b $F4, 2, 8,	$82, 4
.blank:		dc.b 0
		even