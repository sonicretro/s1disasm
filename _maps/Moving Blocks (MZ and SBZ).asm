; ---------------------------------------------------------------------------
; Sprite mappings - moving blocks (MZ, SBZ)
; ---------------------------------------------------------------------------
Map_MBlock:	dc.w @mz1-Map_MBlock, @mz2-Map_MBlock
		dc.w @sbz-Map_MBlock, @sbzwide-Map_MBlock
		dc.w @mz3-Map_MBlock
@mz1:		dc.b 1
		dc.b $F8, $F, 0, 8, $F0
@mz2:		dc.b 2
		dc.b $F8, $F, 0, 8, $E0
		dc.b $F8, $F, 0, 8, 0
@sbz:		dc.b 4
		dc.b $F8, $C, $20, 0, $E0
		dc.b 0,	$D, 0, 4, $E0
		dc.b $F8, $C, $20, 0, 0
		dc.b 0,	$D, 0, 4, 0
@sbzwide:	dc.b 4
		dc.b $F8, $E, 0, 0, $C0
		dc.b $F8, $E, 0, 3, $E0
		dc.b $F8, $E, 0, 3, 0
		dc.b $F8, $E, 8, 0, $20
@mz3:		dc.b 3
		dc.b $F8, $F, 0, 8, $D0
		dc.b $F8, $F, 0, 8, $F0
		dc.b $F8, $F, 0, 8, $10
		even