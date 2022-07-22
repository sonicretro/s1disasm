SndA3_Death_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndA3_Death_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, SndA3_Death_FM5,	$F4, $00

; FM5 Data
SndA3_Death_FM5:
	smpsSetvoice        $00
	dc.b	nB3, $07, smpsNoAttack, nAb3

SndA3_Death_Loop00:
	dc.b	$01
	smpsAlterVol        $01
	smpsLoop            $00, $2F, SndA3_Death_Loop00
	smpsStop

SndA3_Death_Voices:
;	Voice $00
;	$30
;	$30, $30, $30, $30, 	$9E, $D8, $DC, $DC, 	$0E, $0A, $04, $05
;	$08, $08, $08, $08, 	$BF, $BF, $BF, $BF, 	$14, $3C, $14, $80
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
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $14, $3C, $14

