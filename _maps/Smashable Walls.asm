; ---------------------------------------------------------------------------
; Sprite mappings - smashable walls (GHZ, SLZ)
; ---------------------------------------------------------------------------
Map_Smash_internal:
		dc.w .left-Map_Smash_internal
		dc.w .middle-Map_Smash_internal
		dc.w .right-Map_Smash_internal
.left:		dc.b 8
		dc.b $E0, 5, 0,	0, $F0
		dc.b $F0, 5, 0,	0, $F0
		dc.b 0,	5, 0, 0, $F0
		dc.b $10, 5, 0,	0, $F0
		dc.b $E0, 5, 0,	4, 0
		dc.b $F0, 5, 0,	4, 0
		dc.b 0,	5, 0, 4, 0
		dc.b $10, 5, 0,	4, 0
.middle:	dc.b 8
		dc.b $E0, 5, 0,	4, $F0
		dc.b $F0, 5, 0,	4, $F0
		dc.b 0,	5, 0, 4, $F0
		dc.b $10, 5, 0,	4, $F0
		dc.b $E0, 5, 0,	4, 0
		dc.b $F0, 5, 0,	4, 0
		dc.b 0,	5, 0, 4, 0
		dc.b $10, 5, 0,	4, 0
.right:		dc.b 8
		dc.b $E0, 5, 0,	4, $F0
		dc.b $F0, 5, 0,	4, $F0
		dc.b 0,	5, 0, 4, $F0
		dc.b $10, 5, 0,	4, $F0
		dc.b $E0, 5, 0,	8, 0
		dc.b $F0, 5, 0,	8, 0
		dc.b 0,	5, 0, 8, 0
		dc.b $10, 5, 0,	8, 0
		even