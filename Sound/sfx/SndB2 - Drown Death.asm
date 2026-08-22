SndB2_Drown_Death_Header:
	smpsHeaderStartSong 1, 1
	smpsHeaderVoice     SndB2_Drown_Death_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM4, SndB2_Drown_Death_FM4,	$0C, $04
	smpsHeaderSFXChannel cFM5, SndB2_Drown_Death_FM5,	$0E, $02

; FM5 Data
SndB2_Drown_Death_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $83, $0C

SndB2_Drown_Death_Loop01:
	dc.b	nA0, $05, $05
	smpsAlterVol        $03
	smpsLoop            $00, $0A, SndB2_Drown_Death_Loop01
	smpsStop

; FM4 Data
SndB2_Drown_Death_FM4:
	dc.b	nRst, $06
	smpsSetvoice        $00
	smpsModSet          $01, $01, $6F, $0E

SndB2_Drown_Death_Loop00:
	dc.b	nC1, $04, $05
	smpsAlterVol        $03
	smpsLoop            $00, $0A, SndB2_Drown_Death_Loop00
	smpsStop

SndB2_Drown_Death_Voices:
;	Voice $00
;	$35
;	$14, $1A, $04, $09, 	$0E, $10, $11, $0E, 	$0C, $15, $03, $06
;	$16, $0E, $09, $10, 	$2F, $2F, $4F, $4F, 	$2F, $12, $12, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $01, $01
	smpsVcCoarseFreq    $09, $04, $0A, $04
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0E, $11, $10, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $06, $03, $15, $0C
	smpsVcDecayRate2    $10, $09, $0E, $16
	smpsVcDecayLevel    $04, $04, $02, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $12, $12, $2F

