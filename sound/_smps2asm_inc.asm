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

SonicDriverVer			= 1
SMPS2ASMVer			= 1
; Set the following to non-zero to use all S2 DAC samples, or to zero otherwise.
; The S1 samples are a subset of this.
use_s2_samples			= 0
; Set the following to non-zero to use all S3D DAC samples, or to zero
; otherwise. Most of the S3D samples are also present in S3/S&K, but
; there are two samples specific to S3D.
use_s3d_samples			= 0
; Set the following to non-zero to use all S3 DAC samples,
; or to zero otherwise.
use_s3_samples			= 0
; Set the following to non-zero to use all S&K DAC samples,
; or to zero otherwise.
use_sk_samples			= 0

; PSG conversion to S3/S&K/S3D drivers require a tone shift of 12 semi-tones.
psgdelta	EQU 12
; ---------------------------------------------------------------------------
; Standard Octave Pitch Equates
		rsset	$88
smpsPitch10lo		rs.b	$C
smpsPitch09lo		rs.b	$C
smpsPitch08lo		rs.b	$C
smpsPitch07lo		rs.b	$C
smpsPitch06lo		rs.b	$C
smpsPitch05lo		rs.b	$C
smpsPitch04lo		rs.b	$C
smpsPitch03lo		rs.b	$C
smpsPitch02lo		rs.b	$C
smpsPitch01lo		rs.b	$C
	rsreset
smpsPitch00			rs.b	$C
smpsPitch01hi		rs.b	$C
smpsPitch02hi		rs.b	$C
smpsPitch03hi		rs.b	$C
smpsPitch04hi		rs.b	$C
smpsPitch05hi		rs.b	$C
smpsPitch06hi		rs.b	$C
smpsPitch07hi		rs.b	$C
smpsPitch08hi		rs.b	$C
smpsPitch09hi		rs.b	$C
smpsPitch10hi		rs.b	$C
; ---------------------------------------------------------------------------
; Note Equates
		rsset	$80
