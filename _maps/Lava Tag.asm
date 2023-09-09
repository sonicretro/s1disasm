; ---------------------------------------------------------------------------
; Sprite mappings - invisible lava tag (MZ)
; ---------------------------------------------------------------------------
Map_LTag_internal:	mappingsTable
	mappingsTableEntry.w	.f0

.f0:	spriteHeader	; no sprite, because the tag is invisible!
.f0_End

	even
