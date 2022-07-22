Mus81_GHZ_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Mus81_GHZ_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $03

	smpsHeaderDAC       Mus81_GHZ_DAC
	smpsHeaderFM        Mus81_GHZ_FM1,	$F4, $12
	smpsHeaderFM        Mus81_GHZ_FM2,	$00, $0B
	smpsHeaderFM        Mus81_GHZ_FM3,	$F4, $14
	smpsHeaderFM        Mus81_GHZ_FM4,	$F4, $08
	smpsHeaderFM        Mus81_GHZ_FM5,	$F4, $20
	smpsHeaderPSG       Mus81_GHZ_PSG1,	$D0, $01, $00, fTone_03
	smpsHeaderPSG       Mus81_GHZ_PSG2,	$D0, $03, $00, fTone_06
	smpsHeaderPSG       Mus81_GHZ_PSG3,	$00, $03, $00, fTone_04

; FM1 Data
Mus81_GHZ_FM1:
	smpsSetvoice        $02
	smpsPan             panRight, $00
	smpsCall            Mus81_GHZ_Call02
	smpsPan             panCenter, $00

Mus81_GHZ_Loop0E:
	smpsPan             panLeft, $00
	dc.b	nE7, $04
	smpsPan             panRight, $00
	dc.b	nC7
	smpsAlterVol        $01
	smpsLoop            $00, $0D, Mus81_GHZ_Loop0E
	dc.b	nE7, $04, nRst, $14
	smpsAlterVol        $EB
	smpsPan             panCenter, $00
	dc.b	nRst, $40, nRst, nRst, nRst, nRst, nRst

Mus81_GHZ_Jump04:
	smpsSetvoice        $06
	smpsModSet          $0D, $01, $07, $04
	smpsAlterPitch      $F4
	dc.b	nRst, $20
	smpsCall            Mus81_GHZ_Call07
	dc.b	nC6, $38
	smpsCall            Mus81_GHZ_Call07
	dc.b	nC6, $08, $08, nE6
	smpsAlterPitch      $0C
	smpsSetvoice        $06
	smpsAlterPitch      $F4
	dc.b	nD6, $34, smpsNoAttack, $34, nC6, $08, nD6, nE6, $38, smpsNoAttack, $38, nC6
	dc.b	$08, nC6, nE6, nEb6, $34, smpsNoAttack, $34, nC6, $08, nEb6, nD6, $1C
	dc.b	smpsNoAttack, $1C
	smpsSetvoice        $05
	smpsAlterPitch      $F4
	smpsAlterVol        $0A
	dc.b	nRst, $08, nE7, $0C, nRst, $04
	smpsNoteFill        $0B
	dc.b	nE7, $08, nF7, nE7, nG7
	smpsNoteFill        $14
	dc.b	nE7, $10
	smpsNoteFill        $0B
	dc.b	nC7, $08
	smpsNoteFill        $00
	smpsAlterVol        $F6
	smpsAlterPitch      $18
	smpsJump            Mus81_GHZ_Jump04

Mus81_GHZ_Call02:
	dc.b	nA6, $04, nF6, nA6, nF6, nB6, nG6, nB6, nG6, nC7, nA6, nC7
	dc.b	nA6, nD7, nB6, nD7, nB6
	smpsReturn

Mus81_GHZ_Call07:
	dc.b	nC7, $08, nA6, $10, nC7, $08, nB6, $10, nC7, $08, nB6, $10
	dc.b	nG6, $30, nA6, $08, nE7, nD7, $10, nC7, $08, nB6, $10, nC7
	dc.b	$08, nB6, $10, nG6, $38, nC7, $08, nA6, $10, nC7, $08, nB6
	dc.b	$10, nC7, $08, nB6, $10, nG6, $30, nA6, $08, $08, nF6, $10
	dc.b	nA6, $08, nG6, $10, nA6, $08, nG6, $10
	smpsReturn

; FM2 Data
Mus81_GHZ_FM2:
	smpsSetvoice        $00
	smpsNop             $01
	dc.b	nRst, $08, nA2, nA3, nA2, nBb2, nBb3, nB2, nB3
	smpsNoteFill        $04
	smpsSetvoice        $01

