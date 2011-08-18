; Variables (v) and Flags (f)

v_regbuffer:	= $FFFFFC00	; stores registers d0-a7 during an error event ($40 bytes)
v_spbuffer:	= $FFFFFC40	; stores most recent sp address (4 bytes)
v_errortype:	= $FFFFFC44	; error type

v_256x256:	=   $FF0000	; 256x256 tile mappings ($A400 bytes)
v_lvllayout:	= $FFFFA400	; level and background layouts ($400 bytes)

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
v_sndprio:	= $000	; sound priority (priority of new music/SFX must be higher or equal to this value or it won't play; bit 7 of priority being set prevents this value from changing)
v_main_tempo_timeout:	= $001	; Counts down to zero; when zero, resets to next value and delays song by 1 frame
v_main_tempo:	= $002	; Used for music only
f_stopmusic:	= $003	; flag set to stop music when paused
v_fadeout_counter:	= $004

v_fadeout_delay:	= $006

f_updating_dac:	= $008	; $80 if updating DAC, $00 otherwise
v_playsnd0:	= $009	; sound or music copied from below
v_playsnd1:	= $00A	; sound or music to play
v_playsnd2:	= $00B	; special sound to play
v_playnull:	= $00C	; unused sound to play

f_voice_selector:	= $00E	; $00 = use music voice pointer; $40 = use special voice pointer; $80 = use track voice pointer

v_voice_ptr:	= $018	; voice data pointer (4 bytes)

v_special_voice_ptr:	= $020	; voice data pointer for special SFX ($D0-$DF) (4 bytes)

f_fadein_flag:	= $024	; Flag for fade in
v_fadein_delay:	= $025
v_fadein_counter:	= $026	; Timer for fade in/out
f_1up_playing:	= $027	; flag indicating 1-up song is playing
v_tempo_mod:	= $028	; music - tempo modifier
v_speeduptempo:	= $029	; music - tempo modifier with speed shoes
f_speedup:	= $02A	; flag indicating whether speed shoes tempo is on ($80) or off ($00)
v_ring_speaker:	= $02B	; which speaker the "ring" sound is played in (00 = right; 01 = left)
f_push_playing:	= $02C	; if set, prevents further push sounds from playing

v_track_ram:	= $040	; Start of music RAM

v_dac_track:	= $040
v_dac_playback_control:	= $040	; Playback control bits for DAC channel
v_dac_voice_control:	= $041	; Voice control bits for DAC channel
v_dac_tempo_time:	= $042	; music - tempo dividing timing
v_dac_ptr:	= $044	; DAC channel pointer (4 bytes)
v_dac_amsfmspan:	= $04A
v_dac_stack_ptr:	= $04D
v_dac_note_timeout:	= $04E	; Counts down to zero; when zero, a new DAC sample is needed
v_dac_note_duration:	= $04F
v_dac_curr_sample:	= $050
v_dac_loop_index:	= $064	; Several bytes, may overlap with gosub/return stack

; Note: using the channel assignment bits to determine FM channel #. Thus, there is no FM 3.

v_fm1_track:	= $070
v_fm1_playback_control:	= $070	; Playback control bits for FM1
v_fm1_voice_control:	= $071	; Voice control bits
v_fm1_tempo_time:	= $072	; music - tempo dividing timing
v_fm1_ptr:	= $074	; FM channel 0 pointer (4 bytes)
v_fm1_key:	= $078	; FM channel 0 key displacement
v_fm1_volume:	= $079	; FM channel 0 volume attenuation
v_fm1_amsfmspan:	= $07A
v_fm1_voice:	= $07B
v_fm1_stack_ptr:	= $07D
v_fm1_note_timeout:	= $07E	; Counts down to zero; when zero, a new note is needed
v_fm1_note_duration:	= $07F
v_fm1_curr_note:	= $080
v_fm1_note_fill:	= $082
v_fm1_note_fill_master:	= $083
v_fm1_modulation_ptr:	= $084	; 4 bytes
v_fm1_modulation_wait:	= $088
v_fm1_modulation_speed:	= $089
v_fm1_modulation_delta:	= $08A
v_fm1_modulation_steps:	= $08B
v_fm1_modulation_freq:	= $08C	; 2 bytes
v_fm1_freq_adjust:	= $08E
v_fm1_feedbackalgo:	= $08F
v_fm1_loop_index:	= $094	; Several bytes, may overlap with gosub/return stack

v_fm2_track:	= $0A0
v_fm2_playback_control:	= $0A0	; Playback control bits for FM2
v_fm2_voice_control:	= $0A1	; Voice control bits
v_fm2_tempo_time:	= $0A2	; music - tempo dividing timing
v_fm2_ptr:	= $0A4	; FM channel 1 pointer (4 bytes)
v_fm2_key:	= $0A8	; FM channel 1 key displacement
v_fm2_volume:	= $0A9	; FM channel 1 volume attenuation
v_fm2_amsfmspan:	= $0AA
v_fm2_voice:	= $0AB
v_fm2_stack_ptr:	= $0AD
v_fm2_note_timeout:	= $0AE	; Counts down to zero; when zero, a new note is needed
v_fm2_note_duration:	= $0AF
v_fm2_curr_note:	= $0B0
v_fm2_note_fill:	= $0B2
v_fm2_note_fill_master:	= $0B3
v_fm2_modulation_ptr:	= $0B4	; 4 bytes
v_fm2_modulation_wait:	= $0B8
v_fm2_modulation_speed:	= $0B9
v_fm2_modulation_delta:	= $0BA
v_fm2_modulation_steps:	= $0BB
v_fm2_modulation_freq:	= $0BC	; 2 bytes
v_fm2_freq_adjust:	= $0BE
v_fm2_feedbackalgo:	= $0BF
v_fm2_loop_index:	= $0C4	; Several bytes, may overlap with gosub/return stack

v_fm3_track:	= $0D0
v_fm3_playback_control:	= $0D0	; Playback control bits for FM3
v_fm3_voice_control:	= $0D1	; Voice control bits
v_fm3_tempo_time:	= $0D2	; music - tempo dividing timing
v_fm3_ptr:	= $0D4	; FM channel 2 pointer (4 bytes)
v_fm3_key:	= $0D8	; FM channel 2 key displacement
v_fm3_volume:	= $0D9	; FM channel 2 volume attenuation
v_fm3_amsfmspan:	= $0DA
v_fm3_voice:	= $0DB
v_fm3_stack_ptr:	= $0DD
v_fm3_note_timeout:	= $0DE	; Counts down to zero; when zero, a new note is needed
v_fm3_note_duration:	= $0DF
v_fm3_curr_note:	= $0E0
v_fm3_note_fill:	= $0E2
v_fm3_note_fill_master:	= $0E3
v_fm3_modulation_ptr:	= $0E4	; 4 bytes
v_fm3_modulation_wait:	= $0E8
v_fm3_modulation_speed:	= $0E9
v_fm3_modulation_delta:	= $0EA
v_fm3_modulation_steps:	= $0EB
v_fm3_modulation_freq:	= $0EC	; 2 bytes
v_fm3_freq_adjust:	= $0EE
v_fm3_feedbackalgo:	= $0EF
v_fm3_loop_index:	= $0F4	; Several bytes, may overlap with gosub/return stack

v_fm4_track:	= $100
v_fm4_playback_control:	= $100	; Playback control bits for FM4
v_fm4_voice_control:	= $101	; Voice control bits
v_fm4_tempo_time:	= $102	; music - tempo dividing timing
v_fm4_ptr:	= $104	; FM channel 4 pointer (4 bytes)
v_fm4_key:	= $108	; FM channel 4 key displacement
v_fm4_volume:	= $109	; FM channel 4 volume attenuation
v_fm4_amsfmspan:	= $10A
v_fm4_voice:	= $10B
v_fm4_stack_ptr:	= $10D
v_fm4_note_timeout:	= $10E	; Counts down to zero; when zero, a new note is needed
v_fm4_note_duration:	= $10F
v_fm4_curr_note:	= $110
v_fm4_note_fill:	= $112
v_fm4_note_fill_master:	= $113
v_fm4_modulation_ptr:	= $114	; 4 bytes
v_fm4_modulation_wait:	= $118
v_fm4_modulation_speed:	= $119
v_fm4_modulation_delta:	= $11A
v_fm4_modulation_steps:	= $11B
v_fm4_modulation_freq:	= $11C	; 2 bytes
v_fm4_freq_adjust:	= $11E
v_fm4_feedbackalgo:	= $11F
v_fm4_loop_index:	= $124	; Several bytes, may overlap with gosub/return stack

v_fm5_track:	= $130
v_fm5_playback_control:	= $130	; Playback control bits for FM5
v_fm5_voice_control:	= $131	; Voice control bits
v_fm5_tempo_time:	= $132	; music - tempo dividing timing
v_fm5_ptr:	= $134	; FM channel 5 pointer (4 bytes)
v_fm5_key:	= $138	; FM channel 5 key displacement
v_fm5_volume:	= $139	; FM channel 5 volume attenuation
v_fm5_amsfmspan:	= $13A
v_fm5_voice:	= $13B
v_fm5_stack_ptr:	= $13D
v_fm5_note_timeout:	= $13E	; Counts down to zero; when zero, a new note is needed
v_fm5_note_duration:	= $13F
v_fm5_curr_note:	= $140
v_fm5_note_fill:	= $142
v_fm5_note_fill_master:	= $143
v_fm5_modulation_ptr:	= $144	; 4 bytes
v_fm5_modulation_wait:	= $148
v_fm5_modulation_speed:	= $149
v_fm5_modulation_delta:	= $14A
v_fm5_modulation_steps:	= $14B
v_fm5_modulation_freq:	= $14C	; 2 bytes
v_fm5_freq_adjust:	= $14E
v_fm5_feedbackalgo:	= $14F
v_fm5_loop_index:	= $154	; Several bytes, may overlap with gosub/return stack

v_fm6_track:	= $160
v_fm6_playback_control:	= $160	; Playback control bits for FM6
v_fm6_voice_control:	= $161	; Voice control bits
v_fm6_tempo_time:	= $162	; music - tempo dividing timing
v_fm6_ptr:	= $164	; FM channel 6 pointer (4 bytes)
v_fm6_key:	= $168	; FM channel 6 key displacement
v_fm6_volume:	= $169	; FM channel 6 volume attenuation
v_fm6_amsfmspan:	= $16A
v_fm6_voice:	= $16B
v_fm6_stack_ptr:	= $16D
v_fm6_note_timeout:	= $16E	; Counts down to zero; when zero, a new note is needed
v_fm6_note_duration:	= $16F
v_fm6_curr_note:	= $170
v_fm6_note_fill:	= $172
v_fm6_note_fill_master:	= $173
v_fm6_modulation_ptr:	= $174	; 4 bytes
v_fm6_modulation_wait:	= $178
v_fm6_modulation_speed:	= $179
v_fm6_modulation_delta:	= $17A
v_fm6_modulation_steps:	= $17B
v_fm6_modulation_freq:	= $17C	; 2 bytes
v_fm6_freq_adjust:	= $17E
v_fm6_feedbackalgo:	= $17F
v_fm6_loop_index:	= $184	; Several bytes, may overlap with gosub/return stack

v_psg1_track:	= $190
v_psg1_playback_control:	= $190	; Playback control bits for PSG1
v_psg1_voice_control:	= $191	; Voice control bits
v_psg1_tempo_time:	= $192	; music - tempo dividing timing
v_psg1_ptr:	= $194	; PSG channel 1 pointer (4 bytes)
v_psg1_key:	= $198	; PSG channel 1 key displacement
v_psg1_volume:	= $199	; PSG channel 1 volume attenuation
v_psg1_amsfmspan:	= $19A
v_psg1_tone:	= $19B
v_psg1_flutter_index:	= $19C
v_psg1_stack_ptr:	= $19D
v_psg1_note_timeout:	= $19E	; Counts down to zero; when zero, a new note is needed
v_psg1_note_duration:	= $19F
v_psg1_curr_note:	= $1A0
v_psg1_note_fill:	= $1A2
v_psg1_note_fill_master:	= $1A3
v_psg1_modulation_ptr:	= $1A4	; 4 bytes
v_psg1_modulation_wait:	= $1A8
v_psg1_modulation_speed:	= $1A9
v_psg1_modulation_delta:	= $1AA
v_psg1_modulation_steps:	= $1AB
v_psg1_modulation_freq:	= $1AC	; 2 bytes
v_psg1_freq_adjust:	= $1AE
v_psg1_noise:	= $1AF
v_psg1_loop_index:	= $1B4	; Several bytes, may overlap with gosub/return stack

v_psg2_track:	= $1C0
v_psg2_playback_control:	= $1C0	; Playback control bits for PSG2
v_psg2_voice_control:	= $1C1	; Voice control bits
v_psg2_tempo_time:	= $1C2	; music - tempo dividing timing
v_psg2_ptr:	= $1C4	; PSG channel 2 pointer (4 bytes)
v_psg2_key:	= $1C8	; PSG channel 2 key displacement
v_psg2_volume:	= $1C9	; PSG channel 2 volume attenuation
v_psg2_amsfmspan:	= $1CA
v_psg2_tone:	= $1CB
v_psg2_flutter_index:	= $1CC
v_psg2_stack_ptr:	= $1CD
v_psg2_note_timeout:	= $1CE	; Counts down to zero; when zero, a new note is needed
v_psg2_note_duration:	= $1CF
v_psg2_curr_note:	= $1D0
v_psg2_note_fill:	= $1D2
v_psg2_note_fill_master:	= $1D3
v_psg2_modulation_ptr:	= $1D4	; 4 bytes
v_psg2_modulation_wait:	= $1D8
v_psg2_modulation_speed:	= $1D9
v_psg2_modulation_delta:	= $1DA
v_psg2_modulation_steps:	= $1DB
v_psg2_modulation_freq:	= $1DC	; 2 bytes
v_psg2_freq_adjust:	= $1DE
v_psg2_noise:	= $1DF
v_psg2_loop_index:	= $1E4	; Several bytes, may overlap with gosub/return stack

v_psg3_track:	= $1F0
v_psg3_playback_control:	= $1F0	; Playback control bits for PSG3
v_psg3_voice_control:	= $1F1	; Voice control bits
v_psg3_tempo_time:	= $1F2	; music - tempo dividing timing
v_psg3_ptr:	= $1F4	; PSG channel 3 pointer (4 bytes)
v_psg3_key:	= $1F8	; PSG channel 3 key displacement
v_psg3_volume:	= $1F9	; PSG channel 3 volume attenuation
v_psg3_amsfmspan:	= $1FA
v_psg3_tone:	= $1FB
v_psg3_flutter_index:	= $1FC
v_psg3_stack_ptr:	= $1FD
v_psg3_note_timeout:	= $1FE	; Counts down to zero; when zero, a new note is needed
v_psg3_note_duration:	= $1FF
v_psg3_curr_note:	= $200
v_psg3_note_fill:	= $202
v_psg3_note_fill_master:	= $203
v_psg3_modulation_ptr:	= $204	; 4 bytes
v_psg3_modulation_wait:	= $208
v_psg3_modulation_speed:	= $209
v_psg3_modulation_delta:	= $20A
v_psg3_modulation_steps:	= $20B
v_psg3_modulation_freq:	= $20C	; 2 bytes
v_psg3_freq_adjust:	= $20E
v_psg3_noise:	= $20F
v_psg3_loop_index:	= $214	; Several bytes, may overlap with gosub/return stack

v_sfx_track_ram:	= $220	; Start of sfx RAM

v_sfx_fm3_track:	= $220
v_sfx_fm3_playback_control:	= $220	; Playback control bits for sfx FM3
v_sfx_fm3_voice_control:	= $221	; Voice control bits
v_sfx_fm3_tempo_time:	= $222	; sfx - tempo dividing timing
v_sfx_fm3_ptr:	= $224	; FM channel 2 pointer (4 bytes)
v_sfx_fm3_key:	= $228	; FM channel 2 key displacement
v_sfx_fm3_volume:	= $229	; FM channel 2 volume attenuation
v_sfx_fm3_amsfmspan:	= $22A
v_sfx_fm3_voice:	= $22B
v_sfx_fm3_stack_ptr:	= $22D
v_sfx_fm3_note_timeout:	= $22E	; Counts down to zero; when zero, a new note is needed
v_sfx_fm3_note_duration:	= $22F
v_sfx_fm3_curr_note:	= $230
v_sfx_fm3_note_fill:	= $232
v_sfx_fm3_note_fill_master:	= $233
v_sfx_fm3_modulation_ptr:	= $234	; 4 bytes
v_sfx_fm3_modulation_wait:	= $238
v_sfx_fm3_modulation_speed:	= $239
v_sfx_fm3_modulation_delta:	= $23A
v_sfx_fm3_modulation_steps:	= $23B
v_sfx_fm3_modulation_freq:	= $23C	; 2 bytes
v_sfx_fm3_freq_adjust:	= $23E
v_sfx_fm3_feedbackalgo:	= $23F
v_sfx_fm3_voice_ptr:	= $240
v_sfx_fm3_loop_index:	= $244	; Several bytes, may overlap with gosub/return stack

v_sfx_fm4_track:	= $250
v_sfx_fm4_playback_control:	= $250	; Playback control bits for sfx FM4
v_sfx_fm4_voice_control:	= $251	; Voice control bits
v_sfx_fm4_tempo_time:	= $252	; sfx - tempo dividing timing
v_sfx_fm4_ptr:	= $254	; FM channel 4 pointer (4 bytes)
v_sfx_fm4_key:	= $258	; FM channel 4 key displacement
v_sfx_fm4_volume:	= $259	; FM channel 4 volume attenuation
v_sfx_fm4_amsfmspan:	= $25A
v_sfx_fm4_voice:	= $25B
v_sfx_fm4_stack_ptr:	= $25D
v_sfx_fm4_note_timeout:	= $25E	; Counts down to zero; when zero, a new note is needed
v_sfx_fm4_note_duration:	= $25F
v_sfx_fm4_curr_note:	= $260
v_sfx_fm4_note_fill:	= $262
v_sfx_fm4_note_fill_master:	= $263
v_sfx_fm4_modulation_ptr:	= $264	; 4 bytes
v_sfx_fm4_modulation_wait:	= $268
v_sfx_fm4_modulation_speed:	= $269
v_sfx_fm4_modulation_delta:	= $26A
v_sfx_fm4_modulation_steps:	= $26B
v_sfx_fm4_modulation_freq:	= $26C	; 2 bytes
v_sfx_fm4_freq_adjust:	= $26E
v_sfx_fm4_feedbackalgo:	= $26F
v_sfx_fm4_voice_ptr:	= $270
v_sfx_fm4_loop_index:	= $274	; Several bytes, may overlap with gosub/return stack

v_sfx_fm5_track:	= $280
v_sfx_fm5_playback_control:	= $280	; Playback control bits for sfx FM5
v_sfx_fm5_voice_control:	= $281	; Voice control bits
v_sfx_fm5_tempo_time:	= $282	; sfx - tempo dividing timing
v_sfx_fm5_ptr:	= $284	; FM channel 5 pointer (4 bytes)
v_sfx_fm5_key:	= $288	; FM channel 5 key displacement
v_sfx_fm5_volume:	= $289	; FM channel 5 volume attenuation
v_sfx_fm5_amsfmspan:	= $28A
v_sfx_fm5_voice:	= $28B
v_sfx_fm5_stack_ptr:	= $28D
v_sfx_fm5_note_timeout:	= $28E	; Counts down to zero; when zero, a new note is needed
v_sfx_fm5_note_duration:	= $28F
v_sfx_fm5_curr_note:	= $290
v_sfx_fm5_note_fill:	= $292
v_sfx_fm5_note_fill_master:	= $293
v_sfx_fm5_modulation_ptr:	= $294	; 4 bytes
v_sfx_fm5_modulation_wait:	= $298
v_sfx_fm5_modulation_speed:	= $299
v_sfx_fm5_modulation_delta:	= $29A
v_sfx_fm5_modulation_steps:	= $29B
v_sfx_fm5_modulation_freq:	= $29C	; 2 bytes
v_sfx_fm5_freq_adjust:	= $29E
v_sfx_fm5_feedbackalgo:	= $29F
v_sfx_fm5_voice_ptr:	= $2A0
v_sfx_fm5_loop_index:	= $2A4	; Several bytes, may overlap with gosub/return stack

v_sfx_psg1_track:	= $2B0
v_sfx_psg1_playback_control:	= $2B0	; Playback control bits for sfx PSG1
v_sfx_psg1_voice_control:	= $2B1	; Voice control bits
v_sfx_psg1_tempo_time:	= $2B2	; sfx - tempo dividing timing
v_sfx_psg1_ptr:	= $2B4	; PSG channel 1 pointer (4 bytes)
v_sfx_psg1_key:	= $2B8	; PSG channel 1 key displacement
v_sfx_psg1_volume:	= $2B9	; PSG channel 1 volume attenuation
v_sfx_psg1_amsfmspan:	= $2BA
v_sfx_psg1_tone:	= $2BB
v_sfx_psg1_flutter_index:	= $2BC
v_sfx_psg1_stack_ptr:	= $2BD
v_sfx_psg1_note_timeout:	= $2BE	; Counts down to zero; when zero, a new note is needed
v_sfx_psg1_note_duration:	= $2BF
v_sfx_psg1_curr_note:	= $2C0
v_sfx_psg1_note_fill:	= $2C2
v_sfx_psg1_note_fill_master:	= $2C3
v_sfx_psg1_modulation_ptr:	= $2C4	; 4 bytes
v_sfx_psg1_modulation_wait:	= $2C8
v_sfx_psg1_modulation_speed:	= $2C9
v_sfx_psg1_modulation_delta:	= $2CA
v_sfx_psg1_modulation_steps:	= $2CB
v_sfx_psg1_modulation_freq:	= $2CC	; 2 bytes
v_sfx_psg1_freq_adjust:	= $2CE
v_sfx_psg1_noise:	= $2CF
v_sfx_psg1_loop_index:	= $2D4	; Several bytes, may overlap with gosub/return stack

v_sfx_psg2_track:	= $2E0
v_sfx_psg2_playback_control:	= $2E0	; Playback control bits for sfx PSG2
v_sfx_psg2_voice_control:	= $2E1	; Voice control bits
v_sfx_psg2_tempo_time:	= $2E2	; sfx - tempo dividing timing
v_sfx_psg2_ptr:	= $2E4	; PSG channel 2 pointer (4 bytes)
v_sfx_psg2_key:	= $2E8	; PSG channel 2 key displacement
v_sfx_psg2_volume:	= $2E9	; PSG channel 2 volume attenuation
v_sfx_psg2_amsfmspan:	= $2EA
v_sfx_psg2_tone:	= $2EB
v_sfx_psg2_flutter_index:	= $2EC
v_sfx_psg2_stack_ptr:	= $2ED
v_sfx_psg2_note_timeout:	= $2EE	; Counts down to zero; when zero, a new note is needed
v_sfx_psg2_note_duration:	= $2EF
v_sfx_psg2_curr_note:	= $2F0
v_sfx_psg2_note_fill:	= $2F2
v_sfx_psg2_note_fill_master:	= $2F3
v_sfx_psg2_modulation_ptr:	= $2F4	; 4 bytes
v_sfx_psg2_modulation_wait:	= $2F8
v_sfx_psg2_modulation_speed:	= $2F9
v_sfx_psg2_modulation_delta:	= $2FA
v_sfx_psg2_modulation_steps:	= $2FB
v_sfx_psg2_modulation_freq:	= $2FC	; 2 bytes
v_sfx_psg2_freq_adjust:	= $2FE
v_sfx_psg2_noise:	= $2FF
v_sfx_psg2_loop_index:	= $304	; Several bytes, may overlap with gosub/return stack

v_sfx_psg3_track:	= $310
v_sfx_psg3_playback_control:	= $310	; Playback control bits for sfx PSG3
v_sfx_psg3_voice_control:	= $311	; Voice control bits
v_sfx_psg3_tempo_time:	= $312	; sfx - tempo dividing timing
v_sfx_psg3_ptr:	= $314	; PSG channel 3 pointer (4 bytes)
v_sfx_psg3_key:	= $318	; PSG channel 3 key displacement
v_sfx_psg3_volume:	= $319	; PSG channel 3 volume attenuation
v_sfx_psg3_amsfmspan:	= $31A
v_sfx_psg3_tone:	= $31B
v_sfx_psg3_flutter_index:	= $31C
v_sfx_psg3_stack_ptr:	= $31D
v_sfx_psg3_note_timeout:	= $31E	; Counts down to zero; when zero, a new note is needed
v_sfx_psg3_note_duration:	= $31F
v_sfx_psg3_curr_note:	= $320
v_sfx_psg3_note_fill:	= $322
v_sfx_psg3_note_fill_master:	= $323
v_sfx_psg3_modulation_ptr:	= $324	; 4 bytes
v_sfx_psg3_modulation_wait:	= $328
v_sfx_psg3_modulation_speed:	= $329
v_sfx_psg3_modulation_delta:	= $32A
v_sfx_psg3_modulation_steps:	= $32B
v_sfx_psg3_modulation_freq:	= $32C	; 2 bytes
v_sfx_psg3_freq_adjust:	= $32E
v_sfx_psg3_noise:	= $32F
v_sfx_psg3_loop_index:	= $334	; Several bytes, may overlap with gosub/return stack

v_sfx2_track_ram:	= $340	; Start of special sfx RAM

v_sfx2_fm4_track:	= $340
v_sfx2_fm4_playback_control:	= $340	; Playback control bits for sfx FM4
v_sfx2_fm4_voice_control:	= $341	; Voice control bits
v_sfx2_fm4_tempo_time:	= $342	; sfx - tempo dividing timing
v_sfx2_fm4_ptr:	= $344	; FM channel 4 pointer (4 bytes)
v_sfx2_fm4_key:	= $348	; FM channel 4 key displacement
v_sfx2_fm4_volume:	= $349	; FM channel 4 volume attenuation
v_sfx2_fm4_amsfmspan:	= $34A
v_sfx2_fm4_voice:	= $34B
v_sfx2_fm4_stack_ptr:	= $34D
v_sfx2_fm4_note_timeout:	= $34E	; Counts down to zero; when zero, a new note is needed
v_sfx2_fm4_note_duration:	= $34F
v_sfx2_fm4_curr_note:	= $350
v_sfx2_fm4_note_fill:	= $352
v_sfx2_fm4_note_fill_master:	= $353
v_sfx2_fm4_modulation_ptr:	= $354	; 4 bytes
v_sfx2_fm4_modulation_wait:	= $358
v_sfx2_fm4_modulation_speed:	= $359
v_sfx2_fm4_modulation_delta:	= $35A
v_sfx2_fm4_modulation_steps:	= $35B
v_sfx2_fm4_modulation_freq:	= $35C	; 2 bytes
v_sfx2_fm4_freq_adjust:	= $35E
v_sfx2_fm4_feedbackalgo:	= $35F
v_sfx2_fm4_voice_ptr:	= $360
v_sfx2_fm4_loop_index:	= $364	; Several bytes, may overlap with gosub/return stack

v_sfx2_psg3_track:	= $370
v_sfx2_psg3_playback_control:	= $370	; Playback control bits for sfx PSG3
v_sfx2_psg3_voice_control:	= $371	; Voice control bits
v_sfx2_psg3_tempo_time:	= $372	; sfx - tempo dividing timing
v_sfx2_psg3_ptr:	= $374	; PSG channel 3 pointer (4 bytes)
v_sfx2_psg3_key:	= $378	; PSG channel 3 key displacement
v_sfx2_psg3_volume:	= $379	; PSG channel 3 volume attenuation
v_sfx2_psg3_amsfmspan:	= $37A
v_sfx2_psg3_tone:	= $37B
v_sfx2_psg3_flutter_index:	= $37C
v_sfx2_psg3_stack_ptr:	= $37D
v_sfx2_psg3_note_timeout:	= $37E	; Counts down to zero; when zero, a new note is needed
v_sfx2_psg3_note_duration:	= $37F
v_sfx2_psg3_curr_note:	= $380
v_sfx2_psg3_note_fill:	= $382
v_sfx2_psg3_note_fill_master:	= $383
v_sfx2_psg3_modulation_ptr:	= $384	; 4 bytes
v_sfx2_psg3_modulation_wait:	= $388
v_sfx2_psg3_modulation_speed:	= $389
v_sfx2_psg3_modulation_delta:	= $38A
v_sfx2_psg3_modulation_steps:	= $38B
v_sfx2_psg3_modulation_freq:	= $38C	; 2 bytes
v_sfx2_psg3_freq_adjust:	= $38E
v_sfx2_psg3_noise:	= $38F
v_sfx2_psg3_loop_index:	= $394	; Several bytes, may overlap with gosub/return stack

v_1up_ram_copy:	= $3A0

f_fastmusic:	= $3CA	; flag set to speed up the music (00 = normal; 80 = fast)

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
v_256loop1:	= $FFFFF7AC	; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256loop2:	= $FFFFF7AD	; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256roll1:	= $FFFFF7AE	; 256x256 level tile which contains a roll tunnel (GHZ)
v_256roll2:	= $FFFFF7AF	; 256x256 level tile which contains a roll tunnel (GHZ)
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
