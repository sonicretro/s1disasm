SndCB_Wall_Smash_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndCB_Wall_Smash_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM5, SndCB_Wall_Smash_FM5,	$00, $00
	smpsHeaderSFXChannel cPSG3, SndCB_Wall_Smash_PSG3,	$00, $00

; FM5 Data
SndCB_Wall_Smash_FM5:
	smpsSetvoice        $00
	smpsModSet          $03, $01, $20, $04

SndCB_Wall_Smash_Loop00:
	dc.b	nC0, $18
	smpsAlterVol        $0A
	smpsLoop            $00, $06, SndCB_Wall_Smash_Loop00
	smpsStop

; PSG3 Data
SndCB_Wall_Smash_PSG3:
	smpsModSet          $01, $01, $0F, $05
	smpsPSGform         $E7

SndCB_Wall_Smash_Loop01:
	dc.b	nB3, $18, smpsNoAttack
	smpsPSGAlterVol     $03
	smpsLoop            $00, $05, SndCB_Wall_Smash_Loop01
	smpsStop

SndCB_Wall_Smash_Voices:
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

