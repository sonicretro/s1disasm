; ===========================================================================
; Created by Flamewing, based on S1SMPS2ASM version 1.1 by Marc Gordon (AKA Cinossu)
; ===========================================================================
; Permission to use, copy, modify, and/or distribute this software for any
; purpose with or without fee is hereby granted.
;
; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
; OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
; ===========================================================================

SMPS2ASMVer	= 1

; PSG conversion to S3/S&K/S3D drivers require a tone shift of 12 semi-tones.
psgdelta	EQU 12
; ---------------------------------------------------------------------------
; Standard Octave Pitch Equates
	enumconf	$C
	enum		smpsPitch10lo=$88,smpsPitch09lo,smpsPitch08lo,smpsPitch07lo,smpsPitch06lo
	nextenum	smpsPitch05lo,smpsPitch04lo,smpsPitch03lo,smpsPitch02lo,smpsPitch01lo
	enum		smpsPitch00=$00,smpsPitch01hi,smpsPitch02hi,smpsPitch03hi,smpsPitch04hi
	nextenum	smpsPitch05hi,smpsPitch06hi,smpsPitch07hi,smpsPitch08hi,smpsPitch09hi
	nextenum	smpsPitch10hi
	enumconf	1
; ---------------------------------------------------------------------------
; Note Equates
	enum		nRst=$80,nC0,nCs0,nD0,nEb0,nE0,nF0,nFs0,nG0,nAb0,nA0,nBb0,nB0,nC1,nCs1,nD1
	nextenum	nEb1,nE1,nF1,nFs1,nG1,nAb1,nA1,nBb1,nB1,nC2,nCs2,nD2,nEb2,nE2,nF2,nFs2
	nextenum	nG2,nAb2,nA2,nBb2,nB2,nC3,nCs3,nD3,nEb3,nE3,nF3,nFs3,nG3,nAb3,nA3,nBb3
	nextenum	nB3,nC4,nCs4,nD4,nEb4,nE4,nF4,nFs4,nG4,nAb4,nA4,nBb4,nB4,nC5,nCs5,nD5
	nextenum	nEb5,nE5,nF5,nFs5,nG5,nAb5,nA5,nBb5,nB5,nC6,nCs6,nD6,nEb6,nE6,nF6,nFs6
	nextenum	nG6,nAb6,nA6,nBb6,nB6,nC7,nCs7,nD7,nEb7,nE7,nF7,nFs7,nG7,nAb7,nA7,nBb7
; SMPS2ASM uses nMaxPSG for songs from S1/S2 drivers.
; nMaxPSG1 and nMaxPSG2 are used only for songs from S3/S&K/S3D drivers.
; The use of psgdelta is intended to undo the effects of PSGPitchConvert
; and ensure that the ending note is indeed the maximum PSG frequency.
	if SonicDriverVer<=2
nMaxPSG				EQU nA5
nMaxPSG1			EQU nA5+psgdelta
nMaxPSG2			EQU nA5+psgdelta
	else
nMaxPSG				EQU nBb6-psgdelta
nMaxPSG1			EQU nBb6
nMaxPSG2			EQU nB6
	endif
; ---------------------------------------------------------------------------
; PSG volume envelope equates
	switch SonicDriverVer
		case 1
			enum		fTone_01=$01,fTone_02,fTone_03,fTone_04,fTone_05,fTone_06
			nextenum	fTone_07,fTone_08,fTone_09
		case 2
			enum		fTone_01=$01,fTone_02,fTone_03,fTone_04,fTone_05,fTone_06
			nextenum	fTone_07,fTone_08,fTone_09,fTone_0A,fTone_0B,fTone_0C
			nextenum	fTone_0D
		elsecase;SonicDriverVer>=3
			enum		sTone_01=$01,sTone_02,sTone_03,sTone_04,sTone_05,sTone_06
			nextenum	sTone_07,sTone_08,sTone_09,sTone_0A,sTone_0B,sTone_0C
			nextenum	sTone_0D,sTone_0E,sTone_0F,sTone_10,sTone_11,sTone_12
			nextenum	sTone_13,sTone_14,sTone_15,sTone_16,sTone_17,sTone_18
			nextenum	sTone_19,sTone_1A,sTone_1B,sTone_1C,sTone_1D,sTone_1E
			nextenum	sTone_1F,sTone_20,sTone_21,sTone_22,sTone_23,sTone_24
			nextenum	sTone_25,sTone_26,sTone_27
			; For conversions:
			if SonicDriverVer>=5
				nextenum	fTone_01,fTone_02,fTone_03,fTone_04,fTone_05,fTone_06
				nextenum	fTone_07,fTone_08,fTone_09,fTone_0A,fTone_0B,fTone_0C
				nextenum	fTone_0D
			endif
	endcase
