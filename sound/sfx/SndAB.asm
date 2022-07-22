SndAB_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndAB_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, SndAB_PSG3,	$00, $00

; PSG3 Data
SndAB_PSG3:
	smpsPSGvoice        $00
	smpsPSGform         $E7
	dc.b	nMaxPSG, $03, nRst, $03, nMaxPSG, $01, smpsNoAttack

SndAB_Loop00:
	dc.b	$01
	smpsPSGAlterVol     $01
	dc.b	smpsNoAttack
	smpsLoop            $00, $15, SndAB_Loop00
	smpsStop

; Song seems to not use any FM voices
SndAB_Voices:
