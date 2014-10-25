; Variables (v) and Flags (f)

v_regbuffer:	= $FFFFFC00	; stores registers d0-a7 during an error event ($40 bytes)
v_spbuffer:	= $FFFFFC40	; stores most recent sp address (4 bytes)
v_errortype:	= $FFFFFC44	; error type

v_128x128:	=   $FF0000	; 128x128 tile mappings ($A400 bytes)
v_lvllayoutfg:	= $FFFFA400	; level layout ROM address (4 bytes)
v_lvllayoutbg:	= $FFFFA404	; background layout ROM address (4 bytes)

v_ngfx_buffer:	= $FFFFAA00	; Nemesis graphics decompression buffer ($200 bytes)
v_spritequeue:	= $FFFFAC00	; sprite display queue, in order of priority ($400 bytes)
v_16x16:	= $FFFFB000	; 16x16 tile mappings

v_sgfx_buffer:	= $FFFFC800	; buffered Sonic graphics ($18 cells) ($300 bytes)
v_tracksonic:	= $FFFFCB00	; position tracking data for Sonic ($100 bytes)
v_hscrolltablebuffer:	= $FFFFCC00 ; scrolling table data ($400 bytes)
v_objspace:	= $FFFFD000	; object variable space ($40 bytes per object) ($2000 bytes)
v_player:	= v_objspace	; object variable space for Sonic ($40 bytes)
v_lvlobjspace:	= $FFFFD800	; level object variable space ($1800 bytes)

v_snddriver_ram:  = $FFFFF000 ; start of RAM for the sound driver data

