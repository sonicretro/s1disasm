Mus89_Special_Stage_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Mus89_Special_Stage_Voices
	smpsHeaderChan      $07, $03
	smpsHeaderTempo     $02, $08

	smpsHeaderDAC       Mus89_Special_Stage_DAC
	smpsHeaderFM        Mus89_Special_Stage_FM1,	$DC, $18
	smpsHeaderFM        Mus89_Special_Stage_FM2,	$DC, $0C
	smpsHeaderFM        Mus89_Special_Stage_FM3,	$E8, $18
	smpsHeaderFM        Mus89_Special_Stage_FM4,	$E8, $18
	smpsHeaderFM        Mus89_Special_Stage_FM5,	$E8, $18
	smpsHeaderFM        Mus89_Special_Stage_FM6,	$E8, $14
	smpsHeaderPSG       Mus89_Special_Stage_PSG1,	$DC, $03, $00, fTone_04
	smpsHeaderPSG       Mus89_Special_Stage_PSG2,	$FD, $01, $00, fTone_08
	smpsHeaderPSG       Mus89_Special_Stage_PSG3,	$DC, $04, $00, fTone_04

; FM1 Data
Mus89_Special_Stage_FM1:
	smpsSetvoice        $00

Mus89_Special_Stage_Loop05:
	dc.b	nE5, $18, nF5, $0C, nG5, $18, nE5, $0C, $18, nC5, $0C, nE5
	dc.b	$18, nC5, $0C, nE5, $18, nF5, $0C, nG5, $18, nE5, $0C, nC5
	dc.b	$18, nD5, $0C, nC5, $24
	smpsLoop            $00, $02, Mus89_Special_Stage_Loop05
	dc.b	smpsNoAttack, $03, nRst, $09, nD5, $0C, nE5, nF5, nE5, nF5, nG5, $18
	dc.b	nE5, $0C, nC5, $24, nRst, $0C, nD5, nE5, nF5, nE5, nF5, nG5
	dc.b	$18, nA5, $0C, nG5, $21, nRst, $03
	smpsJump            Mus89_Special_Stage_Loop05

; FM2 Data
Mus89_Special_Stage_FM2:
	smpsSetvoice        $02
	smpsNop             $01

Mus89_Special_Stage_Loop04:
	dc.b	nF5, $0C, nRst, $18, nE5, $0C, nRst, $18, nD5, $0C, nRst, $18
	dc.b	nC5, $0C, nD5, nE5, nF5, $0C, nRst, $18, nE5, $0C, nRst, $18
	dc.b	nD5, $12, nE5, $06, nD5, $0C, nC5, $24
	smpsLoop            $00, $02, Mus89_Special_Stage_Loop04
	dc.b	nBb4, $0C, nRst, $18, nBb4, $0C, nRst, $18, nC5, $0C, nRst, $18
	dc.b	nC5, $0C, nRst, $18, nBb4, $0C, nRst, $18, nBb4, $0C, nRst, $18
	dc.b	nD5, $0C, nRst, $18, nG5, $24
	smpsNop             $01
	smpsJump            Mus89_Special_Stage_Loop04

; FM3 Data
Mus89_Special_Stage_FM3:
	smpsSetvoice        $03
	smpsModSet          $1A, $01, $04, $06
	smpsPan             panCenter, $00

Mus89_Special_Stage_Loop03:
	smpsCall            Mus89_Special_Stage_Call04
	dc.b	nRst, nC7, $03, nRst, $09, nC7, $0C, nB6, nC7, nD7
	smpsCall            Mus89_Special_Stage_Call04
	dc.b	nC7, $12, nD7, $06, nC7, $0C, nB6, $24
	smpsLoop            $00, $02, Mus89_Special_Stage_Loop03
	smpsCall            Mus89_Special_Stage_Call05
	dc.b	nRst, nB6, $03, nRst, $09, nB6, $0C, nRst, nB6, $03, nRst, $09
	dc.b	nB6, $0C
	smpsCall            Mus89_Special_Stage_Call05
	dc.b	nRst, nC7, $03, nRst, $09, nC7, $0C, $24
	smpsJump            Mus89_Special_Stage_Loop03

