; ---------------------------------------------------------------------------
; Sprite mappings - chaos emeralds from	the special stage results screen
; ---------------------------------------------------------------------------
Map_SSRC_internal:
		dc.w byte_CE02-Map_SSRC_internal
		dc.w byte_CE08-Map_SSRC_internal
		dc.w byte_CE0E-Map_SSRC_internal
		dc.w byte_CE14-Map_SSRC_internal
		dc.w byte_CE1A-Map_SSRC_internal
		dc.w byte_CE20-Map_SSRC_internal
		dc.w byte_CE26-Map_SSRC_internal
byte_CE02:	dc.b 1
		dc.b $F8, 5, $20, 4, $F8
byte_CE08:	dc.b 1
		dc.b $F8, 5, 0,	0, $F8
byte_CE0E:	dc.b 1
		dc.b $F8, 5, $40, 4, $F8
byte_CE14:	dc.b 1
		dc.b $F8, 5, $60, 4, $F8
byte_CE1A:	dc.b 1
		dc.b $F8, 5, $20, 8, $F8
byte_CE20:	dc.b 1
		dc.b $F8, 5, $20, $C, $F8
byte_CE26:	dc.b 0			; Blank frame
		even