Mus81_GHZ_Loop0C:
	dc.b	nC3, $08
	smpsLoop            $00, $18, Mus81_GHZ_Loop0C
	smpsNoteFill        $00
	dc.b	nC3, $04, nRst, nC3, $08, nA2, $04, nRst, nA2, $08, nBb2, $04
	dc.b	nRst, nBb2, $08, nB2, $04, nRst, nB2, $08
	smpsNoteFill        $04

Mus81_GHZ_Loop0D:
	dc.b	nC3, $08
	smpsLoop            $00, $1D, Mus81_GHZ_Loop0D
	smpsNoteFill        $00
	dc.b	nC3, nD3, nE3

Mus81_GHZ_Jump03:
	smpsSetvoice        $01
	smpsCall            Mus81_GHZ_Call05
	smpsCall            Mus81_GHZ_Call06
	smpsNoteFill        $00
	dc.b	nC3, nD3, nE3
	smpsCall            Mus81_GHZ_Call05
	smpsCall            Mus81_GHZ_Call06
	dc.b	nC3, nC3, nC3
	smpsNoteFill        $00
	smpsSetvoice        $00
	dc.b	nBb2, $18, nA2, nG2, nF2, nE2, $08, nRst, nD2, nRst, nA2, $18
	dc.b	nB2, nC3, nD3, nE3, $08, nRst, nA3, nRst, nAb3, $18, nG3, nF3
	dc.b	nEb3, nD3, $08, nRst, nC3, nRst, nG2, $18, nD3, nG2, nG3, $08
	dc.b	nE2, nE3, nF2, nF3, nG2, nG3
	smpsNoteFill        $04
	smpsNop             $01
	smpsJump            Mus81_GHZ_Jump03

Mus81_GHZ_Call05:
	smpsNoteFill        $04
	dc.b	nF3, $08, nF3, nF3, nF3, nF3, nF3, nF3
	smpsNoteFill        $00
	dc.b	nF3
	smpsNoteFill        $04
	dc.b	nE3, nE3, nE3, nE3, nE3
	smpsNoteFill        $00
	dc.b	nC3, nD3, nE3
	smpsNoteFill        $04
	dc.b	nF3, nF3, nF3, nF3, nF3, nF3, nF3
	smpsNoteFill        $00
	dc.b	nF3
	smpsNoteFill        $04
	dc.b	nE3, nE3, nE3, nE3, nE3
	smpsNoteFill        $00
	dc.b	nC3, nD3, nE3
	smpsReturn

Mus81_GHZ_Call06:
	smpsNoteFill        $04
	dc.b	nF3, nF3, nF3, nF3, nF3, nF3, nF3
	smpsNoteFill        $00
	dc.b	nF3
	smpsNoteFill        $04
	dc.b	nE3, nE3, nE3, nE3, nE3, nE3, nE3
	smpsNoteFill        $00
	dc.b	nE3
	smpsNoteFill        $04
	dc.b	nD3, nD3, nD3, nD3, nD3, nD3, nD3
	smpsNoteFill        $00
	dc.b	nD3
	smpsNoteFill        $04
	dc.b	nC3, nC3, nC3, nC3, nC3
	smpsReturn

; FM3 Data
Mus81_GHZ_FM3:
	smpsSetvoice        $02
	smpsPan             panLeft, $00
	smpsCall            Mus81_GHZ_Call02
	smpsSetvoice        $08
	smpsPan             panCenter, $00
	smpsAlterPitch      $E8
	smpsAlterVol        $FE
	dc.b	nRst, $01

Mus81_GHZ_Loop0A:
	dc.b	nC6, $01, smpsNoAttack, nB5, $0F, nRst, $08, nBb5, $01, smpsNoAttack, nA5, $0F
	dc.b	nRst, $08
	smpsLoop            $00, $02, Mus81_GHZ_Loop0A
	dc.b	nC6, $01, smpsNoAttack, nB5, $07, nRst, $08, nBb5, $01, smpsNoAttack, nA5, $07
	dc.b	nRst, $08, nCs6, $01, smpsNoAttack, nC6, $0F, nRst, $08, nC6, $01, smpsNoAttack
	dc.b	nB5, $0F, nRst, $08, nBb5, $01, smpsNoAttack, nA5, $10, smpsNoAttack, $3B, nRst
	dc.b	$04

