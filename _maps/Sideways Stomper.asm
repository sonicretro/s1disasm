; ---------------------------------------------------------------------------
; Sprite mappings - spiked metal block from beta version (MZ)
; ---------------------------------------------------------------------------
Map_SStom_internal:
		dc.w .block-Map_SStom_internal
		dc.w .spikes-Map_SStom_internal
		dc.w .wallbracket-Map_SStom_internal
		dc.w .pole1-Map_SStom_internal
		dc.w .pole2-Map_SStom_internal
		dc.w .pole3-Map_SStom_internal
		dc.w .pole4-Map_SStom_internal
		dc.w .pole5-Map_SStom_internal
		dc.w .pole5-Map_SStom_internal
.block:		dc.b 3
		dc.b $E0, $B, 0, $1F, $F4 ; main metal block
		dc.b 0,	$B, $10, $1F, $F4
		dc.b $F0, 3, 0,	$2B, $C
.spikes:	dc.b 3
		dc.b $E8, $C, $12, $1B,	$F0 ; three spikes
		dc.b $FC, $C, $12, $1B,	$F0
		dc.b $10, $C, $12, $1B,	$F0
.wallbracket:	dc.b 1
		dc.b $F0, 3, 8,	$2B, $FC ; thing holding it to the wall
.pole1:		dc.b 2
		dc.b $F8, 5, 0,	$41, $E0 ; poles of various lengths
		dc.b $F8, 5, 0,	$41, $F0
.pole2:		dc.b 4
		dc.b $F8, 5, 0,	$41, $E0
		dc.b $F8, 5, 0,	$41, $F0
		dc.b $F8, 5, 0,	$41, 0
		dc.b $F8, 5, 0,	$41, $10
.pole3:		dc.b 6
		dc.b $F8, 5, 0,	$41, $E0
		dc.b $F8, 5, 0,	$41, $F0
		dc.b $F8, 5, 0,	$41, 0
		dc.b $F8, 5, 0,	$41, $10
		dc.b $F8, 5, 0,	$41, $20
		dc.b $F8, 5, 0,	$41, $30
.pole4:		dc.b 8
		dc.b $F8, 5, 0,	$41, $E0
		dc.b $F8, 5, 0,	$41, $F0
		dc.b $F8, 5, 0,	$41, 0
		dc.b $F8, 5, 0,	$41, $10
		dc.b $F8, 5, 0,	$41, $20
		dc.b $F8, 5, 0,	$41, $30
		dc.b $F8, 5, 0,	$41, $40
		dc.b $F8, 5, 0,	$41, $50
.pole5:		dc.b 8		; Incorrect: this should be $A
		dc.b $F8, 5, 0,	$41, $E0
		dc.b $F8, 5, 0,	$41, $F0
		dc.b $F8, 5, 0,	$41, 0
		dc.b $F8, 5, 0,	$41, $10
		dc.b $F8, 5, 0,	$41, $20
		dc.b $F8, 5, 0,	$41, $30
		dc.b $F8, 5, 0,	$41, $40
		dc.b $F8, 5, 0,	$41, $50
		dc.b $F8, 5, 0,	$41, $60
		dc.b $F8, 5, 0,	$41, $70
		; .pole6 should be here, but it isn't...
		even