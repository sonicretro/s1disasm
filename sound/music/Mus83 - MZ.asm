Mus83_MZ_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Mus83_MZ_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $09

	smpsHeaderDAC       Mus83_MZ_DAC
	smpsHeaderFM        Mus83_MZ_FM1,	$E8, $15
	smpsHeaderFM        Mus83_MZ_FM2,	$E8, $0E
	smpsHeaderFM        Mus83_MZ_FM3,	$E8, $15
	smpsHeaderFM        Mus83_MZ_FM4,	$E8, $17
	smpsHeaderFM        Mus83_MZ_FM5,	$E8, $17
	smpsHeaderPSG       Mus83_MZ_PSG1,	$D0, $03, $00, fTone_08
	smpsHeaderPSG       Mus83_MZ_PSG2,	$D0, $05, $00, fTone_08
	smpsHeaderPSG       Mus83_MZ_PSG3,	$0B, $03, $00, fTone_09

; FM3 Data
Mus83_MZ_FM3:
	smpsAlterNote       $02

; FM1 Data
Mus83_MZ_FM1:
	smpsSetvoice        $00
	dc.b	nRst, $24

Mus83_MZ_Jump04:
	smpsCall            Mus83_MZ_Call04
	dc.b	nA6, $09, nRst, $03, nA6, $06, nG6, nA6, $09, nRst, $03, nA6
	dc.b	$06, nG6, nA6, $09, nRst, $03, nA6, $06, nG6, nA6, $0C, nB6
	dc.b	nF6, $12, nE6, $35, nRst, $01
	smpsCall            Mus83_MZ_Call04
	dc.b	nA6, $24, nB6, $0C, nAb6, $24, nB6, $09, nRst, $03, nB6, $12
	dc.b	nA6, $4D, nRst, $61, nRst, $48
	smpsJump            Mus83_MZ_Jump04

Mus83_MZ_Call04:
	dc.b	nA5, $06, nB5, nC6, nE6, nB6, $09, nRst, $03, nB6, $06, nA6
	dc.b	nB6, $09, nRst, $03, nB6, $06, nA6, nB6, $09, nRst, $03, nB6
	dc.b	$06, nA6, nB6, nA6, nE6, nC6, nG6, $0C, nA6, $06, smpsNoAttack, nF6
	dc.b	$4D, nRst, $01
	smpsReturn

; FM4 Data
Mus83_MZ_FM4:
	smpsSetvoice        $03
	smpsAlterVol        $F7
	dc.b	nRst, $06, nE5, $03, $03, $06, nRst, nE4, $1E
	smpsSetvoice        $02
	smpsAlterVol        $09
	dc.b	nB6, $06

Mus83_MZ_Jump03:
	smpsCall            Mus83_MZ_Call03
	dc.b	nA6, $09, nRst, $03, nA6, nRst, nB6, $06, nRst, nA6, $0C, nRst
	dc.b	$06, nA6, $09, nRst, $03, nA6, nRst, nB6, $06, nRst, nA6, $0C
	dc.b	nRst, $18, nG6, $03, nRst, $0F, nG6, $03, nRst, $39, nB6, $06
	smpsCall            Mus83_MZ_Call03
	dc.b	nF6, $09, nRst, $03, nF6, nRst, nA6, $06, nRst, nF6, $0C, nRst
	dc.b	$06, nAb6, $09, nRst, $03, nAb6, nRst, nB6, $06, nRst, nAb6, $0C
	dc.b	nRst, $18, nC7, $03, nRst, $0F, nC7, $03, nRst, $09, nE7, $09
	dc.b	nRst, $03, nE7, nRst, nD7, $06, nRst, nC7, $03, nRst, nB6, $12
	smpsCall            Mus83_MZ_Call02
	smpsJump            Mus83_MZ_Jump03

