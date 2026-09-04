; ---------------------------------------------------------------------------
; Modified SMPS 68k Type 1b sound driver
; The source code to a similar version of the driver can be found here:
; https://hiddenpalace.org/News/Sega_of_Japan_Sound_Documents_and_Source_Code
; ---------------------------------------------------------------------------

; Constants
SMPS_TRACK_COUNT = (SMPS_RAM.v_track_ram_end-SMPS_RAM.v_track_ram)/SMPS_Track.len
SMPS_MUSIC_TRACK_COUNT = (SMPS_RAM.v_music_track_ram_end-SMPS_RAM.v_music_track_ram)/SMPS_Track.len
SMPS_MUSIC_FM_DAC_TRACK_COUNT = (SMPS_RAM.v_music_fmdac_tracks_end-SMPS_RAM.v_music_fmdac_tracks)/SMPS_Track.len
SMPS_MUSIC_FM_TRACK_COUNT = (SMPS_RAM.v_music_fm_tracks_end-SMPS_RAM.v_music_fm_tracks)/SMPS_Track.len
SMPS_MUSIC_PSG_TRACK_COUNT = (SMPS_RAM.v_music_psg_tracks_end-SMPS_RAM.v_music_psg_tracks)/SMPS_Track.len
SMPS_SFX_TRACK_COUNT = (SMPS_RAM.v_sfx_track_ram_end-SMPS_RAM.v_sfx_track_ram)/SMPS_Track.len
SMPS_SFX_FM_TRACK_COUNT = (SMPS_RAM.v_sfx_fm_tracks_end-SMPS_RAM.v_sfx_fm_tracks)/SMPS_Track.len
SMPS_SFX_PSG_TRACK_COUNT = (SMPS_RAM.v_sfx_psg_tracks_end-SMPS_RAM.v_sfx_psg_tracks)/SMPS_Track.len
SMPS_SPECIAL_SFX_TRACK_COUNT = (SMPS_RAM.v_spcsfx_track_ram_end-SMPS_RAM.v_spcsfx_track_ram)/SMPS_Track.len
SMPS_SPECIAL_SFX_FM_TRACK_COUNT = (SMPS_RAM.v_spcsfx_fm_tracks_end-SMPS_RAM.v_spcsfx_fm_tracks)/SMPS_Track.len
SMPS_SPECIAL_SFX_PSG_TRACK_COUNT = (SMPS_RAM.v_spcsfx_psg_tracks_end-SMPS_RAM.v_spcsfx_psg_tracks)/SMPS_Track.len
; ---------------------------------------------------------------------------
; Macros
; turn a sample rate into a djnz loop counter
pcmLoopCounterBase function sampleRate,baseCycles, 1+(Z80_Clock/(sampleRate)-(baseCycles)+(13/2))/13
pcmLoopCounter function sampleRate, pcmLoopCounterBase(sampleRate,90) ; 90 is the number of cycles zPlaySEGAPCMLoop takes to deliver one sample.
dpcmLoopCounter function sampleRate, pcmLoopCounterBase(sampleRate,301/2) ; 301 is the number of cycles zPlayPCMLoop takes to deliver two samples.
; ---------------------------------------------------------------------------

; Go_SoundTypes:
Go_SoundPriorities:	dc.l SoundPriorities
; Go_SoundD0:
Go_SpecSoundIndex:	dc.l SpecSoundIndex
Go_MusicIndex:		dc.l MusicIndex
Go_SoundIndex:		dc.l SoundIndex
; off_719A0:
Go_SpeedUpIndex:	dc.l SpeedUpIndex
Go_PSGIndex:		dc.l PSG_Index

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG instruments used in music
; ---------------------------------------------------------------------------
PSG_Index:
		dc.l PSG1, PSG2, PSG3
		dc.l PSG4, PSG5, PSG6
		dc.l PSG7, PSG8, PSG9

PSG1:		dc.b 0,0,0,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,$80

PSG2:		dc.b 0,2,4,6,8,$10,$80

PSG3:		dc.b 0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,$80

PSG4:		dc.b 0,0,2,3,4,4,5,5,5,6,$80

PSG6:		dc.b 3,3,3,2,2,2,2,1,1,1,0,0,0,0,$80

PSG5:		dc.b 0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2
		dc.b 2,2,2,3,3,3,3,3,3,3,3,4,$80

PSG7:		dc.b 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2,3,3,3,4,4,4,5,5,5,6,7,$80

PSG8:		dc.b 0,0,0,0,0,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5
		dc.b 5,5,6,6,6,6,6,7,7,7,$80

PSG9:		dc.b 0,1,2,3,4,5,6,7,8,9,$A,$B,$C,$D,$E,$F,$80

; ===========================================================================
; ---------------------------------------------------------------------------
; New tempos for songs during speed shoes
; ---------------------------------------------------------------------------
; DANGER! several songs will use the first few bytes of MusicIndex as their main
; tempos while speed shoes are active. If you don't want that, you should add
; their "correct" sped-up main tempos to the list.
; byte_71A94:
SpeedUpIndex:
		dc.b 7		; GHZ
		dc.b $72	; LZ
		dc.b $73	; MZ
		dc.b $26	; SLZ
		dc.b $15	; SYZ
		dc.b 8		; SBZ
		dc.b $FF	; Invincibility
		dc.b 5		; Extra Life
		;dc.b ?		; Special Stage
		;dc.b ?		; Title Screen
		;dc.b ?		; Ending
		;dc.b ?		; Boss
		;dc.b ?		; FZ
		;dc.b ?		; Sonic Got Through
		;dc.b ?		; Game Over
		;dc.b ?		; Continue Screen
		;dc.b ?		; Credits
		;dc.b ?		; Drowning
		;dc.b ?		; Get Emerald

; ===========================================================================
; ---------------------------------------------------------------------------
; Music Pointers
; ---------------------------------------------------------------------------
MusicIndex:
ptr_mus81:	dc.l Music81
ptr_mus82:	dc.l Music82
ptr_mus83:	dc.l Music83
ptr_mus84:	dc.l Music84
ptr_mus85:	dc.l Music85
ptr_mus86:	dc.l Music86
ptr_mus87:	dc.l Music87
ptr_mus88:	dc.l Music88
ptr_mus89:	dc.l Music89
ptr_mus8A:	dc.l Music8A
ptr_mus8B:	dc.l Music8B
ptr_mus8C:	dc.l Music8C
ptr_mus8D:	dc.l Music8D
ptr_mus8E:	dc.l Music8E
ptr_mus8F:	dc.l Music8F
ptr_mus90:	dc.l Music90
ptr_mus91:	dc.l Music91
ptr_mus92:	dc.l Music92
ptr_mus93:	dc.l Music93
ptr_musend

; ===========================================================================
; ---------------------------------------------------------------------------
; Priority of sound. New music or SFX must have a priority higher than or equal
; to what is stored in v_sndprio or it won't play. If bit 7 of new priority is
; set ($80 and up), the new music or SFX will not set its priority -- meaning
; any music or SFX can override it (as long as it can override whatever was
; playing before). Usually, SFX will only override SFX, special SFX ($D0-$DF)
; will only override special SFX and music will only override music.
; ---------------------------------------------------------------------------
; SoundTypes:
SoundPriorities:
		dc.b     $90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90	; $81
		dc.b $90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90	; $90
		dc.b $80,$70,$70,$70,$70,$70,$70,$70,$70,$70,$68,$70,$70,$70,$60,$70	; $A0
		dc.b $70,$60,$70,$60,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$7F	; $B0
		dc.b $60,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70	; $C0
		dc.b $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80	; $D0
		dc.b $90,$90,$90,$90,$90                                            	; $E0

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to update music more than once per frame
; (Called by horizontal & vert. interrupts)
; ---------------------------------------------------------------------------

; sub_71B4C:
UpdateMusic:
		stopZ80
		nop
		nop
		nop
; loc_71B5A:
.updateloop:
		btst	#0,(z80_bus_request).l			; is the z80 busy?
		bne.s	.updateloop				; if so, wait

		btst	#7,(z80_ram+zDAC_Status).l		; is DAC accepting new samples?
		beq.s	.driverinput				; branch if yes
		startZ80
		nop
		nop
		nop
		nop
		nop
		bra.s	UpdateMusic
; ===========================================================================

; loc_71B82:
.driverinput:
		lea	(v_snddriver_ram&$FFFFFF).l,a6
		clr.b	SMPS_RAM.f_voice_selector(a6)
		tst.b	SMPS_RAM.f_pausemusic(a6)		; is music paused?
		bne.w	PauseMusic				; if yes, branch
		subq.b	#1,SMPS_RAM.v_main_tempo_timeout(a6)	; has main tempo timer expired?
		bne.s	.skipdelay
		jsr	TempoWait(pc)
; loc_71B9E:
.skipdelay:
		move.b	SMPS_RAM.v_fadeout_counter(a6),d0
		beq.s	.skipfadeout
		jsr	DoFadeOut(pc)
; loc_71BA8:
.skipfadeout:
		tst.b	SMPS_RAM.f_fadein_flag(a6)
		beq.s	.skipfadein
		jsr	DoFadeIn(pc)
; loc_71BB2:
.skipfadein:
	if FixBugs
		moveq	#0,d0
		or.b	SMPS_RAM.v_soundqueue2(a6),d0
		or.w	SMPS_RAM.v_soundqueue0(a6),d0
	else
		; DANGER! The following line only checks v_soundqueue0 and v_soundqueue1, breaking v_soundqueue2.
		tst.w	SMPS_RAM.v_soundqueue0(a6)		; is a music or sound queued for playing?
	endif
		beq.s	.nosndinput				; if not, branch
		jsr	CycleSoundQueue(pc)
; loc_71BBC:
.nosndinput:
		cmpi.b	#$80,SMPS_RAM.v_sound_id(a6)		; is song queue set for silence (empty)?
		beq.s	.nonewsound				; if yes, branch
		jsr	PlaySoundID(pc)
; loc_71BC8:
.nonewsound:
		lea	SMPS_RAM.v_music_dac_track(a6),a5
		tst.b	SMPS_Track.PlaybackControl(a5)		; is DAC track playing?
		bpl.s	.dacdone				; branch if not
		jsr	DACUpdateTrack(pc)
; loc_71BD4:
.dacdone:
		clr.b	SMPS_RAM.f_updating_dac(a6)
		moveq	#SMPS_MUSIC_FM_TRACK_COUNT-1,d7		; 6 FM tracks
; loc_71BDA:
.bgmfmloop:
		adda.w	#SMPS_Track.len,a5
		tst.b	SMPS_Track.PlaybackControl(a5)		; is track playing?
		bpl.s	.bgmfmnext				; branch if not
		jsr	FMUpdateTrack(pc)
; loc_71BE6:
.bgmfmnext:
		dbf	d7,.bgmfmloop

		moveq	#SMPS_MUSIC_PSG_TRACK_COUNT-1,d7	; 3 PSG tracks
; loc_71BEC:
.bgmpsgloop:
		adda.w	#SMPS_Track.len,a5
		tst.b	SMPS_Track.PlaybackControl(a5)		; is track playing?
		bpl.s	.bgmpsgnext				; branch if not
		jsr	PSGUpdateTrack(pc)
; loc_71BF8:
.bgmpsgnext:
		dbf	d7,.bgmpsgloop

		move.b	#$80,SMPS_RAM.f_voice_selector(a6)	; now at SFX tracks
		moveq	#SMPS_SFX_FM_TRACK_COUNT-1,d7		; 3 FM tracks (SFX)
; loc_71C04:
.sfxfmloop:
		adda.w	#SMPS_Track.len,a5
		tst.b	SMPS_Track.PlaybackControl(a5)		; is track playing?
		bpl.s	.sfxfmnext				; branch if not
		jsr	FMUpdateTrack(pc)
; loc_71C10:
.sfxfmnext:
		dbf	d7,.sfxfmloop

		moveq	#SMPS_SFX_PSG_TRACK_COUNT-1,d7		; 3 PSG tracks (SFX)
; loc_71C16:
.sfxpsgloop:
		adda.w	#SMPS_Track.len,a5
		tst.b	SMPS_Track.PlaybackControl(a5)		; is track playing?
		bpl.s	.sfxpsgnext				; branch if not
		jsr	PSGUpdateTrack(pc)
; loc_71C22:
.sfxpsgnext:
		dbf	d7,.sfxpsgloop

		move.b	#$40,SMPS_RAM.f_voice_selector(a6)	; now at special SFX tracks
		adda.w	#SMPS_Track.len,a5
		tst.b	SMPS_Track.PlaybackControl(a5)		; is track playing?
		bpl.s	.specfmdone				; branch if not
		jsr	FMUpdateTrack(pc)
; loc_71C38:
.specfmdone:
		adda.w	#SMPS_Track.len,a5
		tst.b	SMPS_Track.PlaybackControl(a5)		; is track playing
		bpl.s	DoStartZ80				; branch if not
		jsr	PSGUpdateTrack(pc)
; loc_71C44:
DoStartZ80:
		startZ80
		rts
; End of function UpdateMusic
; ===========================================================================

; sub_71C4E: UpdateDAC:
DACUpdateTrack:
		subq.b	#1,SMPS_Track.DurationTimeout(a5)	; has DAC sample timeout expired?
		bne.s	.locret					; return if not
		move.b	#$80,SMPS_RAM.f_updating_dac(a6)	; set flag to indicate this is the DAC
;DACDoNext:
		movea.l	SMPS_Track.DataPointer(a5),a4		; dAC track data pointer
; loc_71C5E:
.sampleloop:
		moveq	#0,d5
		move.b	(a4)+,d5				; get next SMPS unit
		cmpi.b	#$E0,d5					; is it a coord. flag?
		blo.s	.notcoord				; branch if not
		jsr	CoordFlag(pc)
		bra.s	.sampleloop
; ===========================================================================
; loc_71C6E:
.notcoord:
		tst.b	d5					; is it a sample?
		bpl.s	.gotduration				; branch if not (duration)
		move.b	d5,SMPS_Track.SavedDAC(a5)		; store new sample
		move.b	(a4)+,d5				; get another byte
		bpl.s	.gotduration				; branch if it is a duration
		subq.w	#1,a4					; put byte back
		move.b	SMPS_Track.SavedDuration(a5),SMPS_Track.DurationTimeout(a5) ; use last duration
		bra.s	.gotsampleduration
; ===========================================================================
; loc_71C84:
.gotduration:
		jsr	SetDuration(pc)
; loc_71C88:
.gotsampleduration:
		move.l	a4,SMPS_Track.DataPointer(a5) 		; save pointer
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is track being overridden?
		bne.s	.locret					; return if yes
		moveq	#0,d0
		move.b	SMPS_Track.SavedDAC(a5),d0		; get sample
		cmpi.b	#$80,d0					; is it a rest?
		beq.s	.locret					; return if yes
		btst	#3,d0					; is bit 3 set (samples between $88-$8F)?
		bne.s	.timpani				; various timpani
		move.b	d0,(z80_ram+zDAC_Sample).l
; locret_71CAA:
.locret:
		rts
; ===========================================================================
; loc_71CAC:
.timpani:
		subi.b	#$88,d0					; convert into an index
		move.b	DAC_sample_rate(pc,d0.w),d0
		; Warning: this affects the raw pitch of sample $83, meaning it will
		; use this value from then on.
		move.b	d0,(z80_ram+zTimpani_Pitch).l
		move.b	#$83,(z80_ram+zDAC_Sample).l		; use timpani
		rts
; End of function DACUpdateTrack

; ===========================================================================
; Note: this only defines rates for samples $88-$8D, meaning $8E-$8F are invalid.
; Also, $8C-$8D are so slow you may want to skip them.
; byte_71CC4:
timpaniLoopCounter function scale,dpcmLoopCounter(int(zDAC_Timpani.sample_rate*scale))

DAC_sample_rate:
		dc.b timpaniLoopCounter(1.30)
		dc.b timpaniLoopCounter(1.20)
		dc.b timpaniLoopCounter(0.97)
		dc.b timpaniLoopCounter(0.95)
		dc.b $FF, $FF
		even
; ===========================================================================

; sub_71CCA:
FMUpdateTrack:
		subq.b	#1,SMPS_Track.DurationTimeout(a5)	; update duration timeout
		bne.s	.notegoing				; branch if it hasn't expired
		bclr	#4,SMPS_Track.PlaybackControl(a5)	; clear 'do not attack next note' bit
		jsr	FMDoNext(pc)
		jsr	FMPrepareNote(pc)
		bra.w	FMNoteOn
