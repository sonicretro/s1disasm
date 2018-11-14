; ---------------------------------------------------------------------------
; Sprite mappings - large green	glassy blocks (MZ)
; ---------------------------------------------------------------------------
Map_Glass_internal:
		dc.w @tall-Map_Glass_internal
		dc.w @shine-Map_Glass_internal
		dc.w @short-Map_Glass_internal
@tall:		dc.b $C
		dc.b $B8, $C, 0, 0, $E0	; tall block
		dc.b $B8, $C, 8, 0, 0
		dc.b $C0, $F, 0, 4, $E0
		dc.b $C0, $F, 8, 4, 0
		dc.b $E0, $F, 0, 4, $E0
		dc.b $E0, $F, 8, 4, 0
		dc.b 0,	$F, 0, 4, $E0
		dc.b 0,	$F, 8, 4, 0
		dc.b $20, $F, 0, 4, $E0
		dc.b $20, $F, 8, 4, 0
		dc.b $40, $C, $10, 0, $E0
		dc.b $40, $C, $18, 0, 0
@shine:		dc.b 2
		dc.b 8,	6, 0, $14, $F0	; reflected shine on block
		dc.b 0,	6, 0, $14, 0
@short:		dc.b $A
		dc.b $C8, $C, 0, 0, $E0	; short block
		dc.b $C8, $C, 8, 0, 0
		dc.b $D0, $F, 0, 4, $E0
		dc.b $D0, $F, 8, 4, 0
		dc.b $F0, $F, 0, 4, $E0
		dc.b $F0, $F, 8, 4, 0
		dc.b $10, $F, 0, 4, $E0
		dc.b $10, $F, 8, 4, 0
		dc.b $30, $C, $10, 0, $E0
		dc.b $30, $C, $18, 0, 0
		even