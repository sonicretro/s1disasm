Mus85_SYZ_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Mus85_SYZ_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $03

	smpsHeaderDAC       Mus85_SYZ_DAC
	smpsHeaderFM        Mus85_SYZ_FM1,	$F4, $11
	smpsHeaderFM        Mus85_SYZ_FM2,	$E8, $0B
	smpsHeaderFM        Mus85_SYZ_FM3,	$F4, $14
	smpsHeaderFM        Mus85_SYZ_FM4,	$F4, $18
	smpsHeaderFM        Mus85_SYZ_FM5,	$F4, $18
	smpsHeaderPSG       Mus85_SYZ_PSG1,	$D0, $06, $00, fTone_06
	smpsHeaderPSG       Mus85_SYZ_PSG2,	$E8, $07, $00, $00
	smpsHeaderPSG       Mus85_SYZ_PSG3,	$00, $05, $00, fTone_04

; FM1 Data
Mus85_SYZ_FM1:
	dc.b	nRst, $2A

Mus85_SYZ_Jump02:
	smpsSetvoice        $00
	smpsModSet          $08, $01, $06, $04
	smpsCall            Mus85_SYZ_Call08
	dc.b	nD6, $0A, nF6, $2C
	smpsCall            Mus85_SYZ_Call08
	dc.b	nD6, nF6, $02, nRst, $04, nF6, $02, nRst, $04, nG6, $04, nF6
	dc.b	$02, nG6, $04, nRst, $02, nA6, $06
	smpsWeirdD1LRR
	dc.b	nRst, $12
	smpsSetvoice        $04
	smpsModOff
	smpsAlterVol        $08
	smpsCall            Mus85_SYZ_Call09
	smpsCall            Mus85_SYZ_Call0A
	dc.b	nA5, $08, nC6, $0C, nG6, $0A, nA6, $02, nRst, $04, nA6, $02
	dc.b	nG6, $03, nRst, nF6, $0C
	smpsCall            Mus85_SYZ_Call09
	dc.b	nRst, $06, nE6, $02, nRst, $04, nE6, $0C, nF6, nE6, $0A, nD6
	dc.b	$02, nRst, $2A
	smpsAlterVol        $F8
	smpsJump            Mus85_SYZ_Jump02

Mus85_SYZ_Call08:
	dc.b	nRst, $04, nE6, $02, nRst, $04, nE6, $08, nC6, $02, nRst, $04
	dc.b	nA5, $02, nRst, $04, nE6, $0A, nC6, $02, nRst, $0C, nRst, $2E
	dc.b	nFs6, $02, nRst, $04, nFs6, $08, nD6, $02, nRst, $04, nB5, $02
	dc.b	nRst, $04, nFs6, $0C
	smpsReturn

Mus85_SYZ_Call09:
	smpsCall            Mus85_SYZ_Call0A
	dc.b	nA5, nRst, $02, nBb5, nRst, $04, nBb5, $08, nC6, $03, nRst, nBb5
	dc.b	nRst, nA5, $04, nBb5, nRst, $02, nC6, $0E
	smpsReturn

Mus85_SYZ_Call0A:
	dc.b	nRst, $04, nF6, $08, nE6, $03, nRst, nD6, nRst, nC6, nRst, nD6
	dc.b	nRst, nC6, $04
	smpsReturn

; FM2 Data
Mus85_SYZ_FM2:
	smpsSetvoice        $01
	smpsAlterVol        $FE
	smpsNop             $01
	dc.b	nA4, $03, nRst, nA4, nRst, nG4, nRst, nG4, nRst, nF4, nRst, nF4
	dc.b	nRst, nE4, nRst, nE4, $02, nRst, nD4
	smpsAlterVol        $02

Mus85_SYZ_Jump01:
	smpsCall            Mus85_SYZ_Call06
	dc.b	nBb4, nRst, $02, nA4, nRst, $04, nA4, $08, nG4, $03, nRst, nG4
	dc.b	nRst, nF4, nRst, nF4, nRst, nE4, $0A, nD4, $02
	smpsCall            Mus85_SYZ_Call06
	dc.b	nBb4, $08, nA4, $03, nRst, nA4, nRst, nA4, nRst, nA4, nRst, nA4
	dc.b	nRst, $13, nBb4, $02

