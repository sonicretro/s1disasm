; ---------------------------------------------------------------------------
; Sprite mappings - Jaws enemy (LZ)
; ---------------------------------------------------------------------------
Map_Jaws_internal:
		dc.w .open1-Map_Jaws_internal
		dc.w .shut1-Map_Jaws_internal
		dc.w .open2-Map_Jaws_internal
		dc.w .shut2-Map_Jaws_internal
.open1:		dc.b 2
		dc.b $F4, $E, 0, 0, $F0	; mouth open
		dc.b $F5, 5, 0,	$18, $10
.shut1:		dc.b 2
		dc.b $F4, $E, 0, $C, $F0 ; mouth shut
		dc.b $F5, 5, 0,	$1C, $10
.open2:		dc.b 2
		dc.b $F4, $E, 0, 0, $F0
		dc.b $F5, 5, $10, $18, $10
.shut2:		dc.b 2
		dc.b $F4, $E, 0, $C, $F0
		dc.b $F5, 5, $10, $1C, $10
		even