; ---------------------------------------------------------------------------
; DAC Equates
	switch SonicDriverVer
		case 1
			enum		dKick=$81,dSnare,dTimpani
			enum		dHiTimpani=$88,dMidTimpani,dLowTimpani,dVLowTimpani
		case 2
			enum		dKick=$81,dSnare,dClap,dScratch,dTimpani,dHiTom,dVLowClap,dHiTimpani,dMidTimpani
			nextenum	dLowTimpani,dVLowTimpani,dMidTom,dLowTom,dFloorTom,dHiClap
			nextenum	dMidClap,dLowClap
		case 3
			enum		dSnareS3=$81,dHighTom,dMidTomS3,dLowTomS3,dFloorTomS3,dKickS3,dMuffledSnare
			nextenum	dCrashCymbal,dRideCymbal,dLowMetalHit,dMetalHit,dHighMetalHit
			nextenum	dHigherMetalHit,dMidMetalHit,dClapS3,dElectricHighTom
			nextenum	dElectricMidTom,dElectricLowTom,dElectricFloorTom
			nextenum	dTightSnare,dMidpitchSnare,dLooseSnare,dLooserSnare
			nextenum	dHiTimpaniS3,dLowTimpaniS3,dMidTimpaniS3,dQuickLooseSnare
			nextenum	dClick,dPowerKick,dQuickGlassCrash
			nextenum	dGlassCrashSnare,dGlassCrash,dGlassCrashKick,dQuietGlassCrash
			nextenum	dOddSnareKick,dKickExtraBass,dComeOn,dDanceSnare,dLooseKick
			nextenum	dModLooseKick,dWoo,dGo,dSnareGo,dPowerTom,dHiWoodBlock,dLowWoodBlock
			nextenum	dHiHitDrum,dLowHitDrum,dMetalCrashHit,dEchoedClapHit_S3
			nextenum	dLowerEchoedClapHit_S3,dHipHopHitKick,dHipHopHitPowerKick
			nextenum	dBassHey,dDanceStyleKick,dHipHopHitKick2,dHipHopHitKick3
			nextenum	dReverseFadingWind,dScratchS3,dLooseSnareNoise,dPowerKick2
			nextenum	dCrashingNoiseWoo,dQuickHit,dKickHey,dPowerKickHit
			nextenum	dLowPowerKickHit,dLowerPowerKickHit,dLowestPowerKickHit
		case 4
			enum		dSnareS3=$81,dHighTom,dMidTomS3,dLowTomS3,dFloorTomS3,dKickS3,dMuffledSnare
			nextenum	dCrashCymbal,dRideCymbal,dLowMetalHit,dMetalHit,dHighMetalHit
			nextenum	dHigherMetalHit,dMidMetalHit,dClapS3,dElectricHighTom
			nextenum	dElectricMidTom,dElectricLowTom,dElectricFloorTom
			nextenum	dTightSnare,dMidpitchSnare,dLooseSnare,dLooserSnare
			nextenum	dHiTimpaniS3,dLowTimpaniS3,dMidTimpaniS3,dQuickLooseSnare
			nextenum	dClick,dPowerKick,dQuickGlassCrash
			nextenum	dGlassCrashSnare,dGlassCrash,dGlassCrashKick,dQuietGlassCrash
			nextenum	dOddSnareKick,dKickExtraBass,dComeOn,dDanceSnare,dLooseKick
			nextenum	dModLooseKick,dWoo,dGo,dSnareGo,dPowerTom,dHiWoodBlock,dLowWoodBlock
			nextenum	dHiHitDrum,dLowHitDrum,dMetalCrashHit,dEchoedClapHit
			nextenum	dLowerEchoedClapHit,dHipHopHitKick,dHipHopHitPowerKick
			nextenum	dBassHey,dDanceStyleKick,dHipHopHitKick2,dHipHopHitKick3
			nextenum	dReverseFadingWind,dScratchS3,dLooseSnareNoise,dPowerKick2
			nextenum	dCrashingNoiseWoo,dQuickHit,dKickHey,dPowerKickHit
			nextenum	dLowPowerKickHit,dLowerPowerKickHit,dLowestPowerKickHit
		elsecase;SonicDriverVer>=5
			if (use_s3_samples<>0)||(use_sk_samples<>0)||(use_s3d_samples<>0)
				enum		dSnareS3=$81,dHighTom,dMidTomS3,dLowTomS3,dFloorTomS3,dKickS3,dMuffledSnare
				nextenum	dCrashCymbal,dRideCymbal,dLowMetalHit,dMetalHit,dHighMetalHit
				nextenum	dHigherMetalHit,dMidMetalHit,dClapS3,dElectricHighTom
				nextenum	dElectricMidTom,dElectricLowTom,dElectricFloorTom
				nextenum	dTightSnare,dMidpitchSnare,dLooseSnare,dLooserSnare
				nextenum	dHiTimpaniS3,dLowTimpaniS3,dMidTimpaniS3,dQuickLooseSnare
				nextenum	dClick,dPowerKick,dQuickGlassCrash
			endif
			if (use_s3_samples<>0)||(use_sk_samples<>0)
				nextenum	dGlassCrashSnare,dGlassCrash,dGlassCrashKick,dQuietGlassCrash
				nextenum	dOddSnareKick,dKickExtraBass,dComeOn,dDanceSnare,dLooseKick
				nextenum	dModLooseKick,dWoo,dGo,dSnareGo,dPowerTom,dHiWoodBlock,dLowWoodBlock
				nextenum	dHiHitDrum,dLowHitDrum,dMetalCrashHit,dEchoedClapHit
				nextenum	dLowerEchoedClapHit,dHipHopHitKick,dHipHopHitPowerKick
				nextenum	dBassHey,dDanceStyleKick,dHipHopHitKick2,dHipHopHitKick3
				nextenum	dReverseFadingWind,dScratchS3,dLooseSnareNoise,dPowerKick2
				nextenum	dCrashingNoiseWoo,dQuickHit,dKickHey,dPowerKickHit
				nextenum	dLowPowerKickHit,dLowerPowerKickHit,dLowestPowerKickHit
			endif
			; For conversions:
			if (use_s2_samples<>0)
				if (use_s3_samples<>0)||(use_sk_samples<>0)||(use_s3d_samples<>0)
					nextenum	dKick
				else
					enum		dKick=$81
				endif
				nextenum	dSnare,dClap,dScratch,dTimpani,dHiTom,dVLowClap,dHiTimpani,dMidTimpani
				nextenum	dLowTimpani,dVLowTimpani,dMidTom,dLowTom,dFloorTom,dHiClap
				nextenum	dMidClap,dLowClap
			endif
			if (use_s3d_samples<>0)
				nextenum	dFinalFightMetalCrash,dIntroKick
			endif
			if (use_s3_samples<>0)
				nextenum	dEchoedClapHit_S3,dLowerEchoedClapHit_S3
			endif
	endcase
