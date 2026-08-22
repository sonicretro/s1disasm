SndC0_Basaran_Flap_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndC0_Basaran_Flap_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, SndC0_Basaran_Flap_FM5,	$00, $03

; FM5 Data
SndC0_Basaran_Flap_FM5:
	smpsSetvoice        $00
	dc.b	nG1, $05, nRst, $05, nG1, $04, nRst, $04
	smpsStop

SndC0_Basaran_Flap_Voices:
;	Voice $00
;	$38
;	$08, $08, $08, $08, 	$1F, $1F, $1F, $0E, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $1F, 	$00, $00, $00, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $08, $08, $08, $08
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0E, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $01, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $00, $00, $00

