SndAC_Hit_Boss_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndAC_Hit_Boss_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, SndAC_Hit_Boss_FM5,	$00, $00

; FM5 Data
SndAC_Hit_Boss_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $0C, $01

SndAC_Hit_Boss_Loop00:
	dc.b	nC0, $0A
	smpsAlterVol        $10
	smpsLoop            $00, $04, SndAC_Hit_Boss_Loop00
	smpsStop

SndAC_Hit_Boss_Voices:
;	Voice $00
;	$F9
;	$21, $30, $10, $32, 	$1F, $1F, $1F, $1F, 	$05, $18, $09, $02
;	$0B, $1F, $10, $05, 	$1F, $2F, $4F, $2F, 	$0E, $07, $04, $80
	smpsVcAlgorithm     $01
	smpsVcFeedback      $07
	smpsVcUnusedBits    $03
	smpsVcDetune        $03, $01, $03, $02
	smpsVcCoarseFreq    $02, $00, $00, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $02, $09, $18, $05
	smpsVcDecayRate2    $05, $10, $1F, $0B
	smpsVcDecayLevel    $02, $04, $02, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $04, $07, $0E

