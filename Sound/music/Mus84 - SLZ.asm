Mus84_SLZ_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Mus84_SLZ_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $06

	smpsHeaderDAC       Mus84_SLZ_DAC
	smpsHeaderFM        Mus84_SLZ_FM1,	$E8, $00
	smpsHeaderFM        Mus84_SLZ_FM2,	$E8, $06
	smpsHeaderFM        Mus84_SLZ_FM3,	$DC, $1A
	smpsHeaderFM        Mus84_SLZ_FM4,	$DC, $1A
	smpsHeaderFM        Mus84_SLZ_FM5,	$F4, $20
	smpsHeaderPSG       Mus84_SLZ_PSG1,	$C4, $06, $00, fTone_05
	smpsHeaderPSG       Mus84_SLZ_PSG2,	$C4, $06, $00, fTone_05
	smpsHeaderPSG       Mus84_SLZ_PSG3,	$00, $04, $00, fTone_04

; FM1 Data
Mus84_SLZ_FM1:
	smpsSetvoice        $00
	dc.b	nRst, $0C, nG5, nA5, nG6

Mus84_SLZ_Jump05:
	smpsCall            Mus84_SLZ_Call00
	dc.b	nE6, $1E

Mus84_SLZ_Loop00:
	dc.b	nE7, $06, nC7, $3C, nRst, $1E
	smpsLoop            $00, $03, Mus84_SLZ_Loop00
	dc.b	nE7, $06, nC7, $18, nG5, $0C, nA5, nG6
	smpsJump            Mus84_SLZ_Jump05

Mus84_SLZ_Call00:
	smpsCall            Mus84_SLZ_Call0A
	dc.b	nE6, $1E, nF6, $06, nE6, nD6, $12, nG5, $0C, nA5, nG6
	smpsCall            Mus84_SLZ_Call0A
	smpsReturn

Mus84_SLZ_Call0A:
	dc.b	nE6, $2A, nE6, $03, nF6, nG6, $09, nA6, nBb6, $06, nA6, $0C
	dc.b	nG6, nF6, $1E, nF6, $06, nE6, nF6, $1E, nD6, $0C, nE6, nF6
	dc.b	$2A, nD6, $03, nE6, nF6, $09, nG6, nAb6, $06, nG6, $0C, nF6
	smpsReturn

; FM2 Data
Mus84_SLZ_FM2:
	smpsSetvoice        $01
	smpsNop             $01
	dc.b	nRst, $30

Mus84_SLZ_Jump04:
	smpsCall            Mus84_SLZ_Call07
	dc.b	nRst, $06, nB3, $02, nRst, $01, nB3, $02, nRst, $01, nC4, $06
	dc.b	nRst, $03, nC4, nRst, $06, nC4, $12, nRst, $06, nC4, $02, nRst
	dc.b	$01, nC4, $02, nRst, $01, nD4, $06, nRst, $03, nD4, nRst, $06
	dc.b	nG3, $12, nD4, $06, nG3
	smpsCall            Mus84_SLZ_Call07
	dc.b	nRst, $06, nD4, $02, nRst, $01, nB3, $02, nRst, $01
	smpsCall            Mus84_SLZ_Call08
	dc.b	nB3, $02, nRst, $01, nE4, $02, nRst, $01, nF4, $06, nRst, $03
	dc.b	nF4, nRst, $06, nF4, $12, nRst, $06, nG4, $02, nRst, $01, nF4
	dc.b	$02, nRst, $01
	smpsCall            Mus84_SLZ_Call08
	dc.b	nE4, $02, nRst, $01, nF4, $02, nRst, $01, nG4, $06, nRst, nG3
	dc.b	$24
	smpsNop             $01
	smpsJump            Mus84_SLZ_Jump04

Mus84_SLZ_Call07:
	dc.b	nC4, $06, nRst, $03, nC4, nRst, $06, nC4, $12, nRst, $06, nC4
	dc.b	$02, nRst, $01, nC4, $02, nRst, $01, nBb3, $06, nRst, $03, nBb3
	dc.b	$03, nRst, $06, nA3, $12, nRst, $06, nA3, $02, nRst, $01, nA3
	dc.b	$02, nRst, $01