Mus83_MZ_Call03:
	dc.b	smpsNoAttack, $03, nRst, nB6, nRst, nC7, $06, nRst, nB6, $0C, nRst, $06
	dc.b	nB6, $09, nRst, $03, nB6, nRst, nC7, $06, nRst, nB6, $0C, nRst
	dc.b	$18, nC7, $03, nRst, $0F, nC7, $03, nRst, $1B, nC7, $03, nRst
	dc.b	$0F, nC7, $03, nRst, $09
	smpsReturn

; FM5 Data
Mus83_MZ_FM5:
	smpsSetvoice        $04
	smpsAlterVol        $FC
	smpsAlterPitch      $24
	dc.b	nRst, $06, nE4, $03, $03, $06, nRst, nE3, $1E
	smpsSetvoice        $02
	smpsAlterPitch      $DC
	smpsAlterVol        $04
	dc.b	nG6, $06

Mus83_MZ_Jump02:
	smpsCall            Mus83_MZ_Call01
	dc.b	nF6, $09, nRst, $03, nF6, nRst, nG6, $06, nRst, nF6, $0C, nRst
	dc.b	$06, nF6, $09, nRst, $03, nF6, nRst, nG6, $06, nRst, nF6, $0C
	dc.b	nRst, $18, nE6, $03, nRst, $0F, nE6, $03, nRst, $39, nG6, $06
	smpsCall            Mus83_MZ_Call01
	dc.b	nD6, $09, nRst, $03, nD6, nRst, nF6, $06, nRst, nD6, $0C, nRst
	dc.b	$06, nE6, $09, nRst, $03, nE6, nRst, nAb6, $06, nRst, nE6, $0C
	dc.b	nRst, $18, nA6, $03, nRst, $0F, nA6, $03, nRst, $09, nC7, $09
	dc.b	nRst, $03, nC7, nRst, nB6, $06, nRst, nA6, $03, nRst, nAb6, $12
	smpsAlterNote       $03
	smpsCall            Mus83_MZ_Call02
	smpsAlterNote       $00
	smpsJump            Mus83_MZ_Jump02

Mus83_MZ_Call01:
	dc.b	smpsNoAttack, $03, nRst, nG6, nRst, nA6, $06, nRst, nG6, $0C, nRst, $06
	dc.b	nG6, $09, nRst, $03, nG6, nRst, nA6, $06, nRst, nG6, $0C, nRst
	dc.b	$18, nA6, $03, nRst, $0F, nA6, $03, nRst, $1B, nA6, $03, nRst
	dc.b	$0F, nA6, $03, nRst, $09
	smpsReturn

; FM2 Data
Mus83_MZ_FM2:
	smpsSetvoice        $01
	dc.b	nRst, $06, nE4, $03, nE4
	smpsNop             $01
	dc.b	nE4, $06, nRst, nE3, $24

Mus83_MZ_Jump01:
	smpsCall            Mus83_MZ_Call00

Mus83_MZ_Loop00:
	dc.b	nG3, $03, nRst, nG3, $06, nD4, $03, nRst, nD4, $06, nB3, $03
	dc.b	nRst, nB3, $06, nD4, $03, nRst, nD4, $06
	smpsLoop            $01, $02, Mus83_MZ_Loop00
	dc.b	nC4, $03, nRst, nC4, $06, nG4, $03, nRst, nG4, $06, nE4, $03
	dc.b	nRst, nE4, $06, nG4, $03, nRst, nG4, $06, nB3, $03, nRst, nB3
	dc.b	$06, nF4, $03, nRst, nF4, $06, nE4, $03, nRst, nE4, $06, nB3
	dc.b	$03, nRst, nB3, $06
	smpsCall            Mus83_MZ_Call00
	dc.b	nB3, $03, nRst, nB3, $06, nF4, $03, nRst, nF4, $06, nD4, $03
	dc.b	nRst, nD4, $06, nF4, $03, nRst, nF4, $06, nE4, $03, nRst, nE4
	dc.b	$06, nB4, $03, nRst, nB4, $06, nAb4, $03, nRst, nAb4, $06, nB4
	dc.b	$03, nRst, nB4, $06, nA3, $03, nRst, nA3, $06, nE4, $03, nRst
	dc.b	nE4, $06, nC4, $03, nRst, nC4, $06, nE4, $03, nRst, nE4, $06
	dc.b	nA3, $03, nRst, nA3, $06, nE4, $03, nRst, nE4, $06, nD4, $03
	dc.b	nRst, nD4, $06, nE4, $03, nRst, nE4, $06

Mus83_MZ_Loop01:
	dc.b	nA3, $12, nA3, $06, nG3, $12, nG3, $06, nF3, $12, nF3, $06
	dc.b	nG3, $12, nG3, $06
	smpsLoop            $01, $02, Mus83_MZ_Loop01
	smpsNop             $01
	smpsJump            Mus83_MZ_Jump01

Mus83_MZ_Call00:
	dc.b	nA3, $03, nRst, nA3, $06, nE4, $03, nRst, nE4, $06, nD4, $03
	dc.b	nRst, nD4, $06, nE4, $03, nRst, nE4, $06
	smpsLoop            $00, $02, Mus83_MZ_Call00

Mus83_MZ_Loop05:
	dc.b	nD4, $03, nRst, nD4, $06, nA4, $03, nRst, nA4, $06, nF4, $03
	dc.b	nRst, nF4, $06, nA4, $03, nRst, nA4, $06
	smpsLoop            $00, $02, Mus83_MZ_Loop05
	smpsReturn

; PSG1 Data
Mus83_MZ_PSG1:
	dc.b	nRst, $3C

Mus83_MZ_Jump06:
	dc.b	nRst, $60
	smpsCall            Mus83_MZ_Call06
	dc.b	nRst, $2A, nF7, $0C, nF7, $06, nD7, $0C, nB6, $06, nAb6, $2A
	dc.b	nRst, $48
	smpsCall            Mus83_MZ_Call06
	dc.b	nRst, $60

Mus83_MZ_Loop03:
	dc.b	nA6, $06, nC7, $03, nA6, nC7, $06, nA6, nB6, nG6, nD6, nB6
	dc.b	nF6, nA6, $03, nF6, nA6, $06, nF6, nG6, nA6, nB6, nG6
	smpsLoop            $00, $02, Mus83_MZ_Loop03
	smpsJump            Mus83_MZ_Jump06

Mus83_MZ_Call06:
	dc.b	nRst, $30, nF7, $03, nD7, nA6, nF6, nD7, nA6, nF6, nD6, nA6
	dc.b	nF6, nD6, nA5, nF6, nD6, nA5, nF5, $27, nRst, $3C
	smpsReturn

; PSG2 Data
Mus83_MZ_PSG2:
	dc.b	nRst, $02
	smpsAlterNote       $01
	smpsJump            Mus83_MZ_PSG1

; PSG3 Data
Mus83_MZ_PSG3:
	smpsPSGform         $E7
	smpsPSGAlterVol     $FF
	; These first three notes are too high when combined with this track's
	; transposition value, causing them to overflow the PSG frequency table
	; and play invalid notes. In the Sonic 1 prototype, this problem was
	; even worse as there were smpsChangeTransposition commands around the
	; following line that raised the notes yet another octave higher,
	; causing the fourth note to break too.
	; Since the commands are gone now, we can assume that this was the
	; developers' intended solution, though it unfortunately only fixed the
	; fourth note. So, in order to fix the bug for good, the notes on the
	; following line have to be lowered by yet another octave.
	dc.b	nRst, $06, nE5, $03, $03, $06, nRst, nE4, $24
	smpsPSGAlterVol     $01

Mus83_MZ_Jump05:
	smpsCall            Mus83_MZ_Call05
	dc.b	nG3, nG3, nD4, nD4, nB3, nB3, nD4, nD4, nG3, nG3, nD4, nD4
	dc.b	nB3, nB3, nD4, nD4, nC4, nC4, nG4, nG4, nE4, nE4, nG4, nG4
	dc.b	nB3, nB3, nF4, nF4, nE4, nE4, nB3, nB3
	smpsCall            Mus83_MZ_Call05
	dc.b	nB3, nB3, nF4, nF4, nD4, nD4, nF4, nF4, nE4, nE4, nB4, nB4
	dc.b	nAb4, nAb4, nB4, nB4, nA3, nA3, nE4, nE4, nC4, nC4, nE4, nE4
	dc.b	nA3, nA3, nE4, nE4, nD4, nD4, nE4, nE4
	smpsPSGAlterVol     $FF