nRst		rs.b	1
nC0		rs.b	1
nCs0		rs.b	1
nDb0	= 	nCs0
nD0		rs.b	1
nEb0		rs.b	1
nDs0	=	nEb0
nE0		rs.b	1
nFb0	=	nE0
nF0		rs.b	1
nEs0	=	nF0
nFs0		rs.b	1
nGb0	=	nFs0
nG0		rs.b	1
nAb0		rs.b	1
nGs0	=	nAb0
nA0		rs.b	1
nBb0		rs.b	1
nAs0	=	nBb0
nB0		rs.b	1
nCb1	=	nB0
nC1		rs.b	1
nBs0	=	nC1
nCs1		rs.b	1
nDb1	= 	nCs1
nD1		rs.b	1
nEb1		rs.b	1
nDs1	=	nEb1
nE1		rs.b	1
nFb1	=	nE1
nF1		rs.b	1
nEs1	=	nF1
nFs1		rs.b	1
nGb1	=	nFs1
nG1		rs.b	1
nAb1		rs.b	1
nGs1	=	nAb1
nA1		rs.b	1
nBb1		rs.b	1
nAs1	=	nBb1
nB1		rs.b	1
nCb2	=	nB1
nC2		rs.b	1
nBs1	=	nC2
nCs2		rs.b	1
nDb2	= 	nCs2
nD2		rs.b	1
nEb2		rs.b	1
nDs2	=	nEb2
nE2		rs.b	1
nFb2	=	nE2
nF2		rs.b	1
nEs2	=	nF2
nFs2		rs.b	1
nGb2	=	nFs2
nG2		rs.b	1
nAb2		rs.b	1
nGs2	=	nAb2
nA2		rs.b	1
nBb2		rs.b	1
nAs2	=	nBb2
nB2		rs.b	1
nCb3	=	nB2
nC3		rs.b	1
nBs2	=	nC3
nCs3		rs.b	1
nDb3	= 	nCs3
nD3		rs.b	1
nEb3		rs.b	1
nDs3	=	nEb3
nE3		rs.b	1
nFb3	=	nE3
nF3		rs.b	1
nEs3	=	nF3
nFs3		rs.b	1
nGb3	=	nFs3
nG3		rs.b	1
nAb3		rs.b	1
nGs3	=	nAb3
nA3		rs.b	1
nBb3		rs.b	1
nAs3	=	nBb3
nB3		rs.b	1
nCb4	=	nB3
nC4		rs.b	1
nBs3	=	nC4
nCs4		rs.b	1
nDb4	= 	nCs4
nD4		rs.b	1
nEb4		rs.b	1
nDs4	=	nEb4
nE4		rs.b	1
nFb4	=	nE4
nF4		rs.b	1
nEs4	=	nF4
nFs4		rs.b	1
nGb4	=	nFs4
nG4		rs.b	1
nAb4		rs.b	1
nGs4	=	nAb4
nA4		rs.b	1
nBb4		rs.b	1
nAs4	=	nBb4
nB4		rs.b	1
nCb5	=	nB4
nC5		rs.b	1
nBs4	=	nC5
nCs5		rs.b	1
nDb5	= 	nCs5
nD5		rs.b	1
nEb5		rs.b	1
nDs5	=	nEb5
nE5		rs.b	1
nFb5	=	nE5
nF5		rs.b	1
nEs5	=	nF5
nFs5		rs.b	1
nGb5	=	nFs5
nG5		rs.b	1
nAb5		rs.b	1
nGs5	=	nAb5
nA5		rs.b	1
nBb5		rs.b	1
nAs5	=	nBb5
nB5		rs.b	1
nCb6	=	nB5
nC6		rs.b	1
nBs5	=	nC6
nCs6		rs.b	1
nDb6	= 	nCs6
nD6		rs.b	1
nEb6		rs.b	1
nDs6	=	nEb6
nE6		rs.b	1
nFb6	=	nE6
nF6		rs.b	1
nEs6	=	nF6
nFs6		rs.b	1
nGb6	=	nFs6
nG6		rs.b	1
nAb6		rs.b	1
nGs6	=	nAb6
nA6		rs.b	1
nBb6		rs.b	1
nAs6	=	nBb6
nB6		rs.b	1
nCb7	=	nB6
nC7		rs.b	1
nBs6	=	nC7
nCs7		rs.b	1
nDb7	= 	nCs7
nD7		rs.b	1
nEb7		rs.b	1
nDs7	=	nEb7
nE7		rs.b	1
nFb7	=	nE7
nF7		rs.b	1
nEs7	=	nF7
nFs7		rs.b	1
nGb7	=	nFs7
nG7		rs.b	1
nAb7		rs.b	1
nGs7	=	nAb7
nA7		rs.b	1
nBb7		rs.b	1
nAs7	=	nBb7

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
	if SonicDriverVer=1
		rsset	1
fTone_01	rs.b	1
fTone_02	rs.b	1
fTone_03	rs.b	1
fTone_04	rs.b	1
fTone_05	rs.b	1
fTone_06	rs.b	1
fTone_07	rs.b	1
fTone_08	rs.b	1
fTone_09	rs.b	1
	elseif SonicDriverVer=2
		rsset	1
fTone_01	rs.b	1
fTone_02	rs.b	1
fTone_03	rs.b	1
fTone_04	rs.b	1
fTone_05	rs.b	1
fTone_06	rs.b	1
fTone_07	rs.b	1
fTone_08	rs.b	1
fTone_09	rs.b	1
fTone_0A	rs.b	1
fTone_0B	rs.b	1
fTone_0C	rs.b	1
fTone_0D	rs.b	1
	else;if SonicDriverVer>=3
		rsset	1
sTone_01	rs.b	1
sTone_02	rs.b	1
sTone_03	rs.b	1
sTone_04	rs.b	1
sTone_05	rs.b	1
sTone_06	rs.b	1
sTone_07	rs.b	1
sTone_08	rs.b	1
sTone_09	rs.b	1
sTone_0A	rs.b	1
sTone_0B	rs.b	1
sTone_0C	rs.b	1
sTone_0D	rs.b	1
sTone_0E	rs.b	1
sTone_0F	rs.b	1
sTone_10	rs.b	1
sTone_11	rs.b	1
sTone_12	rs.b	1
sTone_13	rs.b	1
sTone_14	rs.b	1
sTone_15	rs.b	1
sTone_16	rs.b	1
sTone_17	rs.b	1
sTone_18	rs.b	1
sTone_19	rs.b	1
sTone_1A	rs.b	1
sTone_1B	rs.b	1
sTone_1C	rs.b	1
sTone_1D	rs.b	1
sTone_1E	rs.b	1
sTone_1F	rs.b	1
sTone_20	rs.b	1
sTone_21	rs.b	1
sTone_22	rs.b	1
sTone_23	rs.b	1
sTone_24	rs.b	1
sTone_25	rs.b	1
sTone_26	rs.b	1
sTone_27	rs.b	1

		; For conversions:
		if SonicDriverVer>=5
