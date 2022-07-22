SndC8_Burning_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndC8_Burning_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, SndC8_Burning_PSG3,	$00, $00

; PSG3 Data
SndC8_Burning_PSG3:
	smpsPSGvoice        $00
	smpsPSGform         $E7
	dc.b	nD3, $25
	smpsStop

; Song seems to not use any FM voices
SndC8_Burning_Voices:
