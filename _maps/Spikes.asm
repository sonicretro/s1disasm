; ---------------------------------------------------------------------------
; Sprite mappings - spikes
; ---------------------------------------------------------------------------
Map_Spike_internal:	mappingsTable
	mappingsTableEntry.w	byte_CFF4
	mappingsTableEntry.w	byte_D004
	mappingsTableEntry.w	byte_D014
	mappingsTableEntry.w	byte_D01A
	mappingsTableEntry.w	byte_D02A
	mappingsTableEntry.w	byte_D049

byte_CFF4:	spriteHeader
	spritePiece	-$14, -$10, 1, 4, 4, 0, 0, 0, 0	; 3 spikes
	spritePiece	-4, -$10, 1, 4, 4, 0, 0, 0, 0
	spritePiece	$C, -$10, 1, 4, 4, 0, 0, 0, 0
byte_CFF4_End

byte_D004:	spriteHeader
	spritePiece	-$10, -$14, 4, 1, 0, 0, 0, 0, 0	; 3 spikes facing sideways
	spritePiece	-$10, -4, 4, 1, 0, 0, 0, 0, 0
	spritePiece	-$10, $C, 4, 1, 0, 0, 0, 0, 0
byte_D004_End

byte_D014:	spriteHeader
	spritePiece	-4, -$10, 1, 4, 4, 0, 0, 0, 0	; 1 spike
byte_D014_End

byte_D01A:	spriteHeader
	spritePiece	-$1C, -$10, 1, 4, 4, 0, 0, 0, 0	; 3 spikes widely spaced
	spritePiece	-4, -$10, 1, 4, 4, 0, 0, 0, 0
	spritePiece	$14, -$10, 1, 4, 4, 0, 0, 0, 0
byte_D01A_End

byte_D02A:	spriteHeader
	spritePiece	-$40, -$10, 1, 4, 4, 0, 0, 0, 0	; 6 spikes
	spritePiece	-$28, -$10, 1, 4, 4, 0, 0, 0, 0
	spritePiece	-$10, -$10, 1, 4, 4, 0, 0, 0, 0
	spritePiece	8, -$10, 1, 4, 4, 0, 0, 0, 0
	spritePiece	$20, -$10, 1, 4, 4, 0, 0, 0, 0
	spritePiece	$38, -$10, 1, 4, 4, 0, 0, 0, 0
byte_D02A_End

byte_D049:	spriteHeader
	spritePiece	-$10, -4, 4, 1, 0, 0, 0, 0, 0	; 1 spike facing sideways
byte_D049_End

	even
