; ---------------------------------------------------------------------------
; Sprite mappings - platforms that move	in circles (SLZ)
; ---------------------------------------------------------------------------
Map_Circ:	dc.w @platform-Map_Circ
@platform:	dc.b 2
		dc.b $F8, 9, 0,	$51, $E8
		dc.b $F8, 9, 8,	$51, 0
		even