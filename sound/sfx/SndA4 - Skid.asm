SndA4_Skid_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndA4_Skid_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cPSG2, SndA4_Skid_PSG2,	$F4, $00
	smpsHeaderSFXChannel cPSG3, SndA4_Skid_PSG3,	$F4, $00

; PSG2 Data
SndA4_Skid_PSG2:
	smpsPSGvoice        $00
	dc.b	nBb3, $01, nRst, nBb3, nRst, $03

SndA4_Skid_Loop01:
	dc.b	nBb3, $01, nRst, $01
	smpsLoop            $00, $0B, SndA4_Skid_Loop01
	smpsStop

; PSG3 Data
SndA4_Skid_PSG3:
	smpsPSGvoice        $00
	dc.b	nRst, $01, nAb3, nRst, nAb3, nRst, $03

SndA4_Skid_Loop00:
	dc.b	nAb3, $01, nRst, $01
	smpsLoop            $00, $0B, SndA4_Skid_Loop00
	smpsStop

; Song seems to not use any FM voices
SndA4_Skid_Voices:
