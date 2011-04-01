; ---------------------------------------------------------------------------
; Sprite mappings - spiked ball	on a chain (LZ)
; ---------------------------------------------------------------------------
Map_SBall2:	dc.w @chain-Map_SBall2
		dc.w @spikeball-Map_SBall2
		dc.w @base-Map_SBall2
@chain:		dc.b 1
		dc.b $F8, 5, 0,	0, $F8	; chain link
@spikeball:	dc.b 1
		dc.b $F0, $F, 0, 4, $F0	; spikeball
@base:		dc.b 1
		dc.b $F8, 5, 0,	$14, $F8 ; wall attachment
		even