; =================================================================================
; From here on, until otherwise stated, all offsets are relative to v_snddriver_ram
; =================================================================================
v_startofvariables:	= $000
v_sndprio:		= $000	; sound priority (priority of new music/SFX must be higher or equal to this value or it won't play; bit 7 of priority being set prevents this value from changing)
v_main_tempo_timeout:	= $001	; Counts down to zero; when zero, resets to next value and delays song by 1 frame
v_main_tempo:		= $002	; Used for music only
f_stopmusic:		= $003	; flag set to stop music when paused
v_fadeout_counter:	= $004

v_fadeout_delay:	= $006
v_communication_byte:	= $007	; used in Ristar to sync with a boss' attacks; unused here
f_updating_dac:		= $008	; $80 if updating DAC, $00 otherwise
v_playsnd0:		= $009	; sound or music copied from below
v_playsnd1:		= $00A	; sound or music to play
v_playsnd2:		= $00B	; special sound to play
v_playnull:		= $00C	; unused sound to play

f_voice_selector:	= $00E	; $00 = use music voice pointer; $40 = use special voice pointer; $80 = use track voice pointer

v_voice_ptr:		= $018	; voice data pointer (4 bytes)

v_special_voice_ptr:	= $020	; voice data pointer for special SFX ($D0-$DF) (4 bytes)

f_fadein_flag:		= $024	; Flag for fade in
v_fadein_delay:		= $025
v_fadein_counter:	= $026	; Timer for fade in/out
f_1up_playing:		= $027	; flag indicating 1-up song is playing
v_tempo_mod:		= $028	; music - tempo modifier
v_speeduptempo:		= $029	; music - tempo modifier with speed shoes
f_speedup:		= $02A	; flag indicating whether speed shoes tempo is on ($80) or off ($00)
v_ring_speaker:		= $02B	; which speaker the "ring" sound is played in (00 = right; 01 = left)
f_push_playing:		= $02C	; if set, prevents further push sounds from playing

v_track_ram:		= $040	; Start of music RAM

v_dac_track:		= v_track_ram+zTrackSz*0
v_dac_playback_control:		= v_dac_track+0	; Playback control bits for DAC channel
v_dac_voice_control:		= v_dac_track+1	; Voice control bits for DAC channel
v_dac_tempo_time:		= v_dac_track+2	; music - tempo dividing timing
v_dac_ptr:			= v_dac_track+4	; DAC channel pointer (4 bytes)
v_dac_amsfmspan:		= v_dac_track+$A
v_dac_stack_ptr:		= v_dac_track+$D
v_dac_note_timeout:		= v_dac_track+$E	; byte ; Counts down to zero; when zero, a new DAC sample is needed
v_dac_note_duration:		= v_dac_track+$F
v_dac_curr_sample:		= v_dac_track+$10
v_dac_loop_index:		= v_dac_track+$24	; Several bytes, may overlap with gosub/return stack

; Note: using the channel assignment bits to determine FM channel #. Thus, there is no FM 3.

v_fm1_track:		= v_track_ram+zTrackSz*1
v_fm1_playback_control:		= v_fm1_track+0	; Playback control bits for FM1
v_fm1_voice_control:		= v_fm1_track+1	; Voice control bits
v_fm1_tempo_time:		= v_fm1_track+2	; music - tempo dividing timing
v_fm1_ptr:			= v_fm1_track+4	; FM channel 0 pointer (4 bytes)
v_fm1_key:			= v_fm1_track+8	; FM channel 0 key displacement
v_fm1_volume:			= v_fm1_track+9	; FM channel 0 volume attenuation
v_fm1_amsfmspan:		= v_fm1_track+$A
v_fm1_voice:			= v_fm1_track+$B
v_fm1_stack_ptr:		= v_fm1_track+$D
v_fm1_note_timeout:		= v_fm1_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_fm1_note_duration:		= v_fm1_track+$F
v_fm1_curr_note:		= v_fm1_track+$10
v_fm1_note_fill:		= v_fm1_track+$12
v_fm1_note_fill_master:		= v_fm1_track+$13
v_fm1_modulation_ptr:		= v_fm1_track+$14	; 4 bytes
v_fm1_modulation_wait:		= v_fm1_track+$18
v_fm1_modulation_speed:		= v_fm1_track+$19
v_fm1_modulation_delta:		= v_fm1_track+$1A
v_fm1_modulation_steps:		= v_fm1_track+$1B
v_fm1_modulation_freq:		= v_fm1_track+$1C	; 2 bytes
v_fm1_freq_adjust:		= v_fm1_track+$1E
v_fm1_feedbackalgo:		= v_fm1_track+$1F
v_fm1_loop_index:		= v_fm1_track+$24	; Several bytes, may overlap with gosub/return stack

v_fm2_track:		= v_track_ram+zTrackSz*2
v_fm2_playback_control:		= v_fm2_track+0	; Playback control bits for FM2
v_fm2_voice_control:		= v_fm2_track+1	; Voice control bits
v_fm2_tempo_time:		= v_fm2_track+2	; music - tempo dividing timing
v_fm2_ptr:			= v_fm2_track+4	; FM channel 1 pointer (4 bytes)
v_fm2_key:			= v_fm2_track+8	; FM channel 1 key displacement
v_fm2_volume:			= v_fm2_track+9	; FM channel 1 volume attenuation
v_fm2_amsfmspan:		= v_fm2_track+$A
v_fm2_voice:			= v_fm2_track+$B
v_fm2_stack_ptr:		= v_fm2_track+$D
v_fm2_note_timeout:		= v_fm2_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_fm2_note_duration:		= v_fm2_track+$F
v_fm2_curr_note:		= v_fm2_track+$10
v_fm2_note_fill:		= v_fm2_track+$12
v_fm2_note_fill_master:		= v_fm2_track+$13
v_fm2_modulation_ptr:		= v_fm2_track+$14	; 4 bytes
v_fm2_modulation_wait:		= v_fm2_track+$18
v_fm2_modulation_speed:		= v_fm2_track+$19
v_fm2_modulation_delta:		= v_fm2_track+$1A
v_fm2_modulation_steps:		= v_fm2_track+$1B
v_fm2_modulation_freq:		= v_fm2_track+$1C	; 2 bytes
v_fm2_freq_adjust:		= v_fm2_track+$1E
v_fm2_feedbackalgo:		= v_fm2_track+$1F
v_fm2_loop_index:		= v_fm2_track+$24	; Several bytes, may overlap with gosub/return stack

v_fm3_track:		= v_track_ram+zTrackSz*3
v_fm3_playback_control:		= v_fm3_track+0	; Playback control bits for FM3
v_fm3_voice_control:		= v_fm3_track+1	; Voice control bits
v_fm3_tempo_time:		= v_fm3_track+2	; music - tempo dividing timing
v_fm3_ptr:			= v_fm3_track+4	; FM channel 2 pointer (4 bytes)
v_fm3_key:			= v_fm3_track+8	; FM channel 2 key displacement
v_fm3_volume:			= v_fm3_track+9	; FM channel 2 volume attenuation
v_fm3_amsfmspan:		= v_fm3_track+$A
v_fm3_voice:			= v_fm3_track+$B
v_fm3_stack_ptr:		= v_fm3_track+$D
v_fm3_note_timeout:		= v_fm3_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_fm3_note_duration:		= v_fm3_track+$F
v_fm3_curr_note:		= v_fm3_track+$10
v_fm3_note_fill:		= v_fm3_track+$12
v_fm3_note_fill_master:		= v_fm3_track+$13
v_fm3_modulation_ptr:		= v_fm3_track+$14	; 4 bytes
v_fm3_modulation_wait:		= v_fm3_track+$18
v_fm3_modulation_speed:		= v_fm3_track+$19
v_fm3_modulation_delta:		= v_fm3_track+$1A
v_fm3_modulation_steps:		= v_fm3_track+$1B
v_fm3_modulation_freq:		= v_fm3_track+$1C	; 2 bytes
v_fm3_freq_adjust:		= v_fm3_track+$1E
v_fm3_feedbackalgo:		= v_fm3_track+$1F
v_fm3_loop_index:		= v_fm3_track+$24	; Several bytes, may overlap with gosub/return stack

v_fm4_track:		= v_track_ram+zTrackSz*4
v_fm4_playback_control:		= v_fm4_track+0	; Playback control bits for FM4
v_fm4_voice_control:		= v_fm4_track+1	; Voice control bits
v_fm4_tempo_time:		= v_fm4_track+2	; music - tempo dividing timing
v_fm4_ptr:			= v_fm4_track+4	; FM channel 4 pointer (4 bytes)
v_fm4_key:			= v_fm4_track+8	; FM channel 4 key displacement
v_fm4_volume:			= v_fm4_track+9	; FM channel 4 volume attenuation
v_fm4_amsfmspan:		= v_fm4_track+$A
v_fm4_voice:			= v_fm4_track+$B
v_fm4_stack_ptr:		= v_fm4_track+$D
v_fm4_note_timeout:		= v_fm4_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_fm4_note_duration:		= v_fm4_track+$F
v_fm4_curr_note:		= v_fm4_track+$10
v_fm4_note_fill:		= v_fm4_track+$12
v_fm4_note_fill_master:		= v_fm4_track+$13
v_fm4_modulation_ptr:		= v_fm4_track+$14	; 4 bytes
v_fm4_modulation_wait:		= v_fm4_track+$18
v_fm4_modulation_speed:		= v_fm4_track+$19
v_fm4_modulation_delta:		= v_fm4_track+$1A
v_fm4_modulation_steps:		= v_fm4_track+$1B
v_fm4_modulation_freq:		= v_fm4_track+$1C	; 2 bytes
v_fm4_freq_adjust:		= v_fm4_track+$1E
v_fm4_feedbackalgo:		= v_fm4_track+$1F
v_fm4_loop_index:		= v_fm4_track+$24	; Several bytes, may overlap with gosub/return stack

v_fm5_track:		= v_track_ram+zTrackSz*5
v_fm5_playback_control:		= v_fm5_track+0	; Playback control bits for FM5
v_fm5_voice_control:		= v_fm5_track+1	; Voice control bits
v_fm5_tempo_time:		= v_fm5_track+2	; music - tempo dividing timing
v_fm5_ptr:			= v_fm5_track+4	; FM channel 5 pointer (4 bytes)
v_fm5_key:			= v_fm5_track+8	; FM channel 5 key displacement
v_fm5_volume:			= v_fm5_track+9	; FM channel 5 volume attenuation
v_fm5_amsfmspan:		= v_fm5_track+$A
v_fm5_voice:			= v_fm5_track+$B
v_fm5_stack_ptr:		= v_fm5_track+$D
v_fm5_note_timeout:		= v_fm5_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_fm5_note_duration:		= v_fm5_track+$F
v_fm5_curr_note:		= v_fm5_track+$10
v_fm5_note_fill:		= v_fm5_track+$12
v_fm5_note_fill_master:		= v_fm5_track+$13
v_fm5_modulation_ptr:		= v_fm5_track+$14	; 4 bytes
v_fm5_modulation_wait:		= v_fm5_track+$18
v_fm5_modulation_speed:		= v_fm5_track+$19
v_fm5_modulation_delta:		= v_fm5_track+$1A
v_fm5_modulation_steps:		= v_fm5_track+$1B
v_fm5_modulation_freq:		= v_fm5_track+$1C	; 2 bytes
v_fm5_freq_adjust:		= v_fm5_track+$1E
v_fm5_feedbackalgo:		= v_fm5_track+$1F
v_fm5_loop_index:		= v_fm5_track+$24	; Several bytes, may overlap with gosub/return stack

v_fm6_track:		= v_track_ram+zTrackSz*6
v_fm6_playback_control:		= v_fm6_track+0	; Playback control bits for FM6
v_fm6_voice_control:		= v_fm6_track+1	; Voice control bits
v_fm6_tempo_time:		= v_fm6_track+2	; music - tempo dividing timing
v_fm6_ptr:			= v_fm6_track+4	; FM channel 6 pointer (4 bytes)
v_fm6_key:			= v_fm6_track+8	; FM channel 6 key displacement
v_fm6_volume:			= v_fm6_track+9	; FM channel 6 volume attenuation
v_fm6_amsfmspan:		= v_fm6_track+$A
v_fm6_voice:			= v_fm6_track+$B
v_fm6_stack_ptr:		= v_fm6_track+$D
v_fm6_note_timeout:		= v_fm6_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_fm6_note_duration:		= v_fm6_track+$F
v_fm6_curr_note:		= v_fm6_track+$10
v_fm6_note_fill:		= v_fm6_track+$12
v_fm6_note_fill_master:		= v_fm6_track+$13
v_fm6_modulation_ptr:		= v_fm6_track+$14	; 4 bytes
v_fm6_modulation_wait:		= v_fm6_track+$18
v_fm6_modulation_speed:		= v_fm6_track+$19
v_fm6_modulation_delta:		= v_fm6_track+$1A
v_fm6_modulation_steps:		= v_fm6_track+$1B
v_fm6_modulation_freq:		= v_fm6_track+$1C	; 2 bytes
v_fm6_freq_adjust:		= v_fm6_track+$1E
v_fm6_feedbackalgo:		= v_fm6_track+$1F
v_fm6_loop_index:		= v_fm6_track+$24	; Several bytes, may overlap with gosub/return stack

v_psg1_track:		= v_track_ram+zTrackSz*7
v_psg1_playback_control:	= v_psg1_track+0	; Playback control bits for PSG1
v_psg1_voice_control:		= v_psg1_track+1	; Voice control bits
v_psg1_tempo_time:		= v_psg1_track+2	; music - tempo dividing timing
v_psg1_ptr:			= v_psg1_track+4	; PSG channel 1 pointer (4 bytes)
v_psg1_key:			= v_psg1_track+8	; PSG channel 1 key displacement
v_psg1_volume:			= v_psg1_track+9	; PSG channel 1 volume attenuation
v_psg1_amsfmspan:		= v_psg1_track+$A
v_psg1_tone:			= v_psg1_track+$B
v_psg1_flutter_index:		= v_psg1_track+$C
v_psg1_stack_ptr:		= v_psg1_track+$D
v_psg1_note_timeout:		= v_psg1_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_psg1_note_duration:		= v_psg1_track+$F
v_psg1_curr_note:		= v_psg1_track+$10
v_psg1_note_fill:		= v_psg1_track+$12
v_psg1_note_fill_master:	= v_psg1_track+$13
v_psg1_modulation_ptr:		= v_psg1_track+$14	; 4 bytes
v_psg1_modulation_wait:		= v_psg1_track+$18
v_psg1_modulation_speed:	= v_psg1_track+$19
v_psg1_modulation_delta:	= v_psg1_track+$1A
v_psg1_modulation_steps:	= v_psg1_track+$1B
v_psg1_modulation_freq:		= v_psg1_track+$1C	; 2 bytes
v_psg1_freq_adjust:		= v_psg1_track+$1E
v_psg1_noise:			= v_psg1_track+$1F
v_psg1_loop_index:		= v_psg1_track+$24	; Several bytes, may overlap with gosub/return stack

v_psg2_track:		= v_track_ram+zTrackSz*8
v_psg2_playback_control:	= v_psg2_track+0	; Playback control bits for PSG2
v_psg2_voice_control:		= v_psg2_track+1	; Voice control bits
v_psg2_tempo_time:		= v_psg2_track+2	; music - tempo dividing timing
v_psg2_ptr:			= v_psg2_track+4	; PSG channel 2 pointer (4 bytes)
v_psg2_key:			= v_psg2_track+8	; PSG channel 2 key displacement
v_psg2_volume:			= v_psg2_track+9	; PSG channel 2 volume attenuation
v_psg2_amsfmspan:		= v_psg2_track+$A
v_psg2_tone:			= v_psg2_track+$B
v_psg2_flutter_index:		= v_psg2_track+$C
v_psg2_stack_ptr:		= v_psg2_track+$D
v_psg2_note_timeout:		= v_psg2_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_psg2_note_duration:		= v_psg2_track+$F
v_psg2_curr_note:		= v_psg2_track+$10
v_psg2_note_fill:		= v_psg2_track+$12
v_psg2_note_fill_master:	= v_psg2_track+$13
v_psg2_modulation_ptr:		= v_psg2_track+$14	; 4 bytes
v_psg2_modulation_wait:		= v_psg2_track+$18
v_psg2_modulation_speed:	= v_psg2_track+$19
v_psg2_modulation_delta:	= v_psg2_track+$1A
v_psg2_modulation_steps:	= v_psg2_track+$1B
v_psg2_modulation_freq:		= v_psg2_track+$1C	; 2 bytes
v_psg2_freq_adjust:		= v_psg2_track+$1E
v_psg2_noise:			= v_psg2_track+$1F
v_psg2_loop_index:		= v_psg2_track+$24	; Several bytes, may overlap with gosub/return stack

v_psg3_track:		= v_track_ram+zTrackSz*9
v_psg3_playback_control:	= v_psg3_track+0	; Playback control bits for PSG3
v_psg3_voice_control:		= v_psg3_track+1	; Voice control bits
v_psg3_tempo_time:		= v_psg3_track+2	; music - tempo dividing timing
v_psg3_ptr:			= v_psg3_track+4	; PSG channel 3 pointer (4 bytes)
v_psg3_key:			= v_psg3_track+8	; PSG channel 3 key displacement
v_psg3_volume:			= v_psg3_track+9	; PSG channel 3 volume attenuation
v_psg3_amsfmspan:		= v_psg3_track+$A
v_psg3_tone:			= v_psg3_track+$B
v_psg3_flutter_index:		= v_psg3_track+$C
v_psg3_stack_ptr:		= v_psg3_track+$D
v_psg3_note_timeout:		= v_psg3_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_psg3_note_duration:		= v_psg3_track+$F
v_psg3_curr_note:		= v_psg3_track+$10
v_psg3_note_fill:		= v_psg3_track+$12
v_psg3_note_fill_master:	= v_psg3_track+$13
v_psg3_modulation_ptr:		= v_psg3_track+$14	; 4 bytes
v_psg3_modulation_wait:		= v_psg3_track+$18
v_psg3_modulation_speed:	= v_psg3_track+$19
v_psg3_modulation_delta:	= v_psg3_track+$1A
v_psg3_modulation_steps:	= v_psg3_track+$1B
v_psg3_modulation_freq:		= v_psg3_track+$1C	; 2 bytes
v_psg3_freq_adjust:		= v_psg3_track+$1E
v_psg3_noise:			= v_psg3_track+$1F
v_psg3_loop_index:		= v_psg3_track+$24	; Several bytes, may overlap with gosub/return stack

v_sfx_track_ram:	= v_track_ram+zTrackSz*10	; Start of sfx RAM, straight after the end of music RAM

v_sfx_fm3_track:	= v_sfx_track_ram+zTrackSz*0
v_sfx_fm3_playback_control:	= v_sfx_fm3_track+0	; Playback control bits for sfx FM3
v_sfx_fm3_voice_control:	= v_sfx_fm3_track+1	; Voice control bits
v_sfx_fm3_tempo_time:		= v_sfx_fm3_track+2	; sfx - tempo dividing timing
v_sfx_fm3_ptr:			= v_sfx_fm3_track+4	; FM channel 2 pointer (4 bytes)
v_sfx_fm3_key:			= v_sfx_fm3_track+8	; FM channel 2 key displacement
v_sfx_fm3_volume:		= v_sfx_fm3_track+9	; FM channel 2 volume attenuation
v_sfx_fm3_amsfmspan:		= v_sfx_fm3_track+$A
v_sfx_fm3_voice:		= v_sfx_fm3_track+$B
v_sfx_fm3_stack_ptr:		= v_sfx_fm3_track+$D
v_sfx_fm3_note_timeout:		= v_sfx_fm3_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_sfx_fm3_note_duration:	= v_sfx_fm3_track+$F
v_sfx_fm3_curr_note:		= v_sfx_fm3_track+$10
v_sfx_fm3_note_fill:		= v_sfx_fm3_track+$12
v_sfx_fm3_note_fill_master:	= v_sfx_fm3_track+$13
v_sfx_fm3_modulation_ptr:	= v_sfx_fm3_track+$14	; 4 bytes
v_sfx_fm3_modulation_wait:	= v_sfx_fm3_track+$18
v_sfx_fm3_modulation_speed:	= v_sfx_fm3_track+$19
v_sfx_fm3_modulation_delta:	= v_sfx_fm3_track+$1A
v_sfx_fm3_modulation_steps:	= v_sfx_fm3_track+$1B
v_sfx_fm3_modulation_freq:	= v_sfx_fm3_track+$1C	; 2 bytes
v_sfx_fm3_freq_adjust:		= v_sfx_fm3_track+$1E
v_sfx_fm3_feedbackalgo:		= v_sfx_fm3_track+$1F
v_sfx_fm3_voice_ptr:		= v_sfx_fm3_track+$20
v_sfx_fm3_loop_index:		= v_sfx_fm3_track+$24	; Several bytes, may overlap with gosub/return stack

v_sfx_fm4_track:	= v_sfx_track_ram+zTrackSz*1
v_sfx_fm4_playback_control:	= v_sfx_fm4_track+0	; Playback control bits for sfx FM4
v_sfx_fm4_voice_control:	= v_sfx_fm4_track+1	; Voice control bits
v_sfx_fm4_tempo_time:		= v_sfx_fm4_track+2	; sfx - tempo dividing timing
v_sfx_fm4_ptr:			= v_sfx_fm4_track+4	; FM channel 4 pointer (4 bytes)
v_sfx_fm4_key:			= v_sfx_fm4_track+8	; FM channel 4 key displacement
v_sfx_fm4_volume:		= v_sfx_fm4_track+9	; FM channel 4 volume attenuation
v_sfx_fm4_amsfmspan:		= v_sfx_fm4_track+$A
v_sfx_fm4_voice:		= v_sfx_fm4_track+$B
v_sfx_fm4_stack_ptr:		= v_sfx_fm4_track+$D
v_sfx_fm4_note_timeout:		= v_sfx_fm4_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_sfx_fm4_note_duration:	= v_sfx_fm4_track+$F
v_sfx_fm4_curr_note:		= v_sfx_fm4_track+$10
v_sfx_fm4_note_fill:		= v_sfx_fm4_track+$12
v_sfx_fm4_note_fill_master:	= v_sfx_fm4_track+$13
v_sfx_fm4_modulation_ptr:	= v_sfx_fm4_track+$14	; 4 bytes
v_sfx_fm4_modulation_wait:	= v_sfx_fm4_track+$18
v_sfx_fm4_modulation_speed:	= v_sfx_fm4_track+$19
v_sfx_fm4_modulation_delta:	= v_sfx_fm4_track+$1A
v_sfx_fm4_modulation_steps:	= v_sfx_fm4_track+$1B
v_sfx_fm4_modulation_freq:	= v_sfx_fm4_track+$1C	; 2 bytes
v_sfx_fm4_freq_adjust:		= v_sfx_fm4_track+$1E
v_sfx_fm4_feedbackalgo:		= v_sfx_fm4_track+$1F
v_sfx_fm4_voice_ptr:		= v_sfx_fm4_track+$20
v_sfx_fm4_loop_index:		= v_sfx_fm4_track+$24	; Several bytes, may overlap with gosub/return stack

v_sfx_fm5_track:	= v_sfx_track_ram+zTrackSz*2
v_sfx_fm5_playback_control:	= v_sfx_fm5_track+0	; Playback control bits for sfx FM5
v_sfx_fm5_voice_control:	= v_sfx_fm5_track+1	; Voice control bits
v_sfx_fm5_tempo_time:		= v_sfx_fm5_track+2	; sfx - tempo dividing timing
v_sfx_fm5_ptr:			= v_sfx_fm5_track+4	; FM channel 5 pointer (4 bytes)
v_sfx_fm5_key:			= v_sfx_fm5_track+8	; FM channel 5 key displacement
v_sfx_fm5_volume:		= v_sfx_fm5_track+9	; FM channel 5 volume attenuation
v_sfx_fm5_amsfmspan:		= v_sfx_fm5_track+$A
v_sfx_fm5_voice:		= v_sfx_fm5_track+$B
v_sfx_fm5_stack_ptr:		= v_sfx_fm5_track+$D
v_sfx_fm5_note_timeout:		= v_sfx_fm5_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_sfx_fm5_note_duration:	= v_sfx_fm5_track+$F
v_sfx_fm5_curr_note:		= v_sfx_fm5_track+$10
v_sfx_fm5_note_fill:		= v_sfx_fm5_track+$12
v_sfx_fm5_note_fill_master:	= v_sfx_fm5_track+$13
v_sfx_fm5_modulation_ptr:	= v_sfx_fm5_track+$14	; 4 bytes
v_sfx_fm5_modulation_wait:	= v_sfx_fm5_track+$18
v_sfx_fm5_modulation_speed:	= v_sfx_fm5_track+$19
v_sfx_fm5_modulation_delta:	= v_sfx_fm5_track+$1A
v_sfx_fm5_modulation_steps:	= v_sfx_fm5_track+$1B
v_sfx_fm5_modulation_freq:	= v_sfx_fm5_track+$1C	; 2 bytes
v_sfx_fm5_freq_adjust:		= v_sfx_fm5_track+$1E
v_sfx_fm5_feedbackalgo:		= v_sfx_fm5_track+$1F
v_sfx_fm5_voice_ptr:		= v_sfx_fm5_track+$20
v_sfx_fm5_loop_index:		= v_sfx_fm5_track+$24	; Several bytes, may overlap with gosub/return stack

v_sfx_psg1_track:	= v_sfx_track_ram+zTrackSz*3
v_sfx_psg1_playback_control:	= v_sfx_psg1_track+0	; Playback control bits for sfx PSG1
v_sfx_psg1_voice_control:	= v_sfx_psg1_track+1	; Voice control bits
v_sfx_psg1_tempo_time:		= v_sfx_psg1_track+2	; sfx - tempo dividing timing
v_sfx_psg1_ptr:			= v_sfx_psg1_track+4	; PSG channel 1 pointer (4 bytes)
v_sfx_psg1_key:			= v_sfx_psg1_track+8	; PSG channel 1 key displacement
v_sfx_psg1_volume:		= v_sfx_psg1_track+9	; PSG channel 1 volume attenuation
v_sfx_psg1_amsfmspan:		= v_sfx_psg1_track+$A
v_sfx_psg1_tone:		= v_sfx_psg1_track+$B
v_sfx_psg1_flutter_index:	= v_sfx_psg1_track+$C
v_sfx_psg1_stack_ptr:		= v_sfx_psg1_track+$D
v_sfx_psg1_note_timeout:	= v_sfx_psg1_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_sfx_psg1_note_duration:	= v_sfx_psg1_track+$F
v_sfx_psg1_curr_note:		= v_sfx_psg1_track+$10
v_sfx_psg1_note_fill:		= v_sfx_psg1_track+$12
v_sfx_psg1_note_fill_master:	= v_sfx_psg1_track+$13
v_sfx_psg1_modulation_ptr:	= v_sfx_psg1_track+$14	; 4 bytes
v_sfx_psg1_modulation_wait:	= v_sfx_psg1_track+$18
v_sfx_psg1_modulation_speed:	= v_sfx_psg1_track+$19
v_sfx_psg1_modulation_delta:	= v_sfx_psg1_track+$1A
v_sfx_psg1_modulation_steps:	= v_sfx_psg1_track+$1B
v_sfx_psg1_modulation_freq:	= v_sfx_psg1_track+$1C	; 2 bytes
v_sfx_psg1_freq_adjust:		= v_sfx_psg1_track+$1E
v_sfx_psg1_noise:		= v_sfx_psg1_track+$1F
v_sfx_psg1_loop_index:		= v_sfx_psg1_track+$24	; Several bytes, may overlap with gosub/return stack

v_sfx_psg2_track:	= v_sfx_track_ram+zTrackSz*4
v_sfx_psg2_playback_control:	= v_sfx_psg2_track+0	; Playback control bits for sfx PSG2
v_sfx_psg2_voice_control:	= v_sfx_psg2_track+1	; Voice control bits
v_sfx_psg2_tempo_time:		= v_sfx_psg2_track+2	; sfx - tempo dividing timing
v_sfx_psg2_ptr:			= v_sfx_psg2_track+4	; PSG channel 2 pointer (4 bytes)
v_sfx_psg2_key:			= v_sfx_psg2_track+8	; PSG channel 2 key displacement
v_sfx_psg2_volume:		= v_sfx_psg2_track+9	; PSG channel 2 volume attenuation
v_sfx_psg2_amsfmspan:		= v_sfx_psg2_track+$A
v_sfx_psg2_tone:		= v_sfx_psg2_track+$B
v_sfx_psg2_flutter_index:	= v_sfx_psg2_track+$C
v_sfx_psg2_stack_ptr:		= v_sfx_psg2_track+$D
v_sfx_psg2_note_timeout:	= v_sfx_psg2_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_sfx_psg2_note_duration:	= v_sfx_psg2_track+$F
v_sfx_psg2_curr_note:		= v_sfx_psg2_track+$10
v_sfx_psg2_note_fill:		= v_sfx_psg2_track+$12
v_sfx_psg2_note_fill_master:	= v_sfx_psg2_track+$13
v_sfx_psg2_modulation_ptr:	= v_sfx_psg2_track+$14	; 4 bytes
v_sfx_psg2_modulation_wait:	= v_sfx_psg2_track+$18
v_sfx_psg2_modulation_speed:	= v_sfx_psg2_track+$19
v_sfx_psg2_modulation_delta:	= v_sfx_psg2_track+$1A
v_sfx_psg2_modulation_steps:	= v_sfx_psg2_track+$1B
v_sfx_psg2_modulation_freq:	= v_sfx_psg2_track+$1C	; 2 bytes
v_sfx_psg2_freq_adjust:		= v_sfx_psg2_track+$1E
v_sfx_psg2_noise:		= v_sfx_psg2_track+$1F
v_sfx_psg2_loop_index:		= v_sfx_psg2_track+$24	; Several bytes, may overlap with gosub/return stack

v_sfx_psg3_track:	= v_sfx_track_ram+zTrackSz*5
v_sfx_psg3_playback_control:	= v_sfx_psg3_track+0	; Playback control bits for sfx PSG3
v_sfx_psg3_voice_control:	= v_sfx_psg3_track+1	; Voice control bits
v_sfx_psg3_tempo_time:		= v_sfx_psg3_track+2	; sfx - tempo dividing timing
v_sfx_psg3_ptr:			= v_sfx_psg3_track+4	; PSG channel 3 pointer (4 bytes)
v_sfx_psg3_key:			= v_sfx_psg3_track+8	; PSG channel 3 key displacement
v_sfx_psg3_volume:		= v_sfx_psg3_track+9	; PSG channel 3 volume attenuation
v_sfx_psg3_amsfmspan:		= v_sfx_psg3_track+$A
v_sfx_psg3_tone:		= v_sfx_psg3_track+$B
v_sfx_psg3_flutter_index:	= v_sfx_psg3_track+$C
v_sfx_psg3_stack_ptr:		= v_sfx_psg3_track+$D
v_sfx_psg3_note_timeout:	= v_sfx_psg3_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_sfx_psg3_note_duration:	= v_sfx_psg3_track+$F
v_sfx_psg3_curr_note:		= v_sfx_psg3_track+$10
v_sfx_psg3_note_fill:		= v_sfx_psg3_track+$12
v_sfx_psg3_note_fill_master:	= v_sfx_psg3_track+$13
v_sfx_psg3_modulation_ptr:	= v_sfx_psg3_track+$14	; 4 bytes
v_sfx_psg3_modulation_wait:	= v_sfx_psg3_track+$18
v_sfx_psg3_modulation_speed:	= v_sfx_psg3_track+$19
v_sfx_psg3_modulation_delta:	= v_sfx_psg3_track+$1A
v_sfx_psg3_modulation_steps:	= v_sfx_psg3_track+$1B
v_sfx_psg3_modulation_freq:	= v_sfx_psg3_track+$1C	; 2 bytes
v_sfx_psg3_freq_adjust:		= v_sfx_psg3_track+$1E
v_sfx_psg3_noise:		= v_sfx_psg3_track+$1F
v_sfx_psg3_loop_index:		= v_sfx_psg3_track+$24	; Several bytes, may overlap with gosub/return stack

v_sfx2_track_ram:	= v_sfx_track_ram+zTrackSz*6	; Start of special sfx RAM, straight after the end of sfx RAM

v_sfx2_fm4_track:	= v_sfx2_track_ram+zTrackSz*0
v_sfx2_fm4_playback_control:	= v_sfx2_fm4_track+0	; Playback control bits for sfx FM4
v_sfx2_fm4_voice_control:	= v_sfx2_fm4_track+1	; Voice control bits
v_sfx2_fm4_tempo_time:		= v_sfx2_fm4_track+2	; sfx - tempo dividing timing
v_sfx2_fm4_ptr:			= v_sfx2_fm4_track+4	; FM channel 4 pointer (4 bytes)
v_sfx2_fm4_key:			= v_sfx2_fm4_track+8	; FM channel 4 key displacement
v_sfx2_fm4_volume:		= v_sfx2_fm4_track+9	; FM channel 4 volume attenuation
v_sfx2_fm4_amsfmspan:		= v_sfx2_fm4_track+$A
v_sfx2_fm4_voice:		= v_sfx2_fm4_track+$B
v_sfx2_fm4_stack_ptr:		= v_sfx2_fm4_track+$D
v_sfx2_fm4_note_timeout:	= v_sfx2_fm4_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_sfx2_fm4_note_duration:	= v_sfx2_fm4_track+$F
v_sfx2_fm4_curr_note:		= v_sfx2_fm4_track+$10
v_sfx2_fm4_note_fill:		= v_sfx2_fm4_track+$12
v_sfx2_fm4_note_fill_master:	= v_sfx2_fm4_track+$13
v_sfx2_fm4_modulation_ptr:	= v_sfx2_fm4_track+$14	; 4 bytes
v_sfx2_fm4_modulation_wait:	= v_sfx2_fm4_track+$18
v_sfx2_fm4_modulation_speed:	= v_sfx2_fm4_track+$19
v_sfx2_fm4_modulation_delta:	= v_sfx2_fm4_track+$1A
v_sfx2_fm4_modulation_steps:	= v_sfx2_fm4_track+$1B
v_sfx2_fm4_modulation_freq:	= v_sfx2_fm4_track+$1C	; 2 bytes
v_sfx2_fm4_freq_adjust:		= v_sfx2_fm4_track+$1E
v_sfx2_fm4_feedbackalgo:	= v_sfx2_fm4_track+$1F
v_sfx2_fm4_voice_ptr:		= v_sfx2_fm4_track+$20
v_sfx2_fm4_loop_index:		= v_sfx2_fm4_track+$24	; Several bytes, may overlap with gosub/return stack

v_sfx2_psg3_track:	= v_sfx2_track_ram+zTrackSz*1
v_sfx2_psg3_playback_control:	= v_sfx2_psg3_track+0	; Playback control bits for sfx PSG3
v_sfx2_psg3_voice_control:	= v_sfx2_psg3_track+1	; Voice control bits
v_sfx2_psg3_tempo_time:		= v_sfx2_psg3_track+2	; sfx - tempo dividing timing
v_sfx2_psg3_ptr:		= v_sfx2_psg3_track+4	; PSG channel 3 pointer (4 bytes)
v_sfx2_psg3_key:		= v_sfx2_psg3_track+8	; PSG channel 3 key displacement
v_sfx2_psg3_volume:		= v_sfx2_psg3_track+9	; PSG channel 3 volume attenuation
v_sfx2_psg3_amsfmspan:		= v_sfx2_psg3_track+$A
v_sfx2_psg3_tone:		= v_sfx2_psg3_track+$B
v_sfx2_psg3_flutter_index:	= v_sfx2_psg3_track+$C
v_sfx2_psg3_stack_ptr:		= v_sfx2_psg3_track+$D
v_sfx2_psg3_note_timeout:	= v_sfx2_psg3_track+$E	; byte ; Counts down to zero; when zero, a new note is needed
v_sfx2_psg3_note_duration:	= v_sfx2_psg3_track+$F
v_sfx2_psg3_curr_note:		= v_sfx2_psg3_track+$10
v_sfx2_psg3_note_fill:		= v_sfx2_psg3_track+$12
v_sfx2_psg3_note_fill_master:	= v_sfx2_psg3_track+$13
v_sfx2_psg3_modulation_ptr:	= v_sfx2_psg3_track+$14	; 4 bytes
v_sfx2_psg3_modulation_wait:	= v_sfx2_psg3_track+$18
v_sfx2_psg3_modulation_speed:	= v_sfx2_psg3_track+$19
v_sfx2_psg3_modulation_delta:	= v_sfx2_psg3_track+$1A
v_sfx2_psg3_modulation_steps:	= v_sfx2_psg3_track+$1B
v_sfx2_psg3_modulation_freq:	= v_sfx2_psg3_track+$1C	; 2 bytes
v_sfx2_psg3_freq_adjust:	= v_sfx2_psg3_track+$1E
v_sfx2_psg3_noise:		= v_sfx2_psg3_track+$1F
v_sfx2_psg3_loop_index:		= v_sfx2_psg3_track+$24	; Several bytes, may overlap with gosub/return stack

v_1up_ram_copy:	= $3A0

; =================================================================================
; From here on, no longer relative to sound driver RAM
; =================================================================================

v_gamemode:	= $FFFFF600	; game mode (00=Sega; 04=Title; 08=Demo; 0C=Level; 10=SS; 14=Cont; 18=End; 1C=Credit; +8C=PreLevel)
v_jpadhold2:	= $FFFFF602	; joypad input - held, duplicate
v_jpadpress2:	= $FFFFF603	; joypad input - pressed, duplicate
v_jpadhold1:	= $FFFFF604	; joypad input - held
v_jpadpress1:	= $FFFFF605	; joypad input - pressed

v_vdp_buffer1:	= $FFFFF60C	; VDP instruction buffer (2 bytes)

v_demolength:	= $FFFFF614	; the length of a demo in frames (2 bytes)
v_scrposy_dup:	= $FFFFF616	; screen position y (duplicate) (2 bytes)

v_scrposx_dup:	= $FFFFF61A	; screen position x (duplicate) (2 bytes)

v_hbla_hreg:	= $FFFFF624	; VDP H.interrupt register buffer (8Axx) (2 bytes)
v_hbla_line:	= $FFFFF625	; screen line where water starts and palette is changed by HBlank
v_pfade_start:	= $FFFFF626	; palette fading - start position in bytes
v_pfade_size:	= $FFFFF627	; palette fading - number of colours
v_vbla_routine:	= $FFFFF62A	; VBlank - routine counter
v_spritecount:	= $FFFFF62C	; number of sprites on-screen
v_pcyc_num:	= $FFFFF632	; palette cycling - current reference number (2 bytes)
v_pcyc_time:	= $FFFFF634	; palette cycling - time until the next change (2 bytes)
v_random:	= $FFFFF636	; pseudo random number buffer (4 bytes)
f_pause:	= $FFFFF63A	; flag set to pause the game (2 bytes)
v_vdp_buffer2:	= $FFFFF640	; VDP instruction buffer (2 bytes)
f_hbla_pal:	= $FFFFF644	; flag set to change palette during HBlank (0000 = no; 0001 = change) (2 bytes)
v_waterpos1:	= $FFFFF646	; water height, actual (2 bytes)
v_waterpos2:	= $FFFFF648	; water height, ignoring sway (2 bytes)
v_waterpos3:	= $FFFFF64A	; water height, next target (2 bytes)
f_water:	= $FFFFF64C	; flag set for water
v_wtr_routine:	= $FFFFF64D	; water event - routine counter
f_wtr_state:	= $FFFFF64E	; water palette state when water is above/below the screen (00 = partly/all dry; 01 = all underwater)

v_pal_buffer:	= $FFFFF650	; palette data buffer (used for palette cycling) ($30 bytes)
v_plc_buffer:	= $FFFFF680	; pattern load cues buffer (maximum $10 PLCs) ($60 bytes)
v_ptrnemcode:	= $FFFFF6E0	; pointer for nemesis decompression code ($1502 or $150C) (4 bytes)

f_plc_execute:	= $FFFFF6F8	; flag set for pattern load cue execution (2 bytes)

v_screenposx:	= $FFFFF700	; screen position x (2 bytes)

v_screenposy:	= $FFFFF704	; screen position y (2 bytes)

v_limitleft1:	= $FFFFF720	; left level boundary (2 bytes)
v_limitright1:	= $FFFFF722	; right level boundary (2 bytes)
v_limittop1:	= $FFFFF724	; top level boundary (2 bytes)
v_limitbtm1:	= $FFFFF726	; bottom level boundary (2 bytes)
v_limitleft2:	= $FFFFF728	; left level boundary (2 bytes)
v_limitright2:	= $FFFFF72A	; right level boundary (2 bytes)
v_limittop2:	= $FFFFF72C	; top level boundary (2 bytes)
v_limitbtm2:	= $FFFFF72E	; bottom level boundary (2 bytes)

v_limitleft3:	= $FFFFF732	; left level boundary, at the end of an act (2 bytes)

v_scrshiftx:	= $FFFFF73A	; screen shift as Sonic moves horizontally

v_lookshift:	= $FFFFF73E	; screen shift when Sonic looks up/down (2 bytes)
v_dle_routine:	= $FFFFF742	; dynamic level event - routine counter
f_nobgscroll:	= $FFFFF744	; flag set to cancel background scrolling

v_bgscroll1:	= $FFFFF754	; background scrolling variable 1
v_bgscroll2:	= $FFFFF756	; background scrolling variable 2
v_bgscroll3:	= $FFFFF758	; background scrolling variable 3
f_bgscrollvert:	= $FFFFF75C	; flag for vertical background scrolling
v_sonspeedmax:	= $FFFFF760	; Sonic's maximum speed (2 bytes)
v_sonspeedacc:	= $FFFFF762	; Sonic's acceleration (2 bytes)
v_sonspeeddec:	= $FFFFF764	; Sonic's deceleration (2 bytes)
v_sonframenum:	= $FFFFF766	; frame to display for Sonic
f_sonframechg:	= $FFFFF767	; flag set to update Sonic's sprite frame
v_anglebuffer:	= $FFFFF768	; angle of collision block that Sonic or object is standing on

v_opl_routine:	= $FFFFF76C	; ObjPosLoad - routine counter
v_opl_screen:	= $FFFFF76E	; ObjPosLoad - screen variable
v_opl_data:	= $FFFFF770	; ObjPosLoad - data buffer ($10 bytes)

v_ssangle:	= $FFFFF780	; Special Stage angle (2 bytes)
v_ssrotate:	= $FFFFF782	; Special Stage rotation speed (2 bytes)
v_btnpushtime1:	= $FFFFF790	; button push duration - in level (2 bytes)
v_btnpushtime2:	= $FFFFF792	; button push duration - in demo (2 bytes)
v_palchgspeed:	= $FFFFF794	; palette fade/transition speed (0 is fastest) (2 bytes)
v_collindex:	= $FFFFF796	; ROM address for collision index of current level (4 bytes)
v_palss_num:	= $FFFFF79A	; palette cycling in Special Stage - reference number (2 bytes)
v_palss_time:	= $FFFFF79C	; palette cycling in Special Stage - time until next change (2 bytes)

v_obj31ypos:	= $FFFFF7A4	; y-position of object 31 (MZ stomper) (2 bytes)
v_bossstatus:	= $FFFFF7A7	; status of boss and prison capsule (01 = boss defeated; 02 = prison opened)
v_trackpos:	= $FFFFF7A8	; position tracking reference number (2 bytes)
v_trackbyte:	= $FFFFF7A9	; low byte for position tracking
f_lockscreen:	= $FFFFF7AA	; flag set to lock screen during bosses
v_lani0_frame:	= $FFFFF7B0	; level graphics animation 0 - current frame
v_lani0_time:	= $FFFFF7B1	; level graphics animation 0 - time until next frame
v_lani1_frame:	= $FFFFF7B2	; level graphics animation 1 - current frame
v_lani1_time:	= $FFFFF7B3	; level graphics animation 1 - time until next frame
v_lani2_frame:	= $FFFFF7B4	; level graphics animation 2 - current frame
v_lani2_time:	= $FFFFF7B5	; level graphics animation 2 - time until next frame
v_lani3_frame:	= $FFFFF7B6	; level graphics animation 3 - current frame
v_lani3_time:	= $FFFFF7B7	; level graphics animation 3 - time until next frame
v_lani4_frame:	= $FFFFF7B8	; level graphics animation 4 - current frame
v_lani4_time:	= $FFFFF7B9	; level graphics animation 4 - time until next frame
v_lani5_frame:	= $FFFFF7BA	; level graphics animation 5 - current frame
v_lani5_time:	= $FFFFF7BB	; level graphics animation 5 - time until next frame
v_gfxbigring:	= $FFFFF7BE	; settings for giant ring graphics loading (2 bytes)
f_conveyrev:	= $FFFFF7C0	; flag set to reverse conveyor belts in LZ/SBZ
v_obj63:	= $FFFFF7C1	; object 63 (LZ/SBZ platforms) variables (6 bytes)
f_wtunnelmode:	= $FFFFF7C7	; LZ water tunnel mode
f_lockmulti:	= $FFFFF7C8	; flag set to lock controls, lock Sonic's position & animation
f_wtunnelallow:	= $FFFFF7C9	; LZ water tunnels (00 = enabled; 01 = disabled)
f_jumponly:	= $FFFFF7CA	; flag set to lock controls apart from jumping
v_obj6B:	= $FFFFF7CB	; object 6B (SBZ stomper) variable
f_lockctrl:	= $FFFFF7CC	; flag set to lock controls during ending sequence
f_bigring:	= $FFFFF7CD	; flag set when Sonic collects the giant ring
v_itembonus:	= $FFFFF7D0	; item bonus from broken enemies, blocks etc. (2 bytes)
v_timebonus:	= $FFFFF7D2	; time bonus at the end of an act (2 bytes)
v_ringbonus:	= $FFFFF7D4	; ring bonus at the end of an act (2 bytes)
f_endactbonus:	= $FFFFF7D6	; time/ring bonus update flag at the end of an act
v_sonicend:	= $FFFFF7D7	; routine counter for Sonic in the ending sequence
f_switch:	= $FFFFF7E0	; flags set when Sonic stands on a switch ($10 bytes)

v_spritetablebuffer:	= $FFFFF800 ; sprite table ($200 bytes)
v_pal_water_dup:	= $FFFFFA00 ; duplicate underwater palette, used for transitions ($80 bytes)
v_pal_water:	= $FFFFFA80	; main underwater palette ($80 bytes)
v_pal_dry:	= $FFFFFB00	; main palette ($80 bytes)
v_pal_dry_dup:	= $FFFFFB80	; duplicate palette, used for transitions ($80 bytes)
v_objstate:	= $FFFFFC00	; object state list ($200 bytes)
f_restart:	= $FFFFFE02	; restart level flag (2 bytes)
v_framecount:	= $FFFFFE04	; frame counter (adds 1 every frame) (2 bytes)
v_framebyte:	= v_framecount+1; low byte for frame counter
v_debugitem:	= $FFFFFE06	; debug item currently selected (NOT the object number of the item)
v_debuguse:	= $FFFFFE08	; debug mode use & routine counter (when Sonic is a ring/item) (2 bytes)
v_debugxspeed:	= $FFFFFE0A	; debug mode - horizontal speed
v_debugyspeed:	= $FFFFFE0B	; debug mode - vertical speed
v_vbla_count:	= $FFFFFE0C	; vertical interrupt counter (adds 1 every VBlank) (4 bytes)
v_vbla_word:	= v_vbla_count+2 ; low word for vertical interrupt counter (2 bytes)
v_vbla_byte:	= v_vbla_word+1	; low byte for vertical interrupt counter
v_zone:		= $FFFFFE10	; current zone number
v_act:		= $FFFFFE11	; current act number
v_lives:	= $FFFFFE12	; number of lives
v_air:		= $FFFFFE14	; air remaining while underwater (2 bytes)
v_airbyte:	= v_air+1	; low byte for air
v_lastspecial:	= $FFFFFE16	; last special stage number
v_continues:	= $FFFFFE18	; number of continues
f_timeover:	= $FFFFFE1A	; time over flag
v_lifecount:	= $FFFFFE1B	; lives counter value (for actual number, see "v_lives")
f_lifecount:	= $FFFFFE1C	; lives counter update flag
f_ringcount:	= $FFFFFE1D	; ring counter update flag
f_timecount:	= $FFFFFE1E	; time counter update flag
f_scorecount:	= $FFFFFE1F	; score counter update flag
v_rings:	= $FFFFFE20	; rings (2 bytes)
v_ringbyte:	= v_rings+1	; low byte for rings
v_time:		= $FFFFFE22	; time (4 bytes)
v_timemin:	= $FFFFFE23	; time - minutes
v_timesec:	= $FFFFFE24	; time - seconds
v_timecent:	= $FFFFFE25	; time - centiseconds
v_score:	= $FFFFFE26	; score (4 bytes)
v_shield:	= $FFFFFE2C	; shield status (00 = no; 01 = yes)
v_invinc:	= $FFFFFE2D	; invinciblity status (00 = no; 01 = yes)
v_shoes:	= $FFFFFE2E	; speed shoes status (00 = no; 01 = yes)
v_lastlamp:	= $FFFFFE30	; number of the last lamppost you hit
v_lamp_xpos:	= v_lastlamp+2	; x-axis for Sonic to respawn at lamppost (2 bytes)
v_lamp_ypos:	= v_lastlamp+4	; y-axis for Sonic to respawn at lamppost (2 bytes)
v_lamp_rings:	= v_lastlamp+6	; rings stored at lamppost (2 bytes)
v_lamp_time:	= v_lastlamp+8	; time stored at lamppost (2 bytes)
v_lamp_dle:	= v_lastlamp+$C	; dynamic level event routine counter at lamppost
v_lamp_limitbtm:= v_lastlamp+$E	; level bottom boundary at lamppost (2 bytes)
v_lamp_scrx:	= v_lastlamp+$10 ; x-axis screen at lamppost (2 bytes)
v_lamp_scry:	= v_lastlamp+$12 ; y-axis screen at lamppost (2 bytes)

v_lamp_wtrpos:	= v_lastlamp+$20 ; water position at lamppost (2 bytes)
v_lamp_wtrrout:	= v_lastlamp+$22 ; water routine at lamppost
v_lamp_wtrstat:	= v_lastlamp+$23 ; water state at lamppost
v_lamp_lives:	= v_lastlamp+$24 ; lives counter at lamppost
v_emeralds:	= $FFFFFE57	; number of chaos emeralds
v_emldlist:	= $FFFFFE58	; which individual emeralds you have (00 = no; 01 = yes) (6 bytes)
v_oscillate:	= $FFFFFE5E	; values which oscillate - for swinging platforms, et al ($42 bytes)
v_ani0_time:	= $FFFFFEC0	; synchronised sprite animation 0 - time until next frame (used for synchronised animations)
v_ani0_frame:	= $FFFFFEC1	; synchronised sprite animation 0 - current frame
v_ani1_time:	= $FFFFFEC2	; synchronised sprite animation 1 - time until next frame
v_ani1_frame:	= $FFFFFEC3	; synchronised sprite animation 1 - current frame
v_ani2_time:	= $FFFFFEC4	; synchronised sprite animation 2 - time until next frame
v_ani2_frame:	= $FFFFFEC5	; synchronised sprite animation 2 - current frame
v_ani3_time:	= $FFFFFEC6	; synchronised sprite animation 3 - time until next frame
v_ani3_frame:	= $FFFFFEC7	; synchronised sprite animation 3 - current frame
v_ani3_buf:	= $FFFFFEC8	; synchronised sprite animation 3 - info buffer (2 bytes)
v_limittopdb:	= $FFFFFEF0	; level upper boundary, buffered for debug mode (2 bytes)
v_limitbtmdb:	= $FFFFFEF2	; level bottom boundary, buffered for debug mode (2 bytes)

v_levseldelay:	= $FFFFFF80	; level select - time until change when up/down is held (2 bytes)
v_levselitem:	= $FFFFFF82	; level select - item selected (2 bytes)
v_levselsound:	= $FFFFFF84	; level select - sound selected (2 bytes)
v_scorecopy:	= $FFFFFFC0	; score, duplicate (4 bytes)
v_scorelife:	= $FFFFFFC0	; points required for an extra life (4 bytes) (JP1 only)
v_colladdr1:	= $FFFFFFD0	; (4 bytes)
v_colladdr2:	= $FFFFFFD4	; (4 bytes)
v_top_solid_bit:	= $FFFFFFD8
v_lrb_solid_bit:	= $FFFFFFD9
f_levselcheat:	= $FFFFFFE0	; level select cheat flag
f_slomocheat:	= $FFFFFFE1	; slow motion & frame advance cheat flag
f_debugcheat:	= $FFFFFFE2	; debug mode cheat flag
f_creditscheat:	= $FFFFFFE3	; hidden credits & press start cheat flag
v_title_dcount:	= $FFFFFFE4	; number of times the d-pad is pressed on title screen (2 bytes)
v_title_ccount:	= $FFFFFFE6	; number of times C is pressed on title screen (2 bytes)

f_demo:		= $FFFFFFF0	; demo mode flag (0 = no; 1 = yes; $8001 = ending) (2 bytes)
v_demonum:	= $FFFFFFF2	; demo level number (not the same as the level number) (2 bytes)
v_creditsnum:	= $FFFFFFF4	; credits index number (2 bytes)
v_megadrive:	= $FFFFFFF8	; Megadrive machine type
f_debugmode:	= $FFFFFFFA	; debug mode flag (sometimes 2 bytes)
v_init:		= $FFFFFFFC	; 'init' text string (4 bytes)
