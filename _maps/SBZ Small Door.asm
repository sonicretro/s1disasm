; ---------------------------------------------------------------------------
; Sprite mappings - doors (SBZ)
; ---------------------------------------------------------------------------
Map_ADoor:	dc.w @closed-Map_ADoor, @01-Map_ADoor
		dc.w @02-Map_ADoor, @03-Map_ADoor
		dc.w @04-Map_ADoor, @05-Map_ADoor
		dc.w @06-Map_ADoor, @07-Map_ADoor
		dc.w @open-Map_ADoor
@closed:	dc.b 2
		dc.b $E0, 7, 8,	0, $F8	; door closed
		dc.b 0,	7, 8, 0, $F8
@01:		dc.b 2
		dc.b $DC, 7, 8,	0, $F8
		dc.b 4,	7, 8, 0, $F8
@02:		dc.b 2
		dc.b $D8, 7, 8,	0, $F8
		dc.b 8,	7, 8, 0, $F8
@03:		dc.b 2
		dc.b $D4, 7, 8,	0, $F8
		dc.b $C, 7, 8, 0, $F8
@04:		dc.b 2
		dc.b $D0, 7, 8,	0, $F8
		dc.b $10, 7, 8,	0, $F8
@05:		dc.b 2
		dc.b $CC, 7, 8,	0, $F8
		dc.b $14, 7, 8,	0, $F8
@06:		dc.b 2
		dc.b $C8, 7, 8,	0, $F8
		dc.b $18, 7, 8,	0, $F8
@07:		dc.b 2
		dc.b $C4, 7, 8,	0, $F8
		dc.b $1C, 7, 8,	0, $F8
@open:		dc.b 2
		dc.b $C0, 7, 8,	0, $F8	; door fully open
		dc.b $20, 7, 8,	0, $F8
		even