; ===========================================================================
; loc_71CE0:
.notegoing:
		jsr	NoteTimeoutUpdate(pc)
		jsr	DoModulation(pc)
		bra.w	FMUpdateFreq
; End of function FMUpdateTrack
; ===========================================================================

; sub_71CEC:
FMDoNext:
		movea.l	SMPS_Track.DataPointer(a5),a4		; track data pointer
		bclr	#1,SMPS_Track.PlaybackControl(a5)	; clear 'track at rest' bit
; loc_71CF4:
.noteloop:
		moveq	#0,d5
		move.b	(a4)+,d5				; get byte from track
		cmpi.b	#$E0,d5					; is this a coord. flag?
		blo.s	.gotnote				; branch if not
		jsr	CoordFlag(pc)
		bra.s	.noteloop
; ===========================================================================
; loc_71D04:
.gotnote:
		jsr	FMNoteOff(pc)
		tst.b	d5					; is this a note?
		bpl.s	.gotduration				; branch if not
		jsr	FMSetFreq(pc)
		move.b	(a4)+,d5				; get another byte
		bpl.s	.gotduration				; branch if it is a duration
		subq.w	#1,a4					; otherwise, put it back
		bra.w	FinishTrackUpdate
; ===========================================================================
; loc_71D1A:
.gotduration:
		jsr	SetDuration(pc)
		bra.w	FinishTrackUpdate
; End of function FMDoNext
; ===========================================================================

; sub_71D22:
FMSetFreq:
		subi.b	#$80,d5					; make it a zero-based index
		beq.s	TrackSetRest
		add.b	SMPS_Track.Transpose(a5),d5		; add track transposition
		andi.w	#$7F,d5					; clear high byte and sign bit
		lsl.w	#1,d5
		lea	FMFrequencies(pc),a0
		move.w	(a0,d5.w),d6
		move.w	d6,SMPS_Track.Freq(a5)			; store new frequency
		rts
; End of function FMSetFreq
; ===========================================================================

; sub_71D40:
SetDuration:
		move.b	d5,d0
		move.b	SMPS_Track.TempoDivider(a5),d1		; get dividing timing
; loc_71D46:
.multloop:
		subq.b	#1,d1
		beq.s	.donemult
		add.b	d5,d0
		bra.s	.multloop
; ===========================================================================
; loc_71D4E:
.donemult:
		move.b	d0,SMPS_Track.SavedDuration(a5)		; save duration
		move.b	d0,SMPS_Track.DurationTimeout(a5)	; save duration timeout
		rts
; End of function SetDuration

; ===========================================================================
; loc_71D58:
TrackSetRest:
		bset	#1,SMPS_Track.PlaybackControl(a5)	; set 'track at rest' bit
		clr.w	SMPS_Track.Freq(a5)			; clear frequency
; ===========================================================================

; sub_71D60:
FinishTrackUpdate:
		move.l	a4,SMPS_Track.DataPointer(a5)		; store new track position
		move.b	SMPS_Track.SavedDuration(a5),SMPS_Track.DurationTimeout(a5) ; reset note timeout
		btst	#4,SMPS_Track.PlaybackControl(a5)	; is track set to not attack note?
		bne.s	.locret					; if so, branch
		move.b	SMPS_Track.NoteTimeoutMaster(a5),SMPS_Track.NoteTimeout(a5) ; reset note fill timeout
		clr.b	SMPS_Track.VolEnvIndex(a5)		; reset PSG volume envelope index (even on FM tracks...)
		btst	#3,SMPS_Track.PlaybackControl(a5)	; is modulation on?
		beq.s	.locret					; if not, return
		movea.l	SMPS_Track.ModulationPtr(a5),a0		; modulation data pointer
		move.b	(a0)+,SMPS_Track.ModulationWait(a5)	; reset wait
		move.b	(a0)+,SMPS_Track.ModulationSpeed(a5)	; reset speed
		move.b	(a0)+,SMPS_Track.ModulationDelta(a5)	; reset delta
		move.b	(a0)+,d0				; get steps
		lsr.b	#1,d0					; halve them
		move.b	d0,SMPS_Track.ModulationSteps(a5)	; then store
		clr.w	SMPS_Track.ModulationVal(a5)		; reset frequency change
; locret_71D9C:
.locret:
		rts
; End of function FinishTrackUpdate
; ===========================================================================

; sub_71D9E: NoteFillUpdate
NoteTimeoutUpdate:
		tst.b	SMPS_Track.NoteTimeout(a5)		; is note fill on?
		beq.s	.locret
		subq.b	#1,SMPS_Track.NoteTimeout(a5)		; update note fill timeout
		bne.s	.locret					; return if it hasn't expired
		bset	#1,SMPS_Track.PlaybackControl(a5)	; put track at rest
		tst.b	SMPS_Track.VoiceControl(a5)		; is this a PSG track?
		bmi.w	.psgnoteoff				; if yes, branch
		jsr	FMNoteOff(pc)
		addq.w	#4,sp					; do not return to caller
		rts
; ===========================================================================
; loc_71DBE:
.psgnoteoff:
		jsr	PSGNoteOff(pc)
		addq.w	#4,sp					; do not return to caller
; locret_71DC4:
.locret:
		rts
; End of function NoteTimeoutUpdate
; ===========================================================================

; sub_71DC6:
DoModulation:
		addq.w	#4,sp					; do not return to caller (but see below)
		btst	#3,SMPS_Track.PlaybackControl(a5)	; is modulation active?
		beq.s	.locret					; return if not
		tst.b	SMPS_Track.ModulationWait(a5)		; has modulation wait expired?
		beq.s	.waitdone				; if yes, branch
		subq.b	#1,SMPS_Track.ModulationWait(a5)	; update wait timeout
		rts
; ===========================================================================
; loc_71DDA:
.waitdone:
		subq.b	#1,SMPS_Track.ModulationSpeed(a5)	; update speed
		beq.s	.updatemodulation			; if it expired, want to update modulation
		rts
; ===========================================================================
; loc_71DE2:
.updatemodulation:
		movea.l	SMPS_Track.ModulationPtr(a5),a0		; get modulation data
		move.b	1(a0),SMPS_Track.ModulationSpeed(a5)	; restore modulation speed
		tst.b	SMPS_Track.ModulationSteps(a5)		; check number of steps
		bne.s	.calcfreq				; if nonzero, branch
		move.b	3(a0),SMPS_Track.ModulationSteps(a5)	; restore from modulation data
		neg.b	SMPS_Track.ModulationDelta(a5)		; negate modulation delta
		rts
; ===========================================================================
; loc_71DFE:
.calcfreq:
		subq.b	#1,SMPS_Track.ModulationSteps(a5)	; update modulation steps
		move.b	SMPS_Track.ModulationDelta(a5),d6	; get modulation delta
		ext.w	d6
		add.w	SMPS_Track.ModulationVal(a5),d6		; add cumulative modulation change
		move.w	d6,SMPS_Track.ModulationVal(a5)		; store it
		add.w	SMPS_Track.Freq(a5),d6			; add note frequency to it
		subq.w	#4,sp					; in this case, we want to return to caller after all
; locret_71E16:
.locret:
		rts
; End of function DoModulation
; ===========================================================================

; sub_71E18:
FMPrepareNote:
		btst	#1,SMPS_Track.PlaybackControl(a5)	; is track resting?
		bne.s	locret_71E48				; return if so
		move.w	SMPS_Track.Freq(a5),d6			; get current note frequency
		beq.s	FMSetRest				; branch if zero
; loc_71E24:
FMUpdateFreq:
		move.b	SMPS_Track.Detune(a5),d0		; get detune value
		ext.w	d0
		add.w	d0,d6					; add note frequency
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is track being overridden?
		bne.s	locret_71E48				; return if so
		move.w	d6,d1
		lsr.w	#8,d1
		move.b	#$A4,d0					; register for upper 6 bits of frequency
		jsr	WriteFMIorII(pc)
		move.b	d6,d1
		move.b	#$A0,d0					; register for lower 8 bits of frequency
		jsr	WriteFMIorII(pc)			; (it would be better if this were a jmp)
; locret_71E48:
locret_71E48:
		rts
; ===========================================================================
; loc_71E4A:
FMSetRest:
		bset	#1,SMPS_Track.PlaybackControl(a5)	; set 'track at rest' bit
		rts
; End of function FMPrepareNote

; ===========================================================================
; loc_71E50:
PauseMusic:
		bmi.s	.unpausemusic				; branch if music is being unpaused
		cmpi.b	#2,SMPS_RAM.f_pausemusic(a6)
		beq.w	.unpausedallfm
		move.b	#2,SMPS_RAM.f_pausemusic(a6)
		moveq	#2,d3
		move.b	#$B4,d0					; command to set AMS/FMS/panning
		moveq	#0,d1					; no panning, AMS or FMS
; loc_71E6A:
.killpanloop:
		jsr	WriteFMI(pc)
		jsr	WriteFMII(pc)
		addq.b	#1,d0
		dbf	d3,.killpanloop

		moveq	#2,d3
		moveq	#$28,d0					; key on/off register
; loc_71E7C:
.noteoffloop:
		move.b	d3,d1					; FM1, FM2, FM3
		jsr	WriteFMI(pc)
		addq.b	#4,d1					; FM4, FM5, FM6
		jsr	WriteFMI(pc)
		dbf	d3,.noteoffloop

		jsr	PSGSilenceAll(pc)
		bra.w	DoStartZ80
; ===========================================================================
; loc_71E94:
.unpausemusic:
		clr.b	SMPS_RAM.f_pausemusic(a6)
		moveq	#SMPS_Track.len,d3
		lea	SMPS_RAM.v_music_fmdac_tracks(a6),a5
		moveq	#SMPS_MUSIC_FM_DAC_TRACK_COUNT-1,d4	; 6 FM + 1 DAC tracks
; loc_71EA0:
.bgmfmloop:
		btst	#7,SMPS_Track.PlaybackControl(a5)	; is track playing?
		beq.s	.bgmfmnext				; branch if not
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is track being overridden?
		bne.s	.bgmfmnext				; branch if yes
		move.b	#$B4,d0					; command to set AMS/FMS/panning
		move.b	SMPS_Track.AMSFMSPan(a5),d1		; get value from track RAM
		jsr	WriteFMIorII(pc)
; loc_71EB8:
.bgmfmnext:
		adda.w	d3,a5
		dbf	d4,.bgmfmloop

		lea	SMPS_RAM.v_sfx_fm_tracks(a6),a5
		moveq	#SMPS_SFX_FM_TRACK_COUNT-1,d4		; 3 FM tracks (SFX)
; loc_71EC4:
.sfxfmloop:
		btst	#7,SMPS_Track.PlaybackControl(a5)	; is track playing?
		beq.s	.sfxfmnext				; branch if not
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is track being overridden?
		bne.s	.sfxfmnext				; branch if yes
		move.b	#$B4,d0					; command to set AMS/FMS/panning
		move.b	SMPS_Track.AMSFMSPan(a5),d1		; get value from track RAM
		jsr	WriteFMIorII(pc)
; loc_71EDC:
.sfxfmnext:
		adda.w	d3,a5
		dbf	d4,.sfxfmloop

		lea	SMPS_RAM.v_spcsfx_track_ram(a6),a5
		btst	#7,SMPS_Track.PlaybackControl(a5)	; is track playing?
		beq.s	.unpausedallfm				; branch if not
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is track being overridden?
		bne.s	.unpausedallfm				; branch if yes
		move.b	#$B4,d0					; command to set AMS/FMS/panning
		move.b	SMPS_Track.AMSFMSPan(a5),d1		; get value from track RAM
		jsr	WriteFMIorII(pc)
; loc_71EFE:
.unpausedallfm:
		bra.w	DoStartZ80

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to play a sound or music track
; ---------------------------------------------------------------------------

; Sound_Play:
CycleSoundQueue:
		movea.l	(Go_SoundPriorities).l,a0
		lea	SMPS_RAM.v_soundqueue0(a6),a1		; load music track number
		_move.b	SMPS_RAM.v_sndprio(a6),d3		; get priority of currently playing SFX
		moveq	#SMPS_RAM.v_soundqueue_end-SMPS_RAM.v_soundqueue_start-1,d4
; loc_71F12:
.inputloop:
		move.b	(a1),d0					; move track number to d0
		move.b	d0,d1
		clr.b	(a1)+					; clear entry
		subi.b	#bgm__First,d0				; make it into 0-based index
		bcs.s	.nextinput				; if negative (i.e., it was $80 or lower), branch
		cmpi.b	#$80,SMPS_RAM.v_sound_id(a6)		; is v_sound_id a $80 (silence/empty)?
		beq.s	.havesound				; if yes, branch
		move.b	d1,SMPS_RAM.v_soundqueue0(a6)		; put sound into v_soundqueue0
		bra.s	.nextinput
; ===========================================================================
; loc_71F2C:
.havesound:
		andi.w	#$7F,d0					; clear high byte and sign bit
		move.b	(a0,d0.w),d2				; get sound type
		cmp.b	d3,d2					; is it a lower priority sound?
		blo.s	.nextinput				; branch if yes
		move.b	d2,d3					; store new priority
		move.b	d1,SMPS_RAM.v_sound_id(a6)		; queue sound for playing
; loc_71F3E:
.nextinput:
		dbf	d4,.inputloop

		tst.b	d3					; we don't want to change sound priority if it is negative
		bmi.s	.locret
		_move.b	d3,SMPS_RAM.v_sndprio(a6)		; set new sound priority
; locret_71F4A:
.locret:
		rts
; End of function CycleSoundQueue
; ===========================================================================

; Sound_ChkValue:
PlaySoundID:
		moveq	#0,d7
		move.b	SMPS_RAM.v_sound_id(a6),d7
		beq.w	StopAllSound
		bpl.s	.locret					; if >= 0, return (not a valid sound, bgm or command)
		move.b	#$80,SMPS_RAM.v_sound_id(a6)		; reset music flag
	if FixBugs
		cmpi.b	#bgm__Last,d7				; is this music ($81-$93)?
	else
		; DANGER! Music ends at $93, yet this checks until $9F; attempting to
		; play sounds $94-$9F will cause a crash!
		; See LevSel_NoCheat for more.
		cmpi.b	#bgm__Last+$C,d7			; is this music ($81-$9F)?
	endif
		bls.w	Sound_PlayBGM				; branch if yes
		cmpi.b	#sfx__First,d7				; is this after music but before sfx? (redundant check)
		blo.w	.locret					; return if yes
		cmpi.b	#sfx__Last,d7				; is this sfx ($A0-$CF)?
		bls.w	Sound_PlaySFX				; branch if yes
		cmpi.b	#spec__First,d7				; is this after sfx but before special sfx? (redundant check)
		blo.w	.locret					; return if yes
	if FixBugs
		cmpi.b	#spec__Last,d7				; is this special sfx ($D0-$D0)?
		bls.w	Sound_PlaySpecial			; branch if yes
		cmpi.b	#flg__First,d7				; is this after special sfx but before $E0?
		blo.w	.locret					; return if yes
	else
		; DANGER! Special SFXes end at $D0, yet this checks until $DF; attempting to
		; play sounds $D1-$DF will cause a crash!
		cmpi.b	#spec__Last+$10,d7			; is this special sfx ($D0-$DF)?
		blo.w	Sound_PlaySpecial			; branch if yes
	endif
		cmpi.b	#flg__Last,d7				; is this $E0-$E4?
		bls.s	Sound_E0toE4				; branch if yes
; locret_71F8C:
.locret:
		rts
; ===========================================================================

Sound_E0toE4:
		subi.b	#flg__First,d7
		lsl.w	#2,d7
		jmp	Sound_ExIndex(pc,d7.w)
; ===========================================================================

Sound_ExIndex:
ptr_flgE0:	bra.w	FadeOutMusic	; $E0
ptr_flgE1:	bra.w	PlaySegaSound	; $E1
ptr_flgE2:	bra.w	SpeedUpMusic	; $E2
ptr_flgE3:	bra.w	SlowDownMusic	; $E3
ptr_flgE4:	bra.w	StopAllSound	; $E4
ptr_flgend
; ===========================================================================
; ---------------------------------------------------------------------------
; Play "Say-gaa" PCM sound
; ---------------------------------------------------------------------------
; Sound_E1: PlaySega:
PlaySegaSound:
		lea	(port_1_data).l,a1	; Load first joypad port into a1
		lea	(SegaPCM).l,a2		; Load the SEGA PCM sample into a2
		move.l	#SegaPCM.size,d3	; Load the size of the SEGA PCM sample into d3 
		move.b	#$2A,(ym2612_a0).l	; $A04000 = $2A -> Write to DAC channel	  

