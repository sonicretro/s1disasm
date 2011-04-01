; ---------------------------------------------------------------------------
; Sprite mappings - missile that Buzz Bomber throws
; ---------------------------------------------------------------------------
Map_Missile:	dc.w @Flare1-Map_Missile, @Flare2-Map_Missile
		dc.w @Ball1-Map_Missile, @Ball2-Map_Missile
@Flare1:	dc.b 1
		dc.b $F8, 5, 0,	$24, $F8 ; buzz bomber firing flare
@Flare2:	dc.b 1
		dc.b $F8, 5, 0,	$28, $F8
@Ball1:		dc.b 1
		dc.b $F8, 5, 0,	$2C, $F8 ; missile itself
@Ball2:		dc.b 1
		dc.b $F8, 5, 0,	$33, $F8
		even