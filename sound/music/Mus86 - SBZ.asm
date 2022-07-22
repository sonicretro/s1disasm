Mus86_SBZ_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Mus86_SBZ_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $05

	smpsHeaderDAC       Mus86_SBZ_DAC
	smpsHeaderFM        Mus86_SBZ_FM1,	$F4, $0D
	smpsHeaderFM        Mus86_SBZ_FM2,	$F4, $0D
	smpsHeaderFM        Mus86_SBZ_FM3,	$F4, $13
	smpsHeaderFM        Mus86_SBZ_FM4,	$F4, $17
	smpsHeaderFM        Mus86_SBZ_FM5,	$F4, $17
	smpsHeaderPSG       Mus86_SBZ_PSG1,	$D0, $03, $00, $00
	smpsHeaderPSG       Mus86_SBZ_PSG2,	$D0, $03, $00, $00
	smpsHeaderPSG       Mus86_SBZ_PSG3,	$00, $03, $00, fTone_04

; FM1 Data
Mus86_SBZ_FM1:
	smpsSetvoice        $02
	smpsAlterVol        $08
	dc.b	nRst, $24, nE6, $03, nD6, nC6, nB5, nF6, nE6, nD6, nC6, nG6
	dc.b	nF6, nE6, nD6, nA6, nG6, nF6, nE6, nB6, nA6, nG6, nF6
	smpsAlterVol        $F8
	smpsSetvoice        $03
	smpsModSet          $0D, $01, $08, $05
	smpsCall            Mus86_SBZ_Call06
	smpsSetvoice        $05
	smpsAlterNote       $FE
	smpsPan             panRight, $00
	smpsAlterVol        $03
	smpsAlterPitch      $F4
	smpsCall            Mus86_SBZ_Call04
	smpsAlterPitch      $0C
	smpsAlterVol        $FD
	smpsPan             panCenter, $00
	smpsAlterVol        $FE
	smpsAlterNote       $00
	smpsSetvoice        $03

Mus86_SBZ_Loop0F:
	smpsCall            Mus86_SBZ_Call07
	smpsLoop            $00, $02, Mus86_SBZ_Loop0F
	smpsAlterVol        $02
	smpsJump            Mus86_SBZ_FM1

; FM2 Data
Mus86_SBZ_FM2:
	smpsSetvoice        $00
	smpsAlterVol        $FD
	smpsNop             $01
	smpsNoteFill        $06
	dc.b	nA3, $03, nB3, nRst, nC4, nRst, nD4, nE4
	smpsNoteFill        $00
	dc.b	nG4, $09

Mus86_SBZ_Loop07:
	dc.b	nG3, $06, nG4
	smpsLoop            $00, $05, Mus86_SBZ_Loop07
	dc.b	nG3
	smpsAlterVol        $03
	smpsNoteFill        $06

Mus86_SBZ_Loop0A:
	smpsCall            Mus86_SBZ_Call08

Mus86_SBZ_Loop08:
	dc.b	nG4, nG4, nD4, nD4, nF4, nF4, nD4, nD4
	smpsLoop            $00, $04, Mus86_SBZ_Loop08

Mus86_SBZ_Loop09:
	dc.b	nF4, nF4, nC4, nC4, nEb4, nEb4, nC4, nC4
	smpsLoop            $00, $04, Mus86_SBZ_Loop09
	smpsCall            Mus86_SBZ_Call08
	smpsLoop            $01, $02, Mus86_SBZ_Loop0A
	smpsPan             panLeft, $00
	smpsCall            Mus86_SBZ_Call04
	smpsPan             panCenter, $00

Mus86_SBZ_Loop0B:
	dc.b	nC4, $03, nC4, nG3, nG3, nA3, nA3, nG3, nG3
	smpsLoop            $00, $02, Mus86_SBZ_Loop0B

Mus86_SBZ_Loop0C:
	dc.b	nFs4, nFs4, nCs4, nCs4, nEb4, nEb4, nCs4, nCs4
	smpsLoop            $00, $02, Mus86_SBZ_Loop0C

Mus86_SBZ_Loop0D:
	dc.b	nF4, nF4, nC4, nC4, nD4, nD4, nC4, nC4
	smpsLoop            $00, $02, Mus86_SBZ_Loop0D

Mus86_SBZ_Loop0E:
	dc.b	nG4, nG4, nD4, nD4, nE4, nE4, nD4, nD4
	smpsLoop            $00, $02, Mus86_SBZ_Loop0E
	smpsLoop            $01, $04, Mus86_SBZ_Loop0B
	smpsNoteFill        $00
	smpsNop             $01
	smpsJump            Mus86_SBZ_FM2

