SndBC_Teleport_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndBC_Teleport_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM5, SndBC_Teleport_FM5,	$90, $00
	smpsHeaderSFXChannel cPSG3, SndBC_Teleport_PSG3,	$00, $00

; FM5 Data
SndBC_Teleport_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $C5, $1A
	dc.b	nE6, $07
	smpsStop

; PSG3 Data
SndBC_Teleport_PSG3:
	smpsPSGvoice        fTone_07
	dc.b	nRst, $07
	smpsModSet          $01, $02, $05, $FF
	smpsPSGform         $E7
	dc.b	nBb4, $4F
	smpsStop

SndBC_Teleport_Voices:
;	Voice $00
;	$FD
;	$09, $03, $00, $00, 	$1F, $1F, $1F, $1F, 	$10, $0C, $0C, $0C
;	$0B, $1F, $10, $05, 	$1F, $2F, $4F, $2F, 	$09, $84, $92, $8E
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $03
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $00, $03, $09
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0C, $0C, $0C, $10
	smpsVcDecayRate2    $05, $10, $1F, $0B
	smpsVcDecayLevel    $02, $04, $02, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $0E, $12, $04, $09