; ---------------------------------------------------------------------------
; Channel IDs for SFX
cPSG1				EQU $80
cPSG2				EQU $A0
cPSG3				EQU $C0
cNoise				EQU $E0	; Not for use in S3/S&K/S3D
cFM3				EQU $02
cFM4				EQU $04
cFM5				EQU $05
cFM6				EQU $06	; Only in S3/S&K/S3D, overrides DAC
; ---------------------------------------------------------------------------
; Conversion macros and functions

conv0To256  function n,((n==0)<<8)|n
s2TempotoS1 function n,(((768-n)>>1)/(256-n))&$FF
s2TempotoS3 function n,($100-((n==0)|n))&$FF
s1TempotoS2 function n,((((conv0To256(n)-1)<<8)+(conv0To256(n)>>1))/conv0To256(n))&$FF
s1TempotoS3 function n,s2TempotoS3(s1TempotoS2(n))
s3TempotoS1 function n,s2TempotoS1(s2TempotoS3(n))
s3TempotoS2 function n,s2TempotoS3(n)

convertMainTempoMod macro mod
	if ((SourceDriver>=3)&&(SonicDriverVer>=3))||(SonicDriverVer==SourceDriver)
		dc.b	mod
	elseif SourceDriver==1
		if mod==1
			fatal "Invalid main tempo of 1 in song from Sonic 1"
		endif
		if SonicDriverVer==2
			dc.b	s1TempotoS2(mod)
		else;if SonicDriverVer>=3
			dc.b	s1TempotoS3(mod)
		endif
	elseif SourceDriver==2
		if mod==0
			fatal "Invalid main tempo of 0 in song from Sonic 2"
		endif
		if SonicDriverVer==1
			dc.b	s2TempotoS1(mod)
		else;if SonicDriverVer>=3
			dc.b	s2TempotoS3(mod)
		endif
	else;if SourceDriver>=3
		if mod==0
			message "Performing approximate conversion of Sonic 3 main tempo modifier of 0"
		endif
		if SonicDriverVer==1
			dc.b	s3TempotoS1(mod)
		else;if SonicDriverVer==2
			dc.b	s3TempotoS2(mod)
		endif
	endif
	endm

