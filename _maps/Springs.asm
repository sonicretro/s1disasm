; ---------------------------------------------------------------------------
; Sprite mappings - springs
; ---------------------------------------------------------------------------
Map_Spring_internal:
		dc.w M_Spg_Up-Map_Spring_internal
		dc.w M_Spg_UpFlat-Map_Spring_internal
		dc.w M_Spg_UpExt-Map_Spring_internal
		dc.w M_Spg_Left-Map_Spring_internal
		dc.w M_Spg_LeftFlat-Map_Spring_internal
		dc.w M_Spg_LeftExt-Map_Spring_internal
M_Spg_Up:	dc.b 2			; facing up
		dc.b $F8, $C, 0, 0, $F0
		dc.b 0,	$C, 0, 4, $F0
M_Spg_UpFlat:	dc.b 1			; facing up, flattened
		dc.b 0,	$C, 0, 0, $F0
M_Spg_UpExt:	dc.b 3			; facing up, extended
		dc.b $E8, $C, 0, 0, $F0
		dc.b $F0, 5, 0,	8, $F8
		dc.b 0,	$C, 0, $C, $F0
M_Spg_Left:	dc.b 1			; facing left
		dc.b $F0, 7, 0,	0, $F8
M_Spg_LeftFlat:	dc.b 1			; facing left, flattened
		dc.b $F0, 3, 0,	4, $F8
M_Spg_LeftExt:	dc.b 4			; facing left, extended
		dc.b $F0, 3, 0,	4, $10
		dc.b $F8, 9, 0,	8, $F8
		dc.b $F0, 0, 0,	0, $F8
		dc.b 8,	0, 0, 3, $F8
		even