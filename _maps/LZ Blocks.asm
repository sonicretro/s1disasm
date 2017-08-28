; ---------------------------------------------------------------------------
; Sprite mappings - blocks (LZ)
; ---------------------------------------------------------------------------
Map_LBlock_internal:
		dc.w .sinkblock-Map_LBlock_internal
		dc.w .riseplatform-Map_LBlock_internal
		dc.w .cork-Map_LBlock_internal
		dc.w .block-Map_LBlock_internal
.sinkblock:	dc.b 1
		dc.b $F0, $F, 0, 0, $F0	; block, sinks when stood on
.riseplatform:	dc.b 2
		dc.b $F4, $E, 0, $69, $E0 ; platform, rises when stood on
		dc.b $F4, $E, 0, $75, 0
.cork:		dc.b 1
		dc.b $F0, $F, 1, $1A, $F0 ; cork, floats on water
.block:		dc.b 1
		dc.b $F0, $F, $FD, $FA,	$F0 ; block
		even