fTone_01		rs.b	1
fTone_02		rs.b	1
fTone_03		rs.b	1
fTone_04		rs.b	1
fTone_05		rs.b	1
fTone_06		rs.b	1
fTone_07		rs.b	1
fTone_08		rs.b	1
fTone_09		rs.b	1
fTone_0A		rs.b	1
fTone_0B		rs.b	1
fTone_0C		rs.b	1
fTone_0D		rs.b	1
		endif
	endif
; ---------------------------------------------------------------------------
; DAC Equates
	if SonicDriverVer=1
		rsset	$81
dKick		rs.b	1
dSnare		rs.b	1
dTimpani	rs.b	1
		rsset	$88
dHiTimpani	rs.b	1
dMidTimpani	rs.b	1
dLowTimpani	rs.b	1
dVLowTimpani	rs.b	1
	elseif SonicDriverVer=2
		rsset	$81
dKick		rs.b	1
dSnare		rs.b	1
dClap		rs.b	1
dScratch	rs.b	1
dTimpani	rs.b	1
dHiTom		rs.b	1
dVLowClap	rs.b	1
dHiTimpani	rs.b	1
dMidTimpani	rs.b	1
dLowTimpani	rs.b	1
dVLowTimpani	rs.b	1
dMidTom		rs.b	1
dLowTom		rs.b	1
dFloorTom	rs.b	1
dHiClap		rs.b	1
dMidClap	rs.b	1
dLowClap	rs.b	1
	else;if SonicDriverVer>=3
		if (use_s3_samples<>0)|(use_sk_samples<>0)|(use_s3d_samples<>0)
			rsset	$81
dSnareS3		rs.b	1
dHighTom		rs.b	1
dMidTomS3		rs.b	1
dLowTomS3		rs.b	1
dFloorTomS3		rs.b	1
dKickS3			rs.b	1
dMuffledSnare		rs.b	1
dCrashCymbal		rs.b	1
dRideCymbal		rs.b	1
dLowMetalHit		rs.b	1
dMetalHit		rs.b	1
dHighMetalHit		rs.b	1
dHigherMetalHit		rs.b	1
dMidMetalHit		rs.b	1
dClapS3			rs.b	1
dElectricHighTom	rs.b	1
dElectricMidTom		rs.b	1
dElectricLowTom		rs.b	1
dElectricFloorTom	rs.b	1
dTightSnare		rs.b	1
dMidpitchSnare		rs.b	1
dLooseSnare		rs.b	1
dLooserSnare		rs.b	1
dHiTimpaniS3		rs.b	1
dLowTimpaniS3		rs.b	1
dMidTimpaniS3		rs.b	1
dQuickLooseSnare	rs.b	1
dClick			rs.b	1
dPowerKick		rs.b	1
dQuickGlassCrash	rs.b	1
		endif
		if (use_s3_samples<>0)|(use_sk_samples<>0)
dGlassCrashSnare	rs.b	1
dGlassCrash		rs.b	1
dGlassCrashKick		rs.b	1
dQuietGlassCrash	rs.b	1
dOddSnareKick		rs.b	1
dKickExtraBass		rs.b	1
dComeOn			rs.b	1
dDanceSnare		rs.b	1
dLooseKick		rs.b	1
dModLooseKick		rs.b	1
dWoo			rs.b	1
dGo			rs.b	1
dSnareGo		rs.b	1
dPowerTom		rs.b	1
dHiWoodBlock		rs.b	1
dLowWoodBlock		rs.b	1
dHiHitDrum		rs.b	1
dLowHitDrum		rs.b	1
dMetalCrashHit		rs.b	1
dEchoedClapHit		rs.b	1
dLowerEchoedClapHit	rs.b	1
dHipHopHitKick		rs.b	1
dHipHopHitPowerKick	rs.b	1
dBassHey		rs.b	1
dDanceStyleKick		rs.b	1
dHipHopHitKick2		rs.b	1
dHipHopHitKick3		rs.b	1
dReverseFadingWind	rs.b	1
dScratchS3		rs.b	1
dLooseSnareNoise	rs.b	1
dPowerKick2		rs.b	1
dCrashingNoiseWoo	rs.b	1
dQuickHit		rs.b	1
dKickHey		rs.b	1
dPowerKickHit		rs.b	1
dLowPowerKickHit	rs.b	1
dLowerPowerKickHit	rs.b	1
dLowestPowerKickHit	rs.b	1
		endif
		; For conversions:
		if (use_s2_samples<>0)
			if (use_s3_samples<>0)|(use_sk_samples<>0)|(use_s3d_samples<>0)