Mus85_SYZ_Loop04:
	smpsCall            Mus85_SYZ_Call07
	dc.b	nBb4
	smpsLoop            $00, $02, Mus85_SYZ_Loop04
	smpsCall            Mus85_SYZ_Call07
	dc.b	nE4, nRst, $04, nE4, $08, nE4, $03, nRst, nE4, nRst, nA4, $09
	dc.b	nRst, $03, nA4, $0A, nD4, $02, nRst, $2E, nD4, $02
	smpsNop             $01
	smpsJump            Mus85_SYZ_Jump01

Mus85_SYZ_Call06:
	dc.b	nRst, $04, nD4, $08, nE4, $03, nRst, nD4, nRst, nE4, nRst, nD4
	dc.b	nRst, nF4, $04, nA4, nRst, $02, nA4, nRst, $04, nE5, $08, nC5
	dc.b	$03, nRst, nC5, nRst, nA4, nRst, nA4, nRst, nF4, $0A, nE4, $02
	dc.b	nRst, $04, nE4, $08, nFs4, $03, nRst, nE4, nRst, nFs4, nRst, nE4
	dc.b	nRst, nG4, $04
	smpsReturn

Mus85_SYZ_Call07:
	dc.b	nRst, $04, nBb4, $08, nC5, $03, nRst, nBb4, nRst, nA4, $06, nRst
	dc.b	nBb4, $04, nA4, nRst, $02, nG4, nRst, $04, nG4, $08, nA4, $03
	dc.b	nRst, nG4, nRst, nF4, nRst, nF4, nRst, nG4, $04, nA4, nRst, $02
	smpsReturn

; FM3 Data
Mus85_SYZ_FM3:
	dc.b	nRst, $30
	smpsSetvoice        $05
	smpsCall            Mus85_SYZ_Call04
	dc.b	nRst, $06, nA6, $02, nRst, $0A, nG6, $02, nRst, $0A, nF6, $02
	dc.b	nRst, $04, nE6, $02, nRst, nF6, nE6, nRst, $04
	smpsCall            Mus85_SYZ_Call04
	dc.b	nA5, $02, nRst, nA5, nCs6, nRst, nCs6, nE6, nRst, nE6, nG6, nRst
	dc.b	nG6, nA6, nRst, $10, nRst, $04, nF5, $02
	smpsCall            Mus85_SYZ_Call05
	dc.b	nRst, $13, nF5, $02
	smpsCall            Mus85_SYZ_Call05
	dc.b	nRst, nC5, nRst, nD5, $04, nE5, nRst, $02, nF5
	smpsCall            Mus85_SYZ_Call05
	dc.b	nRst, $15, nRst, $04, nA6, $08, nG6, $03, nRst, nG6, nRst, nF6
	dc.b	nRst, nF6, nRst, nE6, $04, nF6, $02, nE6, $04, nD6, $02
	smpsJump            Mus85_SYZ_FM3

Mus85_SYZ_Call04:
	dc.b	nRst, $36, nA5, $04, nC6, $02, nD6, $04, nF6, $02, nRst, $06
	dc.b	nA5, $04, nC6, $02, nD6, $04, nF6, $02, nRst, $3C
	smpsReturn

Mus85_SYZ_Call05:
	dc.b	nRst, $04, nF5, $08, nF5, $03, nRst, nF5, nRst, nE5, nRst, $13
	dc.b	nD5, $02, nRst, $04, nD5, $08, nD5, $03, nRst, nD5, nRst, nC5
	smpsReturn

; FM4 Data
Mus85_SYZ_FM4:
	smpsPan             panLeft, $00
	smpsAlterNote       $03
	smpsCall            Mus85_SYZ_Call01
	smpsAlterNote       $00

Mus85_SYZ_Jump00:
	smpsModSet          $01, $01, $01, $04
	smpsSetvoice        $02
	smpsCall            Mus85_SYZ_Call02
	smpsAlterVol        $FC
	dc.b	nD6, $02
	smpsCall            Mus85_SYZ_Call03
	smpsAlterVol        $04
	smpsJump            Mus85_SYZ_Jump00

Mus85_SYZ_Call02:
	smpsCall            Mus85_SYZ_Call0D
	dc.b	nA6, $30
	smpsCall            Mus85_SYZ_Call0D
	dc.b	nCs7, $03, nRst, nCs7, nRst, nCs7, nRst, nCs7, nRst, nCs7, $03, nRst
	dc.b	$13
	smpsReturn

Mus85_SYZ_Call0D:
	dc.b	nE6, $24, nF6, $06, nG6, nE6, $24, nC6, $06, nD6, nE6, $24
	dc.b	nF6, $06, nG6
	smpsReturn

Mus85_SYZ_Call03:
	smpsCall            Mus85_SYZ_Call0C
	dc.b	nRst, $13, nD6, $02
	smpsCall            Mus85_SYZ_Call0C
	dc.b	nRst, nA5, nRst, nBb5, $04, nC6, nRst, $02, nD6
	smpsCall            Mus85_SYZ_Call0C
	dc.b	nRst, $13, nA5, $0E, nCs6, $0C, nE6, nCs7, $0A, nD7, $02, nRst
	dc.b	$30
	smpsReturn

Mus85_SYZ_Call0C:
	dc.b	nRst, $04, nD6, $08, nD6, $03, nRst, nD6, nRst, nC6, nRst, nA6
	dc.b	nRst, nF6, nRst, $07, nBb5, $02, nRst, $04, nBb5, $08, nBb5, $03
	dc.b	nRst, nBb5, nRst, nA5
	smpsReturn

Mus85_SYZ_Call01:
	smpsSetvoice        $03
	smpsAlterVol        $FE
	smpsCall            Mus85_SYZ_Call0B
	smpsAlterVol        $06
	smpsReturn

Mus85_SYZ_Call0B:
	smpsChanTempoDiv    $01
	dc.b	nBb3, $01, smpsNoAttack, nA3, $04, nRst, $07, nBb3, $01, smpsNoAttack, nA3, $04
	dc.b	nRst, $07, nC4, $01, smpsNoAttack, nB3, $04, nRst, $07, nC4, $01, smpsNoAttack
	dc.b	nB3, $04, nRst, $07, nCs4, $01, smpsNoAttack, nC4, $04, nRst, $07, nCs4
	dc.b	$01, smpsNoAttack, nC4, $04, nRst, $07, nD4, $01, smpsNoAttack, nCs4, $04, nRst
	dc.b	$07, nD4, $01, smpsNoAttack, nCs4, $04, nRst, $07
	smpsChanTempoDiv    $02
	smpsReturn

; FM5 Data
Mus85_SYZ_FM5:
	smpsPan             panRight, $00
	smpsCall            Mus85_SYZ_Call01
	smpsModSet          $02, $01, $02, $04
	smpsAlterNote       $02
	smpsJump            Mus85_SYZ_Jump00

; PSG1 Data
Mus85_SYZ_PSG1:
	smpsCall            Mus85_SYZ_Call0B

Mus85_SYZ_Jump04:
	smpsCall            Mus85_SYZ_Call02
	dc.b	nD6, $02
	smpsCall            Mus85_SYZ_Call03
	smpsJump            Mus85_SYZ_Jump04

; PSG2 Data
Mus85_SYZ_PSG2:
	smpsStop

; PSG3 Data
Mus85_SYZ_PSG3:
	smpsPSGform         $E7
	smpsNoteFill        $01
	smpsPSGAlterVol     $01

Mus85_SYZ_Loop05:
	dc.b	nRst, $04, nMaxPSG, $02
	smpsLoop            $00, $08, Mus85_SYZ_Loop05
	smpsPSGAlterVol     $FF

Mus85_SYZ_Jump03:
	dc.b	$02, nRst, nMaxPSG
	smpsJump            Mus85_SYZ_Jump03

; DAC Data
Mus85_SYZ_DAC:
	dc.b	dSnare, $06, $06, $06, $06, $06, $06, $04, $02, $04, dKick, $02

Mus85_SYZ_Loop00:
	smpsCall            Mus85_SYZ_Call00
	smpsLoop            $00, $03, Mus85_SYZ_Loop00
	dc.b	nRst, $04, dKick, $08, dSnare, $06, dKick, dKick, $06, dSnare, dSnare, dSnare
	dc.b	$04, dKick, $02

Mus85_SYZ_Loop01:
	smpsCall            Mus85_SYZ_Call00
	smpsLoop            $00, $02, Mus85_SYZ_Loop01
	dc.b	nRst, $04, dKick, $08, dSnare, $06, dKick, dKick, $0C, dSnare, dSnare, $06
	dc.b	$06, $06, $06, $10, $02, $04, dKick, $02

