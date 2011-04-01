; ---------------------------------------------------------------------------
; Sprite mappings - metal pylons in foreground (SLZ)
; ---------------------------------------------------------------------------
Map_Pylon:	dc.w @pylon-Map_Pylon
@pylon:		dc.b 9
		dc.b $80, $F, 0, 0, $F0
		dc.b $A0, $F, $10, 0, $F0
		dc.b $C0, $F, 0, 0, $F0
		dc.b $E0, $F, $10, 0, $F0
		dc.b 0,	$F, 0, 0, $F0
		dc.b $20, $F, $10, 0, $F0
		dc.b $40, $F, 0, 0, $F0
		dc.b $60, $F, $10, 0, $F0
		dc.b $7F, $F, 0, 0, $F0
		even