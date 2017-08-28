; ---------------------------------------------------------------------------
; Sprite mappings - "SONIC TEAM	PRESENTS" and credits
; ---------------------------------------------------------------------------
Map_Cred_internal:
		dc.w .staff-Map_Cred_internal
		dc.w .gameplan-Map_Cred_internal
		dc.w .program-Map_Cred_internal
		dc.w .character-Map_Cred_internal
		dc.w .design-Map_Cred_internal
		dc.w .soundproduce-Map_Cred_internal
		dc.w .soundprogram-Map_Cred_internal
		dc.w .thanks-Map_Cred_internal
		dc.w .presentedby-Map_Cred_internal
		dc.w .tryagain-Map_Cred_internal
		dc.w .sonicteam-Map_Cred_internal
.staff:		dc.b $E			 ; SONIC TEAM STAFF
		dc.b $F8, 5, 0,	$2E, $88
		dc.b $F8, 5, 0,	$26, $98
		dc.b $F8, 5, 0,	$1A, $A8
		dc.b $F8, 1, 0,	$46, $B8
		dc.b $F8, 5, 0,	$1E, $C0
		dc.b $F8, 5, 0,	$3E, $D8
		dc.b $F8, 5, 0,	$E, $E8
		dc.b $F8, 5, 0,	4, $F8
		dc.b $F8, 9, 0,	8, 8
		dc.b $F8, 5, 0,	$2E, $28
		dc.b $F8, 5, 0,	$3E, $38
		dc.b $F8, 5, 0,	4, $48
		dc.b $F8, 5, 0,	$5C, $58
		dc.b $F8, 5, 0,	$5C, $68
.gameplan:	dc.b $10		; GAME PLAN CAROL YAS
		dc.b $D8, 5, 0,	0, $80
		dc.b $D8, 5, 0,	4, $90
		dc.b $D8, 9, 0,	8, $A0
		dc.b $D8, 5, 0,	$E, $B4
		dc.b $D8, 5, 0,	$12, $D0
		dc.b $D8, 5, 0,	$16, $E0
		dc.b $D8, 5, 0,	4, $F0
		dc.b $D8, 5, 0,	$1A, 0
		dc.b 8,	5, 0, $1E, $C8
		dc.b 8,	5, 0, 4, $D8
		dc.b 8,	5, 0, $22, $E8
		dc.b 8,	5, 0, $26, $F8
		dc.b 8,	5, 0, $16, 8
		dc.b 8,	5, 0, $2A, $20
		dc.b 8,	5, 0, 4, $30
		dc.b 8,	5, 0, $2E, $44
.program:	dc.b $A			 ; PROGRAM YU 2
		dc.b $D8, 5, 0,	$12, $80
		dc.b $D8, 5, 0,	$22, $90
		dc.b $D8, 5, 0,	$26, $A0
		dc.b $D8, 5, 0,	0, $B0
		dc.b $D8, 5, 0,	$22, $C0
		dc.b $D8, 5, 0,	4, $D0
		dc.b $D8, 9, 0,	8, $E0
		dc.b 8,	5, 0, $2A, $E8
		dc.b 8,	5, 0, $32, $F8
		dc.b 8,	5, 0, $36, 8
.character:	dc.b $18		 ; CHARACTER DESIGN BIGISLAND
		dc.b $D8, 5, 0,	$1E, $88
		dc.b $D8, 5, 0,	$3A, $98
		dc.b $D8, 5, 0,	4, $A8
		dc.b $D8, 5, 0,	$22, $B8
		dc.b $D8, 5, 0,	4, $C8
		dc.b $D8, 5, 0,	$1E, $D8
		dc.b $D8, 5, 0,	$3E, $E8
		dc.b $D8, 5, 0,	$E, $F8
		dc.b $D8, 5, 0,	$22, 8
		dc.b $D8, 5, 0,	$42, $20
		dc.b $D8, 5, 0,	$E, $30
		dc.b $D8, 5, 0,	$2E, $40
		dc.b $D8, 1, 0,	$46, $50
		dc.b $D8, 5, 0,	0, $58
		dc.b $D8, 5, 0,	$1A, $68
		dc.b 8,	5, 0, $48, $C0
		dc.b 8,	1, 0, $46, $D0
		dc.b 8,	5, 0, 0, $D8
		dc.b 8,	1, 0, $46, $E8
		dc.b 8,	5, 0, $2E, $F0
		dc.b 8,	5, 0, $16, 0
		dc.b 8,	5, 0, 4, $10
		dc.b 8,	5, 0, $1A, $20
		dc.b 8,	5, 0, $42, $30
