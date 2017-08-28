; ---------------------------------------------------------------------------
; Sprite mappings - large girder block (SBZ)
; ---------------------------------------------------------------------------
Map_Gird_internal:
		dc.w .girder-Map_Gird_internal
.girder:	dc.b $C
		dc.b $E8, $E, 0, 0, $A0
		dc.b 0,	$E, $10, 0, $A0
		dc.b $E8, $E, 0, 6, $C0
		dc.b 0,	$E, $10, 6, $C0
		dc.b $E8, $E, 0, 6, $E0
		dc.b 0,	$E, $10, 6, $E0
		dc.b $E8, $E, 0, 6, 0
		dc.b 0,	$E, $10, 6, 0
		dc.b $E8, $E, 0, 6, $20
		dc.b 0,	$E, $10, 6, $20
		dc.b $E8, $E, 0, 6, $40
		dc.b 0,	$E, $10, 6, $40
		even