; PSG conversion to S3/S&K/S3D drivers require a tone shift of 12 semi-tones.
PSGPitchConvert macro pitch
	if (SonicDriverVer>=3)&&(SourceDriver<3)
		dc.b	(pitch+psgdelta)&$FF
	elseif (SonicDriverVer<3)&&(SourceDriver>=3)
		dc.b	(pitch-psgdelta)&$FF
	else
		dc.b	pitch
	endif
	endm

CheckedChannelPointer macro loc
	if SonicDriverVer<>1
		dc.w	z80_ptr(loc)
	else
		if MOMPASS>1
			if loc<songStart
				fatal "Tracks for Sonic 1 songs must come after the start of the song"
			endif
		endif
		dc.w	loc-songStart
	endif
	endm
; ---------------------------------------------------------------------------
; Header Macros
smpsHeaderStartSong macro ver, sourcesmps2asmver

SourceDriver set ver

	if ("sourcesmps2asmver"<>"")
		set SourceSMPS2ASM,sourcesmps2asmver
	else
		set SourceSMPS2ASM,0
	endif

songStart set *

	if MOMPASS>1
		if SMPS2ASMVer < SourceSMPS2ASM
			message "Song at 0x\{songStart} was made for a newer version of SMPS2ASM (this is version \{SMPS2ASMVer}, but song wants at least version \{SourceSMPS2ASM})."
		endif
	endif

	endm

smpsHeaderVoiceNull macro
	if songStart<>*
		fatal "Missing smpsHeaderStartSong"
	endif
	dc.w	$0000
	endm

; Header - Set up Voice Location
; Common to music and SFX
smpsHeaderVoice macro loc
	if songStart<>*
		fatal "Missing smpsHeaderStartSong"
	endif
	if SonicDriverVer<>1
		dc.w	z80_ptr(loc)
	else
		if MOMPASS>1
			if loc<songStart
				fatal "Voice banks for Sonic 1 songs must come after the song"
			endif
		endif
		dc.w	loc-songStart
	endif
	endm

; Header - Set up Voice Location as S3's Universal Voice Bank
; Common to music and SFX
smpsHeaderVoiceUVB macro
	if songStart<>*
		fatal "Missing smpsHeaderStartSong"
	endif
	if SonicDriverVer>=5
		dc.w	z80_ptr(z80_UniVoiceBank)
	elseif SonicDriverVer>=3
		dc.w	little_endian(z80_UniVoiceBank)
	else
		fatal "Universal Voice Bank does not exist in Sonic 1 or Sonic 2 drivers"
	endif
	endm

; Header macros for music (not for SFX)
; Header - Set up Channel Usage
smpsHeaderChan macro fm,psg
	dc.b	fm,psg
	endm

; Header - Set up Tempo
smpsHeaderTempo macro div,mod
	dc.b	div
	convertMainTempoMod mod
	endm

; Header - Set up DAC Channel
smpsHeaderDAC macro loc,pitch,vol
	CheckedChannelPointer loc
	if ("pitch"<>"")
		dc.b	pitch
		if ("vol"<>"")
			dc.b	vol
		else
			dc.b	$00
		endif
	else
		dc.w	$00
	endif
	endm

; Header - Set up FM Channel
smpsHeaderFM macro loc,pitch,vol
	CheckedChannelPointer loc
	dc.b	pitch,vol
	endm

; Header - Set up PSG Channel
smpsHeaderPSG macro loc,pitch,vol,mod,voice
	CheckedChannelPointer loc
	PSGPitchConvert pitch
	dc.b	vol
	; Frequency envelope
	if (SonicDriverVer>=3) && (SourceDriver<3)
		; In SMPS 68k Type 1, this byte is skipped and can contain garbage.
		; Sonic 2's Oil Ocean Zone and Ending themes set this byte to a non-zero value which
		; other drivers may try to process as valid data, so manually force it to 0 here.
		dc.b	0
	else
		if (MOMPASS==2) && (SonicDriverVer<3) && (SourceDriver>=3) && (mod<>0)
			message "This track header specifies a frequency envelope, but this driver does not support them."			
		endif
		dc.b	mod
	endif
	; Volume envelope
	dc.b	voice
	endm

; Header macros for SFX (not for music)
; Header - Set up Tempo
smpsHeaderTempoSFX macro div
	dc.b	div
	endm

; Header - Set up Channel Usage
smpsHeaderChanSFX macro chan
	dc.b	chan
	endm

; Header - Set up FM Channel
smpsHeaderSFXChannel macro chanid,loc,pitch,vol
	if (SonicDriverVer>=3)&&(chanid==cNoise)
		fatal "Using channel ID of cNoise ($E0) in Sonic 3 driver is dangerous. Fix the song so that it turns into a noise channel instead."
	elseif (SonicDriverVer<3)&&(chanid==cFM6)
		fatal "Using channel ID of FM6 ($06) in Sonic 1 or Sonic 2 drivers is unsupported. Change it to another channel."
	endif
	dc.b	$80,chanid
	CheckedChannelPointer loc
	if (chanid&$80)<>0
		PSGPitchConvert pitch
	else
		dc.b	pitch
	endif
	dc.b	vol
	endm