.PlayPCM_Loop:	  
		move.b	(a2)+,(ym2612_d0).l	; Write the PCM data (contained in a2) to $A04001 (YM2612 register D0) 
		moveq	#39,d0			; Set cycles to waste for pitch control to d0 (roughly 400 cycles)
		dbf	d0,*			; Decrement d0; jump to itself if not 0 (pitch control)
		subq.l	#1,d3			; Subtract 1 from the PCM sample size (we can't use dbf here, d3 is too big)
		beq.s	.return_PlayPCM		; If d3 = 0, we finished playing the PCM sample, so stop playing, leave this loop, and unfreeze the 68K
		move.b	#0,(a1)			; Read A and Start input (normally requires extra nops, but makes no effective difference here)
		btst	#bitStart-2,(a1)	; Check for Start button (-2 because it's not bit-shifted yet)
		bne.s	.PlayPCM_Loop		; If start was not pressed, continue playing PCM sample (bne because it wasn't NOT'd)
		
.return_PlayPCM: 				; Otherwise, stop playing, leave this loop, and unfreeze the 68K
		addq.w	#4,sp			; Tamper return value so we don't return to caller
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Play music track $81-$9F
; ---------------------------------------------------------------------------
; Sound_81to9F:
Sound_PlayBGM:
		cmpi.b	#bgm_ExtraLife,d7			; is the "extra life" music to be played?
		bne.s	.bgmnot1up				; if not, branch
		tst.b	SMPS_RAM.f_1up_playing(a6)		; is a 1-up music playing?
		bne.w	.locdblret				; if yes, branch
		lea	SMPS_RAM.v_music_track_ram(a6),a5
		moveq	#SMPS_MUSIC_TRACK_COUNT-1,d0		; 1 DAC + 6 FM + 3 PSG tracks
; loc_71FE6:
.clearsfxloop:
		bclr	#2,SMPS_Track.PlaybackControl(a5)	; clear 'SFX is overriding' bit
		adda.w	#SMPS_Track.len,a5
		dbf	d0,.clearsfxloop

		lea	SMPS_RAM.v_sfx_track_ram(a6),a5
		moveq	#SMPS_SFX_TRACK_COUNT-1,d0		; 3 FM + 3 PSG tracks (SFX)
; loc_71FF8:
.cleartrackplayloop:
		bclr	#7,SMPS_Track.PlaybackControl(a5)	; clear 'track is playing' bit
		adda.w	#SMPS_Track.len,a5
		dbf	d0,.cleartrackplayloop

		_clr.b	SMPS_RAM.v_sndprio(a6)			; clear priority
		movea.l	a6,a0
		lea	SMPS_RAM.v_1up_ram_copy(a6),a1
		move.w	#((SMPS_RAM.v_1up_ram_end-SMPS_RAM.v_1up_ram)/4)-1,d0 ; backup $220 bytes: all variables and music track data
; loc_72012:
.backupramloop:
		move.l	(a0)+,(a1)+
		dbf	d0,.backupramloop

		move.b	#$80,SMPS_RAM.f_1up_playing(a6)
		_clr.b	SMPS_RAM.v_sndprio(a6)			; clear priority again (?)
		bra.s	.bgm_loadMusic
; ===========================================================================
; loc_72024:
.bgmnot1up:
		clr.b	SMPS_RAM.f_1up_playing(a6)
		clr.b	SMPS_RAM.v_fadein_counter(a6)
; loc_7202C:
.bgm_loadMusic:
		jsr	InitMusicPlayback(pc)
		movea.l	(Go_SpeedUpIndex).l,a4
		subi.b	#bgm__First,d7
		move.b	(a4,d7.w),SMPS_RAM.v_speeduptempo(a6)
		movea.l	(Go_MusicIndex).l,a4
		lsl.w	#2,d7
		movea.l	(a4,d7.w),a4				; a4 now points to (uncompressed) song data
		moveq	#0,d0
		move.w	(a4),d0					; load voice pointer
		add.l	a4,d0					; it is a relative pointer
		move.l	d0,SMPS_RAM.v_voice_ptr(a6)
		move.b	5(a4),d0				; load tempo
		move.b	d0,SMPS_RAM.v_tempo_mod(a6)
		tst.b	SMPS_RAM.f_speedup(a6)
		beq.s	.nospeedshoes
		move.b	SMPS_RAM.v_speeduptempo(a6),d0
; loc_72068:
.nospeedshoes:
		move.b	d0,SMPS_RAM.v_main_tempo(a6)
		move.b	d0,SMPS_RAM.v_main_tempo_timeout(a6)
		moveq	#0,d1
		movea.l	a4,a3
		addq.w	#6,a4					; point past header
	if FixBugs
		; Fix the 0FM/DAC fade-in bug
		; https://info.sonicretro.org/SCHG_How-to:Fix_Song_Restoration_Bugs_in_Sonic_1%27s_Sound_Driver
		move.b	4(a3),d4				; load tempo dividing timing
		moveq	#SMPS_Track.len,d6
		moveq	#0,d7
		move.b	#1,d5					; note duration for first "note"
		move.b	2(a3),d7				; load number of FM+DAC tracks
		beq.w	.bgm_fmdone				; branch if zero
		subq.b	#1,d7
		move.b	#$C0,d1					; default AMS+FMS+Panning
	else
		moveq	#0,d7
		move.b	2(a3),d7				; load number of FM+DAC tracks
		beq.w	.bgm_fmdone				; branch if zero
		subq.b	#1,d7
		move.b	#$C0,d1					; default AMS+FMS+Panning
		move.b	4(a3),d4				; load tempo dividing timing
		moveq	#SMPS_Track.len,d6
		move.b	#1,d5					; note duration for first "note"
	endif
		lea	SMPS_RAM.v_music_fmdac_tracks(a6),a1
		lea	FMDACInitBytes(pc),a2
; loc_72098:
.bgm_fmloadloop:
		bset	#7,SMPS_Track.PlaybackControl(a1)	; initial playback control: set 'track playing' bit
		move.b	(a2)+,SMPS_Track.VoiceControl(a1)	; voice control bits
		move.b	d4,SMPS_Track.TempoDivider(a1)
		move.b	d6,SMPS_Track.StackPointer(a1)		; set "gosub" (coord flag $F8) stack init value
		move.b	d1,SMPS_Track.AMSFMSPan(a1)		; set AMS/FMS/Panning
		move.b	d5,SMPS_Track.DurationTimeout(a1)	; set duration of first "note"
		moveq	#0,d0
		move.w	(a4)+,d0				; load DAC/FM pointer
		add.l	a3,d0					; relative pointer
		move.l	d0,SMPS_Track.DataPointer(a1)		; store track pointer
		move.w	(a4)+,SMPS_Track.Transpose(a1)		; load FM channel modifier
		adda.w	d6,a1
		dbf	d7,.bgm_fmloadloop

		cmpi.b	#7,2(a3)				; are 7 FM tracks defined?
		bne.s	.silencefm6
		moveq	#$2B,d0					; DAC enable/disable register
		moveq	#0,d1					; disable DAC
		jsr	WriteFMI(pc)
		bra.w	.bgm_fmdone
; ===========================================================================
; loc_720D8:
.silencefm6:
		moveq	#$28,d0					; key on/off register
		moveq	#6,d1					; note off on all operators of channel 6
		jsr	WriteFMI(pc)
		move.b	#$42,d0					; TL for operator 1 of FM6
		moveq	#$7F,d1					; total silence
		jsr	WriteFMII(pc)
		move.b	#$4A,d0					; TL for operator 3 of FM6
		moveq	#$7F,d1					; total silence
		jsr	WriteFMII(pc)
		move.b	#$46,d0					; TL for operator 2 of FM6
		moveq	#$7F,d1					; total silence
		jsr	WriteFMII(pc)
		move.b	#$4E,d0					; TL for operator 4 of FM6
		moveq	#$7F,d1					; total silence
		jsr	WriteFMII(pc)
		move.b	#$B6,d0					; AMS/FMS/panning of FM6
		move.b	#$C0,d1					; stereo
		jsr	WriteFMII(pc)
; loc_72114:
.bgm_fmdone:
		moveq	#0,d7
		move.b	3(a3),d7				; load number of PSG tracks
		beq.s	.bgm_psgdone				; branch if zero
		subq.b	#1,d7
		lea	SMPS_RAM.v_music_psg_tracks(a6),a1
		lea	PSGInitBytes(pc),a2
; loc_72126:
.bgm_psgloadloop:
		bset	#7,SMPS_Track.PlaybackControl(a1)	; initial playback control: set 'track playing' bit
		move.b	(a2)+,SMPS_Track.VoiceControl(a1)	; voice control bits
		move.b	d4,SMPS_Track.TempoDivider(a1)
		move.b	d6,SMPS_Track.StackPointer(a1)		; set "gosub" (coord flag $F8) stack init value
		move.b	d5,SMPS_Track.DurationTimeout(a1)	; set duration of first "note"
		moveq	#0,d0
		move.w	(a4)+,d0				; load PSG channel pointer
		add.l	a3,d0					; relative pointer
		move.l	d0,SMPS_Track.DataPointer(a1)		; store track pointer
		move.w	(a4)+,SMPS_Track.Transpose(a1)		; load PSG modifier
		move.b	(a4)+,d0				; load redundant byte
		move.b	(a4)+,SMPS_Track.VoiceIndex(a1)		; initial PSG tone
		adda.w	d6,a1
		dbf	d7,.bgm_psgloadloop
; loc_72154:
.bgm_psgdone:
		lea	SMPS_RAM.v_sfx_track_ram(a6),a1
		moveq	#SMPS_SFX_TRACK_COUNT-1,d7		; 6 SFX tracks
; loc_7215A:
.sfxstoploop:
		tst.b	SMPS_Track.PlaybackControl(a1)		; is SFX playing?
		bpl.w	.sfxnext				; branch if not
		moveq	#0,d0
		move.b	SMPS_Track.VoiceControl(a1),d0		; get voice control bits
		bmi.s	.sfxpsgchannel				; branch if this is a PSG channel
		subq.b	#2,d0					; sFX can't have FM1 or FM2
		lsl.b	#2,d0					; convert to index
		bra.s	.gotchannelindex
; ===========================================================================
; loc_7216E:
.sfxpsgchannel:
		lsr.b	#3,d0					; convert to index
; loc_72170:
.gotchannelindex:
		lea	SFX_BGMChannelRAM(pc),a0
		movea.l	(a0,d0.w),a0
		bset	#2,SMPS_Track.PlaybackControl(a0)	; set 'SFX is overriding' bit
; loc_7217C:
.sfxnext:
		adda.w	d6,a1
		dbf	d7,.sfxstoploop

		tst.w	SMPS_RAM.v_spcsfx_fm4_track.PlaybackControl(a6)	 ; is special SFX being played?
		bpl.s	.checkspecialpsg			; branch if not
		bset	#2,SMPS_RAM.v_music_fm4_track.PlaybackControl(a6) ; set 'SFX is overriding' bit
; loc_7218E:
.checkspecialpsg:
		tst.w	SMPS_RAM.v_spcsfx_psg3_track.PlaybackControl(a6) ; is special SFX being played?
		bpl.s	.sendfmnoteoff				; branch if not
		bset	#2,SMPS_RAM.v_music_psg3_track.PlaybackControl(a6) ; set 'SFX is overriding' bit
; loc_7219A:
.sendfmnoteoff:
		lea	SMPS_RAM.v_music_fm_tracks(a6),a5
		moveq	#SMPS_MUSIC_FM_TRACK_COUNT-1,d4		; 6 FM tracks
; loc_721A0:
.fmnoteoffloop:
		jsr	FMNoteOff(pc)
		adda.w	d6,a5
		dbf	d4,.fmnoteoffloop			; run all FM tracks
		moveq	#SMPS_MUSIC_PSG_TRACK_COUNT-1,d4	; 3 PSG tracks
; loc_721AC:
.psgnoteoffloop:
		jsr	PSGNoteOff(pc)
		adda.w	d6,a5
		dbf	d4,.psgnoteoffloop			; run all PSG tracks
; loc_721B6:
.locdblret:
		addq.w	#4,sp					; tamper with return value to not return to caller
		rts
; ===========================================================================
; byte_721BA:
FMDACInitBytes:	; first byte is for DAC; then notice the 0, 1, 2 then 4, 5, 6
		; this is the gap between parts I and II for YM2612 port writes
		dc.b 6,	0, 1, 2, 4, 5, 6
		even
; byte_721C2:
PSGInitBytes:	; specifically, these configure writes to the PSG port for each channel
		dc.b $80, $A0, $C0
		even
; ===========================================================================
; ---------------------------------------------------------------------------
; Play normal sound effect
; ---------------------------------------------------------------------------
; Sound_A0toCF:
Sound_PlaySFX:
		tst.b	SMPS_RAM.f_1up_playing(a6)		; is 1-up playing?
		bne.w	.clear_sndprio				; exit is it is
		tst.b	SMPS_RAM.v_fadeout_counter(a6)		; is music being faded out?
		bne.w	.clear_sndprio				; exit if it is
		tst.b	SMPS_RAM.f_fadein_flag(a6)		; is music being faded in?
		bne.w	.clear_sndprio				; exit if it is
		cmpi.b	#sfx_Ring,d7				; is ring sound effect played?
		bne.s	.sfx_notRing				; if not, branch
		tst.b	SMPS_RAM.v_ring_speaker(a6)		; is the ring sound playing on right speaker?
		bne.s	.gotringspeaker				; branch if not
		move.b	#sfx_RingLeft,d7			; play ring sound in left speaker
; loc_721EE:
.gotringspeaker:
		bchg	#0,SMPS_RAM.v_ring_speaker(a6)		; change speaker
; Sound_notB5:
.sfx_notRing:
		cmpi.b	#sfx_Push,d7				; is "pushing" sound played?
		bne.s	.sfx_notPush				; if not, branch
		tst.b	SMPS_RAM.f_push_playing(a6)		; is pushing sound already playing?
		bne.w	.locret					; return if not
		move.b	#$80,SMPS_RAM.f_push_playing(a6)	; mark it as playing
; Sound_notA7:
.sfx_notPush:
		movea.l	(Go_SoundIndex).l,a0
		subi.b	#sfx__First,d7				; make it 0-based
		lsl.w	#2,d7					; convert sfx ID into index
		movea.l	(a0,d7.w),a3				; sFX data pointer
		movea.l	a3,a1
		moveq	#0,d1
		move.w	(a1)+,d1				; voice pointer
		add.l	a3,d1					; relative pointer
		move.b	(a1)+,d5				; dividing timing
	if FixBugs
		; DANGER! there is a missing 'moveq	#0,d7' here, without which SFXes whose
		; index entry is above $3F will cause a crash.
		; This bug is fixed in Ristar's driver.
		moveq	#0,d7
	endif
		move.b	(a1)+,d7				; number of tracks (FM + PSG)
		subq.b	#1,d7
		moveq	#SMPS_Track.len,d6
; loc_72228:
.sfx_loadloop:
		moveq	#0,d3
		move.b	1(a1),d3				; channel assignment bits
		move.b	d3,d4
		bmi.s	.sfxinitpsg				; branch if PSG
		subq.w	#2,d3					; SFX can only have FM3, FM4 or FM5
		lsl.w	#2,d3
		lea	SFX_BGMChannelRAM(pc),a5
		movea.l	(a5,d3.w),a5
		bset	#2,SMPS_Track.PlaybackControl(a5)	; mark music track as being overridden
		bra.s	.sfxoverridedone
; ===========================================================================
; loc_72244:
.sfxinitpsg:
		lsr.w	#3,d3
		lea	SFX_BGMChannelRAM(pc),a5
		movea.l	(a5,d3.w),a5
		bset	#2,SMPS_Track.PlaybackControl(a5)	; mark music track as being overridden
		cmpi.b	#$C0,d4					; is this PSG 3?
		bne.s	.sfxoverridedone			; branch if not
		move.b	d4,d0
		ori.b	#$1F,d0					; command to silence PSG 3
		move.b	d0,(psg_input).l
		bchg	#5,d0					; command to silence noise channel
		move.b	d0,(psg_input).l
