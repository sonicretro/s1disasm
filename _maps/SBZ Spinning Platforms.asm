; ---------------------------------------------------------------------------
; Sprite mappings - spinning platforms (SBZ)
; ---------------------------------------------------------------------------
Map_Spin:	dc.w @flat-Map_Spin, @spin1-Map_Spin
		dc.w @spin2-Map_Spin, @spin3-Map_Spin
		dc.w @spin4-Map_Spin
@flat:		dc.b 2
		dc.b $F8, 5, 0,	0, $F0
		dc.b $F8, 5, 8,	0, 0
@spin1:		dc.b 2
		dc.b $F0, $D, 0, $14, $F0
		dc.b 0,	$D, 0, $1C, $F0
@spin2:		dc.b 2
		dc.b $F0, 9, 0,	4, $F0
		dc.b 0,	9, 0, $A, $F8
@spin3:		dc.b 2
		dc.b $F0, 9, 0,	$24, $F0
		dc.b 0,	9, 0, $2A, $F8
@spin4:		dc.b 2
		dc.b $F0, 5, 0,	$10, $F8
		dc.b 0,	5, $10,	$10, $F8
		even