Mus81_GHZ_Loop0B:
	dc.b	nBb5, $01, smpsNoAttack, nA5, $0F, nRst, $08, nC6, $01, smpsNoAttack, nB5, $0F
	dc.b	nRst, $08, nCs6, $01, smpsNoAttack, nC6, $07, nRst, $08
	smpsLoop            $00, $02, Mus81_GHZ_Loop0B
	dc.b	nCs6, $01, smpsNoAttack, nC6, $0F, nRst, $08, nC6, $01, smpsNoAttack, nB5, $28
	dc.b	smpsNoAttack, $3E
	smpsAlterVol        $02
	smpsAlterPitch      $18

Mus81_GHZ_Jump02:
	smpsSetvoice        $05
	smpsAlterPitch      $E8
	smpsCall            Mus81_GHZ_Call03
	dc.b	nA6
	smpsCall            Mus81_GHZ_Call03
	dc.b	nE7
	smpsCall            Mus81_GHZ_Call03
	dc.b	nA6, nRst, $24, nRst, nC7, $04, nRst, $0C, nA6, $10, nG6, $04
	dc.b	nRst, nA6, nRst, nC7, nRst
	smpsModOff
	smpsSetvoice        $05
	smpsCall            Mus81_GHZ_Call04
	dc.b	nG6, $04, nA6, nC7, $08, nA6
	smpsCall            Mus81_GHZ_Call04
	dc.b	nG6, $04, nA6, nC7, $08, nE7
	smpsCall            Mus81_GHZ_Call04
	dc.b	nG6, $04, nA6, nC7, $08, nA6
	smpsAlterVol        $06
	dc.b	nC5, nA4, $04, nRst, $16, nRst
	smpsAlterVol        $FA
	dc.b	nE7, $08, nRst, nC7, nRst, nA6, nA6, nA6, $04, nRst, nC7, nRst
	dc.b	nE7, nRst
	smpsAlterPitch      $18
	smpsSetvoice        $07
	smpsPan             panCenter, $00
	smpsNoteFill        $1E
	smpsAlterVol        $06
	dc.b	nF5, $18, $18, $18, $18, $08, nRst, nF5, nRst, nE5, $18, $18
	dc.b	$18, $18, $08, nRst, nE5, nRst, nEb5, $18, $18, $18, $18, $08
	dc.b	nRst, nEb5, nRst, nA5, $18, $18, $18, $18, $08, nRst, nA5, nRst
	smpsAlterVol        $FA
	smpsNoteFill        $00
	smpsJump            Mus81_GHZ_Jump02

Mus81_GHZ_Call03:
	dc.b	nRst, $34, nRst, nG6, $04, nA6, nC7, $08
	smpsReturn

Mus81_GHZ_Call04:
	smpsAlterVol        $06
	dc.b	nE5, $08, nC5, $04, nRst, $12, nRst, nE5, $08, nC5, $04, nRst
	dc.b	nD5, $08, nB4, $04, nRst, $0E, nRst
	smpsAlterVol        $FA
	smpsReturn

; FM4 Data
Mus81_GHZ_FM4:
	smpsSetvoice        $08
	dc.b	nRst, $20, nRst
	smpsPan             panLeft, $00
	smpsAlterPitch      $E8
	smpsAlterVol        $0A

Mus81_GHZ_Loop08:
	dc.b	nAb5, $01, smpsNoAttack, nG5, $0F, nRst, $08, nFs5, $01, smpsNoAttack, nF5, $0F
	dc.b	nRst, $08
	smpsLoop            $00, $02, Mus81_GHZ_Loop08
	dc.b	nAb5, $01, smpsNoAttack, nG5, $07, nRst, $08, nFs5, $01, smpsNoAttack, nF5, $07
	dc.b	nRst, $08, nBb5, $01, smpsNoAttack, nA5, $0F, nRst, $08, nAb5, $01, smpsNoAttack
	dc.b	nG5, $0F, nRst, $08, nFs5, $01, smpsNoAttack, nF5, $10, smpsNoAttack, $3C, nRst
	dc.b	$04

Mus81_GHZ_Loop09:
	dc.b	nFs5, $01, smpsNoAttack, nF5, $0F, nRst, $08, nAb5, $01, smpsNoAttack, nG5, $0F
	dc.b	nRst, $08, nBb5, $01, smpsNoAttack, nA5, $07, nRst, $08
	smpsLoop            $00, $02, Mus81_GHZ_Loop09
	dc.b	nBb5, $01, smpsNoAttack, nA5, $0F, nRst, $08, nAb5, $01, smpsNoAttack, nG5, $28
	dc.b	smpsNoAttack, $3F
	smpsAlterVol        $F6
	smpsAlterPitch      $18
	smpsModOff

Mus81_GHZ_Jump01:
	smpsSetvoice        $05
	smpsAlterPitch      $E8
	smpsAlterVol        $18
	smpsPan             panLeft, $00
	smpsAlterVol        $FD
	smpsCall            Mus81_GHZ_Call01
	dc.b	nD5, nD5, nE5, nE5, nC5, nC5, nA4, nA4, nF4, nF4, nD5, nD5
	dc.b	nB4, nB4, nG4, nG4, nD5, nD5
	smpsCall            Mus81_GHZ_Call01
	dc.b	nE4, nE4, nC5, nC5, nA4, nA4, nF4, nF4, nD4, nD4, nB4, nB4
	smpsAlterVol        $03
	smpsAlterPitch      $18
	smpsAlterPitch      $F4
	smpsSetvoice        $04
	dc.b	nG6, $10, nA6, nB6
	smpsAlterVol        $F9
	dc.b	nC7, $28, smpsNoAttack, $28, nD7, $10, nB6, nG6, nC7, $28, smpsNoAttack, $28
	dc.b	nB6, $10, nG6, nB6, nC7, $28, smpsNoAttack, $28, nD7, $10, nB6, nG6
	dc.b	nC7, $40, smpsNoAttack, $40
	smpsAlterPitch      $0C
	smpsAlterVol        $07
	smpsAlterVol        $E8
	smpsSetvoice        $07
	smpsNoteFill        $1E
	smpsPan             panCenter, $00
	smpsAlterVol        $12
	dc.b	nD5, $18, $18, $18, $18, $08, nRst, nD5, nRst, nC5, $18, $18
	dc.b	$18, $18, $08, nRst, nC5, nRst, nC5, $18, $18, $18, $18, $08
	dc.b	nRst, nC5, nRst, nF5, $18, $18, $18, $18, $08, nRst, nF5, nRst
	smpsAlterVol        $EE
	smpsNoteFill        $00
	smpsJump            Mus81_GHZ_Jump01

Mus81_GHZ_Call01:
	dc.b	nE5, $08, nE5, nC5, nC5, nA4, nA4, nF4, nF4, nD5, nD5, nB4
	dc.b	nB4, nG4, nG4
	smpsReturn

; FM5 Data
Mus81_GHZ_FM5:
	smpsSetvoice        $03
	dc.b	nRst, $20, nRst
	smpsSetvoice        $08
	smpsPan             panRight, $00
	smpsAlterPitch      $E8
	smpsAlterVol        $F2

Mus81_GHZ_Loop02:
	dc.b	nF5, $01, smpsNoAttack, nE5, $0F, nRst, $08, nEb5, $01, smpsNoAttack, nD5, $0F
	dc.b	nRst, $08
	smpsLoop            $00, $02, Mus81_GHZ_Loop02
	dc.b	nF5, $01, smpsNoAttack, nE5, $07, nRst, $08, nEb5, $01, smpsNoAttack, nD5, $07
	dc.b	nRst, $08, nFs5, $01, smpsNoAttack, nF5, $0F, nRst, $08, nF5, $01, smpsNoAttack
	dc.b	nE5, $0F, nRst, $08, nEb5, $01, smpsNoAttack, nD5, $10, smpsNoAttack, $3C, nRst
	dc.b	$04

Mus81_GHZ_Loop03:
	dc.b	nEb5, $01, smpsNoAttack, nD5, $0F, nRst, $08, nF5, $01, smpsNoAttack, nE5, $0F
	dc.b	nRst, $08, nFs5, $01, smpsNoAttack, nF5, $07, nRst, $08
	smpsLoop            $00, $02, Mus81_GHZ_Loop03
	dc.b	nFs5, $01, smpsNoAttack, nF5, $0F, nRst, $08, nF5, $01, smpsNoAttack, nE5, $28
	dc.b	smpsNoAttack, $3F
	smpsAlterPitch      $18
	smpsAlterVol        $0E

Mus81_GHZ_Jump00:
	smpsSetvoice        $05
	smpsAlterPitch      $E8
	smpsPan             panRight, $00
	smpsAlterVol        $FD
	smpsCall            Mus81_GHZ_Call00
	dc.b	nD5, nD5, nE5, nE5, nC5, nC5, nA4, nA4, nF4, nF4, nD5, nD5
	dc.b	nB4, nB4, nG4, nG4, nD5, nD5
	smpsCall            Mus81_GHZ_Call00
	dc.b	nE4, nE4, nC5, nC5, nA4, nA4, nF4, nF4, nD4, nD4, nB4, nB4
	smpsAlterPitch      $18
	smpsAlterVol        $03
	smpsAlterPitch      $F4
	smpsSetvoice        $04
	smpsAlterNote       $02
	dc.b	nG6, $10, nA6, nB6
	smpsAlterVol        $F9
	dc.b	nC7, $28, smpsNoAttack, $28, nD7, $10, nB6, nG6, nC7, $28, smpsNoAttack, $28
	dc.b	nB6, $10, nG6, nB6, nC7, $28, smpsNoAttack, $28, nD7, $10, nB6, nG6
	dc.b	nC7, $40, smpsNoAttack, $40
	smpsAlterPitch      $0C
	smpsAlterNote       $00
	smpsSetvoice        $04
	smpsAlterPitch      $F4
	smpsAlterVol        $FA

Mus81_GHZ_Loop04:
	dc.b	nBb6, $08, nF6, nD7, nF6, nBb6, nF6, nD7, nF6
	smpsLoop            $00, $02, Mus81_GHZ_Loop04

Mus81_GHZ_Loop05:
	dc.b	nA6, nE6, nC7, nE6, nA6, nE6, nC7, nE6
	smpsLoop            $00, $02, Mus81_GHZ_Loop05

Mus81_GHZ_Loop06:
	dc.b	nAb6, nEb6, nC7, nEb6, nAb6, nEb6, nC7, nEb6
	smpsLoop            $00, $02, Mus81_GHZ_Loop06

Mus81_GHZ_Loop07:
	dc.b	nC7, nA6, nE7, nA6, nC7, nA6, nE7, nA6
	smpsLoop            $00, $02, Mus81_GHZ_Loop07
	smpsAlterVol        $0D
	smpsAlterPitch      $0C
	smpsJump            Mus81_GHZ_Jump00

Mus81_GHZ_Call00:
	dc.b	nE5, $08, nE5, nC5, nC5, nA4, nA4, nF4, nF4, nD5, nD5, nB4
	dc.b	nB4, nG4, nG4
	smpsReturn

; PSG1 Data
Mus81_GHZ_PSG1:
	smpsPSGvoice        fTone_05
	smpsModSet          $0E, $01, $01, $03
	dc.b	nRst, $40
	smpsNoteFill        $10
	dc.b	nE5, $18, nD5, nE5, nD5, nE5, $08, nRst, nD5, nRst, nF5, $18
	dc.b	nE5
	smpsNoteFill        $00
	dc.b	nD5, $28, smpsNoAttack, $28
	smpsNoteFill        $10
	dc.b	nD5, $18, nE5, nF5, $10, nD5, $18, nE5, nF5, $10, $18
	smpsNoteFill        $00
	dc.b	nE5, $34, smpsNoAttack, $34
	smpsModOff

