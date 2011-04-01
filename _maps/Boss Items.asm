; ---------------------------------------------------------------------------
; Sprite mappings - extra boss items (e.g. swinging ball on a chain in GHZ)
; ---------------------------------------------------------------------------
Map_BossItems:	dc.w @chainanchor1-Map_BossItems, @chainanchor2-Map_BossItems
		dc.w @cross-Map_BossItems, @widepipe-Map_BossItems
		dc.w @pipe-Map_BossItems, @spike-Map_BossItems
		dc.w @legmask-Map_BossItems, @legs-Map_BossItems
@chainanchor1:	dc.b 1
		dc.b $F8, 5, 0,	0, $F8	; GHZ boss
@chainanchor2:	dc.b 2
		dc.b $FC, 4, 0,	4, $F8	; GHZ boss
		dc.b $F8, 5, 0,	0, $F8
		even
@cross:		dc.b 1
		dc.b $FC, 0, 0,	6, $FC	; unknown
@widepipe:	dc.b 1
		dc.b $14, 9, 0,	7, $F4	; SLZ boss
@pipe:		dc.b 1
		dc.b $14, 5, 0,	$D, $F8	; MZ boss
@spike:		dc.b 4
		dc.b $F0, 4, 0,	$11, $F8 ; SYZ boss
		dc.b $F8, 1, 0,	$13, $F8
		dc.b $F8, 1, 8,	$13, 0
		dc.b 8,	4, 0, $15, $F8
		even
@legmask:	dc.b 2
		dc.b 0,	5, 0, $17, 0	; FZ post-boss: sprite covering part of legs
		dc.b 0,	0, 0, $1B, $10
		even
@legs:		dc.b 2
		dc.b $18, 4, 0,	$1C, 0	; FZ post-boss
		dc.b 0,	$B, 0, $1E, $10
		even