SndCC_Spring_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndCC_Spring_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM4, SndCC_Spring_FM4,	$00, $02

; FM4 Data
SndCC_Spring_FM4:
	smpsSetvoice        $00
	dc.b	nRst, $01
	smpsModSet          $03, $01, $5D, $0F
	dc.b	nB3, $0C
	smpsModOff

SndCC_Spring_Loop00:
	dc.b	smpsNoAttack
	smpsAlterVol        $02
	dc.b	nC5, $02
	smpsLoop            $00, $19, SndCC_Spring_Loop00
	smpsStop

SndCC_Spring_Voices:
;	Voice $00
;	$20
;	$36, $35, $30, $31, 	$DF, $DF, $9F, $9F, 	$07, $06, $09, $06
;	$07, $06, $06, $08, 	$2F, $1F, $1F, $FF, 	$16, $30, $13, $80
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
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $13, $30, $16