Mus86_SBZ_Call08:
	dc.b	nA4, $03, nA4, nE4, nE4, nG4, nG4, nE4, nE4
	smpsLoop            $00, $04, Mus86_SBZ_Call08
	smpsReturn

; FM3 Data
Mus86_SBZ_FM3:
	smpsSetvoice        $01
	smpsNoteFill        $06
	dc.b	nA4, $03, nB4, nRst, nC5, nRst, nD5, nE5
	smpsNoteFill        $00
	dc.b	nG5, $4B
	smpsSetvoice        $03
	smpsAlterNote       $03
	smpsAlterVol        $FA
	smpsCall            Mus86_SBZ_Call06
	smpsSetvoice        $00
	smpsPan             panRight, $00
	smpsNoteFill        $06
	smpsCall            Mus86_SBZ_Call04
	smpsPan             panCenter, $00
	smpsSetvoice        $03
	smpsNoteFill        $00
	smpsAlterVol        $FE

Mus86_SBZ_Loop06:
	smpsCall            Mus86_SBZ_Call07
	smpsLoop            $00, $02, Mus86_SBZ_Loop06
	smpsAlterVol        $08
	smpsJump            Mus86_SBZ_FM3

; FM4 Data
Mus86_SBZ_FM4:
	smpsSetvoice        $04
	smpsPan             panLeft, $00
	smpsModSet          $5C, $01, $05, $04
	smpsNoteFill        $06
	smpsCall            Mus86_SBZ_Call03
	smpsAlterNote       $04
	smpsCall            Mus86_SBZ_Call01
	smpsAlterVol        $06
	smpsSetvoice        $05
	smpsAlterNote       $02
	smpsAlterVol        $ED
	smpsAlterPitch      $F4
	smpsCall            Mus86_SBZ_Call04
	smpsAlterVol        $13
	smpsAlterPitch      $0C
	smpsAlterVol        $F3
	smpsSetvoice        $04
	smpsModOff
	smpsAlterVol        $FA

Mus86_SBZ_Loop05:
	smpsModOff
	smpsCall            Mus86_SBZ_Call05
	dc.b	nRst, $0C, nA5, $02
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $0A, nRst, $03, nA5, nRst, nRst, nA5, nRst, $09
	smpsCall            Mus86_SBZ_Call05
	dc.b	nA5, $02
	smpsAlterNote       $00
	dc.b	$0A, nRst, $06
	smpsModSet          $18, $01, $07, $04
	smpsAlterNote       $E2
	dc.b	nA5, $02, smpsNoAttack
	smpsAlterNote       $00
	dc.b	$1C
	smpsLoop            $00, $02, Mus86_SBZ_Loop05
	smpsAlterVol        $06
	smpsAlterVol        $01
	smpsJump            Mus86_SBZ_FM4

Mus86_SBZ_Call03:
	dc.b	nE5, $03, nE5, nRst, nE5, nRst, nE5, nE5
	smpsNoteFill        $00
	dc.b	nD5, $4B
	smpsReturn

Mus86_SBZ_Call01:
	smpsSetvoice        $02
	smpsAlterVol        $06
	smpsModSet          $08, $01, $08, $04

Mus86_SBZ_Call0A:
	dc.b	nRst, $60, nRst, nRst, nE6, $18, nFs6, nG6, nAb6
	smpsLoop            $00, $02, Mus86_SBZ_Call0A
	smpsReturn

Mus86_SBZ_Call05:
	dc.b	nRst, $0C
	smpsAlterNote       $EC
	dc.b	nG5, $02
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $06, nRst, $01, nG5, $03, nRst, $18, nRst, $0C
	smpsAlterNote       $EC
	dc.b	nCs6, $02
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $06, nRst, $01, nCs6, $03, nRst, $18, nRst, $0C
	smpsAlterNote       $EC
	dc.b	nC6, $02
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $06, nRst, $01, nC6, $03, nRst, $18
	smpsAlterNote       $EC
	smpsReturn

; FM5 Data
Mus86_SBZ_FM5:
	smpsSetvoice        $04
	smpsPan             panRight, $00
	smpsModSet          $5C, $01, $05, $04
	smpsNoteFill        $06
	dc.b	nC5, $03, nC5, nRst, nC5, nRst, nC5, nC5
	smpsNoteFill        $00
	dc.b	nB4, $4B
	smpsCall            Mus86_SBZ_Call01
	smpsAlterVol        $06