.design:	dc.b $14		 ; DESIGN JINYA	PHENIX RIE
		dc.b $D0, 5, 0,	$42, $A0
		dc.b $D0, 5, 0,	$E, $B0
		dc.b $D0, 5, 0,	$2E, $C0
		dc.b $D0, 1, 0,	$46, $D0
		dc.b $D0, 5, 0,	0, $D8
		dc.b $D0, 5, 0,	$1A, $E8
		dc.b 0,	5, 0, $4C, $E8
		dc.b 0,	1, 0, $46, $F8
		dc.b 0,	5, 0, $1A, 4
		dc.b 0,	5, 0, $2A, $14
		dc.b 0,	5, 0, 4, $24
		dc.b $20, 5, 0,	$12, $D0
		dc.b $20, 5, 0,	$3A, $E0
		dc.b $20, 5, 0,	$E, $F0
		dc.b $20, 5, 0,	$1A, 0
		dc.b $20, 1, 0,	$46, $10
		dc.b $20, 5, 0,	$50, $18
		dc.b $20, 5, 0,	$22, $30
		dc.b $20, 1, 0,	$46, $40
		dc.b $20, 5, 0,	$E, $48
.soundproduce:	dc.b $1A		 ; SOUND PRODUCE MASATO	NAKAMURA
		dc.b $D8, 5, 0,	$2E, $98
		dc.b $D8, 5, 0,	$26, $A8
		dc.b $D8, 5, 0,	$32, $B8
		dc.b $D8, 5, 0,	$1A, $C8
		dc.b $D8, 5, 0,	$54, $D8
		dc.b $D8, 5, 0,	$12, $F8
		dc.b $D8, 5, 0,	$22, 8
		dc.b $D8, 5, 0,	$26, $18
		dc.b $D8, 5, 0,	$42, $28
		dc.b $D8, 5, 0,	$32, $38
		dc.b $D8, 5, 0,	$1E, $48
		dc.b $D8, 5, 0,	$E, $58
		dc.b 8,	9, 0, 8, $88
		dc.b 8,	5, 0, 4, $9C
		dc.b 8,	5, 0, $2E, $AC
		dc.b 8,	5, 0, 4, $BC
		dc.b 8,	5, 0, $3E, $CC
		dc.b 8,	5, 0, $26, $DC
		dc.b 8,	5, 0, $1A, $F8
		dc.b 8,	5, 0, 4, 8
		dc.b 8,	5, 0, $58, $18
		dc.b 8,	5, 0, 4, $28
		dc.b 8,	9, 0, 8, $38
		dc.b 8,	5, 0, $32, $4C
		dc.b 8,	5, 0, $22, $5C
		dc.b 8,	5, 0, 4, $6C
.soundprogram:	dc.b $17		 ; SOUND PROGRAM JIMITA	MACKY
		dc.b $D0, 5, 0,	$2E, $98
		dc.b $D0, 5, 0,	$26, $A8
		dc.b $D0, 5, 0,	$32, $B8
		dc.b $D0, 5, 0,	$1A, $C8
		dc.b $D0, 5, 0,	$54, $D8
		dc.b $D0, 5, 0,	$12, $F8
		dc.b $D0, 5, 0,	$22, 8
		dc.b $D0, 5, 0,	$26, $18
		dc.b $D0, 5, 0,	0, $28
		dc.b $D0, 5, 0,	$22, $38
		dc.b $D0, 5, 0,	4, $48
		dc.b $D0, 9, 0,	8, $58
		dc.b 0,	5, 0, $4C, $D0
		dc.b 0,	1, 0, $46, $E0
		dc.b 0,	9, 0, 8, $E8
		dc.b 0,	1, 0, $46, $FC
		dc.b 0,	5, 0, $3E, 4
		dc.b 0,	5, 0, 4, $14
		dc.b $20, 9, 0,	8, $D0
		dc.b $20, 5, 0,	4, $E4
		dc.b $20, 5, 0,	$1E, $F4
		dc.b $20, 5, 0,	$58, 4
		dc.b $20, 5, 0,	$2A, $14
