; ---------------------------------------------------------------------------
; Sprite mappings - invisible lava tag (MZ)
; ---------------------------------------------------------------------------
Map_LTag_internal:
		dc.w @0-Map_LTag_internal
@0:		dc.b 0		; no sprite, because the tag is invisible!
		even