Mus86_SBZ_Loop03:
	dc.b	nRst, $60
	smpsLoop            $00, $01, Mus86_SBZ_Loop03
	smpsSetvoice        $06
	smpsAlterVol        $EB
	smpsAlterPitch      $0C
	smpsModOff

Mus86_SBZ_Loop04:
	smpsCall            Mus86_SBZ_Call02
	dc.b	nE6, nF6, nG6
	smpsCall            Mus86_SBZ_Call02
	dc.b	nG6, nF6, nE6
	smpsLoop            $00, $02, Mus86_SBZ_Loop04
	smpsAlterVol        $09
	smpsAlterPitch      $F4
	smpsJump            Mus86_SBZ_FM5

Mus86_SBZ_Call02:
	dc.b	nRst, $03, nE6, nC6, $06, $06, nG5, nC6, $09, nE6, $09, nRst
	dc.b	$06, nRst, $03, nF6, nCs6, $06, $06, nBb5, nCs6, $09, nF6, $09
	dc.b	nRst, $06, nRst, $03, nE6, nC6, $06, $06, nA5, nC6, $09, nE6
	dc.b	$0F, nD6, $0C
	smpsReturn

; PSG1 Data
Mus86_SBZ_PSG1:
	smpsPSGAlterVol     $01
	smpsPSGvoice        $00
	smpsCall            Mus86_SBZ_Call03
	smpsPSGvoice        fTone_06
	smpsPSGAlterVol     $FF
	smpsCall            Mus86_SBZ_Call0A
	dc.b	nRst, $60
	smpsPSGvoice        $00
	smpsPSGAlterVol     $FF

Mus86_SBZ_Loop17:
	smpsCall            Mus86_SBZ_Call0B
	dc.b	nRst, $0C, nF5, nRst, $03, nF5, nRst, nRst, nF5, nRst, $09
	smpsCall            Mus86_SBZ_Call0B
	dc.b	nF5, $0C, nRst, $06, nF5, $1E
	smpsLoop            $00, $02, Mus86_SBZ_Loop17
	smpsPSGAlterVol     $01
	smpsJump            Mus86_SBZ_PSG1

Mus86_SBZ_Call0B:
	dc.b	nRst, $0C, nE5, $07, nRst, $02, nE5, $03, nRst, $18, nRst, $0C
	dc.b	nBb5, $07, nRst, $02, nBb5, $03, nRst, $18, nRst, $0C, nA5, $07
	dc.b	nRst, $02, nA5, $03, nRst, $18
	smpsReturn

; PSG2 Data
Mus86_SBZ_PSG2:
	smpsPSGvoice        $00
	smpsPSGAlterVol     $01
	dc.b	nC5, $03, nC5, nRst, nC5, nRst, nC5, nC5
	smpsNoteFill        $00
	dc.b	nB4, $4B
	smpsPSGAlterVol     $FF

Mus86_SBZ_Loop13:
	smpsPSGvoice        fTone_05
	smpsNoteFill        $03
	smpsCall            Mus86_SBZ_Call09

Mus86_SBZ_Loop11:
	dc.b	nG6, nG6, nD7, nG6, nC7, nG6, nB6, nG6
	smpsLoop            $00, $04, Mus86_SBZ_Loop11

Mus86_SBZ_Loop12:
	dc.b	nA6, nA6, nEb7, nA6, nD7, nA6, nC7, nA6
	smpsLoop            $00, $04, Mus86_SBZ_Loop12
	smpsCall            Mus86_SBZ_Call09
	smpsLoop            $01, $02, Mus86_SBZ_Loop13
	dc.b	nRst, $60
	smpsPSGAlterVol     $01

Mus86_SBZ_Loop14:
	dc.b	nC7, $03, nC7, nG7, nC7, nF7, nC7, nE7, nC7
	smpsLoop            $00, $02, Mus86_SBZ_Loop14

Mus86_SBZ_Loop15:
	dc.b	nBb6, nBb6, nF7, nBb6, nEb7, nBb6, nCs7, nBb6
	smpsLoop            $00, $02, Mus86_SBZ_Loop15

Mus86_SBZ_Loop16:
	dc.b	nA6, nA6, nE7, nA6, nD7, nA6, nC7, nA6
	smpsLoop            $00, $04, Mus86_SBZ_Loop16
	smpsLoop            $01, $04, Mus86_SBZ_Loop14
	smpsPSGAlterVol     $FF
	smpsJump            Mus86_SBZ_PSG2