dKick				rs.b	1
			else
				rsset	$81
dKick				rs.b	1
			endif
dSnare			rs.b	1
dClap			rs.b	1
dScratch		rs.b	1
dTimpani		rs.b	1
dHiTom			rs.b	1
dVLowClap		rs.b	1
dHiTimpani		rs.b	1
dMidTimpani		rs.b	1
dLowTimpani		rs.b	1
dVLowTimpani		rs.b	1
dMidTom			rs.b	1
dLowTom			rs.b	1
dFloorTom		rs.b	1
dHiClap			rs.b	1
dMidClap		rs.b	1
dLowClap		rs.b	1
		endif
		if (use_s3d_samples<>0)
dFinalFightMetalCrash	rs.b	1
dIntroKick		rs.b	1
		endif
		if (use_s3_samples<>0)
dEchoedClapHit_S3	rs.b	1
dLowerEchoedClapHit_S3	rs.b	1
		endif
	endif
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

	if ~def(little_endian)
little_endian macros
		dc.w	((\1<<8)&$FF00)|((\1>>8)&$FF)
	endif

	if ~def(z80_ptr)
z80_ptr macros
		dc.w	((\1<<8)&$FF00)|((\1>>8)&$7F)|$80
	endif

;conv0To256  function n,((n==0)<<8)|n
;s2TempotoS1 function n,(((768-n)>>1)/(256-n))&$FF
;s2TempotoS3 function n,($100-((n==0)|n))&$FF
;s1TempotoS2 function n,((((conv0To256(n)-1)<<8)+(conv0To256(n)>>1))/conv0To256(n))&$FF
;s1TempotoS3 function n,s2TempotoS3(s1TempotoS2(n))
;s3TempotoS1 function n,s2TempotoS1(s2TempotoS3(n))
;s3TempotoS2 function n,s2TempotoS3(n)

s2TempotoS1 macro n
	s21convval:	= (((768-n)>>1)/(256-n))&$FF
	endm

s2TempotoS3 macro n
	s23convval:	= ($100-((n=0)|n))&$FF
	s32convval:	= s23convval
	endm

s1TempotoS2 macro n
	if n=0
		s12convval:	= ((((256-1)<<8)+(256>>1))/256)&$FF
	else
		s12convval:	= ((((n-1)<<8)+(n>>1))/n)&$FF
	endif
	endm

s1TempotoS3 macro n
	s1TempotoS2	n
	s2TempotoS3	s12convval
	endm

s3TempotoS1 macro n
	s2TempotoS3	n
	s2TempotoS1	s23convval
	endm

s3TempotoS2 macros
	s2TempotoS3	\_

convertMainTempoMod macro val
	if ((SourceDriver>=3)&(SonicDriverVer>=3))|(SonicDriverVer=SourceDriver)
		dc.b	\val
	elseif SourceDriver=1
		if \val\=1
			inform 3,"Invalid main tempo of 1 in song from Sonic 1"
		endif
		if SonicDriverVer=2
			s1TempotoS2	\val
			dc.b	s12convval
		else;if SonicDriverVer>=3
			s1TempotoS3	\val
			dc.b	s13convval
		endif
	elseif SourceDriver=2
		if \val\=0
			inform 3,"Invalid main tempo of 0 in song from Sonic 2"
		endif
		if SonicDriverVer=1
			s2TempotoS1	\val
			dc.b	s21convval
		else;if SonicDriverVer>=3
			s2TempotoS3	\val
			dc.b	s23convval
		endif
	else;if SourceDriver>=3
		if \val\=0
			inform 2,"Performing approximate conversion of Sonic 3 main tempo modifier of 0"
		endif
		if SonicDriverVer=1
			s3TempotoS1	\val
			dc.b	s31convval
		else;if SonicDriverVer=2
			s3TempotoS2	\val
			dc.b	s32convval
		endif
	endif
	endm

