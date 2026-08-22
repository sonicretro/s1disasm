SndB8_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndB8_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, SndB8_PSG3,	$00, $00

; PSG3 Data
SndB8_PSG3:
	smpsModSet          $01, $01, $F0, $08
	smpsPSGform         $E7
	dc.b	nEb4, $08

SndB8_Loop00:
	dc.b	nB3, $02
	smpsPSGAlterVol     $01
	smpsLoop            $00, $03, SndB8_Loop00
	smpsStop

; Song seems to not use any FM voices
SndB8_Voices:
