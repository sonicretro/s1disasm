SndA5_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndA5_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, SndA5_FM5,	$00, $00

; FM5 Data
SndA5_FM5:
	smpsSetvoice        $00
	dc.b	nRst, $01, nBb0, $0A, nRst, $02
	smpsStop

SndA5_Voices:
;	Voice $00
;	$FA
;	$21, $30, $10, $32, 	$2F, $1F, $2F, $2F, 	$05, $08, $09, $02
;	$06, $0F, $06, $02, 	$1F, $2F, $4F, $2F, 	$0F, $1A, $0E, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $03
	smpsVcDetune        $03, $01, $03, $02
	smpsVcCoarseFreq    $02, $00, $00, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $2F, $2F, $1F, $2F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $02, $09, $08, $05
	smpsVcDecayRate2    $02, $06, $0F, $06
	smpsVcDecayLevel    $02, $04, $02, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $0E, $1A, $0F

