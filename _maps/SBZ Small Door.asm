; ---------------------------------------------------------------------------
; Sprite mappings - doors (SBZ)
; ---------------------------------------------------------------------------
Map_ADoor_internal:
		dc.w .closed-Map_ADoor_internal
		dc.w .f01-Map_ADoor_internal
		dc.w .f02-Map_ADoor_internal
		dc.w .f03-Map_ADoor_internal
		dc.w .f04-Map_ADoor_internal
		dc.w .f05-Map_ADoor_internal
		dc.w .f06-Map_ADoor_internal
		dc.w .f07-Map_ADoor_internal
		dc.w .open-Map_ADoor_internal
.closed:	dc.b 2
		dc.b $E0, 7, 8,	0, $F8	; door closed
		dc.b 0,	7, 8, 0, $F8
.f01:		dc.b 2
		dc.b $DC, 7, 8,	0, $F8
		dc.b 4,	7, 8, 0, $F8
.f02:		dc.b 2
		dc.b $D8, 7, 8,	0, $F8
		dc.b 8,	7, 8, 0, $F8
.f03:		dc.b 2
		dc.b $D4, 7, 8,	0, $F8
		dc.b $C, 7, 8, 0, $F8
.f04:		dc.b 2
		dc.b $D0, 7, 8,	0, $F8
		dc.b $10, 7, 8,	0, $F8
.f05:		dc.b 2
		dc.b $CC, 7, 8,	0, $F8
		dc.b $14, 7, 8,	0, $F8
.f06:		dc.b 2
		dc.b $C8, 7, 8,	0, $F8
		dc.b $18, 7, 8,	0, $F8
.f07:		dc.b 2
		dc.b $C4, 7, 8,	0, $F8
		dc.b $1C, 7, 8,	0, $F8
.open:		dc.b 2
		dc.b $C0, 7, 8,	0, $F8	; door fully open
		dc.b $20, 7, 8,	0, $F8
		even