; PSG conversion to S3/S&K/S3D drivers require a tone shift of 12 semi-tones.
PSGPitchConvert macro val
	if (SonicDriverVer>=3)&(SourceDriver<3)
		dc.b	(\val\+psgdelta)&$FF
	elseif (SonicDriverVer<3)&(SourceDriver>=3)
		dc.b	(\val\-psgdelta)&$FF
	else
		dc.b	\val
	endif
	endm

CheckedChannelPointer macro location
	if SonicDriverVer<>1
		z80_ptr	\location\
	else
		if def(\location)
			inform 3,"Tracks for Sonic 1 songs must come after the start of the song"
		else
			dc.w	\location\-songStart
		endif
	endif
	endm
; ---------------------------------------------------------------------------
; Header Macros
smpsHeaderStartSong macro ver,sourcesmps2asmver

SourceDriver set ver

	if (narg=2)
SourceSMPS2ASM set sourcesmps2asmver
	else
SourceSMPS2ASM set 0
	endif

songStart set *

	if SMPS2ASMVer<SourceSMPS2ASM
		inform 1,"Song at 0x%h was made for a newer version of SMPS2ASM (this is version %d, but song wants at least version %d).",songStart,SMPS2ASMVer,SourceSMPS2ASM
	endif

	endm

smpsHeaderVoiceNull macro
	if songStart<>*
		inform 3,"Missing smpsHeaderStartSong"
	endif
	dc.w	$0000
	endm

; Header - Set up Voice Location
; Common to music and SFX
smpsHeaderVoice macro location
	if songStart<>*
		inform 3,"Missing smpsHeaderStartSong"
	endif
	if SonicDriverVer<>1
		z80_ptr	\location\
	else
		if def(\location)
			inform 3,"Voice banks for Sonic 1 songs must come after the song"
		else
			dc.w	\location\-songStart
		endif
	endif
	endm

; Header - Set up Voice Location as S3's Universal Voice Bank
; Common to music and SFX
smpsHeaderVoiceUVB macro
	if songStart<>*
		inform 3,"Missing smpsHeaderStartSong"
	endif
	if SonicDriverVer>=5
		z80_ptr	z80_UniVoiceBank
	elseif SonicDriverVer>=3
		little_endian	z80_UniVoiceBank
	else
		inform 3,"Universal Voice Bank does not exist in Sonic 1 or Sonic 2 drivers"
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
	convertMainTempoMod \mod
	endm

; Header - Set up DAC Channel
smpsHeaderDAC macro location,pitch,vol
	CheckedChannelPointer \location
	if strlen("\pitch")>0
		dc.b	pitch
		if strlen("\vol")>0
			dc.b	vol
		else
			dc.b	$00
		endif
	else
		dc.w	$00
	endif
	endm

; Header - Set up FM Channel
smpsHeaderFM macro location,pitch,vol
	CheckedChannelPointer \location
	dc.b	pitch,vol
	endm

; Header - Set up PSG Channel
smpsHeaderPSG macro location,pitch,vol,mod,voice
	CheckedChannelPointer \location
	PSGPitchConvert \pitch
	dc.b	vol
	; Frequency envelope
	if (SonicDriverVer>=3)&(SourceDriver<3)
		; In SMPS 68k Type 1, this byte is skipped and can contain garbage.
		; Sonic 2's Oil Ocean Zone and Ending themes set this byte to a non-zero value which
		; other drivers may try to process as valid data, so manually force it to 0 here.
		dc.b	0
	else
		if (SonicDriverVer<3)&(SourceDriver>=3)&(\mod<>0)
			inform 1,"This track header specifies a frequency envelope, but this driver does not support them."
		endif
		dc.b	\mod
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
smpsHeaderSFXChannel macro chanid,location,pitch,vol
	if (SonicDriverVer>=3)&(chanid=cNoise)
		inform 3,"Using channel ID of cNoise ($E0) in Sonic 3 driver is dangerous. Fix the song so that it turns into a noise channel instead."
	elseif (SonicDriverVer<3)&(chanid=cFM6)
		inform 3,"Using channel ID of FM6 ($06) in Sonic 1 or Sonic 2 drivers is unsupported. Change it to another channel."
	endif
	dc.b	$80,chanid
	CheckedChannelPointer \location\
	if (chanid&$80)<>0
		PSGPitchConvert \pitch
	else
		dc.b	pitch
	endif
	dc.b	vol
	endm
; ---------------------------------------------------------------------------
; Co-ord Flag Macros and Equates
; E0xx - Panning, AMS, FMS
smpsPan macro direction,amsfms
	dc.b $E0,direction+amsfms
	endm

panNone equ $00
panRight equ $40
panLeft equ $80
panCentre equ $C0
panCenter equ $C0 ; silly Americans :U

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
		if strlen("\val")>0
			dc.b	val
		else
			dc.b	$FF
		endif
		if SourceDriver<3
			smpsStop
		endif
	elseif (SourceDriver>=3)&(strlen("\val"))&(strcmp("\val","$FF"))
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
	elseif SonicDriverVer=3
		inform 3,"Coord. Flag to set tempo divider of a single channel does not exist in S3 driver. Use Flamewing's modified S&K sound driver instead."
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
	if (SonicDriverVer>=5)&(SourceDriver<3)
		; Unique to Flamewing's modified driver
		dc.b	$FF,$0A,val
	else
		if (SonicDriverVer>=3)&(SourceDriver<3)
			inform 1,"Note fill will not work as intended unless you divide the fill value by the tempo divider or complain to Flamewing to add an appropriate coordination flag for it."
		elseif (SonicDriverVer<3)&(SourceDriver>=3)
			inform 1,"Note fill will not work as intended unless you multiply the fill value by the tempo divider or complain to Flamewing to add an appropriate coordination flag for it."
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
smpsSetTempoMod macro val
	if SonicDriverVer>=3
		dc.b	$FF,$00
	else
		dc.b	$EA
	endif
	convertMainTempoMod \val
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
		inform 3,"Coord. Flag to set volume (instead of volume attenuation) does not exist in S1 or S2 drivers. Complain to Flamewing to add it."
	endif
	endm

; Works on all drivers
smpsPSGAlterVol macro vol
	dc.b	$EC,vol
	endm

; Clears pushing sound flag in S1
smpsClearPush macro
	if SonicDriverVer=1
		dc.b	$ED
	else
		inform 3,"Coord. Flag to clear S1 push block flag does not exist in S2 or S3 drivers. Complain to Flamewing to add it."
	endif
	endm

; Stops special SFX (S1 only) and restarts overridden music track
smpsStopSpecial macro
	if SonicDriverVer=1
		dc.b	$EE
	else
		inform 2,"Coord. Flag to stop special SFX does not exist in S2 or S3 drivers. Complain to Flamewing to add it. With adequate caution, smpsStop can do this job."
		smpsStop
	endif
	endm

; EFxx[yy] - Set Voice of FM channel to xx; xx < 0 means yy present
smpsFMvoice macro voice,songID
	if (SonicDriverVer>=3)&(strlen("\songID")>0)
		dc.b	$EF,voice|$80,songID+$81
	else
		dc.b	$EF,voice
	endif
	endm

; F0wwxxyyzz - Modulation - ww: wait time - xx: modulation speed - yy: change per step - zz: number of steps
smpsModSet macro wait,speed,change,step
	dc.b	$F0
	if (SonicDriverVer>=3)&(SourceDriver<3)
		dc.b	wait+1,speed,change,((step+1)*speed)&$FF
	elseif (SonicDriverVer<3)&(SourceDriver>=3)
		dc.b	wait-1,speed,change
		conv_step:	= ((step=0)<<8)|step
		conv_speed:	= ((speed=0)<<8)|speed
		dc.b	(conv_step/conv_speed)-1
	else
		dc.b	wait,speed,change,step
	endif
	;dc.b	speed,change,step
	endm

; Turn on Modulation
smpsModOn macro type
	if SonicDriverVer>=3
		if strlen("\type")>0
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
		z80_ptr loc
	else
		dc.w	loc-*-1
	endif
	endm

