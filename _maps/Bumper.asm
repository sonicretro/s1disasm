; ---------------------------------------------------------------------------
; Sprite mappings - pinball bumper (SYZ)
; ---------------------------------------------------------------------------
Map_Bump_internal:
		dc.w .normal-Map_Bump_internal
		dc.w .bumped1-Map_Bump_internal
		dc.w .bumped2-Map_Bump_internal
.normal:	dc.b 2
		dc.b $F0, 7, 0,	0, $F0
		dc.b $F0, 7, 8,	0, 0
.bumped1:	dc.b 2
		dc.b $F4, 6, 0,	8, $F4
		dc.b $F4, 2, 8,	8, 4
.bumped2:	dc.b 2
		dc.b $F0, 7, 0,	$E, $F0
		dc.b $F0, 7, 8,	$E, 0
		even