Mus81_GHZ_Loop13:
	smpsPSGvoice        fTone_01

Mus81_GHZ_Loop12:
	dc.b	nRst, $10, nC6, $04, nRst, $14, nC6, $08, nRst, $20, nB5, $04
	dc.b	nRst, $14, nB5, $08, nRst, $10
	smpsLoop            $01, $03, Mus81_GHZ_Loop12
	dc.b	nRst, $10, nA5, $04, nRst, $14, nA5, $08, nRst, $20, nG5, $04
	dc.b	nRst, $14, nG5, $08, nRst, $10
	smpsLoop            $00, $02, Mus81_GHZ_Loop13
	smpsPSGvoice        fTone_05
	dc.b	nBb6, $18, nA6, nG6, nF6, nE6, $08, nRst, nD6, nRst, nA5, $18
	dc.b	nB5, nC6, nD6, nE6, $08, nRst, nA6, nRst, nAb6, $18, nG6, nF6
	dc.b	nEb6, nD6, $10, nC6, $08, nRst, nRst, $08, nG6, nA6, nG6, $10
	dc.b	$08, nA6, nRst, $10
	smpsPSGAlterVol     $01
	dc.b	nA5, $18, $08, nRst, nA5, nRst
	smpsPSGAlterVol     $FF
	smpsPSGvoice        fTone_03
	smpsJump            Mus81_GHZ_Loop13

; PSG2 Data
Mus81_GHZ_PSG2:
	dc.b	nRst, $40
	smpsPSGAlterVol     $FE

Mus81_GHZ_Loop0F:
	smpsNoteFill        $06
	dc.b	nC7, $08, nB6, nA6, nG6, nC7, nB6, nA6, nG6
	smpsLoop            $00, $08, Mus81_GHZ_Loop0F
	smpsNoteFill        $00

Mus81_GHZ_Loop11:
	smpsPSGvoice        fTone_01

Mus81_GHZ_Loop10:
	dc.b	nRst, $10, nE6, $04, nRst, $14, nE6, $08, nRst, $20, nD6, $04
	dc.b	nRst, $14, nD6, $08, nRst, $10
	smpsLoop            $01, $03, Mus81_GHZ_Loop10
	dc.b	nRst, $10, nC6, $04, nRst, $14, nC6, $08, nRst, $20, nB5, $04
	dc.b	nRst, $14, nB5, $08, nRst, $10
	smpsLoop            $00, $02, Mus81_GHZ_Loop11
	dc.b	nD6, $34, smpsNoAttack, $34, nC6, $08, nD6, nE6, $38, smpsNoAttack, $38, nC6
	dc.b	$08, nC6, nE6, nEb6, $34, smpsNoAttack, $34, nC6, $08, nEb6, nD6
	smpsPSGvoice        fTone_05
	dc.b	nC5, $18, $18, $18, $18, $08, nRst, nC5, nRst
	smpsPSGvoice        fTone_03
	smpsJump            Mus81_GHZ_Loop11

; PSG3 Data
Mus81_GHZ_PSG3:
	smpsPSGform         $E7
	smpsNoteFill        $06
	dc.b	nMaxPSG, $10, $10, $10

Mus81_GHZ_Jump05:
	dc.b	$08
	smpsJump            Mus81_GHZ_Jump05

; DAC Data
Mus81_GHZ_DAC:
	dc.b	nRst, $08, dKick, dSnare, dKick, dKick, dSnare, dSnare, dSnare

Mus81_GHZ_Loop00:
	dc.b	dKick, $10, dSnare, $08, dKick, $10, $08, dSnare, $10
	smpsLoop            $00, $07, Mus81_GHZ_Loop00
	dc.b	dKick, $10, dSnare, $08, dKick, $10, dSnare, $08, $08, $08