Mus86_SBZ_Call09:
	dc.b	nA6, $03, nA6, nE7, nA6, nD7, nA6, nC7, nA6
	smpsLoop            $00, $04, Mus86_SBZ_Call09
	smpsReturn

; PSG3 Data
Mus86_SBZ_PSG3:
	smpsPSGform         $E7
	smpsNoteFill        $03
	dc.b	nMaxPSG, $03, $06, nRst, nMaxPSG, $06, $0F, $0C, $0C, $0C, $18

Mus86_SBZ_Loop10:
	dc.b	nMaxPSG, $03, $03
	smpsPSGAlterVol     $02
	smpsPSGvoice        fTone_08
	smpsNoteFill        $08
	dc.b	$06
	smpsPSGvoice        fTone_04
	smpsNoteFill        $03
	smpsPSGAlterVol     $FE
	smpsLoop            $00, $88, Mus86_SBZ_Loop10
	smpsJump            Mus86_SBZ_PSG3

; DAC Data
Mus86_SBZ_DAC:
	dc.b	dSnare, $03, $06, $06, $03, $03, $0F, dKick, $0C, nRst, $0C, dKick
	dc.b	dKick, $06, dSnare, dSnare, dSnare, $03, $03

Mus86_SBZ_Loop00:
	dc.b	dKick, $0C, dSnare, dKick, dSnare, dKick, dSnare, $01, dMidTimpani, $05, dHiTimpani, $06
	dc.b	dKick, $01, dMidTimpani, $05, dHiTimpani, $06, dSnare, $01, dMidTimpani, $05, dHiTimpani, $06
	smpsLoop            $00, $02, Mus86_SBZ_Loop00
	dc.b	dKick, $0C, dSnare, dKick, dSnare, dKick, dSnare, dKick, dSnare, $06, dHiTimpani, $03
	dc.b	dHiTimpani, dKick, $0C, dSnare, dKick, dSnare, dKick, $06, dHiTimpani, dSnare, $01, dMidTimpani
	dc.b	$05, dHiTimpani, $06, dKick, $01, dMidTimpani, $05, dSnare, $01, dHiTimpani, $05, dSnare
	dc.b	$01, dMidTimpani, $05, dSnare, $03, $03
	smpsLoop            $01, $02, Mus86_SBZ_Loop00

Mus86_SBZ_Loop01:
	dc.b	dSnare, $03, dSnare, dKick, dKick, dKick, dKick, dSnare, dSnare, dKick, dKick, dKick
	dc.b	dKick, dSnare, dSnare, dSnare, dSnare
	smpsLoop            $00, $02, Mus86_SBZ_Loop01

Mus86_SBZ_Loop02:
	smpsCall            Mus86_SBZ_Call00
	dc.b	dHiTimpani, $02, dKick, $01, dMidTimpani, $05, dSnare, $01, dHiTimpani, $05, dMidTimpani, $06
	smpsCall            Mus86_SBZ_Call00
	dc.b	dMidTimpani, $02, dSnare, $01, dHiTimpani, $05, dSnare, $01, dMidTimpani, $05, dSnare, $01
	dc.b	dHiTimpani, $02, dSnare, $03
	smpsLoop            $01, $02, Mus86_SBZ_Loop02
	smpsJump            Mus86_SBZ_DAC

Mus86_SBZ_Call00:
	dc.b	dKick, $0C, dSnare, $09, dKick, $06, $03, dKick, $01, dHiTimpani, $02, dMidTimpani
	dc.b	$03, dSnare, $01, dHiTimpani, $0B
	smpsLoop            $00, $03, Mus86_SBZ_Call00
	dc.b	dKick, $0C, dSnare, $09, dKick, $06, dSnare, $01
	smpsReturn

Mus86_SBZ_Call06:
	dc.b	nA6, $1E, nG6, $06, nF6, nG6, nE6, $30, nG6, $1E, nF6, $06
	dc.b	nE6, nF6, nD6, $30, nF6, $1E, nEb6, $06, nD6, nEb6, nC6, $18
	dc.b	nD6, nE6, $03, nF6, nE6, $5A
	smpsLoop            $00, $02, Mus86_SBZ_Call06
	smpsReturn

Mus86_SBZ_Call07:
	dc.b	nG6, $1E, nE6, $06, nC6, nC7, nBb6, $0C, nC7, $06, nBb6, $0C
	dc.b	nG6, $06, nBb6, nA6, $24, nE6, $06, nF6, nG6, $12, nA6, $06
	dc.b	nG6, $12, nE6, $0C, nG6, $1E, nE6, $06, nC6, nC7, nBb6, $0C
	dc.b	nC7, $06, nBb6, $0C, nG6, $06, nBb6, nA6, $24, nE6, $06, nF6
	dc.b	nG6, $30, nRst, $06
	smpsReturn