; F7xxyyzzzz - Loop back to zzzz yy times, xx being the loop index for loop recursion fixing
smpsLoop macro index,loops,loc
	dc.b	$F7
	dc.b	index,loops
	if SonicDriverVer<>1
		z80_ptr loc
	else
		dc.w	loc-*-1
	endif
	endm

; F8xxxx - Call pattern at xxxx, saving return point
smpsCall macro loc
	dc.b	$F8
	if SonicDriverVer<>1
		z80_ptr loc
	else
		dc.w	loc-*-1
	endif
	endm
; ---------------------------------------------------------------------------
; Alter Volume
smpsFMAlterVol macro val1,val2
	if (SonicDriverVer>=3)&(strlen("\val2")>0)
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
	z80_ptr	loc
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
	z80_ptr	loc
	endm

smpsAlternateSMPS macro flag
	dc.b	$FD,flag
	endm

smpsFM3SpecialMode macro ind1,ind2,ind3,ind4
	dc.b	$FE,ind1,ind2,ind3,ind4
	endm

smpsPlaySound macro index
	if SonicDriverVer>=5
		inform 1,"smpsPlaySound only plays SFX in Flamedriver; use smpsPlayMusic to play music or fade effects."
	endif
	dc.b	$FF,$01,index
	endm

smpsHaltMusic macro flag
	dc.b	$FF,$02,flag
	endm

smpsCopyData macro data,len
	inform 3,"Coord. Flag to copy data should not be used. Complain to Flamewing if any music uses it."
	dc.b	$FF,$03
	little_endian	data
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
	smpsDetune	\_
	endm

smpsAlterPitch macro
	smpsChangeTransposition	\_
	endm

smpsFMFlutter macro
	smpsFMVolEnv	\_
	endm

smpsWeirdD1LRR macro
	smpsMaxRelRate \_
	endm

smpsSetvoice macro
	smpsFMvoice \_
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
	if (strlen("\d1r1")>0)&(strlen("\d1r2")>0)&(strlen("\d1r3")>0)&(strlen("\d1r4")>0)
vcD1R1Unk set d1r1<<5
vcD1R2Unk set d1r2<<5
vcD1R3Unk set d1r3<<5
vcD1R4Unk set d1r4<<5
	else
vcD1R1Unk set 0
vcD1R2Unk set 0
vcD1R3Unk set 0
vcD1R4Unk set 0
	endif
	endm

; Voices - Detune
smpsVcDetune macro op1,op2,op3,op4
vcDT1 set op1
vcDT2 set op2
vcDT3 set op3
vcDT4 set op4
	endm

; Voices - Coarse-Frequency
smpsVcCoarseFreq macro op1,op2,op3,op4
vcCF1 set op1
vcCF2 set op2
vcCF3 set op3
vcCF4 set op4
	endm

; Voices - Rate Scale
smpsVcRateScale macro op1,op2,op3,op4
vcRS1 set op1
vcRS2 set op2
vcRS3 set op3
vcRS4 set op4
	endm

; Voices - Attack Rate
smpsVcAttackRate macro op1,op2,op3,op4
vcAR1 set op1
vcAR2 set op2
vcAR3 set op3
vcAR4 set op4
	endm

; Voices - Amplitude Modulation
; The original SMPS2ASM erroneously assumed the 6th and 7th bits
; were the Amplitude Modulation.
; According to several docs, however, it's actually the high bit.
smpsVcAmpMod macro op1,op2,op3,op4
	if SourceSMPS2ASM=0
vcAM1 set op1<<5
vcAM2 set op2<<5
vcAM3 set op3<<5
vcAM4 set op4<<5
	else
vcAM1 set op1<<7
vcAM2 set op2<<7
vcAM3 set op3<<7
vcAM4 set op4<<7
	endif
	endm

; Voices - First Decay Rate
smpsVcDecayRate1 macro op1,op2,op3,op4
vcD1R1 set op1
vcD1R2 set op2
vcD1R3 set op3
vcD1R4 set op4
	endm

; Voices - Second Decay Rate
smpsVcDecayRate2 macro op1,op2,op3,op4
vcD2R1 set op1
vcD2R2 set op2
vcD2R3 set op3
vcD2R4 set op4
	endm

; Voices - Decay Level
smpsVcDecayLevel macro op1,op2,op3,op4
vcDL1 set op1
vcDL2 set op2
vcDL3 set op3
vcDL4 set op4
	endm

