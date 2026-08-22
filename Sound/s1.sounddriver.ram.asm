SMPS_Track struct DOTS
PlaybackControl:	ds.b	1	; All tracks
VoiceControl:		ds.b	1	; All tracks
TempoDivider:		ds.b	1	; All tracks
			ds.b	1	; Unused
DataPointer:		ds.l	1	; All tracks (4 bytes)
Transpose:		ds.b	1	; FM/PSG only (sometimes written to as a word, to include TrackVolume)
Volume:			ds.b	1	; FM/PSG only
AMSFMSPan:		ds.b	1	; FM/DAC only
VoiceIndex:		ds.b	1	; FM/PSG only
VolEnvIndex:		ds.b	1	; PSG only
StackPointer:		ds.b	1	; All tracks
DurationTimeout:	ds.b	1	; All tracks
SavedDuration:		ds.b	1	; All tracks
SavedDAC:		;ds.b	1	; DAC only
Freq:			ds.w	1	; FM/PSG only (2 bytes)
NoteTimeout:		ds.b	1	; FM/PSG only
NoteTimeoutMaster:	ds.b	1	; FM/PSG only
ModulationPtr:		ds.l	1	; FM/PSG only (4 bytes)
ModulationWait:		ds.b	1	; FM/PSG only
ModulationSpeed:	ds.b	1	; FM/PSG only
ModulationDelta:	ds.b	1	; FM/PSG only
ModulationSteps:	ds.b	1	; FM/PSG only
ModulationVal:		ds.w	1	; FM/PSG only (2 bytes)
Detune:			ds.b	1	; FM/PSG only
PSGNoise:		;ds.b	1	; PSG only
FeedbackAlgo:		ds.b	1	; FM only
VoicePtr:		ds.l	1	; FM SFX only (4 bytes)
LoopCounters:		ds.l	3	; All tracks (multiple bytes)
GoSubStack:				; All tracks (multiple bytes. This label won't get to be used because of an optimisation that just uses SMPS_Track.len)
	endstruct

SMPS_RAM struct DOTS
v_1up_ram:
v_sndprio:		ds.b	1	; sound priority (priority of new music/SFX must be higher or equal to this value or it won't play; bit 7 of priority being set prevents this value from changing)
v_main_tempo_timeout:	ds.b	1	; Counts down to zero; when zero, resets to next value and delays song by 1 frame
v_main_tempo:		ds.b	1	; Used for music only
f_pausemusic:		ds.b	1	; flag set to stop music when paused
v_fadeout_counter:	ds.b	1
			ds.b	1	; unused
v_fadeout_delay:	ds.b	1
v_communication_byte:	ds.b	1	; used in Ristar to sync with a boss' attacks; unused here
f_updating_dac:		ds.b	1	; $80 if updating DAC, $00 otherwise
v_sound_id:		ds.b	1	; sound or music copied from below
v_soundqueue_start:
v_soundqueue0:		ds.b	1	; sound or music to play
v_soundqueue1:		ds.b	1	; special sound to play
v_soundqueue2:		ds.b	1	; unused sound to play
v_soundqueue_end:
			ds.b	1	; unused
f_voice_selector:	ds.b	1	; $00 = use music voice pointer; $40 = use special voice pointer; $80 = use track voice pointer
			ds.b	9
v_voice_ptr:		ds.l	1	; voice data pointer (4 bytes)
			ds.b	4	; unused
v_special_voice_ptr:	ds.l	1	; voice data pointer for special SFX ($D0-$DF) (4 bytes)
f_fadein_flag:		ds.b	1	; Flag for fade in
v_fadein_delay:		ds.b	1
v_fadein_counter:	ds.b	1	; Timer for fade in/out
f_1up_playing:		ds.b	1	; flag indicating 1-up song is playing
v_tempo_mod:		ds.b	1	; music - tempo modifier
v_speeduptempo:		ds.b	1	; music - tempo modifier with speed shoes
f_speedup:		ds.b	1	; flag indicating whether speed shoes tempo is on ($80) or off ($00)
v_ring_speaker:		ds.b	1	; which speaker the "ring" sound is played in (00 = right; 01 = left)
f_push_playing:		ds.b	1	; if set, prevents further push sounds from playing
			ds.b	$13	; unused
v_track_ram:
v_music_track_ram:			; Start of music RAM
v_music_fmdac_tracks:
v_music_dac_track:	SMPS_Track
v_music_fm_tracks:
v_music_fm1_track:	SMPS_Track
v_music_fm2_track:	SMPS_Track
v_music_fm3_track:	SMPS_Track
v_music_fm4_track:	SMPS_Track
v_music_fm5_track:	SMPS_Track
v_music_fm6_track:	SMPS_Track
v_music_fm_tracks_end:
v_music_fmdac_tracks_end:
v_music_psg_tracks:
v_music_psg1_track:	SMPS_Track
v_music_psg2_track:	SMPS_Track
v_music_psg3_track:	SMPS_Track
v_music_psg_tracks_end:
v_music_track_ram_end:
v_1up_ram_end:
v_sfx_track_ram:			; Start of SFX RAM, straight after the end of music RAM
v_sfx_fm_tracks:
v_sfx_fm3_track:	SMPS_Track
v_sfx_fm4_track:	SMPS_Track
v_sfx_fm5_track:	SMPS_Track
v_sfx_fm_tracks_end:
v_sfx_psg_tracks:
v_sfx_psg1_track:	SMPS_Track
v_sfx_psg2_track:	SMPS_Track
v_sfx_psg3_track:	SMPS_Track
v_sfx_psg_tracks_end:
v_sfx_track_ram_end:
v_spcsfx_track_ram:			; Start of special SFX RAM, straight after the end of SFX RAM
v_spcsfx_fm_tracks:
v_spcsfx_fm4_track:	SMPS_Track
v_spcsfx_fm_tracks_end:
v_spcsfx_psg_tracks:
v_spcsfx_psg3_track:	SMPS_Track
v_spcsfx_psg_tracks_end:
v_spcsfx_track_ram_end:
v_track_ram_end:

v_1up_ram_copy:		ds.b	SMPS_RAM.v_1up_ram_end-SMPS_RAM.v_1up_ram
	endstruct
