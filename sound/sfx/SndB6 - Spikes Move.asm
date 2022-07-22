SndB6_Spikes_Move_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndB6_Spikes_Move_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, SndB6_Spikes_Move_PSG3,	$00, $00

; PSG3 Data
SndB6_Spikes_Move_PSG3:
	smpsModSet          $01, $01, $F0, $08
	smpsPSGform         $E7
	dc.b	nE5, $07

SndB6_Spikes_Move_Loop00:
	dc.b	nG6, $01
	smpsPSGAlterVol     $01
	smpsLoop            $00, $0C, SndB6_Spikes_Move_Loop00
	smpsStop

; Song seems to not use any FM voices
SndB6_Spikes_Move_Voices:
