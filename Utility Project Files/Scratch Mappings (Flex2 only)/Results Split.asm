Map_Got:	mappingsTable
	mappingsTableEntry.w	M_Got_SonicHas	; "SONIC HAS" text
	mappingsTableEntry.w	M_Got_Passed	; "PASSED" text
	mappingsTableEntry.w	M_Got_Score	; Score tally
	mappingsTableEntry.w	M_Got_TBonus	; Time Bonus tally
	mappingsTableEntry.w	M_Got_RBonus	; Ring Bonus tally
	mappingsTableEntry.w	M_Got_Oval	; Blue oval
	mappingsTableEntry.w	M_Got_Act1	; Act number 1
	mappingsTableEntry.w	M_Got_Act2	; Act number 2
	mappingsTableEntry.w	M_Got_Act3	; Act number 3

M_Got_SonicHas:	spriteHeader	; SONIC HAS
	spritePiece	-$48, -8, 2, 2, $3E, 0, 0, 0, 0	; S
	spritePiece	-$38, -8, 2, 2, $32, 0, 0, 0, 0	; O
	spritePiece	-$28, -8, 2, 2, $2E, 0, 0, 0, 0	; N
	spritePiece	-$18, -8, 1, 2, $20, 0, 0, 0, 0	; I
	spritePiece	-$10, -8, 2, 2, 8, 0, 0, 0, 0	; C

	spritePiece	$10, -8, 2, 2, $1C, 0, 0, 0, 0	; H
	spritePiece	$20, -8, 2, 2, 0, 0, 0, 0, 0	; A
	spritePiece	$30, -8, 2, 2, $3E, 0, 0, 0, 0	; S
M_Got_SonicHas_End

M_Got_Passed:	spriteHeader	; PASSED
	spritePiece	-$30, -8, 2, 2, $36, 0, 0, 0, 0	; P
	spritePiece	-$20, -8, 2, 2, 0, 0, 0, 0, 0	; A
	spritePiece	-$10, -8, 2, 2, $3E, 0, 0, 0, 0	; S
	spritePiece	0, -8, 2, 2, $3E, 0, 0, 0, 0	; S
	spritePiece	$10, -8, 2, 2, $10, 0, 0, 0, 0	; E
	spritePiece	$20, -8, 2, 2, $C, 0, 0, 0, 0	; D
M_Got_Passed_End

M_Got_Score:	spriteHeader	; Score tally
	spritePiece	-$50, -8, 4, 2, $14A, 0, 0, 0, 0; "SCOR"
	spritePiece	-$30, -8, 1, 2, $162, 0, 0, 0, 0; "E"
	spritePiece	$18, -8, 3, 2, $164, 0, 0, 0, 0	; Tally (first four digits)
	spritePiece	$30, -8, 4, 2, $16A, 0, 0, 0, 0	; Tally (second four digits)
	spritePiece	-$33, -9, 2, 1, $6E, 0, 0, 0, 0	; Small oval (upper half)
	spritePiece	-$33, -1, 2, 1, $6E, 1, 1, 0, 0	; Small oval (lower half)
M_Got_Score_End

M_Got_TBonus:	spriteHeader	; Time Bonus tally
	spritePiece	-$50, -8, 4, 2, $15A, 0, 0, 0, 0; "TIME"
	spritePiece	-$27, -8, 4, 2, $66, 0, 0, 0, 0	; "BONU"
	spritePiece	-7, -8, 1, 2, $14A, 0, 0, 0, 0	; "S"
	spritePiece	-$A, -9, 2, 1, $6E, 0, 0, 0, 0	; Small oval (upper half)
	spritePiece	-$A, -1, 2, 1, $6E, 1, 1, 0, 0	; Small oval (lower half)
	spritePiece	$28, -8, 4, 2, -$10, 0, 0, 0, 0	; Tally (first four digits)
	spritePiece	$48, -8, 1, 2, $170, 0, 0, 0, 0	; Tally (second four digits)
M_Got_TBonus_End

M_Got_RBonus:	spriteHeader	; Ring Bonus tally
	spritePiece	-$50, -8, 4, 2, $152, 0, 0, 0, 0; "RING"
	spritePiece	-$27, -8, 4, 2, $66, 0, 0, 0, 0	; "BONU"
	spritePiece	-7, -8, 1, 2, $14A, 0, 0, 0, 0	; "S"
	spritePiece	-$A, -9, 2, 1, $6E, 0, 0, 0, 0	; Small oval (upper half)
	spritePiece	-$A, -1, 2, 1, $6E, 1, 1, 0, 0	; Small oval (lower half)
	spritePiece	$28, -8, 4, 2, -8, 0, 0, 0, 0	; Tally (first four digits)
	spritePiece	$48, -8, 1, 2, $170, 0, 0, 0, 0	; Tally (second four digits)
M_Got_RBonus_End

M_Got_Oval:	spriteHeader	; Blue oval
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
M_Got_Oval_End

M_Got_Act1:	spriteHeader	; Act number 1
	spritePiece	-$14, 4, 4, 1, $53, 0, 0, 0, 0	; "ACT"
	spritePiece	$C, -$C, 1, 3, $57, 0, 0, 0, 0	; 1
M_Got_Act1_End

M_Got_Act2:	spriteHeader	; Act number 2
	spritePiece	-$14, 4, 4, 1, $53, 0, 0, 0, 0	; "ACT"
	spritePiece	8, -$C, 2, 3, $5A, 0, 0, 0, 0	; 2
M_Got_Act2_End

M_Got_Act3:	spriteHeader	; Act number 3
	spritePiece	-$14, 4, 4, 1, $53, 0, 0, 0, 0	; "ACT"
	spritePiece	8, -$C, 2, 3, $60, 0, 0, 0, 0	; 3
M_Got_Act3_End
	even