Mus89_Special_Stage_Call04:
	dc.b	nRst, $0C, nE7, $03, nRst, $09, nE7, $0C, nRst, nD7, $03, nRst
	dc.b	$09, nD7, $0C
	smpsReturn

Mus89_Special_Stage_Call05:
	dc.b	nRst, $0C, nA6, $03, nRst, $09, nA6, $0C, nRst, nA6, $03, nRst
	dc.b	$09, nA6, $0C
	smpsReturn

; FM4 Data
Mus89_Special_Stage_FM4:
	smpsSetvoice        $03
	smpsModSet          $1A, $01, $04, $06
	smpsPan             panRight, $00

Mus89_Special_Stage_Loop02:
	smpsCall            Mus89_Special_Stage_Call02
	dc.b	nRst, nA6, $03, nRst, $09, nA6, $0C, nG6, nA6, nB6
	smpsCall            Mus89_Special_Stage_Call02
	dc.b	nA6, $12, nB6, $06, nA6, $0C, nG6, $24
	smpsLoop            $00, $02, Mus89_Special_Stage_Loop02
	smpsCall            Mus89_Special_Stage_Call03
	dc.b	nRst, nG6, $03, nRst, $09, nG6, $0C, nRst, nG6, $03, nRst, $09
	dc.b	nG6, $0C
	smpsCall            Mus89_Special_Stage_Call03
	dc.b	nRst, nA6, $03, nRst, $09, nA6, $0C, $24
	smpsJump            Mus89_Special_Stage_Loop02

Mus89_Special_Stage_Call02:
	dc.b	nRst, $0C, nC7, $03, nRst, $09, nC7, $0C, nRst, nB6, $03, nRst
	dc.b	$09, nB6, $0C
	smpsReturn

Mus89_Special_Stage_Call03:
	dc.b	nRst, $0C, nF6, $03, nRst, $09, nF6, $0C, nRst, nF6, $03, nRst
	dc.b	$09, nF6, $0C
	smpsReturn

; FM5 Data
Mus89_Special_Stage_FM5:
	smpsSetvoice        $03
	smpsModSet          $1A, $01, $04, $06
	smpsPan             panLeft, $00

Mus89_Special_Stage_Loop01:
	smpsCall            Mus89_Special_Stage_Call00
	dc.b	nRst, nF6, $03, nRst, $09, nF6, $0C, nE6, nF6, nG6
	smpsCall            Mus89_Special_Stage_Call00
	dc.b	nF6, $12, nG6, $06, nF6, $0C, nE6, $24
	smpsLoop            $00, $02, Mus89_Special_Stage_Loop01
	smpsCall            Mus89_Special_Stage_Call01
	dc.b	nRst, nE6, $03, nRst, $09, nE6, $0C, nRst, nE6, $03, nRst, $09
	dc.b	nE6, $0C
	smpsCall            Mus89_Special_Stage_Call01
	dc.b	nRst, nF6, $03, nRst, $09, nF6, $0C, $24
	smpsJump            Mus89_Special_Stage_Loop01

Mus89_Special_Stage_Call00:
	dc.b	nRst, $0C, nA6, $03, nRst, $09, nA6, $0C, nRst, nG6, $03, nRst
	dc.b	$09, nG6, $0C
	smpsReturn

Mus89_Special_Stage_Call01:
	dc.b	nRst, $0C, nD6, $03, nRst, $09, nD6, $0C, nRst, nD6, $03, nRst
	dc.b	$09, nD6, $0C
	smpsReturn

; PSG1 Data
Mus89_Special_Stage_PSG1:
	smpsNoteFill        $06

Mus89_Special_Stage_Loop06:
	smpsCall            Mus89_Special_Stage_Call06
	dc.b	nC6, $06, $06, nA5, $03, nRst, $09, nF5, $03, nRst, $09, nB5
	dc.b	$03, nRst, $21
	smpsCall            Mus89_Special_Stage_Call06
	dc.b	nC6, $03, nRst, $15, nD6, $03, nRst, $09, nC6, $03, nRst, $21
	smpsLoop            $00, $02, Mus89_Special_Stage_Loop06
	smpsCall            Mus89_Special_Stage_Call07
	dc.b	nB6, $06, $06, nG6, nG6, nE6, nE6, nB6, nB6, nG6, nG6, nE6
	dc.b	$03, nRst, $09
	smpsCall            Mus89_Special_Stage_Call07
	dc.b	nC7, $06, $06, nA6, nA6, nF6, nF6, nG6, $09, nRst, $1B
	smpsJump            Mus89_Special_Stage_Loop06