.thanks:	dc.b $1F		 ; SPECIAL THANKS FUJIO	MINEGISHI PAPA
		dc.b $D8, 5, 0,	$2E, $80
		dc.b $D8, 5, 0,	$12, $90
		dc.b $D8, 5, 0,	$E, $A0
		dc.b $D8, 5, 0,	$1E, $B0
		dc.b $D8, 1, 0,	$46, $C0
		dc.b $D8, 5, 0,	4, $C8
		dc.b $D8, 5, 0,	$16, $D8
		dc.b $D8, 5, 0,	$3E, $F8
		dc.b $D8, 5, 0,	$3A, 8
		dc.b $D8, 5, 0,	4, $18
		dc.b $D8, 5, 0,	$1A, $28
		dc.b $D8, 5, 0,	$58, $38
		dc.b $D8, 5, 0,	$2E, $48
		dc.b 0,	5, 0, $5C, $B0
		dc.b 0,	5, 0, $32, $C0
		dc.b 0,	5, 0, $4C, $D0
		dc.b 0,	1, 0, $46, $E0
		dc.b 0,	5, 0, $26, $E8
		dc.b 0,	9, 0, 8, 0
		dc.b 0,	1, 0, $46, $14
		dc.b 0,	5, 0, $1A, $1C
		dc.b 0,	5, 0, $E, $2C
		dc.b 0,	5, 0, 0, $3C
		dc.b 0,	1, 0, $46, $4C
		dc.b 0,	5, 0, $2E, $54
		dc.b 0,	5, 0, $3A, $64
		dc.b 0,	1, 0, $46, $74
		dc.b $20, 5, 0,	$12, $F8
		dc.b $20, 5, 0,	4, 8
		dc.b $20, 5, 0,	$12, $18
		dc.b $20, 5, 0,	4, $28
.presentedby:	dc.b $F			 ; PRESENTED BY	SEGA
		dc.b $F8, 5, 0,	$12, $80
		dc.b $F8, 5, 0,	$22, $90
		dc.b $F8, 5, 0,	$E, $A0
		dc.b $F8, 5, 0,	$2E, $B0
		dc.b $F8, 5, 0,	$E, $C0
		dc.b $F8, 5, 0,	$1A, $D0
		dc.b $F8, 5, 0,	$3E, $E0
		dc.b $F8, 5, 0,	$E, $F0
		dc.b $F8, 5, 0,	$42, 0
		dc.b $F8, 5, 0,	$48, $18
		dc.b $F8, 5, 0,	$2A, $28
		dc.b $F8, 5, 0,	$2E, $40
		dc.b $F8, 5, 0,	$E, $50
		dc.b $F8, 5, 0,	0, $60
		dc.b $F8, 5, 0,	4, $70
.tryagain:	dc.b 8			 ; TRY AGAIN
		dc.b $30, 5, 0,	$3E, $C0
		dc.b $30, 5, 0,	$22, $D0
		dc.b $30, 5, 0,	$2A, $E0
		dc.b $30, 5, 0,	4, $F8
		dc.b $30, 5, 0,	0, 8
		dc.b $30, 5, 0,	4, $18
		dc.b $30, 1, 0,	$46, $28
		dc.b $30, 5, 0,	$1A, $30
.sonicteam:	dc.b $11		 ; SONIC TEAM PRESENTS
		dc.b $E8, 5, 0,	$2E, $B4
		dc.b $E8, 5, 0,	$26, $C4
		dc.b $E8, 5, 0,	$1A, $D4
		dc.b $E8, 1, 0,	$46, $E4
		dc.b $E8, 5, 0,	$1E, $EC
		dc.b $E8, 5, 0,	$3E, 4
		dc.b $E8, 5, 0,	$E, $14
		dc.b $E8, 5, 0,	4, $24
		dc.b $E8, 9, 0,	8, $34
		dc.b 0,	5, 0, $12, $C0
		dc.b 0,	5, 0, $22, $D0
		dc.b 0,	5, 0, $E, $E0
		dc.b 0,	5, 0, $2E, $F0
		dc.b 0,	5, 0, $E, 0
		dc.b 0,	5, 0, $1A, $10
		dc.b 0,	5, 0, $3E, $20
		dc.b 0,	5, 0, $2E, $30
		even