SndBD_ChainStomp_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndBD_ChainStomp_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM5, SndBD_ChainStomp_FM5,	$10, $0A
	smpsHeaderSFXChannel cFM4, SndBD_ChainStomp_FM4,	$00, $00

; FM5 Data
SndBD_ChainStomp_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $60, $01
	dc.b	nD3, $08
	smpsStop

; FM4 Data
SndBD_ChainStomp_FM4:
	dc.b	nRst, $08
	smpsSetvoice        $01
	dc.b	nEb0, $22
	smpsStop

SndBD_ChainStomp_Voices:
;	Voice $00
;	$FA
;	$21, $3A, $19, $30, 	$1F, $1F, $1F, $1F, 	$05, $18, $09, $02
;	$0B, $1F, $10, $05, 	$1F, $2F, $4F, $2F, 	$0E, $07, $04, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $03
	smpsVcDetune        $03, $01, $03, $02
	smpsVcCoarseFreq    $00, $09, $0A, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $02, $09, $18, $05
	smpsVcDecayRate2    $05, $10, $1F, $0B
	smpsVcDecayLevel    $02, $04, $02, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $04, $07, $0E

;	Voice $01
;	$FA
;	$31, $30, $10, $32, 	$1F, $1F, $1F, $1F, 	$05, $18, $05, $10
;	$0B, $1F, $10, $10, 	$1F, $2F, $1F, $2F, 	$0D, $00, $01, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $03
	smpsVcDetune        $03, $01, $03, $03
	smpsVcCoarseFreq    $02, $00, $00, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $10, $05, $18, $05
	smpsVcDecayRate2    $10, $10, $1F, $0B
	smpsVcDecayLevel    $02, $01, $02, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $01, $00, $0D

