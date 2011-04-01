; ---------------------------------------------------------------------------
; Sprite mappings - signpost
; ---------------------------------------------------------------------------
Map_Sign:	dc.w @eggman-Map_Sign, @spin1-Map_Sign
		dc.w @spin2-Map_Sign, @spin3-Map_Sign
		dc.w @sonic-Map_Sign
@eggman:	dc.b 3
		dc.b $F0, $B, 0, 0, $E8
		dc.b $F0, $B, 8, 0, 0
		dc.b $10, 1, 0,	$38, $FC
@spin1:		dc.b 2
		dc.b $F0, $F, 0, $C, $F0
		dc.b $10, 1, 0,	$38, $FC
@spin2:		dc.b 2
		dc.b $F0, 3, 0,	$1C, $FC
		dc.b $10, 1, 8,	$38, $FC
@spin3:		dc.b 2
		dc.b $F0, $F, 8, $C, $F0
		dc.b $10, 1, 8,	$38, $FC
@sonic:		dc.b 3
		dc.b $F0, $B, 0, $20, $E8
		dc.b $F0, $B, 0, $2C, 0
		dc.b $10, 1, 0,	$38, $FC
		even