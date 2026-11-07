Map_SSR:	mappingsTable
	mappingsTableEntry.w	M_SSR_Chaos	; "CHAOS EMERALDS" text
	mappingsTableEntry.w	M_SSR_Score	; Score tally
	mappingsTableEntry.w	M_SSR_Ring	; Ring Bonus tally
	mappingsTableEntry.w	M_SSR_Oval	; Blue oval (cross-referenced from the regular title card mappings)
	mappingsTableEntry.w	M_SSR_ContSon1	; Continue tally with mini Sonic (foot down)
	mappingsTableEntry.w	M_SSR_ContSon2	; Continue tally with mini Sonic (foot up)
	mappingsTableEntry.w	M_SSR_Continue	; Continue tally without mini Sonic
	mappingsTableEntry.w	M_SSR_SpeStage	; "SPECIAL STAGE" text
	mappingsTableEntry.w	M_SSR_GotAll	; "SONIC GOT THEM ALL" text

M_SSR_Chaos:	spriteHeader	; CHAOS EMERALDS
	spritePiece	-$70, -8, 2, 2, 8, 0, 0, 0, 0	; C
	spritePiece	-$60, -8, 2, 2, $1C, 0, 0, 0, 0	; H
	spritePiece	-$50, -8, 2, 2, 0, 0, 0, 0, 0	; A
	spritePiece	-$40, -8, 2, 2, $32, 0, 0, 0, 0	; O
	spritePiece	-$30, -8, 2, 2, $3E, 0, 0, 0, 0	; S

	spritePiece	-$10, -8, 2, 2, $10, 0, 0, 0, 0	; E
	spritePiece	0, -8, 2, 2, $2A, 0, 0, 0, 0	; M
	spritePiece	$10, -8, 2, 2, $10, 0, 0, 0, 0	; E
	spritePiece	$20, -8, 2, 2, $3A, 0, 0, 0, 0	; R
	spritePiece	$30, -8, 2, 2, 0, 0, 0, 0, 0	; A
	spritePiece	$40, -8, 2, 2, $26, 0, 0, 0, 0	; L
	spritePiece	$50, -8, 2, 2, $C, 0, 0, 0, 0	; D
	spritePiece	$60, -8, 2, 2, $3E, 0, 0, 0, 0	; S
M_SSR_Chaos_End

M_SSR_Score:	spriteHeader	; Score tally
	spritePiece	-$50, -8, 4, 2, $14A, 0, 0, 0, 0; "SCOR"
	spritePiece	-$30, -8, 1, 2, $162, 0, 0, 0, 0; "E"
	spritePiece	$18, -8, 3, 2, $164, 0, 0, 0, 0	; Tally (first four digits)
	spritePiece	$30, -8, 4, 2, $16A, 0, 0, 0, 0	; Tally (second four digits)
	spritePiece	-$33, -9, 2, 1, $6E, 0, 0, 0, 0	; Small oval (upper half)
	spritePiece	-$33, -1, 2, 1, $6E, 1, 1, 0, 0	; Small oval (lower half)
M_SSR_Score_End

M_SSR_Ring:	spriteHeader	; Ring Bonus tally
	spritePiece	-$50, -8, 4, 2, $152, 0, 0, 0, 0; "RING"
	spritePiece	-$27, -8, 4, 2, $66, 0, 0, 0, 0	; "BONU"
	spritePiece	-7, -8, 1, 2, $14A, 0, 0, 0, 0	; "S"
	spritePiece	-$A, -9, 2, 1, $6E, 0, 0, 0, 0	; Small oval (upper half)
	spritePiece	-$A, -1, 2, 1, $6E, 1, 1, 0, 0	; Small oval (lower half)
	spritePiece	$28, -8, 4, 2, -8, 0, 0, 0, 0	; Tally (first four digits)
	spritePiece	$48, -8, 1, 2, $170, 0, 0, 0, 0	; Tally (second four digits)
M_SSR_Ring_End

M_SSR_Oval:	spriteHeader	; Blue oval
	spritePiece	-$C, -$1C, 4, 1, $70, 0, 0, 0, 0
	spritePiece	$14, -$1C, 1, 3, $74, 0, 0, 0, 0
	spritePiece	-$14, -$14, 2, 1, $77, 0, 0, 0, 0
	spritePiece	-$1C, -$C, 2, 2, $79, 0, 0, 0, 0
	spritePiece	-$14, $14, 4, 1, $70, 1, 1, 0, 0
	spritePiece	-$1C, 4, 1, 3, $74, 1, 1, 0, 0
	spritePiece	4, $C, 2, 1, $77, 1, 1, 0, 0
	spritePiece	$C, -4, 2, 2, $79, 1, 01, 0, 0
	spritePiece	-4, -$14, 3, 1, $7D, 0, 0, 0, 0
	spritePiece	-$C, -$C, 4, 1, $7C, 0, 0, 0, 0
	spritePiece	-$C, -4, 3, 1, $7C, 0, 0, 0, 0
	spritePiece	-$14, 4, 4, 1, $7C, 0, 0, 0, 0
	spritePiece	-$14, $C, 3, 1, $7C, 0, 0, 0, 0
