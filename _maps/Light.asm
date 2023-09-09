; ---------------------------------------------------------------------------
; Sprite mappings - lamp (SYZ)
; ---------------------------------------------------------------------------
Map_Light_internal:	mappingsTable
	mappingsTableEntry.w	.f0
	mappingsTableEntry.w	.f1
	mappingsTableEntry.w	.f2
	mappingsTableEntry.w	.f3
	mappingsTableEntry.w	.f4
	mappingsTableEntry.w	.f5

.f0:	spriteHeader
	spritePiece	-$10, -8, 4, 1, $31, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 1, $31, 0, 1, 0, 0
.f0_End

.f1:	spriteHeader
	spritePiece	-$10, -8, 4, 1, $35, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 1, $35, 0, 1, 0, 0
.f1_End

.f2:	spriteHeader
	spritePiece	-$10, -8, 4, 1, $39, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 1, $39, 0, 1, 0, 0
.f2_End

.f3:	spriteHeader
	spritePiece	-$10, -8, 4, 1, $3D, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 1, $3D, 0, 1, 0, 0
.f3_End

.f4:	spriteHeader
	spritePiece	-$10, -8, 4, 1, $41, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 1, $41, 0, 1, 0, 0
.f4_End

.f5:	spriteHeader
	spritePiece	-$10, -8, 4, 1, $45, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 1, $45, 0, 1, 0, 0
.f5_End

	even