; ---------------------------------------------------------------------------
; Co-ord Flag Macros and Equates
; E0xx - Panning, AMS, FMS
smpsPan macro direction,amsfms
panNone set $00
panRight set $40
panLeft set $80
panCentre set $C0
panCenter set $C0 ; silly Americans :U
	dc.b $E0,direction+amsfms
	endm

; E1xx - Set channel detune to val
smpsDetune macro val
	dc.b	$E1,val
	endm

; E2xx - Useless
smpsNop macro val
	if SonicDriverVer<3
		dc.b	$E2,val
	endif
	endm

; Return (used after smpsCall)
smpsReturn macro val
	if SonicDriverVer>=3
		dc.b	$F9
	else
		dc.b	$E3
	endif
	endm

; Fade in previous song (ie. 1-Up)
smpsFade macro val
	if SonicDriverVer>=3
		dc.b	$E2
		if ("val"<>"")
			dc.b	val
		else
			dc.b	$FF
		endif
		if SourceDriver<3
			smpsStop
		endif
	elseif (SourceDriver>=3) && ("val"<>"") && ("val"<>"$FF")
		; This is one of those weird S3+ "fades" that we don't need
	else
		dc.b	$E4
	endif
	endm

; E5xx - Set channel tempo divider to xx
smpsChanTempoDiv macro val
	if SonicDriverVer>=5
		; New flag unique to Flamewing's modified S&K driver
		dc.b	$FF,$08,val
	elseif SonicDriverVer==3
		fatal "Coord. Flag to set tempo divider of a single channel does not exist in S3 driver. Use Flamewing's modified S&K sound driver instead."
	else
		dc.b	$E5,val
	endif
	endm

; E6xx - Alter Volume by xx
smpsAlterVol macro val
	dc.b	$E6,val
	endm

; E7 - Prevent attack of next note
smpsNoAttack	EQU $E7

; E8xx - Set note fill to xx
smpsNoteFill macro val
	if (SonicDriverVer>=5)&&(SourceDriver<3)
		; Unique to Flamewing's modified driver
		dc.b	$FF,$0A,val
	else
		if (SonicDriverVer>=3)&&(SourceDriver<3)
			message "Note fill will not work as intended unless you divide the fill value by the tempo divider or complain to Flamewing to add an appropriate coordination flag for it."
		elseif (SonicDriverVer<3)&&(SourceDriver>=3)
			message "Note fill will not work as intended unless you multiply the fill value by the tempo divider or complain to Flamewing to add an appropriate coordination flag for it."
		endif
		dc.b	$E8,val
	endif
	endm

; Add xx to channel pitch
smpsChangeTransposition macro val
	if SonicDriverVer>=3
		dc.b	$FB,val
	else
		dc.b	$E9,val
	endif
	endm

; Set music tempo modifier to xx
smpsSetTempoMod macro mod
	if SonicDriverVer>=3
		dc.b	$FF,$00
	else
		dc.b	$EA
	endif
	convertMainTempoMod mod
	endm

; Set music tempo divider to xx
smpsSetTempoDiv macro val
	if SonicDriverVer>=3
		dc.b	$FF,$04,val
	else
		dc.b	$EB,val
	endif
	endm

; ECxx - Set Volume to xx
smpsSetVol macro val
	if SonicDriverVer>=3
		dc.b	$E4,val
	else
		fatal "Coord. Flag to set volume (instead of volume attenuation) does not exist in S1 or S2 drivers. Complain to Flamewing to add it."
	endif
	endm

; Works on all drivers
smpsPSGAlterVol macro vol
	dc.b	$EC,vol
	endm

; Clears pushing sound flag in S1
smpsClearPush macro
	if SonicDriverVer==1
		dc.b	$ED
	else
		fatal "Coord. Flag to clear S1 push block flag does not exist in S2 or S3 drivers. Complain to Flamewing to add it."
	endif
	endm

; Stops special SFX (S1 only) and restarts overridden music track
smpsStopSpecial macro
	if SonicDriverVer==1
		dc.b	$EE
	else
		message "Coord. Flag to stop special SFX does not exist in S2 or S3 drivers. Complain to Flamewing to add it. With adequate caution, smpsStop can do this job."
		smpsStop
	endif
	endm

; EFxx[yy] - Set Voice of FM channel to xx; xx < 0 means yy present
smpsFMvoice macro voice,songID
	if (SonicDriverVer>=3)&&("songID"<>"")
		dc.b	$EF,voice|$80,songID+$81
	else
		dc.b	$EF,voice
	endif
	endm