Mus89_Special_Stage_Call06:
	dc.b	nE6, $06, $06, nC6, $03, nRst, $09, nA5, $03, nRst, $09, nD6
	dc.b	$06, $06, nB5, $03, nRst, $09, nG5, $03, nRst, $09
	smpsReturn

Mus89_Special_Stage_Call07:
	dc.b	nA6, $06, $06, nF6, nF6, nD6, nD6, nA6, nA6, nF6, nF6, nD6
	dc.b	$03, nRst, $09
	smpsReturn

; PSG2 Data
Mus89_Special_Stage_PSG2:
	dc.b	nRst, $0C, nC5, nC5, nRst, nC5, nC5, nRst, nC5, nC5, nRst, nC5
	dc.b	$06, $06, $0C, nRst, nC5, nC5, nRst, nC5, nC5, nRst, nC5, nC5
	dc.b	nC5, $24
	smpsJump            Mus89_Special_Stage_PSG2

; DAC Data
Mus89_Special_Stage_DAC:
; PSG3 Data
Mus89_Special_Stage_PSG3:
	smpsStop

; FM6 Data
Mus89_Special_Stage_FM6:
	smpsSetvoice        $01

Mus89_Special_Stage_Loop00:
	dc.b	nE7, $18, nF7, $0C, nG7, $18, nE7, $0C, $18, nC7, $0C, nE7
	dc.b	$18, nC7, $0C, nE7, $18, nF7, $0C, nG7, $18, nE7, $0C, nC7
	dc.b	$18, nD7, $0C, nC7, $24
	smpsLoop            $00, $02, Mus89_Special_Stage_Loop00
	dc.b	nRst, $0C, nD7, nE7, nF7, nE7, nF7, nG7, $18, nE7, $0C, nC7
	dc.b	$24, nRst, $0C, nD7, nE7, nF7, nE7, nF7, nG7, $18, nA7, $0C
	dc.b	nG7, $21, nRst, $03
	smpsJump            Mus89_Special_Stage_Loop00

Mus89_Special_Stage_Voices:
;	Voice $00
;	$2C
;	$74, $74, $34, $34, 	$1F, $12, $1F, $1F, 	$00, $00, $00, $00
;	$00, $01, $00, $01, 	$00, $36, $00, $36, 	$16, $80, $17, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $04, $04, $04, $04
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $12, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $01, $00, $01, $00
	smpsVcDecayLevel    $03, $00, $03, $00
	smpsVcReleaseRate   $06, $00, $06, $00
	smpsVcTotalLevel    $00, $17, $00, $16

;	Voice $01
;	$2C
;	$72, $78, $34, $34, 	$1F, $12, $1F, $12, 	$00, $0A, $00, $0A
;	$00, $00, $00, $00, 	$00, $16, $00, $16, 	$16, $80, $17, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $04, $04, $08, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $12, $1F, $12, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $00, $0A, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $01, $00, $01, $00
	smpsVcReleaseRate   $06, $00, $06, $00
	smpsVcTotalLevel    $00, $17, $00, $16

;	Voice $02
;	$30
;	$30, $30, $30, $30, 	$9E, $D8, $DC, $DC, 	$0E, $0A, $04, $05
;	$08, $08, $08, $08, 	$B0, $B0, $B0, $B5, 	$14, $3C, $14, $80
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
	smpsVcReleaseRate   $05, $00, $00, $00
	smpsVcTotalLevel    $00, $14, $3C, $14

;	Voice $03
;	$3D
;	$01, $02, $00, $01, 	$1F, $10, $10, $10, 	$07, $1F, $1F, $1F
;	$00, $00, $00, $00, 	$10, $07, $07, $07, 	$17, $80, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $00, $02, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $10, $10, $10, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1F, $07
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $01
	smpsVcReleaseRate   $07, $07, $07, $00
	smpsVcTotalLevel    $00, $00, $00, $17