; loc_7226E:
.sfxoverridedone:
		movea.l	SFX_SFXChannelRAM(pc,d3.w),a5
		movea.l	a5,a2
		moveq	#(SMPS_Track.len/4)-1,d0		; $30 bytes
; loc_72276:
.clearsfxtrackram:
		clr.l	(a2)+
		dbf	d0,.clearsfxtrackram

		move.w	(a1)+,SMPS_Track.PlaybackControl(a5)	; initial playback control bits
		move.b	d5,SMPS_Track.TempoDivider(a5)		; initial voice control bits
		moveq	#0,d0
		move.w	(a1)+,d0				; track data pointer
		add.l	a3,d0					; relative pointer
		move.l	d0,SMPS_Track.DataPointer(a5)		; store track pointer
		move.w	(a1)+,SMPS_Track.Transpose(a5)		; load FM/PSG channel modifier
		move.b	#1,SMPS_Track.DurationTimeout(a5)	; set duration of first "note"
		move.b	d6,SMPS_Track.StackPointer(a5)		; set "gosub" (coord flag $F8) stack init value
		tst.b	d4					; is this a PSG channel?
		bmi.s	.sfxpsginitdone				; branch if yes
		move.b	#$C0,SMPS_Track.AMSFMSPan(a5)		; AMS/FMS/Panning
		move.l	d1,SMPS_Track.VoicePtr(a5)		; voice pointer
; loc_722A8:
.sfxpsginitdone:
		dbf	d7,.sfx_loadloop

		tst.b	SMPS_RAM.v_sfx_fm4_track.PlaybackControl(a6) ; is special SFX being played?
		bpl.s	.doneoverride				; branch if not
		bset	#2,SMPS_RAM.v_spcsfx_fm4_track.PlaybackControl(a6) ; set 'SFX is overriding' bit
; loc_722B8:
.doneoverride:
		tst.b	SMPS_RAM.v_sfx_psg3_track.PlaybackControl(a6) ; is SFX being played?
		bpl.s	.locret					; branch if not
		bset	#2,SMPS_RAM.v_spcsfx_psg3_track.PlaybackControl(a6) ; set 'SFX is overriding' bit
; locret_722C4:
.locret:
		rts
; ===========================================================================
; loc_722C6:
.clear_sndprio:
		_clr.b	SMPS_RAM.v_sndprio(a6)			; clear priority
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; RAM addresses for FM and PSG channel variables used by the SFX
; ---------------------------------------------------------------------------
; dword_722CC: BGMChannelRAM:
SFX_BGMChannelRAM:
		dc.l (v_snddriver_ram.v_music_fm3_track)&$FFFFFF
		dc.l 0
		dc.l (v_snddriver_ram.v_music_fm4_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_music_fm5_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_music_psg1_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_music_psg2_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_music_psg3_track)&$FFFFFF ; plain PSG3
		dc.l (v_snddriver_ram.v_music_psg3_track)&$FFFFFF ; noise
; dword_722EC: SFXChannelRAM:
SFX_SFXChannelRAM:
		dc.l (v_snddriver_ram.v_sfx_fm3_track)&$FFFFFF
		dc.l 0
		dc.l (v_snddriver_ram.v_sfx_fm4_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_sfx_fm5_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_sfx_psg1_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_sfx_psg2_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_sfx_psg3_track)&$FFFFFF ; plain PSG3
		dc.l (v_snddriver_ram.v_sfx_psg3_track)&$FFFFFF ; noise
; ===========================================================================
; ---------------------------------------------------------------------------
; Play GHZ waterfall sound
; ---------------------------------------------------------------------------
; Sound_D0toDF:
Sound_PlaySpecial:
		tst.b	SMPS_RAM.f_1up_playing(a6)		; is 1-up playing?
		bne.w	.locret					; return if so
		tst.b	SMPS_RAM.v_fadeout_counter(a6)		; is music being faded out?
		bne.w	.locret					; exit if it is
		tst.b	SMPS_RAM.f_fadein_flag(a6)		; is music being faded in?
		bne.w	.locret					; exit if it is
		movea.l	(Go_SpecSoundIndex).l,a0
		subi.b	#spec__First,d7				; make it 0-based
		lsl.w	#2,d7
		movea.l	(a0,d7.w),a3
		movea.l	a3,a1
		moveq	#0,d0
		move.w	(a1)+,d0				; voice pointer
		add.l	a3,d0					; relative pointer
		move.l	d0,SMPS_RAM.v_special_voice_ptr(a6)	; store voice pointer
		move.b	(a1)+,d5				; dividing timing
	if FixBugs
		; DANGER! there is a missing 'moveq	#0,d7' here, without which special SFXes whose
		; index entry is above $3F will cause a crash. This instance was not fixed in Ristar's driver.
		moveq	#0,d7
	endif
		move.b	(a1)+,d7				; number of tracks (FM + PSG)
		subq.b	#1,d7
		moveq	#SMPS_Track.len,d6
; loc_72348:
.sfxloadloop:
		move.b	1(a1),d4				; voice control bits
		bmi.s	.sfxoverridepsg				; branch if PSG
		bset	#2,SMPS_RAM.v_music_fm4_track.PlaybackControl(a6) ; set 'SFX is overriding' bit

		lea	SMPS_RAM.v_spcsfx_fm4_track(a6),a5
		bra.s	.sfxinitpsg
; ===========================================================================
; loc_7235A:
.sfxoverridepsg:
		bset	#2,SMPS_RAM.v_music_psg3_track.PlaybackControl(a6) ; set 'SFX is overriding' bit
		lea	SMPS_RAM.v_spcsfx_psg3_track(a6),a5
; loc_72364:
.sfxinitpsg:
		movea.l	a5,a2
		moveq	#(SMPS_Track.len/4)-1,d0		; $30 bytes
; loc_72368:
.clearsfxtrackram:
		clr.l	(a2)+
		dbf	d0,.clearsfxtrackram

		move.w	(a1)+,SMPS_Track.PlaybackControl(a5)	; initial playback control bits & voice control bits
		move.b	d5,SMPS_Track.TempoDivider(a5)
		moveq	#0,d0
		move.w	(a1)+,d0				; track data pointer
		add.l	a3,d0					; relative pointer
		move.l	d0,SMPS_Track.DataPointer(a5)		; store track pointer
		move.w	(a1)+,SMPS_Track.Transpose(a5)		; load FM/PSG channel modifier
		move.b	#1,SMPS_Track.DurationTimeout(a5)	; set duration of first "note"
		move.b	d6,SMPS_Track.StackPointer(a5)		; set "gosub" (coord flag $F8) stack init value
		tst.b	d4					; is this a PSG channel?
		bmi.s	.sfxpsginitdone				; branch if yes
		move.b	#$C0,SMPS_Track.AMSFMSPan(a5)		; AMS/FMS/Panning
; loc_72396:
.sfxpsginitdone:
		dbf	d7,.sfxloadloop

		tst.b	SMPS_RAM.v_sfx_fm4_track.PlaybackControl(a6) ; is track playing?
		bpl.s	.doneoverride				; branch if not
		bset	#2,SMPS_RAM.v_spcsfx_fm4_track.PlaybackControl(a6) ; set 'SFX is overriding' bit
; loc_723A6:
.doneoverride:
		tst.b	SMPS_RAM.v_sfx_psg3_track.PlaybackControl(a6) ; is track playing?
		bpl.s	.locret					; branch if not
		bset	#2,SMPS_RAM.v_spcsfx_psg3_track.PlaybackControl(a6) ; set 'SFX is overriding' bit
		ori.b	#$1F,d4					; command to silence channel
		move.b	d4,(psg_input).l
		bchg	#5,d4					; command to silence noise channel
		move.b	d4,(psg_input).l
; locret_723C6:
.locret:
		rts
; End of function PlaySoundID

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused RAM addresses for FM and PSG channel variables used by the Special SFX
; ---------------------------------------------------------------------------
; The first block would have been used for overriding the music tracks
; as they have a lower priority, just as they are in Sound_PlaySFX
; The third block would be used to set up the Special SFX
; The second block, however, is for the SFX tracks, which have a higher priority
; and would be checked for if they're currently playing
; If they are, then the third block would be used again, this time to mark
; the new tracks as 'currently playing'

; These were actually used in Moonwalker's driver (and other SMPS 68k Type 1a drivers)

; BGMFM4PSG3RAM:
;SpecSFX_BGMChannelRAM:
		dc.l (v_snddriver_ram.v_music_fm4_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_music_psg3_track)&$FFFFFF
; SFXFM4PSG3RAM:
;SpecSFX_SFXChannelRAM:
		dc.l (v_snddriver_ram.v_sfx_fm4_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_sfx_psg3_track)&$FFFFFF
; SpecialSFXFM4PSG3RAM:
;SpecSFX_SpecSFXChannelRAM:
		dc.l (v_snddriver_ram.v_spcsfx_fm4_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_spcsfx_psg3_track)&$FFFFFF
; ===========================================================================

; Snd_FadeOut1: Snd_FadeOutSFX: FadeOutSFX:
StopSFX:
		_clr.b	SMPS_RAM.v_sndprio(a6)			; clear priority
		lea	SMPS_RAM.v_sfx_track_ram(a6),a5
		moveq	#SMPS_SFX_TRACK_COUNT-1,d7		; 3 FM + 3 PSG tracks (SFX)
; loc_723EA:
.trackloop:
		tst.b	SMPS_Track.PlaybackControl(a5)		; is track playing?
		bpl.w	.nexttrack				; branch if not
		bclr	#7,SMPS_Track.PlaybackControl(a5)	; stop track
		moveq	#0,d3
		move.b	SMPS_Track.VoiceControl(a5),d3		; get voice control bits
		bmi.s	.trackpsg				; branch if PSG
		jsr	FMNoteOff(pc)
		cmpi.b	#4,d3					; is this FM4?
		bne.s	.getfmpointer				; branch if not
		tst.b	SMPS_RAM.v_spcsfx_fm4_track.PlaybackControl(a6) ; is special SFX playing?
		bpl.s	.getfmpointer				; branch if not
	if FixBugs
		; DANGER! there is a missing 'movea.l	a5,a3' here, without which the
		; code is broken. It is dangerous to do a fade out when a GHZ waterfall
		; is playing its sound!
		movea.l	a5,a3
	endif
		lea	SMPS_RAM.v_spcsfx_fm4_track(a6),a5
		movea.l	SMPS_RAM.v_special_voice_ptr(a6),a1	; get special voice pointer
		bra.s	.gotfmpointer
; ===========================================================================
; loc_72416:
.getfmpointer:
		subq.b	#2,d3	; SFX only has FM3 and up
		lsl.b	#2,d3
		lea	SFX_BGMChannelRAM(pc),a0
		movea.l	a5,a3
		movea.l	(a0,d3.w),a5
		movea.l	SMPS_RAM.v_voice_ptr(a6),a1		; get music voice pointer
; loc_72428:
.gotfmpointer:
		bclr	#2,SMPS_Track.PlaybackControl(a5)	; clear 'SFX is overriding' bit
		bset	#1,SMPS_Track.PlaybackControl(a5)	; set 'track at rest' bit
	if FixBugs
		; DANGER! `SetVoice` expects d0 to be a word, but it's only passed
		; as a byte below. This may result in restoring invalid/broken FM
		; voices during fade out sequence if upper byte of d0 was trashed.
		moveq	#0,d0
	endif
		move.b	SMPS_Track.VoiceIndex(a5),d0		; current voice
		jsr	SetVoice(pc)
		movea.l	a3,a5
		bra.s	.nexttrack
; ===========================================================================
; loc_7243C:
.trackpsg:
		jsr	PSGNoteOff(pc)
		lea	SMPS_RAM.v_spcsfx_psg3_track(a6),a0
	if FixBugs
		; cfStopTrack does this check but this function oddly lacks it.
		tst.b	SMPS_Track.PlaybackControl(a0)		; is track playing?
		bpl.s	.getchannelptr				; branch if not
	endif
		cmpi.b	#$E0,d3					; is this a noise channel?
		beq.s	.gotpsgpointer				; branch if yes
		cmpi.b	#$C0,d3					; is this PSG 3?
		beq.s	.gotpsgpointer				; branch if yes

.getchannelptr:
		lsr.b	#3,d3
		lea	SFX_BGMChannelRAM(pc),a0
		movea.l	(a0,d3.w),a0
; loc_7245A:
.gotpsgpointer:
		bclr	#2,SMPS_Track.PlaybackControl(a0)	; clear 'SFX is overriding' bit
		bset	#1,SMPS_Track.PlaybackControl(a0)	; set 'track at rest' bit
		cmpi.b	#$E0,SMPS_Track.VoiceControl(a0)	; is this a noise channel?
		bne.s	.nexttrack				; branch if not
		move.b	SMPS_Track.PSGNoise(a0),(psg_input).l	; set noise type
; loc_72472:
.nexttrack:
		adda.w	#SMPS_Track.len,a5
		dbf	d7,.trackloop

		rts
; End of function StopSFX
; ===========================================================================

; Snd_FadeOut2: FadeOutSFX2: FadeOutSpecialSFX:
StopSpecialSFX:
		lea	SMPS_RAM.v_spcsfx_fm4_track(a6),a5
		tst.b	SMPS_Track.PlaybackControl(a5)		; is track playing?
		bpl.s	.fadedfm				; branch if not
		bclr	#7,SMPS_Track.PlaybackControl(a5)	; stop track
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is SFX overriding?
		bne.s	.fadedfm				; branch if not
		jsr	SendFMNoteOff(pc)
		lea	SMPS_RAM.v_music_fm4_track(a6),a5
		bclr	#2,SMPS_Track.PlaybackControl(a5)	; clear 'SFX is overriding' bit
		bset	#1,SMPS_Track.PlaybackControl(a5)	; set 'track at rest' bit
		tst.b	SMPS_Track.PlaybackControl(a5)		; is track playing?
		bpl.s	.fadedfm				; branch if not
		movea.l	SMPS_RAM.v_voice_ptr(a6),a1		; voice pointer
	if FixBugs
		; DANGER! `SetVoice` expects d0 to be a word, but it's only passed
		; as a byte below. This may result in restoring invalid/broken FM
		; voices during fade out sequence if upper byte of d0 was trashed.
		moveq	#0,d0
	endif
		move.b	SMPS_Track.VoiceIndex(a5),d0		; current voice
		jsr	SetVoice(pc)
; loc_724AE:
.fadedfm:
		lea	SMPS_RAM.v_spcsfx_psg3_track(a6),a5
		tst.b	SMPS_Track.PlaybackControl(a5)		; is track playing?
		bpl.s	.fadedpsg				; branch if not
		bclr	#7,SMPS_Track.PlaybackControl(a5)	; stop track
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is SFX overriding?
		bne.s	.fadedpsg				; return if not
		jsr	SendPSGNoteOff(pc)
		lea	SMPS_RAM.v_music_psg3_track(a6),a5
		bclr	#2,SMPS_Track.PlaybackControl(a5)	; clear 'SFX is overriding' bit
		bset	#1,SMPS_Track.PlaybackControl(a5)	; set 'track at rest' bit
		tst.b	SMPS_Track.PlaybackControl(a5)		; is track playing?
		bpl.s	.fadedpsg				; return if not
		cmpi.b	#$E0,SMPS_Track.VoiceControl(a5)	; is this a noise channel?
		bne.s	.fadedpsg				; return if not
		move.b	SMPS_Track.PSGNoise(a5),(psg_input).l	; set noise type
; locret_724E4:
.fadedpsg:
		rts
; End of function StopSpecialSFX

; ===========================================================================
; ---------------------------------------------------------------------------
; Fade out music
; ---------------------------------------------------------------------------
; Sound_E0:
FadeOutMusic:
		jsr	StopSFX(pc)
		jsr	StopSpecialSFX(pc)
		move.b	#3,SMPS_RAM.v_fadeout_delay(a6)		; set fadeout delay to 3
		move.b	#$28,SMPS_RAM.v_fadeout_counter(a6)	; set fadeout counter
		clr.b	SMPS_RAM.v_music_dac_track.PlaybackControl(a6) ; stop DAC track
		clr.b	SMPS_RAM.f_speedup(a6)			; disable speed shoes tempo
		rts