Mus86_SBZ_Call04:
	smpsCall            Mus86_SBZ_Call0C
	dc.b	nG4, nG4, $09
	smpsCall            Mus86_SBZ_Call0C
	dc.b	nRst, $0C
	smpsReturn

Mus86_SBZ_Call0C:
	dc.b	nA4, $03, nA4, nAb4, nAb4, nG4, nG4, nA4, nA4, nAb4, nAb4, nG4
	dc.b	nG4
	smpsReturn

Mus86_SBZ_Voices:
;	Voice $00
;	$08
;	$0A, $70, $30, $00, 	$1F, $1F, $5F, $5F, 	$12, $0E, $0A, $0A
;	$00, $04, $04, $03, 	$2F, $2F, $2F, $2F, 	$24, $2D, $13, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $01
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $03, $07, $00
	smpsVcCoarseFreq    $00, $00, $00, $0A
	smpsVcRateScale     $01, $01, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0A, $0E, $12
	smpsVcDecayRate2    $03, $04, $04, $00
	smpsVcDecayLevel    $02, $02, $02, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $13, $2D, $24

;	Voice $01
;	$2C
;	$74, $74, $34, $34, 	$1F, $12, $1F, $1F, 	$00, $04, $00, $04
;	$00, $09, $00, $09, 	$00, $08, $00, $08, 	$16, $80, $17, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $04, $04, $04, $04
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $12, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $04, $00, $04, $00
	smpsVcDecayRate2    $09, $00, $09, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $08, $00, $08, $00
	smpsVcTotalLevel    $00, $17, $00, $16

;	Voice $02
;	$3D
;	$01, $02, $02, $02, 	$14, $0E, $8C, $0E, 	$08, $05, $02, $05
;	$00, $08, $08, $08, 	$1F, $1F, $1F, $1F, 	$1A, $92, $A7, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $02, $02, $01
	smpsVcRateScale     $00, $02, $00, $00
	smpsVcAttackRate    $0E, $0C, $0E, $14
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $02, $05, $08
	smpsVcDecayRate2    $08, $08, $08, $00
	smpsVcDecayLevel    $01, $01, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $27, $12, $1A

;	Voice $03
;	$29
;	$36, $74, $71, $31, 	$04, $04, $05, $1D, 	$12, $0E, $1F, $1F
;	$04, $06, $03, $01, 	$5F, $6F, $0F, $0F, 	$27, $27, $2E, $80
	smpsVcAlgorithm     $01
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $07, $07, $03
	smpsVcCoarseFreq    $01, $01, $04, $06
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1D, $05, $04, $04
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $0E, $12
	smpsVcDecayRate2    $01, $03, $06, $04
	smpsVcDecayLevel    $00, $00, $06, $05
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $2E, $27, $27

;	Voice $04
;	$3D
;	$01, $01, $01, $01, 	$8E, $52, $14, $4C, 	$08, $08, $0E, $03
;	$00, $00, $00, $00, 	$1F, $1F, $1F, $1F, 	$1B, $80, $80, $9B
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $01, $01
	smpsVcRateScale     $01, $00, $01, $02
	smpsVcAttackRate    $0C, $14, $12, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $08, $08
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $01, $01, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $1B, $00, $00, $1B

;	Voice $05
;	$30
;	$30, $30, $30, $30, 	$9E, $D8, $DC, $DC, 	$0E, $0A, $04, $05
;	$08, $08, $08, $08, 	$BF, $BF, $BF, $BF, 	$14, $3C, $14, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $00, $00, $00, $00
	smpsVcRateScale     $03, $03, $03, $02
	smpsVcAttackRate    $1C, $1C, $18, $1E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $04, $0A, $0E
	smpsVcDecayRate2    $08, $08, $08, $08
	smpsVcDecayLevel    $0B, $0B, $0B, $0B
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $14, $3C, $14

;	Voice $06
;	$3D
;	$01, $02, $00, $01, 	$1F, $0E, $0E, $0E, 	$07, $1F, $1F, $1F
;	$00, $00, $00, $00, 	$1F, $0F, $0F, $0F, 	$17, $8D, $8C, $8C
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $00, $02, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0E, $0E, $0E, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1F, $07
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $0C, $0C, $0D, $17

