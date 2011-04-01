; ---------------------------------------------------------------------------
; Sprite mappings - "GAME OVER"	and "TIME OVER"
; ---------------------------------------------------------------------------
Map_Over:	dc.w byte_CBAC-Map_Over
		dc.w byte_CBB7-Map_Over
		dc.w byte_CBC2-Map_Over
		dc.w byte_CBCD-Map_Over
byte_CBAC:	dc.b 2			; GAME
		dc.b $F8, $D, 0, 0, $B8
		dc.b $F8, $D, 0, 8, $D8
byte_CBB7:	dc.b 2			; OVER
		dc.b $F8, $D, 0, $14, 8
		dc.b $F8, $D, 0, $C, $28
byte_CBC2:	dc.b 2			; TIME
		dc.b $F8, 9, 0,	$1C, $C4
		dc.b $F8, $D, 0, 8, $DC
byte_CBCD:	dc.b 2			; OVER
		dc.b $F8, $D, 0, $14, $C
		dc.b $F8, $D, 0, $C, $2C
		even