Mus84_SLZ_Loop01:
	dc.b	nD4, $06, nRst, $03, nD4, $06, nRst, $03, nD4, $02, nRst, $01
	dc.b	nD4, $02, nRst, $01
	smpsAlterPitch      $FF
	smpsLoop            $00, $04, Mus84_SLZ_Loop01
	smpsAlterPitch      $04
	dc.b	nG3, $06, nRst, $03, nG3, nRst, $06, nG3, $12, nRst, $06, nG3
	dc.b	$02, nRst, $01, nG3, $02, nRst, $01, nB3, $06, nRst, $03, nB3
	dc.b	nRst, $06, nB3, $12
	smpsReturn

Mus84_SLZ_Call08:
	dc.b	nC4, $06, nRst, $03, nC4, nRst, $06, nC4, $12, nRst, $06, nG3
	dc.b	$02, nRst, $01, nC4, $02, nRst, $01, nD4, $06, nRst, $03, nD4
	dc.b	nRst, $06, nD4, $12, nRst, $06, nA3, $02, nRst, $01, nD4, $02
	dc.b	nRst, $01, nE4, $06, nRst, $03, nE4, nRst, $06, nE4, $12, nRst
	dc.b	$06
	smpsReturn

; FM3 Data
Mus84_SLZ_FM3:
	smpsSetvoice        $02
	smpsPan             panLeft, $00

; PSG1 Data
Mus84_SLZ_PSG1:
	dc.b	nRst, $30

Mus84_SLZ_Jump03:
	smpsCall            Mus84_SLZ_Call05
	dc.b	nG6, $06, nRst, $03, nG6, nRst, $06, nG6, $12, nRst, $06, nB6
	dc.b	$09, nRst, $03, nB6, nRst, nA6, $09, nRst, $03, nG6, nRst, nF6
	dc.b	$0C, nRst, $06
	smpsCall            Mus84_SLZ_Call05
	smpsCall            Mus84_SLZ_Call06
	smpsNoteFill        $08
	dc.b	nRst, $06, nE7, $09, $09, $09, nD7, $09, nC7, $06
	smpsCall            Mus84_SLZ_Call06
	smpsNoteFill        $00
	dc.b	nRst, $0C, nA6, $24
	smpsJump            Mus84_SLZ_Jump03

Mus84_SLZ_Call05:
	dc.b	nG6, $06, nRst, $03, nG6, nRst, $06, nG6, $18, nRst, $06, nF6
	dc.b	nRst, $03, nF6, nRst, $06, nE6, $18, nRst, $06, nA6, nRst, $03
	dc.b	nG6, $06, nRst, $03, nF6, nRst, nA6, $06, nRst, $03, nG6, $06
	dc.b	nRst, $03, nF6, nRst, nA6, $06, nRst, $03, nG6, $06, nRst, $03
	dc.b	nF6, $18, nRst, $06, nF6, nRst, $03, nF6, nRst, $06, nF6, $18
	dc.b	nRst, $06, nAb6, nRst, $03, nAb6, nRst, $06, nAb6, $18, nRst, $06
	smpsReturn

Mus84_SLZ_Call06:
	smpsNoteFill        $08
	dc.b	nRst, $06, nB6, $09, $09, $09, $09
	smpsNoteFill        $05
	dc.b	$03, $03
	smpsNoteFill        $08
	dc.b	nRst, $06, nC7, $09, $09, $09, $09
	smpsNoteFill        $05
	dc.b	$03, $03
	smpsNoteFill        $08
	dc.b	nRst, $06, nD7, $09, $09, $09, $09
	smpsNoteFill        $05
	dc.b	$03, $03
	smpsReturn

; FM4 Data
Mus84_SLZ_FM4:
	smpsSetvoice        $02
	smpsPan             panRight, $00

; PSG2 Data
Mus84_SLZ_PSG2:
	dc.b	nRst, $30

Mus84_SLZ_Jump02:
	smpsCall            Mus84_SLZ_Call03
	dc.b	nE6, $06, nRst, $03, nE6, nRst, $06, nE6, $12, nRst, $06, nG6
	dc.b	$09, nRst, $03, nG6, nRst, nF6, $09, nRst, $03, nE6, nRst, nD6
	dc.b	$0C, nRst, $06
	smpsCall            Mus84_SLZ_Call03
	smpsCall            Mus84_SLZ_Call04
	smpsNoteFill        $08
	dc.b	nRst, $06, nC7, $09, $09, $09, nB6, $09, nA6, $06
	smpsNoteFill        $08
	smpsCall            Mus84_SLZ_Call04
	smpsNoteFill        $00
	dc.b	nRst, $0C, nF6, $24
	smpsJump            Mus84_SLZ_Jump02

