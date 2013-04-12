; ---------------------------------------------------------------------------
; Sprite mappings - disc that you run around (SBZ)
; (It's just a small blob that moves around in a circle. The disc itself is
; part of the level tiles.)
; ---------------------------------------------------------------------------
Map_Disc:	mappingsTable
	mappingsTableEntry.w	@spot

@spot:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
@spot_End

	even
