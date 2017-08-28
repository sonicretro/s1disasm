; ---------------------------------------------------------------------------
; Sprite mappings - invisible lava tag (MZ)
; ---------------------------------------------------------------------------
Map_LTag_internal:
		dc.w .f0-Map_LTag_internal
.f0:		dc.b 0		; no sprite, because the tag is invisible!
		even