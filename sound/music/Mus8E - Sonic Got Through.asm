Mus8E_Sonic_Got_Through_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Mus8E_Sonic_Got_Through_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $03

	smpsHeaderDAC       Mus8E_Sonic_Got_Through_DAC
	smpsHeaderFM        Mus8E_Sonic_Got_Through_FM1,	$F4, $0A
	smpsHeaderFM        Mus8E_Sonic_Got_Through_FM2,	$DC, $0A
	smpsHeaderFM        Mus8E_Sonic_Got_Through_FM3,	$F4, $15
	smpsHeaderFM        Mus8E_Sonic_Got_Through_FM4,	$F4, $15
	smpsHeaderFM        Mus8E_Sonic_Got_Through_FM5,	$F4, $14
	smpsHeaderPSG       Mus8E_Sonic_Got_Through_PSG1,	$D0, $05, $00, fTone_05
	smpsHeaderPSG       Mus8E_Sonic_Got_Through_PSG2,	$DC, $07, $00, fTone_05
	smpsHeaderPSG       Mus8E_Sonic_Got_Through_PSG3,	$DC, $00, $00, fTone_04

; FM1 Data
Mus8E_Sonic_Got_Through_FM1:
	smpsSetvoice        $00

; PSG1 Data
Mus8E_Sonic_Got_Through_PSG1:
	dc.b	nRst, $06, nG4, nA4, nB4, nC5, nD5, nE5, nF5, nG5, $0C, nB6
	dc.b	$02, smpsNoAttack, nC7, $01, nB6, $03, nG6
	smpsModSet          $0C, $01, $08, $04
	dc.b	nA6, $33
	smpsStop

; FM2 Data
Mus8E_Sonic_Got_Through_FM2:
	smpsSetvoice        $01
	smpsNoteFill        $0B
	smpsNop             $01
	dc.b	nG5, $03, nG5, nG4, $06, nG4, nG5, $03, nG5, nG4, $06, nG4
	dc.b	nG5, $03, nG5, nRst, $06, nRst, $0C, nG4, $09
	smpsNoteFill        $00
	dc.b	nA4, $33
	smpsNop             $01
	smpsStop

; FM3 Data
Mus8E_Sonic_Got_Through_FM3:
	smpsPan             panLeft, $00
	smpsSetvoice        $02
	smpsNoteFill        $06
	dc.b	nC6, $03, nC6, nRst, $0C, nC6, $03, nC6, nRst, $0C, nC6, $03
	dc.b	nC6, nRst, $12
	smpsNoteFill        $00
	dc.b	nC6, $09, nD6, $33
	smpsStop

; FM4 Data
Mus8E_Sonic_Got_Through_FM4:
	smpsPan             panRight, $00
	smpsSetvoice        $02
	smpsNoteFill        $06
	dc.b	nA5, $03, nA5, nRst, $0C, nA5, $03, nA5, nRst, $0C, nA5, $03
	dc.b	nA5, nRst, $12
	smpsNoteFill        $00
	dc.b	nA5, $09, nB5, $33
	smpsStop

; FM5 Data
Mus8E_Sonic_Got_Through_FM5:
	smpsSetvoice        $03
	smpsModSet          $0D, $01, $02, $05

; PSG2 Data
Mus8E_Sonic_Got_Through_PSG2:
	dc.b	nG5, $06, nC6, nB5, nG5, nC6, nB5, nG5, nC6, nB5, $0C, nC6
	dc.b	$09, nB5, $33

; PSG3 Data
Mus8E_Sonic_Got_Through_PSG3:
	smpsStop

; DAC Data
Mus8E_Sonic_Got_Through_DAC:
	dc.b	dSnare, $03, dSnare, dKick, $06, dKick, dSnare, $03, dSnare, dKick, $06, dKick
	dc.b	dSnare, $03, dSnare, dHiTimpani, dHiTimpani, dVLowTimpani, dVLowTimpani, $03, dVLowTimpani, dVLowTimpani, dSnare, $09
	dc.b	$33
	smpsStop

Mus8E_Sonic_Got_Through_Voices:
;	Voice $00
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

;	Voice $01
;	$3A
;	$61, $3C, $14, $31, 	$9C, $DB, $9C, $DA, 	$04, $09, $04, $03
;	$03, $01, $03, $00, 	$1F, $0F, $0F, $0F, 	$21, $47, $31, $80
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
	smpsVcDecayLevel    $00, $00, $00, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $31, $47, $21

;	Voice $02
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

;	Voice $03
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

; Unused voice
;	Voice $04
;	$3D
;	$01, $02, $02, $02, 	$10, $50, $50, $50, 	$07, $08, $08, $08
;	$01, $00, $00, $00, 	$2F, $1F, $1F, $1F, 	$1C, $82, $82, $82
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $02, $02, $01
	smpsVcRateScale     $01, $01, $01, $00
	smpsVcAttackRate    $10, $10, $10, $10
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $08, $08, $08, $07
	smpsVcDecayRate2    $00, $00, $00, $01
	smpsVcDecayLevel    $01, $01, $01, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $82, $82, $82, $1C