; F0wwxxyyzz - Modulation - ww: wait time - xx: modulation speed - yy: change per step - zz: number of steps
smpsModSet macro wait,speed,change,step
	dc.b	$F0
	if (SonicDriverVer>=3)&&(SourceDriver<3)
		dc.b	wait+1,speed,change,((step+1) * speed) & $FF
	elseif (SonicDriverVer<3)&&(SourceDriver>=3)
		dc.b	wait-1,speed,change,conv0To256(step)/conv0To256(speed)-1
	else
		dc.b	wait,speed,change,step
	endif
	;dc.b	speed,change,step
	endm

; Turn on Modulation
smpsModOn macro type
	if SonicDriverVer>=3
		if "type"<>""
			dc.b	$F4,type
		else
			dc.b	$F4,$80
		endif
	else
		dc.b	$F1
	endif
	endm

; F2 - End of channel
smpsStop macro
	dc.b	$F2
	endm

; F3xx - PSG waveform to xx
smpsPSGform macro form
	dc.b	$F3,form
	endm

; Turn off Modulation
smpsModOff macro
	if SonicDriverVer>=3
		dc.b	$FA
	else
		dc.b	$F4
	endif
	endm

; F5xx - PSG voice to xx
smpsPSGvoice macro voice
	dc.b	$F5,voice
	endm

; F6xxxx - Jump to xxxx
smpsJump macro loc
	dc.b	$F6
	if SonicDriverVer<>1
		dc.w	z80_ptr(loc)
	else
		dc.w	loc-*-1
	endif
	endm

; F7xxyyzzzz - Loop back to zzzz yy times, xx being the loop index for loop recursion fixing
smpsLoop macro index,loops,loc
	dc.b	$F7
	dc.b	index,loops
	if SonicDriverVer<>1
		dc.w	z80_ptr(loc)
	else
		dc.w	loc-*-1
	endif
	endm

; F8xxxx - Call pattern at xxxx, saving return point
smpsCall macro loc
	dc.b	$F8
	if SonicDriverVer<>1
		dc.w	z80_ptr(loc)
	else
		dc.w	loc-*-1
	endif
	endm
; ---------------------------------------------------------------------------
; Alter Volume
smpsFMAlterVol macro val1,val2
	if (SonicDriverVer>=3)&&("val2"<>"")
		dc.b	$E5,val1,val2
	else
		dc.b	$E6,val1
	endif
	endm

; S3/S&K/S3D-only coordination flags
	if SonicDriverVer>=3
; Silences FM channel then stops as per smpsStop
smpsStopFM macro
	dc.b	$E3
	endm

; Spindash Rev
smpsSpindashRev macro
	dc.b	$E9
	endm

smpsPlayDACSample macro sample
	dc.b	$EA,(sample&$7F)
	endm

smpsConditionalJump macro index,loc
	dc.b	$EB
	dc.b	index
	dc.w	z80_ptr(loc)
	endm

; Set note values to xx-$40
smpsSetNote macro val
	dc.b	$ED,val
	endm

smpsFMICommand macro reg,val
	dc.b	$EE,reg,val
	endm

; Set Modulation
smpsModChange2 macro fmmod,psgmod
	dc.b	$F1,fmmod,psgmod
	endm

; Set Modulation
smpsModChange macro val
	dc.b	$F4,val
	endm

; FCxxxx - Jump to xxxx
smpsContinuousLoop macro loc
	dc.b	$FC
	dc.w	z80_ptr(loc)
	endm

smpsAlternateSMPS macro flag
	dc.b	$FD,flag
	endm

smpsFM3SpecialMode macro ind1,ind2,ind3,ind4
	dc.b	$FE,ind1,ind2,ind3,ind4
	endm

smpsPlaySound macro index
	if SonicDriverVer>=5
		message "smpsPlaySound only plays SFX in Flamedriver; use smpsPlayMusic to play music or fade effects."
	endif
	dc.b	$FF,$01,index
	endm

smpsHaltMusic macro flag
	dc.b	$FF,$02,flag
	endm

smpsCopyData macro data,len
	fatal "Coord. Flag to copy data should not be used. Complain to Flamewing if any music uses it."
	dc.b	$FF,$03
	dc.w	little_endian(data)
	dc.b	len
	endm

smpsSSGEG macro op1,op2,op3,op4
	dc.b	$FF,$05,op1,op3,op2,op4
	endm

smpsFMVolEnv macro tone,mask
	dc.b	$FF,$06,tone,mask
	endm

smpsResetSpindashRev macro val
	dc.b	$FF,$07
	endm

	; Flags ported from other drivers.
	if SonicDriverVer>=5