Mus85_SYZ_Loop02:
	smpsCall            Mus85_SYZ_Call00
	smpsLoop            $00, $03, Mus85_SYZ_Loop02
	dc.b	nRst, $04, dKick, $08, dSnare, $06, dKick, dKick, $06, dSnare, dSnare, dSnare
	dc.b	$04, dKick, $02

Mus85_SYZ_Loop03:
	smpsCall            Mus85_SYZ_Call00
	smpsLoop            $00, $03, Mus85_SYZ_Loop03
	dc.b	nRst, $0C, dSnare, $0A, dKick, $02, dSnare, $06, dSnare, dSnare, $06, $04
	dc.b	dKick, $02
	smpsJump            Mus85_SYZ_Loop00

Mus85_SYZ_Call00:
	dc.b	nRst, $04, dKick, $08, dSnare, $06, dKick, dKick, $0C, dSnare, $0A, dKick
	dc.b	$02
	smpsReturn

Mus85_SYZ_Voices:
;	Voice $00
;	$3C
;	$31, $52, $50, $30, 	$52, $53, $52, $53, 	$08, $00, $08, $00
;	$04, $00, $04, $00, 	$10, $07, $10, $07, 	$1A, $80, $16, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $05, $05, $03
	smpsVcCoarseFreq    $00, $00, $02, $01
	smpsVcRateScale     $01, $01, $01, $01
	smpsVcAttackRate    $13, $12, $13, $12
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $08, $00, $08
	smpsVcDecayRate2    $00, $04, $00, $04
	smpsVcDecayLevel    $00, $01, $00, $01
	smpsVcReleaseRate   $07, $00, $07, $00
	smpsVcTotalLevel    $00, $16, $00, $1A

;	Voice $01
;	$18
;	$37, $30, $30, $31, 	$9E, $DC, $1C, $9C, 	$0D, $06, $04, $01
;	$08, $0A, $03, $05, 	$BF, $BF, $3F, $2F, 	$32, $22, $14, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $03
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $01, $00, $00, $07
	smpsVcRateScale     $02, $00, $03, $02
	smpsVcAttackRate    $1C, $1C, $1C, $1E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $01, $04, $06, $0D
	smpsVcDecayRate2    $05, $03, $0A, $08
	smpsVcDecayLevel    $02, $03, $0B, $0B
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $14, $22, $32

;	Voice $02
;	$3D
;	$01, $02, $02, $02, 	$1F, $10, $10, $10, 	$07, $1F, $1F, $1F
;	$00, $00, $00, $00, 	$1F, $0F, $0F, $0F, 	$17, $8D, $8C, $8C
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $02, $02, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $10, $10, $10, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1F, $07
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $0C, $0C, $0D, $17

;	Voice $03
;	$2C
;	$74, $74, $34, $34, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$00, $01, $00, $01, 	$0F, $3F, $0F, $3F, 	$16, $80, $17, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $04, $04, $04, $04
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $01, $00, $01, $00
	smpsVcDecayLevel    $03, $00, $03, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $17, $00, $16

;	Voice $04
;	$04
;	$37, $72, $77, $49, 	$1F, $1F, $1F, $1F, 	$07, $0A, $07, $0D
;	$00, $00, $00, $00, 	$10, $07, $10, $07, 	$23, $80, $23, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $04, $07, $07, $03
	smpsVcCoarseFreq    $09, $07, $02, $07
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0D, $07, $0A, $07
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $00, $01
	smpsVcReleaseRate   $07, $00, $07, $00
	smpsVcTotalLevel    $00, $23, $00, $23

;	Voice $05
;	$3A
;	$01, $01, $01, $02, 	$8D, $07, $07, $52, 	$09, $00, $00, $03
;	$01, $02, $02, $00, 	$5F, $0F, $0F, $2F, 	$18, $22, $18, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $01, $01, $01
	smpsVcRateScale     $01, $00, $00, $02
	smpsVcAttackRate    $12, $07, $07, $0D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $00, $00, $09
	smpsVcDecayRate2    $00, $02, $02, $01
	smpsVcDecayLevel    $02, $00, $00, $05
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $18, $22, $18