; ===========================================================================

; sub_72504:
DoFadeOut:
		move.b	SMPS_RAM.v_fadeout_delay(a6),d0		; has fadeout delay expired?
		beq.s	.continuefade				; branch if yes
		subq.b	#1,SMPS_RAM.v_fadeout_delay(a6)
		rts
; ===========================================================================
; loc_72510:
.continuefade:
		subq.b	#1,SMPS_RAM.v_fadeout_counter(a6)	; update fade counter
		beq.w	StopAllSound				; branch if fade is done
		move.b	#3,SMPS_RAM.v_fadeout_delay(a6)		; reset fade delay
		lea	SMPS_RAM.v_music_fm_tracks(a6),a5
		moveq	#SMPS_MUSIC_FM_TRACK_COUNT-1,d7		; 6 FM tracks
; loc_72524:
.fmloop:
		tst.b	SMPS_Track.PlaybackControl(a5)		; is track playing?
		bpl.s	.nextfm					; branch if not
		addq.b	#1,SMPS_Track.Volume(a5)		; increase volume attenuation
		bpl.s	.sendfmtl				; branch if still positive
		bclr	#7,SMPS_Track.PlaybackControl(a5)	; stop track
		bra.s	.nextfm
; ===========================================================================
; loc_72534:
.sendfmtl:
		jsr	SendVoiceTL(pc)
; loc_72538:
.nextfm:
		adda.w	#SMPS_Track.len,a5
		dbf	d7,.fmloop

		moveq	#SMPS_MUSIC_PSG_TRACK_COUNT-1,d7	; 3 PSG tracks
; loc_72542:
.psgloop:
		tst.b	SMPS_Track.PlaybackControl(a5)		; is track playing?
		bpl.s	.nextpsg				; branch if not
		addq.b	#1,SMPS_Track.Volume(a5)		; increase volume attenuation
		cmpi.b	#$10,SMPS_Track.Volume(a5)		; is it greater than $F?
		blo.s	.sendpsgvol				; branch if not
		bclr	#7,SMPS_Track.PlaybackControl(a5)	; stop track
		bra.s	.nextpsg
; ===========================================================================
; loc_72558:
.sendpsgvol:
		move.b	SMPS_Track.Volume(a5),d6		; store new volume attenuation
		jsr	SetPSGVolume(pc)
; loc_72560:
.nextpsg:
		adda.w	#SMPS_Track.len,a5
		dbf	d7,.psgloop

		rts
; End of function DoFadeOut
; ===========================================================================

; sub_7256A:
FMSilenceAll:
		moveq	#2,d3					; 3 FM channels for each YM2612 parts
		moveq	#$28,d0					; FM key on/off register
; loc_7256E:
.noteoffloop:
		move.b	d3,d1
		jsr	WriteFMI(pc)
		addq.b	#4,d1					; move to YM2612 part 1
		jsr	WriteFMI(pc)
		dbf	d3,.noteoffloop

		moveq	#$40,d0					; set TL on FM channels...
		moveq	#$7F,d1					; ... to total attenuation...
		moveq	#2,d4					; ... for all 3 channels...
; loc_72584:
.channelloop:
		moveq	#3,d3					; ... for all operators on each channel...
; loc_72586:
.channeltlloop:
		jsr	WriteFMI(pc)				; ... for part 0...
		jsr	WriteFMII(pc)				; ... and part 1.
		addq.w	#4,d0					; next TL operator
		dbf	d3,.channeltlloop

		subi.b	#$F,d0					; move to TL operator 1 of next channel
		dbf	d4,.channelloop

		rts
; End of function FMSilenceAll

; ===========================================================================
; ---------------------------------------------------------------------------
; Stop music
; ---------------------------------------------------------------------------
; Sound_E4: StopSoundAndMusic:
StopAllSound:
		moveq	#$2B,d0					; enable/disable DAC
		move.b	#$80,d1					; enable DAC
		jsr	WriteFMI(pc)
		moveq	#$27,d0					; timers, FM3/FM6 mode
		moveq	#0,d1					; FM3/FM6 normal mode, disable timers
		jsr	WriteFMI(pc)
		movea.l	a6,a0
	if FixBugs
		move.w	#(SMPS_RAM.v_1up_ram_copy/4)-1,d0	; clear $400 bytes: all variables and track data
	else
		; DANGER! This should be clearing all variables and track data, but misses the last $10 bytes of v_spcsfx_psg3_Track.
		move.w	#((SMPS_RAM.v_1up_ram_copy-$10)/4)-1,d0	; clear $390 bytes: all variables and most track data
	endif
; loc_725B6:
.clearramloop:
		clr.l	(a0)+
		dbf	d0,.clearramloop

		move.b	#$80,SMPS_RAM.v_sound_id(a6)		; set music to $80 (silence)
		jsr	FMSilenceAll(pc)
		bra.w	PSGSilenceAll
; ===========================================================================

; sub_725CA:
InitMusicPlayback:
		movea.l	a6,a0
		; save several values
		_move.b	SMPS_RAM.v_sndprio(a6),d1
		move.b	SMPS_RAM.f_1up_playing(a6),d2
		move.b	SMPS_RAM.f_speedup(a6),d3
		move.b	SMPS_RAM.v_fadein_counter(a6),d4
		move.w	SMPS_RAM.v_soundqueue0(a6),d5
	if FixBugs
		; DANGER! Only v_soundqueue0 and v_soundqueue1 are backed up, once again breaking v_soundqueue2
		move.b	SMPS_RAM.v_soundqueue2(a6),d6
	endif
		move.w	#((SMPS_RAM.v_1up_ram_end-SMPS_RAM.v_1up_ram)/4)-1,d0 ; clear $220 bytes: all variables and music track data
; loc_725E4:
.clearramloop:
		clr.l	(a0)+
		dbf	d0,.clearramloop

		; restore the values saved above
		_move.b	d1,SMPS_RAM.v_sndprio(a6)
		move.b	d2,SMPS_RAM.f_1up_playing(a6)
		move.b	d3,SMPS_RAM.f_speedup(a6)
		move.b	d4,SMPS_RAM.v_fadein_counter(a6)
		move.w	d5,SMPS_RAM.v_soundqueue0(a6)
	if FixBugs
		; DANGER! Only v_soundqueue0 and v_soundqueue1 are restored, once again breaking v_soundqueue2
		move.b	d6,SMPS_RAM.v_soundqueue2(a6)
	endif
		move.b	#$80,SMPS_RAM.v_sound_id(a6)		; set music to $80 (silence)

	if FixBugs
		lea	SMPS_RAM.v_music_dac_track.VoiceControl(a6),a1
		lea	FMDACInitBytes(pc),a2
		moveq	#SMPS_MUSIC_FM_DAC_TRACK_COUNT-1,d1	; 7 DAC/FM tracks
		bsr.s	.writeloop
		lea	PSGInitBytes(pc),a2
		moveq	#SMPS_MUSIC_PSG_TRACK_COUNT-1,d1	; 3 PSG tracks

.writeloop:
		move.b	(a2)+,(a1)				; write track's channel byte
		lea	SMPS_Track.len(a1),a1			; next track
		dbf	d1,.writeloop				; loop for all DAC/FM/PSG tracks

		rts
	else
		; DANGER! This silences ALL channels, even the ones being used
		; by SFX, and not music! .sendfmnoteoff does this already, and
		; doesn't affect SFX channels, either.
		; DANGER! InitMusicPlayback, and Sound_PlayBGM for that matter,
		; don't do a very good job of setting up the music tracks.
		; Tracks that aren't defined in a music file's header don't have
		; their channels defined, meaning .sendfmnoteoff won't silence
		; hardware properly. In combination with removing the above
		; calls to FMSilenceAll/PSGSilenceAll, this will cause hanging
		; notes.
		jsr	FMSilenceAll(pc)
		bra.w	PSGSilenceAll
	endif

; End of function InitMusicPlayback
; ===========================================================================

; sub_7260C:
TempoWait:
		move.b	SMPS_RAM.v_main_tempo(a6),SMPS_RAM.v_main_tempo_timeout(a6) ; reset main tempo timeout
		lea	SMPS_RAM.v_music_track_ram+SMPS_Track.DurationTimeout(a6),a0 ; note timeout
		moveq	#SMPS_Track.len,d0
		moveq	#SMPS_MUSIC_TRACK_COUNT-1,d1		; 1 DAC + 6 FM + 3 PSG tracks
; loc_7261A:
.tempoloop:
		addq.b	#1,(a0)					; delay note by 1 frame
		adda.w	d0,a0					; advance to next track
		dbf	d1,.tempoloop

		rts
; End of function TempoWait

; ===========================================================================
; ---------------------------------------------------------------------------
; Speed up music
; ---------------------------------------------------------------------------
; Sound_E2:
SpeedUpMusic:
		tst.b	SMPS_RAM.f_1up_playing(a6)
		bne.s	.speedup_1up
		move.b	SMPS_RAM.v_speeduptempo(a6),SMPS_RAM.v_main_tempo(a6)
		move.b	SMPS_RAM.v_speeduptempo(a6),SMPS_RAM.v_main_tempo_timeout(a6)
		move.b	#$80,SMPS_RAM.f_speedup(a6)
		rts
; ===========================================================================
; loc_7263E:
.speedup_1up:
		move.b	SMPS_RAM.v_1up_ram_copy+SMPS_RAM.v_speeduptempo(a6),SMPS_RAM.v_1up_ram_copy+SMPS_RAM.v_main_tempo(a6)
		move.b	SMPS_RAM.v_1up_ram_copy+SMPS_RAM.v_speeduptempo(a6),SMPS_RAM.v_1up_ram_copy+SMPS_RAM.v_main_tempo_timeout(a6)
		move.b	#$80,SMPS_RAM.v_1up_ram_copy+SMPS_RAM.f_speedup(a6)
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Change music back to normal speed
; ---------------------------------------------------------------------------
; Sound_E3:
SlowDownMusic:
		tst.b	SMPS_RAM.f_1up_playing(a6)
		bne.s	.slowdown_1up
		move.b	SMPS_RAM.v_tempo_mod(a6),SMPS_RAM.v_main_tempo(a6)
		move.b	SMPS_RAM.v_tempo_mod(a6),SMPS_RAM.v_main_tempo_timeout(a6)
		clr.b	SMPS_RAM.f_speedup(a6)
		rts
; ===========================================================================
; loc_7266A:
.slowdown_1up:
		move.b	SMPS_RAM.v_1up_ram_copy+SMPS_RAM.v_tempo_mod(a6),SMPS_RAM.v_1up_ram_copy+SMPS_RAM.v_main_tempo(a6)
		move.b	SMPS_RAM.v_1up_ram_copy+SMPS_RAM.v_tempo_mod(a6),SMPS_RAM.v_1up_ram_copy+SMPS_RAM.v_main_tempo_timeout(a6)
		clr.b	SMPS_RAM.v_1up_ram_copy+SMPS_RAM.f_speedup(a6)
		rts
; ===========================================================================

; sub_7267C:
DoFadeIn:
		tst.b	SMPS_RAM.v_fadein_delay(a6)		; has fadein delay expired?
		beq.s	.continuefade				; branch if yes
		subq.b	#1,SMPS_RAM.v_fadein_delay(a6)
		rts
; ===========================================================================
; loc_72688:
.continuefade:
		tst.b	SMPS_RAM.v_fadein_counter(a6)		; is fade done?
		beq.s	.fadedone				; branch if yes
		subq.b	#1,SMPS_RAM.v_fadein_counter(a6)	; update fade counter
		move.b	#2,SMPS_RAM.v_fadein_delay(a6)		; reset fade delay
		lea	SMPS_RAM.v_music_fm_tracks(a6),a5
		moveq	#SMPS_MUSIC_FM_TRACK_COUNT-1,d7		; 6 FM tracks
; loc_7269E:
.fmloop:
		tst.b	SMPS_Track.PlaybackControl(a5)		; is track playing?
		bpl.s	.nextfm					; branch if not
		subq.b	#1,SMPS_Track.Volume(a5)		; reduce volume attenuation
		jsr	SendVoiceTL(pc)
; loc_726AA:
.nextfm:
		adda.w	#SMPS_Track.len,a5
		dbf	d7,.fmloop
		moveq	#SMPS_MUSIC_PSG_TRACK_COUNT-1,d7	; 3 PSG tracks
; loc_726B4:
.psgloop:
		tst.b	SMPS_Track.PlaybackControl(a5)		; is track playing?
		bpl.s	.nextpsg				; branch if not
		subq.b	#1,SMPS_Track.Volume(a5)		; reduce volume attenuation
		move.b	SMPS_Track.Volume(a5),d6		; get value
		cmpi.b	#$10,d6					; is it is < $10?
		blo.s	.sendpsgvol				; branch if yes
		moveq	#$F,d6					; limit to $F (maximum attenuation)
; loc_726C8:
.sendpsgvol:
		jsr	SetPSGVolume(pc)
; loc_726CC:
.nextpsg:
		adda.w	#SMPS_Track.len,a5
		dbf	d7,.psgloop
		rts
; ===========================================================================
; loc_726D6:
.fadedone:
		bclr	#2,SMPS_RAM.v_music_dac_track.PlaybackControl(a6) ; clear 'SFX overriding' bit
		clr.b	SMPS_RAM.f_fadein_flag(a6)		; stop fadein

	if FixBugs
		; Fix the DAC fade-in bug
		; https://info.sonicretro.org/SCHG_How-to:Fix_Song_Restoration_Bugs_in_Sonic_1%27s_Sound_Driver
		tst.b	SMPS_RAM.v_music_dac_track.PlaybackControl(a6) ; is the DAC channel running?
		bpl.s	.Resume_NoDAC				; if not, branch

		moveq	#$FFFFFFB6,d0				; prepare FM channel 3/6 L/R/AMS/FMS address
		move.b	SMPS_RAM.v_music_dac_track.AMSFMSPan(a6),d1 ; load DAC channel's L/R/AMS/FMS value
		jmp	WriteFMII(pc)				; write to FM 6
.Resume_NoDAC:
	endif
		rts
; End of function DoFadeIn

; ===========================================================================
; loc_726E2:
FMNoteOn:
		btst	#1,SMPS_Track.PlaybackControl(a5)	; is track resting?
		bne.s	.locret					; return if so
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is track being overridden?
		bne.s	.locret					; return if so
		moveq	#$28,d0					; note on/off register
		move.b	SMPS_Track.VoiceControl(a5),d1		; get channel bits
		ori.b	#$F0,d1					; note on on all operators
		bra.w	WriteFMI
; ===========================================================================
; locret_726FC:
.locret:
		rts
; ===========================================================================

; sub_726FE:
FMNoteOff:
		btst	#4,SMPS_Track.PlaybackControl(a5)	; is 'do not attack next note' set?
		bne.s	locret_72714				; return if yes
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is SFX overriding?
		bne.s	locret_72714				; return if yes
; loc_7270A:
SendFMNoteOff:
		moveq	#$28,d0					; note on/off register
		move.b	SMPS_Track.VoiceControl(a5),d1		; note off to this channel
		bra.w	WriteFMI
; ===========================================================================

locret_72714:
		rts
; End of function FMNoteOff

; ===========================================================================
; loc_72716:
WriteFMIorIIMain:
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is track being overridden by sfx?
		bne.s	.locret					; return if yes
		bra.w	WriteFMIorII
; ===========================================================================
; locret_72720:
.locret:
		rts
; ===========================================================================

; sub_72722:
WriteFMIorII:
		btst	#2,SMPS_Track.VoiceControl(a5)		; is this bound for part I or II?
		bne.s	WriteFMIIPart				; branch if for part II
		add.b	SMPS_Track.VoiceControl(a5),d0		; add in voice control bits
; End of function WriteFMIorII
; ===========================================================================

; Strangely, despite this driver being SMPS 68k Type 1b,
; WriteFMI and WriteFMII are the Type 1a versions.
; In Sonic 1's prototype, they were the Type 1b versions.
; I wonder why they were changed?

; sub_7272E:
WriteFMI:
		move.b	(ym2612_a0).l,d2
		btst	#7,d2					; is FM busy?
		bne.s	WriteFMI				; loop if so
		move.b	d0,(ym2612_a0).l
		nop
		nop
		nop