smpsChanFMCommand macro reg,val
	dc.b	$FF,$09,reg,val
	endm

smpsPitchSlide macro enable
	dc.b	$FF,$0B,enable
	endm

smpsSetLFO macro enable,amsfms
	dc.b	$FF,$0C,enable,amsfms
	endm

smpsPlayMusic macro index
	dc.b	$FF,$0D,index
	endm
	endif

	endif
; ---------------------------------------------------------------------------
; S1/S2 only coordination flag
; Sets D1L to maximum volume (minimum attenuation) and RR to maximum for operators 3 and 4 of FM1
smpsMaxRelRate macro
	if SonicDriverVer>=3
		; Emulate it in S3/S&K/S3D driver
		smpsFMICommand $88,$0F
		smpsFMICommand $8C,$0F
	else
		dc.b	$F9
	endif
	endm
; ---------------------------------------------------------------------------
; Backwards compatibility
smpsAlterNote macro
	smpsDetune	ALLARGS
	endm

smpsAlterPitch macro
	smpsChangeTransposition	ALLARGS
	endm

smpsFMFlutter macro
	smpsFMVolEnv	ALLARGS
	endm

smpsWeirdD1LRR macro
	smpsMaxRelRate ALLARGS
	endm

smpsSetvoice macro
	smpsFMvoice ALLARGS
	endm
; ---------------------------------------------------------------------------
; Macros for FM instruments
; Voices - Feedback
smpsVcFeedback macro val
vcFeedback set val
	endm

; Voices - Algorithm
smpsVcAlgorithm macro val
vcAlgorithm set val
	endm

smpsVcUnusedBits macro val,d1r1,d1r2,d1r3,d1r4
vcUnusedBits set val
	if ("d1r1"<>"")&&("d1r2"<>"")&&("d1r3"<>"")&&("d1r4"<>"")
		set vcD1R1Unk,d1r1<<5
		set vcD1R2Unk,d1r2<<5
		set vcD1R3Unk,d1r3<<5
		set vcD1R4Unk,d1r4<<5
	else
		set vcD1R1Unk,0
		set vcD1R2Unk,0
		set vcD1R3Unk,0
		set vcD1R4Unk,0
	endif
	endm

; Voices - Detune
smpsVcDetune macro op1,op2,op3,op4
	set vcDT1,op1
	set vcDT2,op2
	set vcDT3,op3
	set vcDT4,op4
	endm

; Voices - Coarse-Frequency
smpsVcCoarseFreq macro op1,op2,op3,op4
	set vcCF1,op1
	set vcCF2,op2
	set vcCF3,op3
	set vcCF4,op4
	endm

; Voices - Rate Scale
smpsVcRateScale macro op1,op2,op3,op4
	set vcRS1,op1
	set vcRS2,op2
	set vcRS3,op3
	set vcRS4,op4
	endm

; Voices - Attack Rate
smpsVcAttackRate macro op1,op2,op3,op4
	set vcAR1,op1
	set vcAR2,op2
	set vcAR3,op3
	set vcAR4,op4
	endm

; Voices - Amplitude Modulation
; The original SMPS2ASM erroneously assumed the 6th and 7th bits
; were the Amplitude Modulation.
; According to several docs, however, it's actually the high bit.
smpsVcAmpMod macro op1,op2,op3,op4
	if SourceSMPS2ASM==0
		set vcAM1,op1<<5
		set vcAM2,op2<<5
		set vcAM3,op3<<5
		set vcAM4,op4<<5
	else
		set vcAM1,op1<<7
		set vcAM2,op2<<7
		set vcAM3,op3<<7
		set vcAM4,op4<<7
	endif
	endm

; Voices - First Decay Rate
smpsVcDecayRate1 macro op1,op2,op3,op4
	set vcD1R1,op1
	set vcD1R2,op2
	set vcD1R3,op3
	set vcD1R4,op4
	endm

; Voices - Second Decay Rate
smpsVcDecayRate2 macro op1,op2,op3,op4
	set vcD2R1,op1
	set vcD2R2,op2
	set vcD2R3,op3
	set vcD2R4,op4
	endm

; Voices - Decay Level
smpsVcDecayLevel macro op1,op2,op3,op4
	set vcDL1,op1
	set vcDL2,op2
	set vcDL3,op3
	set vcDL4,op4
	endm

; Voices - Release Rate
smpsVcReleaseRate macro op1,op2,op3,op4
	set vcRR1,op1
	set vcRR2,op2
	set vcRR3,op3
	set vcRR4,op4
	endm

