; ---------------------------------------------------------------------------
; Sprite mappings - lamppost
; ---------------------------------------------------------------------------
Map_Lamp:	dc.w @blue-Map_Lamp, @poleonly-Map_Lamp
		dc.w @redballonly-Map_Lamp, @red-Map_Lamp
@blue:		dc.b 6
		dc.b $E4, 1, 0,	0, $F8
		dc.b $E4, 1, 8,	0, 0
		dc.b $F4, 3, $20, 2, $F8
		dc.b $F4, 3, $28, 2, 0
		dc.b $D4, 1, 0,	6, $F8
		dc.b $D4, 1, 8,	6, 0
@poleonly:	dc.b 4
		dc.b $E4, 1, 0,	0, $F8
		dc.b $E4, 1, 8,	0, 0
		dc.b $F4, 3, $20, 2, $F8
		dc.b $F4, 3, $28, 2, 0
@redballonly:	dc.b 2
		dc.b $F8, 1, 0,	8, $F8
		dc.b $F8, 1, 8,	8, 0
@red:		dc.b 6
		dc.b $E4, 1, 0,	0, $F8
		dc.b $E4, 1, 8,	0, 0
		dc.b $F4, 3, $20, 2, $F8
		dc.b $F4, 3, $28, 2, 0
		dc.b $D4, 1, 0,	8, $F8
		dc.b $D4, 1, 8,	8, 0
		even