; loc_72746:
.waitloop:
		move.b	(ym2612_a0).l,d2
		btst	#7,d2					; is FM busy?
		bne.s	.waitloop				; loop if so

		move.b	d1,(ym2612_d0).l
		rts
; End of function WriteFMI

; ===========================================================================
; loc_7275A:
WriteFMIIPart:
		move.b	SMPS_Track.VoiceControl(a5),d2		; get voice control bits
		bclr	#2,d2					; clear chip toggle
		add.b	d2,d0					; add in to destination register
; ===========================================================================

; sub_72764:
WriteFMII:
		move.b	(ym2612_a0).l,d2
		btst	#7,d2					; is FM busy?
		bne.s	WriteFMII				; loop if so
		move.b	d0,(ym2612_a1).l
		nop
		nop
		nop
; loc_7277C:
.waitloop:
		move.b	(ym2612_a0).l,d2
		btst	#7,d2					; is FM busy?
		bne.s	.waitloop				; loop if so

		move.b	d1,(ym2612_d1).l
		rts
; End of function WriteFMII

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Note Values: b-0 to a#8
;
; Each row is an octave, starting with B and ending with A-sharp/B-flat.
; Notably, this differs from the PSG frequency table, which starts with C and
; ends with B. This is caused by 'FMSetFreq' subtracting $80 from the note
; instead of $81, meaning that the first frequency in the table ironically
; corresponds to the 'rest' note. The only way to use this frequency in a
; real note is to transpose the channel to a lower semitone.
;
; Rather than use a complete lookup table, other SMPS drivers such as
; Sonic 3's compute the octave, and only store a single octave's worth of
; notes in the table.
;
; Invalid transposition values will cause this table to be overflowed,
; resulting in garbage data being used as frequency values. In drivers that
; compute the octave instead, invalid transposition values merely cause the
; notes to wrap-around (the note below the lowest note will be the highest
; note). It's important to keep this in mind when porting buggy songs.
; ---------------------------------------------------------------------------
MakeFMFrequency function frequency,roundFloatToInteger(frequency*1024*1024*2/FM_Sample_Rate)
MakeFMFrequenciesOctave macro octave
		; Frequencies for the base octave. The first frequency is B, the last frequency is B-flat.
		irp op, 15.39, 16.35, 17.34, 18.36, 19.45, 20.64, 21.84, 23.13, 24.51, 25.98, 27.53, 29.15
			dc.w MakeFMFrequency(op)+octave*$800
		endm
	endm

; word_72790: FM_Notes:
FMFrequencies:
		MakeFMFrequenciesOctave 0
		MakeFMFrequenciesOctave 1
		MakeFMFrequenciesOctave 2
		MakeFMFrequenciesOctave 3
		MakeFMFrequenciesOctave 4
		MakeFMFrequenciesOctave 5
		MakeFMFrequenciesOctave 6
		MakeFMFrequenciesOctave 7
; ===========================================================================

; sub_72850:
PSGUpdateTrack:
		subq.b	#1,SMPS_Track.DurationTimeout(a5)	; update note timeout
		bne.s	.notegoing
		bclr	#4,SMPS_Track.PlaybackControl(a5)	; clear 'do not attack note' bit
		jsr	PSGDoNext(pc)
		jsr	PSGDoNoteOn(pc)
		bra.w	PSGDoVolFX
; ===========================================================================
; loc_72866:
.notegoing:
		jsr	NoteTimeoutUpdate(pc)
		jsr	PSGUpdateVolFX(pc)
		jsr	DoModulation(pc)
		jsr	PSGUpdateFreq(pc)			; it would be better if this were a jmp and the rts was removed
		rts
; End of function PSGUpdateTrack
; ===========================================================================

; sub_72878:
PSGDoNext:
		bclr	#1,SMPS_Track.PlaybackControl(a5)	; clear 'track at rest' bit
		movea.l	SMPS_Track.DataPointer(a5),a4		; get track data pointer
; loc_72880:
.noteloop:
		moveq	#0,d5
		move.b	(a4)+,d5				; get byte from track
		cmpi.b	#$E0,d5					; is it a coord. flag?
		blo.s	.gotnote				; branch if not
		jsr	CoordFlag(pc)
		bra.s	.noteloop
; ===========================================================================
; loc_72890:
.gotnote:
		tst.b	d5					; is it a note?
		bpl.s	.gotduration				; branch if not
		jsr	PSGSetFreq(pc)
		move.b	(a4)+,d5				; get another byte
		tst.b	d5					; is it a duration?
		bpl.s	.gotduration				; branch if yes
		subq.w	#1,a4					; put byte back
		bra.w	FinishTrackUpdate
; ===========================================================================
; loc_728A4:
.gotduration:
		jsr	SetDuration(pc)
		bra.w	FinishTrackUpdate
; End of function PSGDoNext
; ===========================================================================

; sub_728AC:
PSGSetFreq:
		subi.b	#$81,d5					; convert to 0-based index
		bcs.s	.restpsg				; if $80, put track at rest
		add.b	SMPS_Track.Transpose(a5),d5		; add in channel transposition
		andi.w	#$7F,d5					; clear high byte and sign bit
		lsl.w	#1,d5
		lea	PSGFrequencies(pc),a0
		move.w	(a0,d5.w),SMPS_Track.Freq(a5)		; set new frequency
		bra.w	FinishTrackUpdate
; ===========================================================================
; loc_728CA:
.restpsg:
		bset	#1,SMPS_Track.PlaybackControl(a5)	; set 'track at rest' bit
		move.w	#-1,SMPS_Track.Freq(a5)			; invalidate note frequency
		jsr	FinishTrackUpdate(pc)
		bra.w	PSGNoteOff
; End of function PSGSetFreq
; ===========================================================================

; sub_728DC:
PSGDoNoteOn:
		move.w	SMPS_Track.Freq(a5),d6			; get note frequency
		bmi.s	PSGSetRest				; if invalid, branch
; End of function PSGDoNoteOn
; ===========================================================================

; sub_728E2:
PSGUpdateFreq:
		move.b	SMPS_Track.Detune(a5),d0		; get detune value
		ext.w	d0
		add.w	d0,d6					; add to frequency
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is track being overridden?
		bne.s	.locret					; return if yes
		btst	#1,SMPS_Track.PlaybackControl(a5)	; is track at rest?
		bne.s	.locret					; return if yes
		move.b	SMPS_Track.VoiceControl(a5),d0		; get channel bits
		cmpi.b	#$E0,d0					; is it a noise channel?
		bne.s	.notnoise				; branch if not
		move.b	#$C0,d0					; use PSG 3 channel bits
; loc_72904:
.notnoise:
		move.w	d6,d1
		andi.b	#$F,d1					; low nibble of frequency
		or.b	d1,d0					; latch tone data to channel
		lsr.w	#4,d6					; get upper 6 bits of frequency
		andi.b	#$3F,d6					; send to latched channel
		move.b	d0,(psg_input).l
		move.b	d6,(psg_input).l
; locret_7291E:
.locret:
		rts
; End of function PSGUpdateFreq

; ===========================================================================
; loc_72920:
PSGSetRest:
		bset	#1,SMPS_Track.PlaybackControl(a5)	; set 'track at rest' bit
		rts
; ===========================================================================

; sub_72926:
PSGUpdateVolFX:
		tst.b	SMPS_Track.VoiceIndex(a5)		; test PSG tone
		beq.w	locret_7298A				; return if it is zero
; loc_7292E:
PSGDoVolFX:
		move.b	SMPS_Track.Volume(a5),d6		; get volume
		moveq	#0,d0
		move.b	SMPS_Track.VoiceIndex(a5),d0		; get PSG tone
		beq.s	SetPSGVolume
		movea.l	(Go_PSGIndex).l,a0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	(a0,d0.w),a0
	
	if FixBugs
		; Make the below code more efficient
		move.b	SMPS_Track.VolEnvIndex(a5),d0		; get volume envelope index
		addq.b	#1,SMPS_Track.VolEnvIndex(a5)		; increment volume envelope index
		move.b	(a0,d0.w),d0				; volume envelope value
		bmi.w	VolEnvHold				; branch if not
	else
		move.b	SMPS_Track.VolEnvIndex(a5),d0		; get volume envelope index
		move.b	(a0,d0.w),d0				; volume envelope value
		addq.b	#1,SMPS_Track.VolEnvIndex(a5)		; increment volume envelope index
		btst	#7,d0					; is volume envelope value negative?
		beq.s	.gotflutter				; branch if not
		cmpi.b	#$80,d0					; is it the terminator?
		beq.s	VolEnvHold				; if so, branch
	endif

; loc_72960:
.gotflutter:
		add.w	d0,d6					; add volume envelope value to volume
		cmpi.b	#$10,d6					; is volume $10 or higher?
		blo.s	SetPSGVolume				; branch if not
		moveq	#$F,d6					; limit to silence and fall through
; End of function PSGUpdateVolFX
; ===========================================================================

; sub_7296A:
SetPSGVolume:
		btst	#1,SMPS_Track.PlaybackControl(a5)	; is track at rest?
		bne.s	locret_7298A				; return if so
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is SFX overriding?
		bne.s	locret_7298A				; return if so
		btst	#4,SMPS_Track.PlaybackControl(a5)	; is track set to not attack next note?
		bne.s	PSGCheckNoteTimeout 			; branch if yes
; loc_7297C:
PSGSendVolume:
		or.b	SMPS_Track.VoiceControl(a5),d6		; add in track selector bits
		addi.b	#$10,d6					; mark it as a volume command
		move.b	d6,(psg_input).l

locret_7298A:
		rts
; ===========================================================================
; loc_7298C: PSGCheckNoteFill:
PSGCheckNoteTimeout:
		tst.b	SMPS_Track.NoteTimeoutMaster(a5)	; is note timeout on?
		beq.s	PSGSendVolume				; branch if not
		tst.b	SMPS_Track.NoteTimeout(a5)		; has note timeout expired?
		bne.s	PSGSendVolume				; branch if not
		rts
; End of function SetPSGVolume

; ===========================================================================
; loc_7299A: FlutterDone:
VolEnvHold:
		subq.b	#1,SMPS_Track.VolEnvIndex(a5)		; decrement volume envelope index
		rts
; ===========================================================================

; sub_729A0:
PSGNoteOff:
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is SFX overriding?
		bne.s	locret_729B4				; return if so
; loc_729A6:
SendPSGNoteOff:
		move.b	SMPS_Track.VoiceControl(a5),d0		; PSG channel to change
		ori.b	#$1F,d0					; maximum volume attenuation
		move.b	d0,(psg_input).l
	if FixBugs
		; DANGER! If InitMusicPlayback doesn't silence all channels, there's the
		; risk of music accidentally playing noise because it can't detect if
		; the PSG4/noise channel needs muting on track initialisation.
		; This is the same fix that S&K's driver uses:
		cmpi.b	#$DF,d0					; are stopping PSG3?
		bne.s	locret_729B4
		move.b	#$FF,(psg_input).l			; if so, stop noise channel while we're at it
	endif

locret_729B4:
		rts
; End of function PSGNoteOff
; ===========================================================================

; sub_729B6:
PSGSilenceAll:
		lea	(psg_input).l,a0
		move.b	#$9F,(a0)				; silence PSG 1
		move.b	#$BF,(a0)				; silence PSG 2
		move.b	#$DF,(a0)				; silence PSG 3
		move.b	#$FF,(a0)				; silence noise channel
		rts
; End of function PSGSilenceAll

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG Note Values: c-1 to a-6
;
; Each row is an octave, starting with C and ending with B. Sonic 3's driver
; adds another octave at the start, as well as two more notes and the end to
; complete the last octave. Notably, a-6 is changed from 223721.56Hz to
; 6991.28Hz. These changes need to be applied here in order for ports of
; songs from Sonic 3 and later to sound correct.
;
; Here is what Sonic 3's version of this table looks like:
;		MakePSGFrequencies  109.34,    109.34,    109.34,    109.34,    109.34,    109.34,    109.34,    109.34,    109.34,    110.20,    116.76,    123.73
;		MakePSGFrequencies  130.98,    138.78,    146.99,    155.79,    165.22,    174.78,    185.19,    196.24,    207.91,    220.63,    233.52,    247.47
;		MakePSGFrequencies  261.96,    277.56,    293.59,    311.58,    329.97,    349.56,    370.39,    392.49,    415.83,    440.39,    468.03,    494.95
;		MakePSGFrequencies  522.71,    556.51,    588.73,    621.44,    661.89,    699.12,    740.79,    782.24,    828.59,    880.79,    932.17,    989.91
;		MakePSGFrequencies 1045.42,   1107.52,   1177.47,   1242.89,   1316.00,   1398.25,   1491.47,   1575.50,   1669.55,   1747.82,   1864.34,   1962.46
;		MakePSGFrequencies 2071.49,   2193.34,   2330.42,   2485.78,   2601.40,   2796.51,   2943.69,   3107.23,   3290.01,   3495.64,   3608.40,   3857.25
;		MakePSGFrequencies 4142.98,   4302.32,   4660.85,   4863.50,   5084.56,   5326.69,   5887.39,   6214.47,   6580.02,   6991.28, 223721.56, 223721.56
; ---------------------------------------------------------------------------
MakePSGFrequency function frequency,min($3FF,roundFloatToInteger(PSG_Sample_Rate/(frequency*2)))
MakePSGFrequencies macro
		irp op,ALLARGS
			dc.w MakePSGFrequency(op)
		endm
	endm

; word_729CE:
PSGFrequencies:
		MakePSGFrequencies  130.98,    138.78,    146.99,    155.79,    165.22,    174.78,    185.19,    196.24,    207.91,    220.63,    233.52,    247.47
		MakePSGFrequencies  261.96,    277.56,    293.59,    311.58,    329.97,    349.56,    370.39,    392.49,    415.83,    440.39,    468.03,    494.95
		MakePSGFrequencies  522.71,    556.51,    588.73,    621.44,    661.89,    699.12,    740.79,    782.24,    828.59,    880.79,    932.17,    989.91
		MakePSGFrequencies 1045.42,   1107.52,   1177.47,   1242.89,   1316.00,   1398.25,   1491.47,   1575.50,   1669.55,   1747.82,   1864.34,   1962.46
		MakePSGFrequencies 2071.49,   2193.34,   2330.42,   2485.78,   2601.40,   2796.51,   2943.69,   3107.23,   3290.01,   3495.64,   3608.40,   3857.25
		MakePSGFrequencies 4142.98,   4302.32,   4660.85,   4863.50,   5084.56,   5326.69,   5887.39,   6214.47,   6580.02, 223721.56
; ===========================================================================

; sub_72A5A:
CoordFlag:
		subi.w	#$E0,d5
		lsl.w	#2,d5
		jmp	coordflagLookup(pc,d5.w)
; End of function CoordFlag

; ===========================================================================
; loc_72A64:
coordflagLookup:
		bra.w	cfPanningAMSFMS		; $E0
; ===========================================================================
		bra.w	cfDetune		; $E1
; ===========================================================================
		bra.w	cfSetCommunication	; $E2
; ===========================================================================
		bra.w	cfJumpReturn		; $E3
; ===========================================================================
		bra.w	cfFadeInToPrevious	; $E4
; ===========================================================================
		bra.w	cfSetTempoDivider	; $E5
; ===========================================================================
		bra.w	cfChangeFMVolume	; $E6
; ===========================================================================
		bra.w	cfHoldNote		; $E7
; ===========================================================================
		bra.w	cfNoteTimeout		; $E8
; ===========================================================================
		bra.w	cfChangeTransposition	; $E9
; ===========================================================================
		bra.w	cfSetTempo		; $EA
; ===========================================================================
		bra.w	cfSetTempoDividerAll	; $EB
; ===========================================================================
		bra.w	cfChangePSGVolume	; $EC
; ===========================================================================
		bra.w	cfClearPush		; $ED
; ===========================================================================
		bra.w	cfStopSpecialFM4	; $EE
; ===========================================================================
		bra.w	cfSetVoice		; $EF
; ===========================================================================
		bra.w	cfModulation		; $F0
; ===========================================================================
		bra.w	cfEnableModulation	; $F1
; ===========================================================================
		bra.w	cfStopTrack		; $F2
; ===========================================================================
		bra.w	cfSetPSGNoise		; $F3
; ===========================================================================
		bra.w	cfDisableModulation	; $F4
; ===========================================================================
		bra.w	cfSetPSGTone		; $F5
