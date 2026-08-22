SndB0_Saw_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndB0_Saw_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, SndB0_Saw_FM5,	$FB, $05

; FM5 Data
SndB0_Saw_FM5:
	smpsSetvoice        $00
	dc.b	nBb7, $7F

SndB0_Saw_Loop00:
	dc.b	nBb7, $02
	smpsAlterVol        $01
	smpsLoop            $00, $1B, SndB0_Saw_Loop00
	smpsStop

SndB0_Saw_Voices:
;	Voice $00
;	$83
;	$1F, $15, $1F, $1F, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$02, $02, $02, $02, 	$2F, $2F, $FF, $3F, 	$0B, $16, $01, $82
	smpsVcAlgorithm     $03
	smpsVcFeedback      $00
	smpsVcUnusedBits    $02
	smpsVcDetune        $01, $01, $01, $01
	smpsVcCoarseFreq    $0F, $0F, $05, $0F
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $02, $02, $02, $02
	smpsVcDecayLevel    $03, $0F, $02, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $02, $01, $16, $0B