M_SSR_Oval_End

M_SSR_ContSon1:	spriteHeader	; Continue tally with mini Sonic (foot down)
	spritePiece	-$50, -8, 4, 2, -$2F, 0, 0, 0, 0; "CONT"
	spritePiece	-$30, -8, 4, 2, -$27, 0, 0, 0, 0; "INUE" and small oval (left half)
	spritePiece	-$10, -8, 1, 2, -$1F, 0, 0, 0, 0; Small oval (right half)
	spritePiece	$40, -8, 2, 3, -$1D, 0, 0, 1, 0	; Mini Sonic (foot down)
M_SSR_ContSon1_End

M_SSR_ContSon2:	spriteHeader	; Continue tally with mini Sonic (foot up)
	spritePiece	-$50, -8, 4, 2, -$2F, 0, 0, 0, 0; "CONT"
	spritePiece	-$30, -8, 4, 2, -$27, 0, 0, 0, 0; "INUE" and small oval (left half)
	spritePiece	-$10, -8, 1, 2, -$1F, 0, 0, 0, 0; Small oval (right half)
	spritePiece	$40, -8, 2, 3, -$17, 0, 0, 1, 0	; Mini Sonic (foot up)
M_SSR_ContSon2_End

M_SSR_Continue:	spriteHeader	; Continue tally without mini Sonic
	spritePiece	-$50, -8, 4, 2, -$2F, 0, 0, 0, 0; "CONT"
	spritePiece	-$30, -8, 4, 2, -$27, 0, 0, 0, 0; "INUE" and small oval (left half)
	spritePiece	-$10, -8, 1, 2, -$1F, 0, 0, 0, 0; Small oval (right half)
M_SSR_Continue_End

M_SSR_SpeStage:	spriteHeader	; SPECIAL STAGE
	spritePiece	-$64, -8, 2, 2, $3E, 0, 0, 0, 0	; S
	spritePiece	-$54, -8, 2, 2, $36, 0, 0, 0, 0	; P
	spritePiece	-$44, -8, 2, 2, $10, 0, 0, 0, 0	; E
	spritePiece	-$34, -8, 2, 2, 8, 0, 0, 0, 0	; C
	spritePiece	-$24, -8, 1, 2, $20, 0, 0, 0, 0	; I
	spritePiece	-$1C, -8, 2, 2, 0, 0, 0, 0, 0	; A
	spritePiece	-$C, -8, 2, 2, $26, 0, 0, 0, 0	; L

	spritePiece	$14, -8, 2, 2, $3E, 0, 0, 0, 0	; S
	spritePiece	$24, -8, 2, 2, $42, 0, 0, 0, 0	; T
	spritePiece	$34, -8, 2, 2, 0, 0, 0, 0, 0	; A
	spritePiece	$44, -8, 2, 2, $18, 0, 0, 0, 0	; G
	spritePiece	$54, -8, 2, 2, $10, 0, 0, 0, 0	; E
M_SSR_SpeStage_End

M_SSR_GotAll:	spriteHeader	; SONIC GOT THEM ALL
	spritePiece	-$78, -8, 2, 2, $3E, 0, 0, 0, 0	; S
	spritePiece	-$68, -8, 2, 2, $32, 0, 0, 0, 0	; O
	spritePiece	-$58, -8, 2, 2, $2E, 0, 0, 0, 0	; N
	spritePiece	-$48, -8, 1, 2, $20, 0, 0, 0, 0	; I
	spritePiece	-$40, -8, 2, 2, 8, 0, 0, 0, 0	; C

	spritePiece	-$28, -8, 2, 2, $18, 0, 0, 0, 0	; G
	spritePiece	-$18, -8, 2, 2, $32, 0, 0, 0, 0	; O
	spritePiece	-8, -8, 2, 2, $42, 0, 0, 0, 0	; T

	spritePiece	$10, -8, 2, 2, $42, 0, 0, 0, 0	; T
	spritePiece	$20, -8, 2, 2, $1C, 0, 0, 0, 0	; H
	spritePiece	$30, -8, 2, 2, $10, 0, 0, 0, 0	; E
	spritePiece	$40, -8, 2, 2, $2A, 0, 0, 0, 0	; M

	spritePiece	$58, -8, 2, 2, 0, 0, 0, 0, 0	; A
	spritePiece	$68, -8, 2, 2, $26, 0, 0, 0, 0	; L
	spritePiece	$78, -8, 2, 2, $26, 0, 0, 0, 0	; L
M_SSR_GotAll_End
	even