; ===========================================================================
		bra.w	cfJumpTo		; $F6
; ===========================================================================
		bra.w	cfRepeatAtPos		; $F7
; ===========================================================================
		bra.w	cfJumpToGosub		; $F8
; ===========================================================================
		bra.w	cfOpF9			; $F9
; ===========================================================================
; loc_72ACC:
cfPanningAMSFMS:
		move.b	(a4)+,d1				; new AMS/FMS/panning value
		tst.b	SMPS_Track.VoiceControl(a5)		; is this a PSG track?
		bmi.s	locret_72AEA				; return if yes
		move.b	SMPS_Track.AMSFMSPan(a5),d0		; get current AMS/FMS/panning
		andi.b	#$37,d0					; retain bits 0-2, 3-4 if set
		or.b	d0,d1					; mask in new value
		move.b	d1,SMPS_Track.AMSFMSPan(a5)		; store value
		move.b	#$B4,d0					; command to set AMS/FMS/panning
		bra.w	WriteFMIorIIMain
; ===========================================================================

locret_72AEA:
		rts
; ===========================================================================
; loc_72AEC: cfAlterNotes:
cfDetune:
		move.b	(a4)+,SMPS_Track.Detune(a5)		; set detune value
		rts
; ===========================================================================
; loc_72AF2: cfUnknown1:
cfSetCommunication:
		move.b	(a4)+,SMPS_RAM.v_communication_byte(a6)	; set otherwise unused communication byte to parameter
		rts
; ===========================================================================
; loc_72AF8:
cfJumpReturn:
		moveq	#0,d0
		move.b	SMPS_Track.StackPointer(a5),d0		; track stack pointer
		movea.l	(a5,d0.w),a4				; set track return address
		move.l	#0,(a5,d0.w)				; set 'popped' value to zero
		addq.w	#2,a4					; skip jump target address from gosub flag
		addq.b	#4,d0					; actually 'pop' value
		move.b	d0,SMPS_Track.StackPointer(a5)		; set new stack pointer
		rts
; ===========================================================================
; loc_72B14:
cfFadeInToPrevious:
		movea.l	a6,a0
		lea	SMPS_RAM.v_1up_ram_copy(a6),a1
		move.w	#((SMPS_RAM.v_1up_ram_end-SMPS_RAM.v_1up_ram)/4)-1,d0 ; $220 bytes to restore: all variables and music track data
; loc_72B1E:
.restoreramloop:
		move.l	(a1)+,(a0)+
		dbf	d0,.restoreramloop

	if FixBugs
		; Fix the FM 6 restoration bug
		; https://info.sonicretro.org/SCHG_How-to:Fix_Song_Restoration_Bugs_in_Sonic_1%27s_Sound_Driver
		move.b	#$2B,d0					; register: DAC mode (bit 7 = enable)
		moveq	#0,d1					; value: DAC mode disable
		jsr	WriteFMI(pc)				; write to YM2612 Port 0 [sub_7272E]
	endif

		bset	#2,SMPS_RAM.v_music_dac_track.PlaybackControl(a6) ; set 'SFX overriding' bit
		movea.l	a5,a3
		move.b	#$28,d6
		sub.b	SMPS_RAM.v_fadein_counter(a6),d6	; if fade already in progress, this adjusts track volume accordingly
		moveq	#SMPS_MUSIC_FM_TRACK_COUNT-1,d7		; 6 FM tracks
		lea	SMPS_RAM.v_music_fm_tracks(a6),a5
; loc_72B3A:
.fmloop:
		btst	#7,SMPS_Track.PlaybackControl(a5)	; is track playing?
		beq.s	.nextfm					; branch if not
		bset	#1,SMPS_Track.PlaybackControl(a5)	; set 'track at rest' bit
		add.b	d6,SMPS_Track.Volume(a5)		; apply current volume fade-in
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is SFX overriding?
		bne.s	.nextfm					; branch if yes
		moveq	#0,d0
		move.b	SMPS_Track.VoiceIndex(a5),d0		; get voice
		movea.l	SMPS_RAM.v_voice_ptr(a6),a1		; voice pointer
		jsr	SetVoice(pc)
; loc_72B5C:
.nextfm:
		adda.w	#SMPS_Track.len,a5
		dbf	d7,.fmloop

		moveq	#SMPS_MUSIC_PSG_TRACK_COUNT-1,d7	; 3 PSG tracks
; loc_72B66:
.psgloop:
		btst	#7,SMPS_Track.PlaybackControl(a5)	; is track playing?
		beq.s	.nextpsg				; branch if not
		bset	#1,SMPS_Track.PlaybackControl(a5)	; set 'track at rest' bit
		jsr	PSGNoteOff(pc)
		add.b	d6,SMPS_Track.Volume(a5)		; apply current volume fade-in
; loc_72B78:
.nextpsg:
		adda.w	#SMPS_Track.len,a5
		dbf	d7,.psgloop

		movea.l	a3,a5
		move.b	#$80,SMPS_RAM.f_fadein_flag(a6)		; trigger fade-in
		move.b	#$28,SMPS_RAM.v_fadein_counter(a6)	; fade-in delay
		clr.b	SMPS_RAM.f_1up_playing(a6)
		startZ80
		addq.w	#8,sp					; tamper return value so we don't return to caller
		rts
; ===========================================================================
; loc_72B9E:
cfSetTempoDivider:
		move.b	(a4)+,SMPS_Track.TempoDivider(a5)	; set tempo divider on current track
		rts
; ===========================================================================
; loc_72BA4: cfSetVolume:
cfChangeFMVolume:
		move.b	(a4)+,d0				; get parameter
		add.b	d0,SMPS_Track.Volume(a5)		; add to current volume
		bra.w	SendVoiceTL
; ===========================================================================
; loc_72BAE: cfPreventAttack:
cfHoldNote:
		bset	#4,SMPS_Track.PlaybackControl(a5)	; set 'do not attack next note' bit
		rts
; ===========================================================================
; loc_72BB4: cfNoteFill
cfNoteTimeout:
		move.b	(a4),SMPS_Track.NoteTimeout(a5)		; note fill timeout
		move.b	(a4)+,SMPS_Track.NoteTimeoutMaster(a5)	; note fill master
		rts
; ===========================================================================
; loc_72BBE: cfAddKey:
cfChangeTransposition:
		move.b	(a4)+,d0				; get parameter
		add.b	d0,SMPS_Track.Transpose(a5)		; add to transpose value
		rts
; ===========================================================================
; loc_72BC6:
cfSetTempo:
		move.b	(a4),SMPS_RAM.v_main_tempo(a6)		; set main tempo
		move.b	(a4)+,SMPS_RAM.v_main_tempo_timeout(a6)	; and reset timeout (!)
		rts
; ===========================================================================
; loc_72BD0: cfSetTempoMod:
cfSetTempoDividerAll:
		lea	SMPS_RAM.v_music_track_ram(a6),a0
		move.b	(a4)+,d0				; get new tempo divider
		moveq	#SMPS_Track.len,d1
		moveq	#SMPS_MUSIC_TRACK_COUNT-1,d2		; 1 DAC + 6 FM + 3 PSG tracks
; loc_72BDA:
.trackloop:
		move.b	d0,SMPS_Track.TempoDivider(a0)		; set track's tempo divider
		adda.w	d1,a0
		dbf	d2,.trackloop

		rts
; ===========================================================================
; loc_72BE6: cfChangeVolume:
cfChangePSGVolume:
		move.b	(a4)+,d0				; get volume change
		add.b	d0,SMPS_Track.Volume(a5)		; apply it
		rts
; ===========================================================================
; loc_72BEE:
cfClearPush:
		clr.b	SMPS_RAM.f_push_playing(a6)		; allow push sound to be played once more
		rts
; ===========================================================================
; loc_72BF4:
cfStopSpecialFM4:
		bclr	#7,SMPS_Track.PlaybackControl(a5)	; stop track
		bclr	#4,SMPS_Track.PlaybackControl(a5)	; clear 'do not attack next note' bit
		jsr	FMNoteOff(pc)
		tst.b	SMPS_RAM.v_sfx_fm4_track.PlaybackControl(a6) ; is SFX using FM4?
		bmi.s	.locexit				; branch if yes
		movea.l	a5,a3
		lea	SMPS_RAM.v_music_fm4_track(a6),a5
		movea.l	SMPS_RAM.v_voice_ptr(a6),a1		; voice pointer
		bclr	#2,SMPS_Track.PlaybackControl(a5)	; clear 'SFX is overriding' bit
		bset	#1,SMPS_Track.PlaybackControl(a5)	; set 'track at rest' bit
	if FixBugs
		; DANGER! `SetVoice` expects d0 to be a word, but it's only passed
		; as a byte below. This may result in restoring invalid/broken FM
		; voices during fade out sequence if upper byte of d0 was trashed.
		moveq	#0,d0
	endif
		move.b	SMPS_Track.VoiceIndex(a5),d0		; current voice
		jsr	SetVoice(pc)
		movea.l	a3,a5
; loc_72C22:
.locexit:
		addq.w	#8,sp					; tamper with return value so we don't return to caller
		rts
; ===========================================================================
; loc_72C26:
cfSetVoice:
		moveq	#0,d0
		move.b	(a4)+,d0				; get new voice
		move.b	d0,SMPS_Track.VoiceIndex(a5)		; store it
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is SFX overriding this track?
		bne.w	locret_72CAA				; return if yes
		movea.l	SMPS_RAM.v_voice_ptr(a6),a1		; music voice pointer
		tst.b	SMPS_RAM.f_voice_selector(a6)		; are we updating a music track?
		beq.s	SetVoice				; if yes, branch
		movea.l	SMPS_Track.VoicePtr(a5),a1		; sFX track voice pointer
		tst.b	SMPS_RAM.f_voice_selector(a6)		; are we updating a SFX track?
		bmi.s	SetVoice				; if yes, branch
		movea.l	SMPS_RAM.v_special_voice_ptr(a6),a1	; special SFX voice pointer
; ===========================================================================

; sub_72C4E:
SetVoice:
		subq.w	#1,d0
		bmi.s	.havevoiceptr
		move.w	#25,d1
; loc_72C56:
.voicemultiply:
		adda.w	d1,a1
		dbf	d0,.voicemultiply
; loc_72C5C:
.havevoiceptr:
		move.b	(a1)+,d1				; feedback/algorithm
		move.b	d1,SMPS_Track.FeedbackAlgo(a5)		; save it to track RAM
		move.b	d1,d4
		move.b	#$B0,d0					; command to write feedback/algorithm
		jsr	WriteFMIorII(pc)
		lea	FMInstrumentOperatorTable(pc),a2
		moveq	#(FMInstrumentOperatorTable_End-FMInstrumentOperatorTable)-1,d3 ; don't want to send TL yet
; loc_72C72:
.sendvoiceloop:
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		jsr	WriteFMIorII(pc)
		dbf	d3,.sendvoiceloop

		moveq	#(FMInstrumentTLTable_End-FMInstrumentTLTable)-1,d5
		andi.w	#7,d4					; get algorithm
		move.b	FMSlotMask(pc,d4.w),d4			; get slot mask for algorithm
		move.b	SMPS_Track.Volume(a5),d3		; track volume attenuation
; loc_72C8C:
.sendtlloop:
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		lsr.b	#1,d4					; is bit set for this operator in the mask?
		bcc.s	.sendtl					; branch if not
		add.b	d3,d1					; include additional attenuation
; loc_72C96:
.sendtl:
		jsr	WriteFMIorII(pc)
		dbf	d5,.sendtlloop

		move.b	#$B4,d0					; register for AMS/FMS/Panning
		move.b	SMPS_Track.AMSFMSPan(a5),d1		; value to send
		jsr	WriteFMIorII(pc)			; (It would be better if this were a jmp)

locret_72CAA:
		rts
; End of function SetVoice

; ===========================================================================
; byte_72CAC:
FMSlotMask:	dc.b 8,	8, 8, 8, $A, $E, $E, $F
; ===========================================================================

; sub_72CB4:
SendVoiceTL:
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is SFX overriding?
		bne.s	.locret					; return if so
		moveq	#0,d0
		move.b	SMPS_Track.VoiceIndex(a5),d0		; current voice
		movea.l	SMPS_RAM.v_voice_ptr(a6),a1		; voice pointer
		tst.b	SMPS_RAM.f_voice_selector(a6)
		beq.s	.gotvoiceptr
	if FixBugs
		movea.l	SMPS_Track.VoicePtr(a5),a1
	else
		; DANGER! This uploads the wrong voice! It should have been a5 instead of a6!
		; In Sonic 1's prototype, TrackVoicePtr was a global variable instead of a
		; per-track variable, explaining why this uses a6 instead of a5.
		movea.l	SMPS_Track.VoicePtr(a6),a1
	endif
		tst.b	SMPS_RAM.f_voice_selector(a6)
		bmi.s	.gotvoiceptr
		movea.l	SMPS_RAM.v_special_voice_ptr(a6),a1
; loc_72CD8:
.gotvoiceptr:
		subq.w	#1,d0
		bmi.s	.gotvoice
		move.w	#25,d1
; loc_72CE0:
.voicemultiply:
		adda.w	d1,a1
		dbf	d0,.voicemultiply
; loc_72CE6:
.gotvoice:
		adda.w	#21,a1					; want TL
		lea	FMInstrumentTLTable(pc),a2
		move.b	SMPS_Track.FeedbackAlgo(a5),d0		; get feedback/algorithm
		andi.w	#7,d0					; want only algorithm
		move.b	FMSlotMask(pc,d0.w),d4			; get slot mask
		move.b	SMPS_Track.Volume(a5),d3		; get track volume attenuation
		bmi.s	.locret					; if negative, stop
		moveq	#(FMInstrumentTLTable_End-FMInstrumentTLTable)-1,d5
; loc_72D02:
.sendtlloop:
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		lsr.b	#1,d4					; is bit set for this operator in the mask?
		bcc.s	.senttl					; branch if not
		add.b	d3,d1					; include additional attenuation
		bcs.s	.senttl					; branch on overflow
		jsr	WriteFMIorII(pc)
; loc_72D12:
.senttl:
		dbf	d5,.sendtlloop
; locret_72D16:
.locret:
		rts
; End of function SendVoiceTL

; ===========================================================================
; byte_72D18:
FMInstrumentOperatorTable:
		dc.b  $30		; detune/multiple operator 1
		dc.b  $38		; detune/multiple operator 3
		dc.b  $34		; detune/multiple operator 2
		dc.b  $3C		; detune/multiple operator 4
		dc.b  $50		; rate scaling/attack rate operator 1
		dc.b  $58		; rate scaling/attack rate operator 3
		dc.b  $54		; rate scaling/attack rate operator 2
		dc.b  $5C		; rate scaling/attack rate operator 4
		dc.b  $60		; amplitude modulation/first decay rate operator 1
		dc.b  $68		; amplitude modulation/first decay rate operator 3
		dc.b  $64		; amplitude modulation/first decay rate operator 2
		dc.b  $6C		; amplitude modulation/first decay rate operator 4
		dc.b  $70		; secondary decay rate operator 1
		dc.b  $78		; secondary decay rate operator 3
		dc.b  $74		; secondary decay rate operator 2
		dc.b  $7C		; secondary decay rate operator 4
		dc.b  $80		; secondary amplitude/release rate operator 1
		dc.b  $88		; secondary amplitude/release rate operator 3
		dc.b  $84		; secondary amplitude/release rate operator 2
		dc.b  $8C		; secondary amplitude/release rate operator 4
FMInstrumentOperatorTable_End
; byte_72D2C:
FMInstrumentTLTable:
		dc.b  $40		; total level operator 1
		dc.b  $48		; total level operator 3
		dc.b  $44		; total level operator 2
		dc.b  $4C		; total level operator 4
FMInstrumentTLTable_End
; ===========================================================================
; loc_72D30:
cfModulation:
		bset	#3,SMPS_Track.PlaybackControl(a5)	; turn on modulation
		move.l	a4,SMPS_Track.ModulationPtr(a5)		; save pointer to modulation data
		move.b	(a4)+,SMPS_Track.ModulationWait(a5)	; modulation delay
		move.b	(a4)+,SMPS_Track.ModulationSpeed(a5)	; modulation speed
		move.b	(a4)+,SMPS_Track.ModulationDelta(a5)	; modulation delta
		move.b	(a4)+,d0				; modulation steps...
		lsr.b	#1,d0					; ... divided by 2...
		move.b	d0,SMPS_Track.ModulationSteps(a5)	; ... before being stored
		clr.w	SMPS_Track.ModulationVal(a5)		; total accumulated modulation frequency change
		rts