; Voices - Total Level
; The original SMPS2ASM decides TL high bits automatically,
; but later versions leave it up to the user.
; Alternatively, if we're converting an SMPS 68k song to SMPS Z80,
; then we *want* the TL bits to match the algorithm, because SMPS 68k
; prefers the algorithm over the TL bits, ignoring the latter, while
; SMPS Z80 does the opposite.
; Unfortunately, there's nothing we can do if we're trying to convert
; an SMPS Z80 song to SMPS 68k. It will ignore the bits no matter
; what we do, so we just print a warning.
smpsVcTotalLevel macro op1,op2,op3,op4
	set vcTL1,op1
	set vcTL2,op2
	set vcTL3,op3
	set vcTL4,op4
	dc.b	(vcUnusedBits<<6)+(vcFeedback<<3)+vcAlgorithm
;   0     1     2     3     4     5     6     7
;%1000,%1000,%1000,%1000,%1010,%1110,%1110,%1111
	if SourceSMPS2ASM==0
		set vcTLMask4,((vcAlgorithm==7)<<7)
		set vcTLMask3,((vcAlgorithm>=4)<<7)
		set vcTLMask2,((vcAlgorithm>=5)<<7)
		set vcTLMask1,$80
	else
		set vcTLMask4,0
		set vcTLMask3,0
		set vcTLMask2,0
		set vcTLMask1,0
	endif

	if (SonicDriverVer>=3)&&(SourceDriver<3)
		set vcTLMask4,((vcAlgorithm==7)<<7)
		set vcTLMask3,((vcAlgorithm>=4)<<7)
		set vcTLMask2,((vcAlgorithm>=5)<<7)
		set vcTLMask1,$80
		set vcTL1,vcTL1&$7F
		set vcTL2,vcTL2&$7F
		set vcTL3,vcTL3&$7F
		set vcTL4,vcTL4&$7F
	elseif (SonicDriverVer<3)&&(SourceDriver>=3)&&((((vcTL1|vcTLMask1)&$80)<>$80)||(((vcTL2|vcTLMask2)&$80)<>((vcAlgorithm>=5)<<7))||(((vcTL3|vcTLMask3)&$80)<>((vcAlgorithm>=4)<<7))||(((vcTL4|vcTLMask4)&$80)<>((vcAlgorithm==7)<<7)))
		if MOMPASS>1
			message "Voice at 0x\{*} has TL bits that do not match its algorithm setting. This voice will not work in S1/S2 drivers."
		endif
	endif

	if SonicDriverVer==2
		dc.b	(vcDT4<<4)+vcCF4       ,(vcDT2<<4)+vcCF2       ,(vcDT3<<4)+vcCF3       ,(vcDT1<<4)+vcCF1
		dc.b	(vcRS4<<6)+vcAR4       ,(vcRS2<<6)+vcAR2       ,(vcRS3<<6)+vcAR3       ,(vcRS1<<6)+vcAR1
		dc.b	vcAM4|vcD1R4|vcD1R4Unk ,vcAM2|vcD1R2|vcD1R2Unk ,vcAM3|vcD1R3|vcD1R3Unk ,vcAM1|vcD1R1|vcD1R1Unk
		dc.b	vcD2R4                 ,vcD2R2                 ,vcD2R3                 ,vcD2R1
		dc.b	(vcDL4<<4)+vcRR4       ,(vcDL2<<4)+vcRR2       ,(vcDL3<<4)+vcRR3       ,(vcDL1<<4)+vcRR1
		dc.b	vcTL4|vcTLMask4        ,vcTL2|vcTLMask2        ,vcTL3|vcTLMask3        ,vcTL1|vcTLMask1
	else
		dc.b	(vcDT4<<4)+vcCF4       ,(vcDT3<<4)+vcCF3       ,(vcDT2<<4)+vcCF2       ,(vcDT1<<4)+vcCF1
		dc.b	(vcRS4<<6)+vcAR4       ,(vcRS3<<6)+vcAR3       ,(vcRS2<<6)+vcAR2       ,(vcRS1<<6)+vcAR1
		dc.b	vcAM4|vcD1R4|vcD1R4Unk ,vcAM3|vcD1R3|vcD1R3Unk ,vcAM2|vcD1R2|vcD1R2Unk ,vcAM1|vcD1R1|vcD1R1Unk
		dc.b	vcD2R4                 ,vcD2R3                 ,vcD2R2                 ,vcD2R1
		dc.b	(vcDL4<<4)+vcRR4       ,(vcDL3<<4)+vcRR3       ,(vcDL2<<4)+vcRR2       ,(vcDL1<<4)+vcRR1
		dc.b	vcTL4|vcTLMask4        ,vcTL3|vcTLMask3        ,vcTL2|vcTLMask2        ,vcTL1|vcTLMask1
	endif
	endm

