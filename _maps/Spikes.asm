; ---------------------------------------------------------------------------
; Sprite mappings - spikes
; ---------------------------------------------------------------------------
Map_Spike:	dc.w byte_CFF4-Map_Spike
		dc.w byte_D004-Map_Spike
		dc.w byte_D014-Map_Spike
		dc.w byte_D01A-Map_Spike
		dc.w byte_D02A-Map_Spike
		dc.w byte_D049-Map_Spike
byte_CFF4:	dc.b 3			; 3 spikes
		dc.b $F0, 3, 0,	4, $EC
		dc.b $F0, 3, 0,	4, $FC
		dc.b $F0, 3, 0,	4, $C
byte_D004:	dc.b 3			; 3 spikes facing sideways
		dc.b $EC, $C, 0, 0, $F0
		dc.b $FC, $C, 0, 0, $F0
		dc.b $C, $C, 0,	0, $F0
byte_D014:	dc.b 1			; 1 spike
		dc.b $F0, 3, 0,	4, $FC
byte_D01A:	dc.b 3			; 3 spikes widely spaced
		dc.b $F0, 3, 0,	4, $E4
		dc.b $F0, 3, 0,	4, $FC
		dc.b $F0, 3, 0,	4, $14
byte_D02A:	dc.b 6			; 6 spikes
		dc.b $F0, 3, 0,	4, $C0
		dc.b $F0, 3, 0,	4, $D8
		dc.b $F0, 3, 0,	4, $F0
		dc.b $F0, 3, 0,	4, 8
		dc.b $F0, 3, 0,	4, $20
		dc.b $F0, 3, 0,	4, $38
byte_D049:	dc.b 1			; 1 spike facing sideways
		dc.b $FC, $C, 0, 0, $F0
		even