Mus83_MZ_Loop02:
	dc.b	nA4, $12, nA4, $06, nG4, $12, nG4, $06, nF4, $12, nF4, $06
	dc.b	nG4, $12, nG4, $06
	smpsLoop            $00, $02, Mus83_MZ_Loop02
	smpsPSGAlterVol     $01
	smpsJump            Mus83_MZ_Jump05

Mus83_MZ_Call05:
	dc.b	nA3, $06, nA3, nE4, nE4, nD4, nD4, nE4, nE4, nA3, nA3, nE4
	dc.b	nE4, nD4, nD4, nE4, nE4, nD4, nD4, nA4, nA4, nF4, nF4, nA4
	dc.b	nA4, nD4, nD4, nA4, nA4, nF4, nF4, nA4, nA4
	smpsReturn

; DAC Data
Mus83_MZ_DAC:
	dc.b	nRst, $06, dSnare, $03, $03, $0C, dKick, $0C, $0C, $0C

Mus83_MZ_Jump00:
	dc.b	dKick, $0C
	smpsJump            Mus83_MZ_Jump00

Mus83_MZ_Call02:
	smpsNoteFill        $06

Mus83_MZ_Loop04:
	dc.b	nRst, $06, nE7, nC7, nA6, $0C, nD7, $06, nB6, nG6, nRst, nC7
	dc.b	nA6, nF6, $0C, nD7, $06, nB6, nG6
	smpsLoop            $00, $02, Mus83_MZ_Loop04
	smpsNoteFill        $00
	smpsReturn

Mus83_MZ_Voices:
;	Voice $00
;	$22
;	$0A, $13, $05, $11, 	$03, $12, $12, $11, 	$00, $13, $13, $00
;	$03, $02, $02, $01, 	$1F, $1F, $0F, $0F, 	$1E, $18, $26, $81
	smpsVcAlgorithm     $02
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $01, $00, $01, $00
	smpsVcCoarseFreq    $01, $05, $03, $0A
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $11, $12, $12, $03
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $13, $13, $00
	smpsVcDecayRate2    $01, $02, $02, $03
	smpsVcDecayLevel    $00, $00, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $01, $26, $18, $1E

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

;	Voice $03
;	$23
;	$7C, $32, $00, $00, 	$5F, $58, $DC, $DF, 	$04, $0B, $04, $04
;	$06, $0C, $08, $08, 	$1F, $1F, $BF, $BF, 	$24, $26, $16, $80
	smpsVcAlgorithm     $03
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $03, $07
	smpsVcCoarseFreq    $00, $00, $02, $0C
	smpsVcRateScale     $03, $03, $01, $01
	smpsVcAttackRate    $1F, $1C, $18, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $04, $04, $0B, $04
	smpsVcDecayRate2    $08, $08, $0C, $06
	smpsVcDecayLevel    $0B, $0B, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $16, $26, $24

;	Voice $04
;	$02
;	$3C, $32, $55, $51, 	$1F, $98, $1F, $9F, 	$0F, $11, $0E, $11
;	$0E, $05, $08, $05, 	$5F, $0F, $6F, $0F, 	$2D, $2D, $2F, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $05, $05, $03, $03
	smpsVcCoarseFreq    $01, $05, $02, $0C
	smpsVcRateScale     $02, $00, $02, $00
	smpsVcAttackRate    $1F, $1F, $18, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $11, $0E, $11, $0F
	smpsVcDecayRate2    $05, $08, $05, $0E
	smpsVcDecayLevel    $00, $06, $00, $05
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $2F, $2D, $2D

