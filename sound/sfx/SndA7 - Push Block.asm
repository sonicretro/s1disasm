SndA7_Push_Block_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndA7_Push_Block_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM4, SndA7_Push_Block_FM4,	$00, $06

; FM4 Data
SndA7_Push_Block_FM4:
	smpsSetvoice        $00
	dc.b	nD1, $07, nRst, $02, nD1, $06, nRst, $10
	smpsClearPush
	smpsStop

SndA7_Push_Block_Voices:
;	Voice $00
;	$FA
;	$21, $30, $10, $32, 	$1F, $1F, $1F, $1F, 	$05, $18, $09, $02
;	$06, $0F, $06, $02, 	$1F, $2F, $4F, $2F, 	$0F, $0E, $0E, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $03
	smpsVcDetune        $03, $01, $03, $02
	smpsVcCoarseFreq    $02, $00, $00, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $02, $09, $18, $05
	smpsVcDecayRate2    $02, $06, $0F, $06
	smpsVcDecayLevel    $02, $04, $02, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $0E, $0E, $0F

