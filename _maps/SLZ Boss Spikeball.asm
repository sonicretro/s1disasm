; ---------------------------------------------------------------------------
; Sprite mappings - exploding spikeys that the SLZ boss	drops
; ---------------------------------------------------------------------------
Map_BSBall:	dc.w @fireball1-Map_BSBall
		dc.w @fireball2-Map_BSBall
@fireball1:	dc.b 1
		dc.b $FC, 0, 0,	$27, $FC
@fireball2:	dc.b 1
		dc.b $FC, 0, 0,	$28, $FC
		even