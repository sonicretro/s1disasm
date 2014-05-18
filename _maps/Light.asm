; ---------------------------------------------------------------------------
; Sprite mappings - lamp (SYZ)
; ---------------------------------------------------------------------------
Map_Light:	dc.w .f0-Map_Light, .f1-Map_Light
		dc.w .f2-Map_Light, .f3-Map_Light
		dc.w .f4-Map_Light, .f5-Map_Light
.f0:		dc.b 2
		dc.b $F8, $C, 0, $31, $F0
		dc.b 0,	$C, $10, $31, $F0
.f1:		dc.b 2
		dc.b $F8, $C, 0, $35, $F0
		dc.b 0,	$C, $10, $35, $F0
.f2:		dc.b 2
		dc.b $F8, $C, 0, $39, $F0
		dc.b 0,	$C, $10, $39, $F0
.f3:		dc.b 2
		dc.b $F8, $C, 0, $3D, $F0
		dc.b 0,	$C, $10, $3D, $F0
.f4:		dc.b 2
		dc.b $F8, $C, 0, $41, $F0
		dc.b 0,	$C, $10, $41, $F0
.f5:		dc.b 2
		dc.b $F8, $C, 0, $45, $F0
		dc.b 0,	$C, $10, $45, $F0
		even