; ---------------------------------------------------------------------------
; Sprite mappings - rings
; ---------------------------------------------------------------------------
Map_Ring:	dc.w @front-Map_Ring, @angle1-Map_Ring
		dc.w @edge-Map_Ring, @angle2-Map_Ring
		dc.w @sparkle1-Map_Ring, @sparkle2-Map_Ring
		dc.w @sparkle3-Map_Ring, @sparkle4-Map_Ring
		dc.w @blank-Map_Ring
@front:		dc.b 1
		dc.b $F8, 5, 0,	0, $F8	; ring front
@angle1:	dc.b 1
		dc.b $F8, 5, 0,	4, $F8	; ring angle
@edge:		dc.b 1
		dc.b $F8, 1, 0,	8, $FC	; ring perpendicular
@angle2:	dc.b 1
		dc.b $F8, 5, 8,	4, $F8	; ring angle
@sparkle1:	dc.b 1
		dc.b $F8, 5, 0,	$A, $F8	; sparkle
@sparkle2:	dc.b 1
		dc.b $F8, 5, $18, $A, $F8 ; sparkle
@sparkle3:	dc.b 1
		dc.b $F8, 5, 8,	$A, $F8	;sparkle
@sparkle4:	dc.b 1
		dc.b $F8, 5, $10, $A, $F8 ; sparkle
@blank:		dc.b 0
		even