Mus84_SLZ_Call03:
	dc.b	nE6, $06, nRst, $03, nE6, nRst, $06, nE6, $18, nRst, $06, nD6
	dc.b	nRst, $03, nD6, nRst, $06, nCs6, $18, nRst, $06, nF6, nRst, $03
	dc.b	nE6, $06, nRst, $03, nD6, nRst, nF6, $06, nRst, $03, nE6, $06
	dc.b	nRst, $03, nD6, nRst, nF6, $06, nRst, $03, nE6, $06, nRst, $03
	dc.b	nD6, $18, nRst, $06, nD6, nRst, $03, nD6, nRst, $06, nD6, $18
	dc.b	nRst, $06, nF6, nRst, $03, nF6, nRst, $06, nF6, $18, nRst, $06
	smpsReturn

Mus84_SLZ_Call04:
	smpsNoteFill        $08
	dc.b	nRst, $06, nG6, $09, $09, $09, $09
	smpsNoteFill        $05
	dc.b	$03, $03
	smpsNoteFill        $08
	dc.b	nRst, $06, nA6, $09, $09, $09, $09
	smpsNoteFill        $05
	dc.b	$03, $03
	smpsNoteFill        $08
	dc.b	nRst, $06, nB6, $09, $09, $09, $09
	smpsNoteFill        $05
	dc.b	$03, $03
	smpsReturn

; FM5 Data
Mus84_SLZ_FM5:
	smpsSetvoice        $04
	dc.b	nRst, $0C, nG5, nA5, nG6

Mus84_SLZ_Jump01:
	smpsSetvoice        $04
	smpsCall            Mus84_SLZ_Call00
	dc.b	nE6, $06
	smpsSetvoice        $03
	smpsAlterVol        $EC
	smpsCall            Mus84_SLZ_Call01
	smpsAlterNote       $14
	dc.b	nA5, $01, smpsNoAttack
	smpsAlterNote       $00
	dc.b	nA5, $05
	smpsCall            Mus84_SLZ_Call02
	dc.b	nEb4
	smpsAlterVol        $07
	dc.b	nEb4
	smpsSetvoice        $03
	smpsAlterVol        $E8
	smpsAlterPitch      $CD
	dc.b	nRst, $06
	smpsAlterNote       $14
	dc.b	nE6, $01, smpsNoAttack
	smpsAlterNote       $00
	dc.b	nE6, $05, nF6, $06, nE6, nF6, nG6, nRst, nC6, nRst, $06
	smpsCall            Mus84_SLZ_Call01
	smpsNoteFill        $05
	dc.b	nA5, $03, $03
	smpsNoteFill        $00
	smpsCall            Mus84_SLZ_Call02
	smpsSetvoice        $03
	smpsAlterVol        $EF
	smpsAlterPitch      $CD
	dc.b	nE6, $03, nF6, nG6, $03, nRst, $09
	smpsAlterNote       $EC
	dc.b	nC7, $01, smpsNoAttack
	smpsAlterNote       $00
	smpsModSet          $2C, $01, $04, $04
	dc.b	nC7, $23
	smpsModOff
	smpsAlterVol        $14
	smpsJump            Mus84_SLZ_Jump01

Mus84_SLZ_Call01:
	smpsCall            Mus84_SLZ_Call09
	dc.b	nEb4
	smpsAlterVol        $07
	dc.b	nEb4
	smpsSetvoice        $03
	smpsAlterVol        $E8
	smpsAlterPitch      $CD
	dc.b	nRst, $06
	smpsAlterNote       $14
	dc.b	nE6, $01, smpsNoAttack
	smpsAlterNote       $00
	dc.b	$05, nRst, $06
	smpsAlterNote       $14
	dc.b	nC6, $01, smpsNoAttack
	smpsAlterNote       $00
	dc.b	$05, nRst, $06
	smpsReturn

Mus84_SLZ_Call02:
	dc.b	nC6, $06, nA5, nRst, $06