; Voices - Release Rate
smpsVcReleaseRate macro op1,op2,op3,op4
vcRR1 set op1
vcRR2 set op2
vcRR3 set op3
vcRR4 set op4
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
vcTL1 set op1
vcTL2 set op2
vcTL3 set op3
vcTL4 set op4
	dc.b	(vcUnusedBits<<6)+(vcFeedback<<3)+vcAlgorithm
;   0     1     2     3     4     5     6     7
;%1000,%1000,%1000,%1000,%1010,%1110,%1110,%1111
	if SourceSMPS2ASM=0
vcTLMask4 set ((vcAlgorithm=7)<<7)
vcTLMask3 set ((vcAlgorithm>=4)<<7)
vcTLMask2 set ((vcAlgorithm>=5)<<7)
vcTLMask1 set $80
	else
vcTLMask4 set 0
vcTLMask3 set 0
vcTLMask2 set 0
vcTLMask1 set 0
	endif

	if (SonicDriverVer>=3)&(SourceDriver<3)
vcTLMask4 set ((vcAlgorithm=7)<<7)
vcTLMask3 set ((vcAlgorithm>=4)<<7)
vcTLMask2 set ((vcAlgorithm>=5)<<7)
vcTLMask1 set 128
vcTL1 set vcTL1&127
vcTL2 set vcTL2&127
vcTL3 set vcTL3&127
vcTL4 set vcTL4&127
    elseif (SonicDriverVer<3)&(SourceDriver>=3)&((((vcTL1|vcTLMask1)&$80)<>$80)|(((vcTL2|vcTLMask2)&$80)<>((vcAlgorithm>=5)<<7))|(((vcTL3|vcTLMask3)&$80)<>((vcAlgorithm>=4)<<7))|(((vcTL4|vcTLMask4)&$80)<>((vcAlgorithm=7)<<7)))
        inform 1,"Voice at 0x%h has TL bits that do not match its algorithm setting. This voice will not work in S1/S2 drivers.",*
    endif

	if SonicDriverVer=2
		dc.b	(vcDT4<<4)+vcCF4,       (vcDT2<<4)+vcCF2,       (vcDT3<<4)+vcCF3,       (vcDT1<<4)+vcCF1
		dc.b	(vcRS4<<6)+vcAR4,       (vcRS2<<6)+vcAR2,       (vcRS3<<6)+vcAR3,       (vcRS1<<6)+vcAR1
		dc.b	vcAM4|vcD1R4|vcD1R4Unk, vcAM2|vcD1R2|vcD1R2Unk, vcAM3|vcD1R3|vcD1R3Unk, vcAM1|vcD1R1|vcD1R1Unk
		dc.b	vcD2R4,                 vcD2R2,                 vcD2R3,                 vcD2R1
		dc.b	(vcDL4<<4)+vcRR4,       (vcDL2<<4)+vcRR2,       (vcDL3<<4)+vcRR3,       (vcDL1<<4)+vcRR1
		dc.b	vcTL4|vcTLMask4,        vcTL2|vcTLMask2,        vcTL3|vcTLMask3,        vcTL1|vcTLMask1
	else
		dc.b	(vcDT4<<4)+vcCF4,       (vcDT3<<4)+vcCF3,       (vcDT2<<4)+vcCF2,       (vcDT1<<4)+vcCF1
		dc.b	(vcRS4<<6)+vcAR4,       (vcRS3<<6)+vcAR3,       (vcRS2<<6)+vcAR2,       (vcRS1<<6)+vcAR1
		dc.b	vcAM4|vcD1R4|vcD1R4Unk, vcAM3|vcD1R3|vcD1R3Unk, vcAM2|vcD1R2|vcD1R2Unk, vcAM1|vcD1R1|vcD1R1Unk
		dc.b	vcD2R4,                 vcD2R3,                 vcD2R2,                 vcD2R1
		dc.b	(vcDL4<<4)+vcRR4,       (vcDL3<<4)+vcRR3,       (vcDL2<<4)+vcRR2,       (vcDL1<<4)+vcRR1
		dc.b	vcTL4|vcTLMask4,        vcTL3|vcTLMask3,        vcTL2|vcTLMask2,        vcTL1|vcTLMask1
	endif
	endm

