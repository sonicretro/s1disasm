; ---------------------------------------------------------------------------
; Sprite mappings - pushable blocks (MZ, LZ)
; ---------------------------------------------------------------------------
Map_Push:	dc.w @single-Map_Push
		dc.w @four-Map_Push
@single:	dc.b 1
		dc.b $F0, $F, 0, 8, $F0	; single block
@four:		dc.b 4
		dc.b $F0, $F, 0, 8, $C0	; row of 4 blocks
		dc.b $F0, $F, 0, 8, $E0
		dc.b $F0, $F, 0, 8, 0
		dc.b $F0, $F, 0, 8, $20
		even