; ===========================================================================
; loc_72D52:
cfEnableModulation:
		bset	#3,SMPS_Track.PlaybackControl(a5)	; turn on modulation
		rts
; ===========================================================================
; loc_72D58:
cfStopTrack:
		bclr	#7,SMPS_Track.PlaybackControl(a5)	; stop track
		bclr	#4,SMPS_Track.PlaybackControl(a5)	; clear 'do not attack next note' bit
		tst.b	SMPS_Track.VoiceControl(a5)		; is this a PSG track?
		bmi.s	.stoppsg				; branch if yes
		tst.b	SMPS_RAM.f_updating_dac(a6)		; is this the DAC we are updating?
		bmi.w	.locexit				; exit if yes
		jsr	FMNoteOff(pc)
		bra.s	.stoppedchannel
; ===========================================================================
; loc_72D74:
.stoppsg:
		jsr	PSGNoteOff(pc)
; loc_72D78:
.stoppedchannel:
		tst.b	SMPS_RAM.f_voice_selector(a6)		; are we updating SFX?
		bpl.w	.locexit				; exit if not
		_clr.b	SMPS_RAM.v_sndprio(a6)			; clear priority
		moveq	#0,d0
		move.b	SMPS_Track.VoiceControl(a5),d0		; get voice control bits
		bmi.s	.getpsgptr				; branch if PSG
		lea	SFX_BGMChannelRAM(pc),a0
		movea.l	a5,a3
		cmpi.b	#4,d0					; is this FM4?
		bne.s	.getpointer				; branch if not
		tst.b	SMPS_RAM.v_spcsfx_fm4_track.PlaybackControl(a6) ; is special SFX playing?
		bpl.s	.getpointer				; branch if not
		lea	SMPS_RAM.v_spcsfx_fm4_track(a6),a5
		movea.l	SMPS_RAM.v_special_voice_ptr(a6),a1	; get voice pointer
		bra.s	.gotpointer
; ===========================================================================
; loc_72DA8:
.getpointer:
		subq.b	#2,d0					; SFX can only use FM3 and up
		lsl.b	#2,d0
		movea.l	(a0,d0.w),a5
		tst.b	SMPS_Track.PlaybackControl(a5)		; is track playing?
		bpl.s	.novoiceupd				; branch if not
		movea.l	SMPS_RAM.v_voice_ptr(a6),a1		; get voice pointer
; loc_72DB8:
.gotpointer:
		bclr	#2,SMPS_Track.PlaybackControl(a5)	; clear 'SFX overriding' bit
		bset	#1,SMPS_Track.PlaybackControl(a5)	; set 'track at rest' bit
		move.b	SMPS_Track.VoiceIndex(a5),d0		; current voice
		jsr	SetVoice(pc)
; loc_72DC8:
.novoiceupd:
		movea.l	a3,a5
		bra.s	.locexit
; ===========================================================================
; loc_72DCC:
.getpsgptr:
		lea	SMPS_RAM.v_spcsfx_psg3_track(a6),a0
		tst.b	SMPS_Track.PlaybackControl(a0)		; is track playing?
		bpl.s	.getchannelptr				; branch if not
		cmpi.b	#$E0,d0					; is it the noise channel?
		beq.s	.gotchannelptr				; branch if yes
		cmpi.b	#$C0,d0					; is it PSG 3?
		beq.s	.gotchannelptr				; branch if yes
; loc_72DE0:
.getchannelptr:
		lea	SFX_BGMChannelRAM(pc),a0
		lsr.b	#3,d0
		movea.l	(a0,d0.w),a0
; loc_72DEA:
.gotchannelptr:
		bclr	#2,SMPS_Track.PlaybackControl(a0)	; clear 'SFX overriding' bit
		bset	#1,SMPS_Track.PlaybackControl(a0)	; set 'track at rest' bit
		cmpi.b	#$E0,SMPS_Track.VoiceControl(a0)	; is this a noise pointer?
		bne.s	.locexit				; branch if not
		move.b	SMPS_Track.PSGNoise(a0),(psg_input).l	; set noise tone
; loc_72E02:
.locexit:
		addq.w	#8,sp					; tamper with return value so we don't go back to caller
		rts
; ===========================================================================
; loc_72E06:
cfSetPSGNoise:
		move.b	#$E0,SMPS_Track.VoiceControl(a5)	; turn channel into noise channel
		move.b	(a4)+,SMPS_Track.PSGNoise(a5)		; save noise tone
		btst	#2,SMPS_Track.PlaybackControl(a5)	; is track being overridden?
		bne.s	.locret					; return if yes
		move.b	-1(a4),(psg_input).l			; set tone
; locret_72E1E:
.locret:
		rts
; ===========================================================================
; loc_72E20:
cfDisableModulation:
		bclr	#3,SMPS_Track.PlaybackControl(a5)	; disable modulation
		rts
; ===========================================================================
; loc_72E26:
cfSetPSGTone:
		move.b	(a4)+,SMPS_Track.VoiceIndex(a5)		; set current PSG tone
		rts
; ===========================================================================
; loc_72E2C:
cfJumpTo:
		move.b	(a4)+,d0				; high byte of offset
		lsl.w	#8,d0					; shift it into place
		move.b	(a4)+,d0				; low byte of offset
		adda.w	d0,a4					; add to current position
		subq.w	#1,a4					; put back one byte
		rts
; ===========================================================================
; loc_72E38:
cfRepeatAtPos:
		moveq	#0,d0
		move.b	(a4)+,d0				; loop index
		move.b	(a4)+,d1				; repeat count
		tst.b	SMPS_Track.LoopCounters(a5,d0.w)	; has this loop already started?
		bne.s	.loopexists				; branch if yes
		move.b	d1,SMPS_Track.LoopCounters(a5,d0.w)	; initialize repeat count
; loc_72E48:
.loopexists:
		subq.b	#1,SMPS_Track.LoopCounters(a5,d0.w)	; decrease loop's repeat count
		bne.s	cfJumpTo				; if nonzero, branch to target
		addq.w	#2,a4					; skip target address
		rts
; ===========================================================================
; loc_72E52:
cfJumpToGosub:
		moveq	#0,d0
		move.b	SMPS_Track.StackPointer(a5),d0		; current stack pointer
		subq.b	#4,d0					; add space for another target
		move.l	a4,(a5,d0.w)				; put in current address (*before* target for jump!)
		move.b	d0,SMPS_Track.StackPointer(a5)		; store new stack pointer
		bra.s	cfJumpTo
; ===========================================================================
; loc_72E64:
cfOpF9:
		move.b	#$88,d0					; D1L/RR of Operator 3
		move.b	#$F,d1					; loaded with fixed value (max RR, 1TL)
		jsr	WriteFMI(pc)
		move.b	#$8C,d0					; D1L/RR of Operator 4
		move.b	#$F,d1					; loaded with fixed value (max RR, 1TL)
		bra.w	WriteFMI
; ===========================================================================
; ---------------------------------------------------------------------------
; DAC driver (Kosinski-compressed)
; ---------------------------------------------------------------------------
; Kos_Z80:
DACDriver:	include "sound/z80.asm"

; ---------------------------------------------------------------------------
; SMPS2ASM - A collection of macros that make SMPS's bytecode human-readable.
; ---------------------------------------------------------------------------
FixMusicAndSFXDataBugs = FixBugs
SonicDriverVer = 1 ; Tell SMPS2ASM that we're using Sonic 1's driver.
		include "sound/_smps2asm_inc.asm"

; ---------------------------------------------------------------------------
; Music data
; ---------------------------------------------------------------------------
Music81:	include "sound/music/Mus81 - GHZ.asm"
		even
Music82:	include "sound/music/Mus82 - LZ.asm"
		even
Music83:	include "sound/music/Mus83 - MZ.asm"
		even
Music84:	include "sound/music/Mus84 - SLZ.asm"
		even
Music85:	include "sound/music/Mus85 - SYZ.asm"
		even
Music86:	include "sound/music/Mus86 - SBZ.asm"
		even
Music87:	include "sound/music/Mus87 - Invincibility.asm"
		even
Music88:	include "sound/music/Mus88 - Extra Life.asm"
		even
Music89:	include "sound/music/Mus89 - Special Stage.asm"
		even
Music8A:	include "sound/music/Mus8A - Title Screen.asm"
		even
Music8B:	include "sound/music/Mus8B - Ending.asm"
		even
Music8C:	include "sound/music/Mus8C - Boss.asm"
		even
Music8D:	include "sound/music/Mus8D - FZ.asm"
		even
Music8E:	include "sound/music/Mus8E - Sonic Got Through.asm"
		even
Music8F:	include "sound/music/Mus8F - Game Over.asm"
		even
Music90:	include "sound/music/Mus90 - Continue Screen.asm"
		even
Music91:	include "sound/music/Mus91 - Credits.asm"
		even
Music92:	include "sound/music/Mus92 - Drowning.asm"
		even
Music93:	include "sound/music/Mus93 - Get Emerald.asm"
		even

; ---------------------------------------------------------------------------
; Sound effect pointers
; ---------------------------------------------------------------------------
SoundIndex:
ptr_sndA0:	dc.l SoundA0
ptr_sndA1:	dc.l SoundA1
ptr_sndA2:	dc.l SoundA2
ptr_sndA3:	dc.l SoundA3
ptr_sndA4:	dc.l SoundA4
ptr_sndA5:	dc.l SoundA5
ptr_sndA6:	dc.l SoundA6
ptr_sndA7:	dc.l SoundA7
ptr_sndA8:	dc.l SoundA8
ptr_sndA9:	dc.l SoundA9
ptr_sndAA:	dc.l SoundAA
ptr_sndAB:	dc.l SoundAB
ptr_sndAC:	dc.l SoundAC
ptr_sndAD:	dc.l SoundAD
ptr_sndAE:	dc.l SoundAE
ptr_sndAF:	dc.l SoundAF
ptr_sndB0:	dc.l SoundB0
ptr_sndB1:	dc.l SoundB1
ptr_sndB2:	dc.l SoundB2
ptr_sndB3:	dc.l SoundB3
ptr_sndB4:	dc.l SoundB4
ptr_sndB5:	dc.l SoundB5
ptr_sndB6:	dc.l SoundB6
ptr_sndB7:	dc.l SoundB7
ptr_sndB8:	dc.l SoundB8
ptr_sndB9:	dc.l SoundB9
ptr_sndBA:	dc.l SoundBA
ptr_sndBB:	dc.l SoundBB
ptr_sndBC:	dc.l SoundBC
ptr_sndBD:	dc.l SoundBD
ptr_sndBE:	dc.l SoundBE
ptr_sndBF:	dc.l SoundBF
ptr_sndC0:	dc.l SoundC0
ptr_sndC1:	dc.l SoundC1
ptr_sndC2:	dc.l SoundC2
ptr_sndC3:	dc.l SoundC3
ptr_sndC4:	dc.l SoundC4
ptr_sndC5:	dc.l SoundC5
ptr_sndC6:	dc.l SoundC6
ptr_sndC7:	dc.l SoundC7
ptr_sndC8:	dc.l SoundC8
ptr_sndC9:	dc.l SoundC9
ptr_sndCA:	dc.l SoundCA
ptr_sndCB:	dc.l SoundCB
ptr_sndCC:	dc.l SoundCC
ptr_sndCD:	dc.l SoundCD
ptr_sndCE:	dc.l SoundCE
ptr_sndCF:	dc.l SoundCF
ptr_sndend

; ---------------------------------------------------------------------------
; Special sound effect pointers
; ---------------------------------------------------------------------------
SpecSoundIndex:
ptr_sndD0:	dc.l SoundD0
ptr_specend

; ---------------------------------------------------------------------------
; Sound effect data
; ---------------------------------------------------------------------------
SoundA0:	include "sound/sfx/SndA0 - Jump.asm"
		even
SoundA1:	include "sound/sfx/SndA1 - Lamppost.asm"
		even
SoundA2:	include "sound/sfx/SndA2.asm"
		even
SoundA3:	include "sound/sfx/SndA3 - Death.asm"
		even
SoundA4:	include "sound/sfx/SndA4 - Skid.asm"
		even
SoundA5:	include "sound/sfx/SndA5.asm"
		even
SoundA6:	include "sound/sfx/SndA6 - Hit Spikes.asm"
		even
SoundA7:	include "sound/sfx/SndA7 - Push Block.asm"
		even
SoundA8:	include "sound/sfx/SndA8 - SS Goal.asm"
		even
SoundA9:	include "sound/sfx/SndA9 - SS Item.asm"
		even
SoundAA:	include "sound/sfx/SndAA - Splash.asm"
		even
SoundAB:	include "sound/sfx/SndAB.asm"
		even
SoundAC:	include "sound/sfx/SndAC - Hit Boss.asm"
		even
SoundAD:	include "sound/sfx/SndAD - Get Bubble.asm"
		even
SoundAE:	include "sound/sfx/SndAE - Fireball.asm"
		even
SoundAF:	include "sound/sfx/SndAF - Shield.asm"
		even
SoundB0:	include "sound/sfx/SndB0 - Saw.asm"
		even
SoundB1:	include "sound/sfx/SndB1 - Electric.asm"
		even
SoundB2:	include "sound/sfx/SndB2 - Drown Death.asm"
		even
SoundB3:	include "sound/sfx/SndB3 - Flamethrower.asm"
		even
SoundB4:	include "sound/sfx/SndB4 - Bumper.asm"
		even
SoundB5:	include "sound/sfx/SndB5 - Ring.asm"
		even
SoundB6:	include "sound/sfx/SndB6 - Spikes Move.asm"
		even
SoundB7:	include "sound/sfx/SndB7 - Rumbling.asm"
		even
SoundB8:	include "sound/sfx/SndB8.asm"
		even
SoundB9:	include "sound/sfx/SndB9 - Collapse.asm"
		even
SoundBA:	include "sound/sfx/SndBA - SS Glass.asm"
		even
SoundBB:	include "sound/sfx/SndBB - Door.asm"
		even
SoundBC:	include "sound/sfx/SndBC - Teleport.asm"
		even
SoundBD:	include "sound/sfx/SndBD - ChainStomp.asm"
		even
SoundBE:	include "sound/sfx/SndBE - Roll.asm"
		even
SoundBF:	include "sound/sfx/SndBF - Get Continue.asm"
		even
SoundC0:	include "sound/sfx/SndC0 - Basaran Flap.asm"
		even
SoundC1:	include "sound/sfx/SndC1 - Break Item.asm"
		even
SoundC2:	include "sound/sfx/SndC2 - Drown Warning.asm"
		even
SoundC3:	include "sound/sfx/SndC3 - Giant Ring.asm"
		even
SoundC4:	include "sound/sfx/SndC4 - Bomb.asm"
		even
SoundC5:	include "sound/sfx/SndC5 - Cash Register.asm"
		even
SoundC6:	include "sound/sfx/SndC6 - Ring Loss.asm"
		even
SoundC7:	include "sound/sfx/SndC7 - Chain Rising.asm"
		even
SoundC8:	include "sound/sfx/SndC8 - Burning.asm"
		even
SoundC9:	include "sound/sfx/SndC9 - Hidden Bonus.asm"
		even
SoundCA:	include "sound/sfx/SndCA - Enter SS.asm"
		even
SoundCB:	include "sound/sfx/SndCB - Wall Smash.asm"
		even
SoundCC:	include "sound/sfx/SndCC - Spring.asm"
		even
SoundCD:	include "sound/sfx/SndCD - Switch.asm"
		even
SoundCE:	include "sound/sfx/SndCE - Ring Left Speaker.asm"
		even
SoundCF:	include "sound/sfx/SndCF - Signpost.asm"
		even

; ---------------------------------------------------------------------------
; Special sound effect data
; ---------------------------------------------------------------------------
SoundD0:	include "sound/sfx/SndD0 - Waterfall.asm"
		even

; ---------------------------------------------------------------------------
; 'Sega' chant PCM sample
; ---------------------------------------------------------------------------
SegaPCM:	binclude "sound/dac/pcm/generated/sega.pcm"
SegaPCM_End:	even
SegaPCM.size:	equ SegaPCM_End-SegaPCM