Mus84_SLZ_Call09:
	smpsAlterNote       $14
	dc.b	nG5, $01, smpsNoAttack
	smpsAlterNote       $00
	dc.b	$02, nA5, $03
	smpsNoteFill        $05
	dc.b	nC6, $03, nC6, $06, nA5, $03, nC6, $03
	smpsNoteFill        $00
	dc.b	nC6, nRst
	smpsAlterVol        $FC
	smpsAlterPitch      $33
	smpsSetvoice        $05
	dc.b	nEb4, $03
	smpsAlterVol        $07
	dc.b	nEb4
	smpsAlterVol        $07
	dc.b	nEb4
	smpsAlterVol        $07
	smpsReturn

; Unused dead data
Mus84_SLZ_Jump07:
	smpsJump            Mus84_SLZ_Jump07

Mus84_SLZ_Jump08:
	smpsJump            Mus84_SLZ_Jump08

; PSG3 Data
Mus84_SLZ_PSG3:
	smpsPSGform         $E7
	smpsNoteFill        $02
	dc.b	nRst, $24

Mus84_SLZ_Jump06:
	dc.b	nMaxPSG, $03, $03
	smpsPSGAlterVol     $02
	smpsPSGvoice        fTone_08
	smpsNoteFill        $08
	dc.b	$06
	smpsPSGvoice        fTone_04
	smpsNoteFill        $03
	smpsPSGAlterVol     $FE
	smpsJump            Mus84_SLZ_Jump06

; DAC Data
Mus84_SLZ_DAC:
	dc.b	nRst, $30

Mus84_SLZ_Jump00:
	dc.b	dKick, $0C
	smpsJump            Mus84_SLZ_Jump00

Mus84_SLZ_Voices:
;	Voice $00
;	$34
;	$33, $41, $7E, $74, 	$5B, $9F, $5F, $1F, 	$04, $07, $07, $08
;	$00, $00, $00, $00, 	$FF, $FF, $EF, $FF, 	$23, $90, $29, $97
	smpsVcAlgorithm     $04
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $07, $04, $03
	smpsVcCoarseFreq    $04, $0E, $01, $03
	smpsVcRateScale     $00, $01, $02, $01
	smpsVcAttackRate    $1F, $1F, $1F, $1B
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $08, $07, $07, $04
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $0F, $0E, $0F, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $17, $29, $10, $23

;	Voice $01
;	$3A
;	$61, $3C, $14, $31, 	$9C, $DB, $9C, $DA, 	$04, $09, $04, $03
;	$03, $01, $03, $00, 	$1F, $0F, $0F, $AF, 	$21, $47, $31, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $01, $03, $06
	smpsVcCoarseFreq    $01, $04, $0C, $01
	smpsVcRateScale     $03, $02, $03, $02
	smpsVcAttackRate    $1A, $1C, $1B, $1C
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $04, $09, $04
	smpsVcDecayRate2    $00, $03, $01, $03
	smpsVcDecayLevel    $0A, $00, $00, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $31, $47, $21

;	Voice $02
;	$04
;	$72, $42, $32, $32, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$00, $07, $00, $07, 	$23, $80, $23, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $04, $07
	smpsVcCoarseFreq    $02, $02, $02, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $07, $00, $07, $00
	smpsVcTotalLevel    $00, $23, $00, $23

;	Voice $03
;	$3A
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $00, 	$1F, $FF, $1F, $0F, 	$18, $28, $27, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $07, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $0E, $0E
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $27, $28, $18

;	Voice $04
;	$3C
;	$38, $74, $76, $33, 	$10, $10, $10, $10, 	$02, $07, $04, $07
;	$03, $09, $03, $09, 	$2F, $2F, $2F, $2F, 	$1E, $80, $1E, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $07, $07, $03
	smpsVcCoarseFreq    $03, $06, $04, $08
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $10, $10, $10, $10
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $07, $04, $07, $02
	smpsVcDecayRate2    $09, $03, $09, $03
	smpsVcDecayLevel    $02, $02, $02, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $1E, $00, $1E

;	Voice $05
;	$F4
;	$06, $04, $0F, $0E, 	$1F, $1F, $1F, $1F, 	$00, $00, $0B, $0B
;	$00, $00, $05, $08, 	$0F, $0F, $FF, $FF, 	$15, $85, $02, $8A
	smpsVcAlgorithm     $04
	smpsVcFeedback      $06
	smpsVcUnusedBits    $03
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $0E, $0F, $04, $06
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0B, $0B, $00, $00
	smpsVcDecayRate2    $08, $05, $00, $00
	smpsVcDecayLevel    $0F, $0F, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $0A, $02, $05, $15

