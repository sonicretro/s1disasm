; ---------------------------------------------------------------------------
; Sprite mappings - rings
; ---------------------------------------------------------------------------
Map_Ring_internal:	mappingsTable
	mappingsTableEntry.w	.front
	mappingsTableEntry.w	.angle1
	mappingsTableEntry.w	.edge
	mappingsTableEntry.w	.angle2
	mappingsTableEntry.w	.sparkle1
	mappingsTableEntry.w	.sparkle2
	mappingsTableEntry.w	.sparkle3
	mappingsTableEntry.w	.sparkle4

.front:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0	; ring front
.front_End

.angle1:	spriteHeader
	spritePiece	-8, -8, 2, 2, 4, 0, 0, 0, 0	; ring angle
.angle1_End

.edge:	spriteHeader
	spritePiece	-4, -8, 1, 2, 8, 0, 0, 0, 0	; ring perpendicular
.edge_End

.angle2:	spriteHeader
	spritePiece	-8, -8, 2, 2, 4, 1, 0, 0, 0	; ring angle
.angle2_End

.sparkle1:	spriteHeader
	spritePiece	-8, -8, 2, 2, $A, 0, 0, 0, 0	; sparkle
.sparkle1_End

.sparkle2:	spriteHeader
	spritePiece	-8, -8, 2, 2, $A, 1, 1, 0, 0	; sparkle
.sparkle2_End

.sparkle3:	spriteHeader
	spritePiece	-8, -8, 2, 2, $A, 1, 0, 0, 0	; sparkle
.sparkle3_End

.sparkle4:	spriteHeader
	spritePiece	-8, -8, 2, 2, $A, 0, 1, 0, 0	; sparkle
.sparkle4_End

	even