Mus81_GHZ_Loop01:
	dc.b	dKick, $10, dSnare, $08, dKick, $10, $08, dSnare, $10
	smpsLoop            $00, $07, Mus81_GHZ_Loop01
	dc.b	dKick, $10, dSnare, $08, dKick, $10, dSnare, $08, $08, $08
	smpsLoop            $01, $02, Mus81_GHZ_Loop01
	smpsJump            Mus81_GHZ_Loop01

Mus81_GHZ_Voices:
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
;	$20
;	$36, $35, $30, $31, 	$DF, $DF, $9F, $9F, 	$07, $06, $09, $06
;	$07, $06, $06, $08, 	$20, $10, $10, $F8, 	$19, $37, $13, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $01, $00, $05, $06
	smpsVcRateScale     $02, $02, $03, $03
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $06, $09, $06, $07
	smpsVcDecayRate2    $08, $06, $06, $07
	smpsVcDecayLevel    $0F, $01, $01, $02
	smpsVcReleaseRate   $08, $00, $00, $00
	smpsVcTotalLevel    $00, $13, $37, $19

;	Voice $02
;	$36
;	$0F, $01, $01, $01, 	$1F, $1F, $1F, $1F, 	$12, $11, $0E, $00
;	$00, $0A, $07, $09, 	$FF, $0F, $1F, $0F, 	$18, $80, $80, $80
	smpsVcAlgorithm     $06
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $01, $0F
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $0E, $11, $12
	smpsVcDecayRate2    $09, $07, $0A, $00
	smpsVcDecayLevel    $00, $01, $00, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $00, $00, $18

;	Voice $03
;	$3D
;	$01, $02, $02, $02, 	$14, $0E, $8C, $0E, 	$08, $05, $02, $05
;	$00, $0D, $0D, $0D, 	$1F, $1F, $1F, $1F, 	$1A, $80, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $02, $02, $01
	smpsVcRateScale     $00, $02, $00, $00
	smpsVcAttackRate    $0E, $0C, $0E, $14
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $02, $05, $08
	smpsVcDecayRate2    $0D, $0D, $0D, $00
	smpsVcDecayLevel    $01, $01, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $00, $00, $1A

;	Voice $04
;	$2C
;	$72, $78, $34, $34, 	$1F, $12, $1F, $12, 	$00, $0A, $00, $0A
;	$00, $00, $00, $00, 	$0F, $1F, $0F, $1F, 	$16, $80, $17, $80
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
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $17, $00, $16

;	Voice $05
;	$2C
;	$74, $74, $34, $34, 	$1F, $12, $1F, $1F, 	$00, $00, $00, $00
;	$00, $01, $00, $01, 	$0F, $3F, $0F, $3F, 	$16, $80, $17, $80
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
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $17, $00, $16

;	Voice $06
;	$04
;	$72, $42, $32, $32, 	$12, $12, $12, $12, 	$00, $08, $00, $08
;	$00, $08, $00, $08, 	$0F, $1F, $0F, $1F, 	$23, $80, $23, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $04, $07
	smpsVcCoarseFreq    $02, $02, $02, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $12, $12, $12, $12
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $08, $00, $08, $00
	smpsVcDecayRate2    $08, $00, $08, $00
	smpsVcDecayLevel    $01, $00, $01, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $23, $00, $23

;	Voice $07
;	$3D
;	$01, $02, $02, $02, 	$10, $50, $50, $50, 	$07, $08, $08, $08
;	$01, $00, $00, $00, 	$20, $17, $17, $17, 	$1C, $80, $80, $80
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
	smpsVcReleaseRate   $07, $07, $07, $00
	smpsVcTotalLevel    $00, $00, $00, $1C

;	Voice $08
;	$2C
;	$74, $74, $34, $34, 	$1F, $12, $1F, $1F, 	$00, $07, $00, $07
;	$00, $07, $00, $07, 	$00, $38, $00, $38, 	$16, $80, $17, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $04, $04, $04, $04
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $12, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $07, $00, $07, $00
	smpsVcDecayRate2    $07, $00, $07, $00
	smpsVcDecayLevel    $03, $00, $03, $00
	smpsVcReleaseRate   $08, $00, $08, $00
	smpsVcTotalLevel    $00, $17, $00, $16

