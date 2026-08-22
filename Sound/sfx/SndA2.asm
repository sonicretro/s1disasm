SndA2_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndA2_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, SndA2_PSG3,	$00, $00

; PSG3 Data
SndA2_PSG3:
	smpsModSet          $01, $01, $F0, $08
	smpsPSGform         $E7
	dc.b	nEb5, $04, nCs6, $04

SndA2_Loop00:
	dc.b	nEb5, $01
	smpsPSGAlterVol     $01
	smpsLoop            $00, $06, SndA2_Loop00
	smpsStop

; Song seems to not use any FM voices
SndA2_Voices:
