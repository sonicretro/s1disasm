; ---------------------------------------------------------------------------
; Sprite mappings - drowning countdown numbers (LZ)
; ---------------------------------------------------------------------------
Map_Drown_internal:
		dc.w .num-Map_Drown_internal
.num:		dc.b 1
		dc.b $E8, $E, 0, 0, $F2
		even