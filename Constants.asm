; ---------------------------------------------------------------------------
; Constants
; ---------------------------------------------------------------------------

Size_of_SegaPCM:		equ $6978
Size_of_DAC_driver_guess:	equ $1760

; VDP addressses
vdp_data_port:		equ $C00000
vdp_control_port:	equ $C00004
vdp_counter:		equ $C00008

psg_input:		equ $C00011

; Z80 addresses
z80_ram:		equ $A00000	; start of Z80 RAM
z80_dac3_pitch:		equ z80_ram+zSample3_Pitch
z80_dac_status:		equ z80_ram+zDAC_Status
z80_dac_sample:		equ z80_ram+zDAC_Sample
z80_ram_end:		equ $A02000	; end of non-reserved Z80 RAM
z80_version:		equ $A10001
z80_port_1_data:	equ $A10002
z80_port_1_control:	equ $A10008
z80_port_2_control:	equ $A1000A
z80_expansion_control:	equ $A1000C
z80_bus_request:	equ $A11100
z80_reset:		equ $A11200
ym2612_a0:		equ $A04000
ym2612_d0:		equ $A04001
ym2612_a1:		equ $A04002
ym2612_d1:		equ $A04003

security_addr:		equ $A14000

; Sound driver constants
TrackPlaybackControl:	equ 0		; All tracks
TrackVoiceControl:	equ 1		; All tracks
TrackTempoDivider:	equ 2		; All tracks
TrackDataPointer:	equ 4		; All tracks (4 bytes)
TrackTranspose:		equ 8		; FM/PSG only (sometimes written to as a word, to include TrackVolume)
TrackVolume:		equ 9		; FM/PSG only
TrackAMSFMSPan:		equ $A		; FM/DAC only
TrackVoiceIndex:	equ $B		; FM/PSG only
TrackVolEnvIndex:	equ $C		; PSG only
TrackStackPointer:	equ $D		; All tracks
TrackDurationTimeout:	equ $E		; All tracks
TrackSavedDuration:	equ $F		; All tracks
TrackSavedDAC:		equ $10		; DAC only
TrackFreq:		equ $10		; FM/PSG only (2 bytes)
TrackNoteTimeout:	equ $12		; FM/PSG only
TrackNoteTimeoutMaster:equ $13		; FM/PSG only
TrackModulationPtr:	equ $14		; FM/PSG only (4 bytes)
TrackModulationWait:	equ $18		; FM/PSG only
TrackModulationSpeed:	equ $19		; FM/PSG only
TrackModulationDelta:	equ $1A		; FM/PSG only
TrackModulationSteps:	equ $1B		; FM/PSG only
TrackModulationVal:	equ $1C		; FM/PSG only (2 bytes)
TrackDetune:		equ $1E		; FM/PSG only
TrackPSGNoise:		equ $1F		; PSG only
TrackFeedbackAlgo:	equ $1F		; FM only
TrackVoicePtr:		equ $20		; FM SFX only (4 bytes)
TrackLoopCounters:	equ $24		; All tracks (multiple bytes)
TrackGoSubStack:	equ TrackSz	; All tracks (multiple bytes. This constant won't get to be used because of an optimisation that just uses zTrackSz)

TrackSz:	equ $30

; VRAM data
vram_fg:	equ $C000	; foreground namespace
vram_bg:	equ $E000	; background namespace
vram_sonic:	equ $F000	; Sonic graphics
vram_sprites:	equ $F800	; sprite table
vram_hscroll:	equ $FC00	; horizontal scroll table

; Game modes
id_Sega:	equ ptr_GM_Sega-GameModeArray	; $00
id_Title:	equ ptr_GM_Title-GameModeArray	; $04
id_Demo:	equ ptr_GM_Demo-GameModeArray	; $08
id_Level:	equ ptr_GM_Level-GameModeArray	; $0C
id_Special:	equ ptr_GM_Special-GameModeArray; $10
id_Continue:	equ ptr_GM_Cont-GameModeArray	; $14
id_Ending:	equ ptr_GM_Ending-GameModeArray	; $18
id_Credits:	equ ptr_GM_Credits-GameModeArray; $1C

; Levels
id_GHZ:		equ 0
id_LZ:		equ 1
id_MZ:		equ 2
id_SLZ:		equ 3
id_SYZ:		equ 4
id_SBZ:		equ 5
id_EndZ:	equ 6
id_SS:		equ 7

; Colours
cBlack:		equ $000		; colour black
cWhite:		equ $EEE		; colour white
cBlue:		equ $E00		; colour blue
cGreen:		equ $0E0		; colour green
cRed:		equ $00E		; colour red
cYellow:	equ cGreen+cRed		; colour yellow
cAqua:		equ cGreen+cBlue	; colour aqua
cMagenta:	equ cBlue+cRed		; colour magenta

; Joypad input
btnStart:	equ %10000000 ; Start button	($80)
btnA:		equ %01000000 ; A		($40)
btnC:		equ %00100000 ; C		($20)
btnB:		equ %00010000 ; B		($10)
btnR:		equ %00001000 ; Right		($08)
btnL:		equ %00000100 ; Left		($04)
btnDn:		equ %00000010 ; Down		($02)
btnUp:		equ %00000001 ; Up		($01)
btnDir:		equ %00001111 ; Any direction	($0F)
btnABC:		equ %01110000 ; A, B or C	($70)
bitStart:	equ 7
bitA:		equ 6
bitC:		equ 5
bitB:		equ 4
bitR:		equ 3
bitL:		equ 2
bitDn:		equ 1
bitUp:		equ 0

; Object variables
obRender:	equ 1	; bitfield for x/y flip, display mode
obGfx:		equ 2	; palette line & VRAM setting (2 bytes)
obMap:		equ 4	; mappings address (4 bytes)
obX:		equ 8	; x-axis position (2-4 bytes)
obScreenY:	equ $A	; y-axis position for screen-fixed items (2 bytes)
obY:		equ $C	; y-axis position (2-4 bytes)
obVelX:		equ $10	; x-axis velocity (2 bytes)
obVelY:		equ $12	; y-axis velocity (2 bytes)
obInertia:	equ $14	; potential speed (2 bytes)
obHeight:	equ $16	; height/2
obWidth:	equ $17	; width/2
obPriority:	equ $18	; sprite stack priority -- 0 is front
obActWid:	equ $19	; action width
obFrame:	equ $1A	; current frame displayed
obAniFrame:	equ $1B	; current frame in animation script
obAnim:		equ $1C	; current animation
obNextAni:	equ $1D	; next animation
obTimeFrame:	equ $1E	; time to next frame
obDelayAni:	equ $1F	; time to delay animation
obColType:	equ $20	; collision response type
obColProp:	equ $21	; collision extra property
obStatus:	equ $22	; orientation or mode
obRespawnNo:	equ $23	; respawn list index number
obRoutine:	equ $24	; routine number
ob2ndRout:	equ $25	; secondary routine number
obAngle:	equ $26	; angle
obSubtype:	equ $28	; object subtype
obSolid:	equ ob2ndRout ; solid status flag

; Object variables used by Sonic
flashtime:	equ $30	; time between flashes after getting hit
invtime:	equ $32	; time left for invincibility
shoetime:	equ $34	; time left for speed shoes

; Object variables (Sonic 2 disassembly nomenclature)
render_flags:	equ 1	; bitfield for x/y flip, display mode
art_tile:	equ 2	; palette line & VRAM setting (2 bytes)
mappings:	equ 4	; mappings address (4 bytes)
x_pos:		equ 8	; x-axis position (2-4 bytes)
y_pos:		equ $C	; y-axis position (2-4 bytes)
x_vel:		equ $10	; x-axis velocity (2 bytes)
y_vel:		equ $12	; y-axis velocity (2 bytes)
y_radius:	equ $16	; height/2
x_radius:	equ $17	; width/2
priority:	equ $18	; sprite stack priority -- 0 is front
width_pixels:	equ $19	; action width
mapping_frame:	equ $1A	; current frame displayed
anim_frame:	equ $1B	; current frame in animation script
anim:		equ $1C	; current animation
next_anim:	equ $1D	; next animation
anim_frame_duration: equ $1E ; time to next frame
collision_flags: equ $20 ; collision response type
collision_property: equ $21 ; collision extra property
status:		equ $22	; orientation or mode
respawn_index:	equ $23	; respawn list index number
routine:	equ $24	; routine number
routine_secondary: equ $25 ; secondary routine number
angle:		equ $26	; angle
subtype:	equ $28	; object subtype

; Animation flags
afEnd:		equ $FF	; return to beginning of animation
afBack:		equ $FE	; go back (specified number) bytes
afChange:	equ $FD	; run specified animation
afRoutine:	equ $FC	; increment routine counter
afReset:	equ $FB	; reset animation and 2nd object routine counter
af2ndRoutine:	equ $FA	; increment 2nd routine counter

; Background music
bgm__First:	equ $81
bgm_GHZ:	equ ((ptr_mus81-MusicIndex)/4)+bgm__First
bgm_LZ:		equ ((ptr_mus82-MusicIndex)/4)+bgm__First
bgm_MZ:		equ ((ptr_mus83-MusicIndex)/4)+bgm__First
bgm_SLZ:	equ ((ptr_mus84-MusicIndex)/4)+bgm__First
bgm_SYZ:	equ ((ptr_mus85-MusicIndex)/4)+bgm__First
bgm_SBZ:	equ ((ptr_mus86-MusicIndex)/4)+bgm__First
bgm_Invincible:	equ ((ptr_mus87-MusicIndex)/4)+bgm__First
bgm_ExtraLife:	equ ((ptr_mus88-MusicIndex)/4)+bgm__First
bgm_SS:		equ ((ptr_mus89-MusicIndex)/4)+bgm__First
bgm_Title:	equ ((ptr_mus8A-MusicIndex)/4)+bgm__First
bgm_Ending:	equ ((ptr_mus8B-MusicIndex)/4)+bgm__First
bgm_Boss:	equ ((ptr_mus8C-MusicIndex)/4)+bgm__First
bgm_FZ:		equ ((ptr_mus8D-MusicIndex)/4)+bgm__First
bgm_GotThrough:	equ ((ptr_mus8E-MusicIndex)/4)+bgm__First
bgm_GameOver:	equ ((ptr_mus8F-MusicIndex)/4)+bgm__First
bgm_Continue:	equ ((ptr_mus90-MusicIndex)/4)+bgm__First
bgm_Credits:	equ ((ptr_mus91-MusicIndex)/4)+bgm__First
bgm_Drowning:	equ ((ptr_mus92-MusicIndex)/4)+bgm__First
bgm_Emerald:	equ ((ptr_mus93-MusicIndex)/4)+bgm__First
bgm__Last:	equ ((ptr_musend-MusicIndex-4)/4)+bgm__First

; Sound effects
sfx__First:	equ $A0
sfx_Jump:	equ ((ptr_sndA0-SoundIndex)/4)+sfx__First
sfx_Lamppost:	equ ((ptr_sndA1-SoundIndex)/4)+sfx__First
sfx_A2:		equ ((ptr_sndA2-SoundIndex)/4)+sfx__First
sfx_Death:	equ ((ptr_sndA3-SoundIndex)/4)+sfx__First
sfx_Skid:	equ ((ptr_sndA4-SoundIndex)/4)+sfx__First
sfx_A5:		equ ((ptr_sndA5-SoundIndex)/4)+sfx__First
sfx_HitSpikes:	equ ((ptr_sndA6-SoundIndex)/4)+sfx__First
sfx_Push:	equ ((ptr_sndA7-SoundIndex)/4)+sfx__First
sfx_SSGoal:	equ ((ptr_sndA8-SoundIndex)/4)+sfx__First
sfx_SSItem:	equ ((ptr_sndA9-SoundIndex)/4)+sfx__First
sfx_Splash:	equ ((ptr_sndAA-SoundIndex)/4)+sfx__First
sfx_AB:		equ ((ptr_sndAB-SoundIndex)/4)+sfx__First
sfx_HitBoss:	equ ((ptr_sndAC-SoundIndex)/4)+sfx__First
sfx_Bubble:	equ ((ptr_sndAD-SoundIndex)/4)+sfx__First
sfx_Fireball:	equ ((ptr_sndAE-SoundIndex)/4)+sfx__First
sfx_Shield:	equ ((ptr_sndAF-SoundIndex)/4)+sfx__First
sfx_Saw:	equ ((ptr_sndB0-SoundIndex)/4)+sfx__First
sfx_Electric:	equ ((ptr_sndB1-SoundIndex)/4)+sfx__First
sfx_Drown:	equ ((ptr_sndB2-SoundIndex)/4)+sfx__First
sfx_Flamethrower:equ ((ptr_sndB3-SoundIndex)/4)+sfx__First
sfx_Bumper:	equ ((ptr_sndB4-SoundIndex)/4)+sfx__First
sfx_Ring:	equ ((ptr_sndB5-SoundIndex)/4)+sfx__First
sfx_SpikesMove:	equ ((ptr_sndB6-SoundIndex)/4)+sfx__First
sfx_Rumbling:	equ ((ptr_sndB7-SoundIndex)/4)+sfx__First
sfx_B8:		equ ((ptr_sndB8-SoundIndex)/4)+sfx__First
sfx_Collapse:	equ ((ptr_sndB9-SoundIndex)/4)+sfx__First
sfx_SSGlass:	equ ((ptr_sndBA-SoundIndex)/4)+sfx__First
sfx_Door:	equ ((ptr_sndBB-SoundIndex)/4)+sfx__First
sfx_Teleport:	equ ((ptr_sndBC-SoundIndex)/4)+sfx__First
sfx_ChainStomp:	equ ((ptr_sndBD-SoundIndex)/4)+sfx__First
sfx_Roll:	equ ((ptr_sndBE-SoundIndex)/4)+sfx__First
sfx_Continue:	equ ((ptr_sndBF-SoundIndex)/4)+sfx__First
sfx_Basaran:	equ ((ptr_sndC0-SoundIndex)/4)+sfx__First
sfx_BreakItem:	equ ((ptr_sndC1-SoundIndex)/4)+sfx__First
sfx_Warning:	equ ((ptr_sndC2-SoundIndex)/4)+sfx__First
sfx_GiantRing:	equ ((ptr_sndC3-SoundIndex)/4)+sfx__First
sfx_Bomb:	equ ((ptr_sndC4-SoundIndex)/4)+sfx__First
sfx_Cash:	equ ((ptr_sndC5-SoundIndex)/4)+sfx__First
sfx_RingLoss:	equ ((ptr_sndC6-SoundIndex)/4)+sfx__First
sfx_ChainRise:	equ ((ptr_sndC7-SoundIndex)/4)+sfx__First
sfx_Burning:	equ ((ptr_sndC8-SoundIndex)/4)+sfx__First
sfx_Bonus:	equ ((ptr_sndC9-SoundIndex)/4)+sfx__First
sfx_EnterSS:	equ ((ptr_sndCA-SoundIndex)/4)+sfx__First
sfx_WallSmash:	equ ((ptr_sndCB-SoundIndex)/4)+sfx__First
sfx_Spring:	equ ((ptr_sndCC-SoundIndex)/4)+sfx__First
sfx_Switch:	equ ((ptr_sndCD-SoundIndex)/4)+sfx__First
sfx_RingLeft:	equ ((ptr_sndCE-SoundIndex)/4)+sfx__First
sfx_Signpost:	equ ((ptr_sndCF-SoundIndex)/4)+sfx__First
sfx__Last:	equ ((ptr_sndend-SoundIndex-4)/4)+sfx__First

; Special sound effects
spec__First:	equ $D0
sfx_Waterfall:	equ ((ptr_sndD0-SpecSoundIndex)/4)+spec__First
spec__Last:	equ ((ptr_specend-SpecSoundIndex-4)/4)+spec__First

flg__First:	equ $E0
bgm_Fade:	equ ((ptr_flgE0-Sound_ExIndex)/4)+flg__First
sfx_Sega:	equ ((ptr_flgE1-Sound_ExIndex)/4)+flg__First
bgm_Speedup:	equ ((ptr_flgE2-Sound_ExIndex)/4)+flg__First
bgm_Slowdown:	equ ((ptr_flgE3-Sound_ExIndex)/4)+flg__First
bgm_Stop:	equ ((ptr_flgE4-Sound_ExIndex)/4)+flg__First
flg__Last:	equ ((ptr_flgend-Sound_ExIndex-4)/4)+flg__First

; Sonic frame IDs
fr_Null:	equ  (ptr_MS_Null-Map_Sonic)/2
fr_Stand:	equ (ptr_MS_Stand-Map_Sonic)/2		; 1
fr_Wait1:	equ (ptr_MS_Wait1-Map_Sonic)/2		; 2
fr_Wait2:	equ (ptr_MS_Wait2-Map_Sonic)/2		; 3
fr_Wait3:	equ (ptr_MS_Wait3-Map_Sonic)/2		; 4
fr_LookUp:	equ (ptr_MS_LookUp-Map_Sonic)/2		; 5
fr_Walk11:	equ (ptr_MS_Walk11-Map_Sonic)/2		; 6
fr_Walk12:	equ (ptr_MS_Walk12-Map_Sonic)/2		; 7
fr_Walk13:	equ (ptr_MS_Walk13-Map_Sonic)/2		; 8
fr_Walk14:	equ (ptr_MS_Walk14-Map_Sonic)/2		; 9
fr_Walk15:	equ (ptr_MS_Walk15-Map_Sonic)/2		; $A
fr_Walk16:	equ (ptr_MS_Walk16-Map_Sonic)/2		; $B
fr_Walk21:	equ (ptr_MS_Walk21-Map_Sonic)/2		; $C
fr_Walk22:	equ (ptr_MS_Walk22-Map_Sonic)/2		; $D
fr_Walk23:	equ (ptr_MS_Walk23-Map_Sonic)/2		; $E
fr_Walk24:	equ (ptr_MS_Walk24-Map_Sonic)/2		; $F
fr_Walk25:	equ (ptr_MS_Walk25-Map_Sonic)/2		; $10
fr_Walk26:	equ (ptr_MS_Walk26-Map_Sonic)/2		; $11
fr_Walk31:	equ (ptr_MS_Walk31-Map_Sonic)/2		; $12
fr_Walk32:	equ (ptr_MS_Walk32-Map_Sonic)/2		; $13
fr_Walk33:	equ (ptr_MS_Walk33-Map_Sonic)/2		; $14
fr_Walk34:	equ (ptr_MS_Walk34-Map_Sonic)/2		; $15
fr_Walk35:	equ (ptr_MS_Walk35-Map_Sonic)/2		; $16
fr_Walk36:	equ (ptr_MS_Walk36-Map_Sonic)/2		; $17
fr_Walk41:	equ (ptr_MS_Walk41-Map_Sonic)/2		; $18
fr_Walk42:	equ (ptr_MS_Walk42-Map_Sonic)/2		; $19
fr_Walk43:	equ (ptr_MS_Walk43-Map_Sonic)/2		; $1A
fr_Walk44:	equ (ptr_MS_Walk44-Map_Sonic)/2		; $1B
fr_Walk45:	equ (ptr_MS_Walk45-Map_Sonic)/2		; $1C
fr_Walk46:	equ (ptr_MS_Walk46-Map_Sonic)/2		; $1D
fr_Run11:	equ (ptr_MS_Run11-Map_Sonic)/2		; $1E
fr_Run12:	equ (ptr_MS_Run12-Map_Sonic)/2		; $1F
fr_Run13:	equ (ptr_MS_Run13-Map_Sonic)/2		; $20
fr_Run14:	equ (ptr_MS_Run14-Map_Sonic)/2		; $21
fr_Run21:	equ (ptr_MS_Run21-Map_Sonic)/2		; $22
fr_Run22:	equ (ptr_MS_Run22-Map_Sonic)/2		; $23
fr_Run23:	equ (ptr_MS_Run23-Map_Sonic)/2		; $24
fr_Run24:	equ (ptr_MS_Run24-Map_Sonic)/2		; $25
fr_Run31:	equ (ptr_MS_Run31-Map_Sonic)/2		; $26
fr_Run32:	equ (ptr_MS_Run32-Map_Sonic)/2		; $27
fr_Run33:	equ (ptr_MS_Run33-Map_Sonic)/2		; $28
fr_Run34:	equ (ptr_MS_Run34-Map_Sonic)/2		; $29
fr_Run41:	equ (ptr_MS_Run41-Map_Sonic)/2		; $2A
fr_Run42:	equ (ptr_MS_Run42-Map_Sonic)/2		; $2B
fr_Run43:	equ (ptr_MS_Run43-Map_Sonic)/2		; $2C
fr_Run44:	equ (ptr_MS_Run44-Map_Sonic)/2		; $2D
fr_Roll1:	equ (ptr_MS_Roll1-Map_Sonic)/2		; $2E
fr_Roll2:	equ (ptr_MS_Roll2-Map_Sonic)/2		; $2F
fr_Roll3:	equ (ptr_MS_Roll3-Map_Sonic)/2		; $30
fr_Roll4:	equ (ptr_MS_Roll4-Map_Sonic)/2		; $31
fr_Roll5:	equ (ptr_MS_Roll5-Map_Sonic)/2		; $32
fr_Warp1:	equ (ptr_MS_Warp1-Map_Sonic)/2		; $33
fr_Warp2:	equ (ptr_MS_Warp2-Map_Sonic)/2		; $34
fr_Warp3:	equ (ptr_MS_Warp3-Map_Sonic)/2		; $35
fr_Warp4:	equ (ptr_MS_Warp4-Map_Sonic)/2		; $36
fr_Stop1:	equ (ptr_MS_Stop1-Map_Sonic)/2		; $37
fr_Stop2:	equ (ptr_MS_Stop2-Map_Sonic)/2		; $38
fr_Duck:	equ (ptr_MS_Duck-Map_Sonic)/2		; $39
fr_Balance1:	equ (ptr_MS_Balance1-Map_Sonic)/2	; $3A
fr_Balance2:	equ (ptr_MS_Balance2-Map_Sonic)/2	; $3B
fr_Float1:	equ (ptr_MS_Float1-Map_Sonic)/2		; $3C
fr_Float2:	equ (ptr_MS_Float2-Map_Sonic)/2		; $3D
fr_Float3:	equ (ptr_MS_Float3-Map_Sonic)/2		; $3E
fr_Float4:	equ (ptr_MS_Float4-Map_Sonic)/2		; $3F
fr_Spring:	equ (ptr_MS_Spring-Map_Sonic)/2		; $40
fr_Hang1:	equ (ptr_MS_Hang1-Map_Sonic)/2		; $41
fr_Hang2:	equ (ptr_MS_Hang2-Map_Sonic)/2		; $42
fr_Leap1:	equ (ptr_MS_Leap1-Map_Sonic)/2		; $43
fr_Leap2:	equ (ptr_MS_Leap2-Map_Sonic)/2		; $44
fr_Push1:	equ (ptr_MS_Push1-Map_Sonic)/2		; $45
fr_Push2:	equ (ptr_MS_Push2-Map_Sonic)/2		; $46
fr_Push3:	equ (ptr_MS_Push3-Map_Sonic)/2		; $47
fr_Push4:	equ (ptr_MS_Push4-Map_Sonic)/2		; $48
fr_Surf:	equ (ptr_MS_Surf-Map_Sonic)/2		; $49
fr_BubStand:	equ (ptr_MS_BubStand-Map_Sonic)/2	; $4A
fr_Burnt:	equ (ptr_MS_Burnt-Map_Sonic)/2		; $4B
fr_Drown:	equ (ptr_MS_Drown-Map_Sonic)/2		; $4C
fr_Death:	equ (ptr_MS_Death-Map_Sonic)/2		; $4D
fr_Shrink1:	equ (ptr_MS_Shrink1-Map_Sonic)/2	; $4E
fr_Shrink2:	equ (ptr_MS_Shrink2-Map_Sonic)/2	; $4F
fr_Shrink3:	equ (ptr_MS_Shrink3-Map_Sonic)/2	; $50
fr_Shrink4:	equ (ptr_MS_Shrink4-Map_Sonic)/2	; $51
fr_Shrink5:	equ (ptr_MS_Shrink5-Map_Sonic)/2	; $52
fr_Float5:	equ (ptr_MS_Float5-Map_Sonic)/2		; $53
fr_Float6:	equ (ptr_MS_Float6-Map_Sonic)/2		; $54
fr_Injury:	equ (ptr_MS_Injury-Map_Sonic)/2		; $55
fr_GetAir:	equ (ptr_MS_GetAir-Map_Sonic)/2		; $56
fr_WaterSlide:	equ (ptr_MS_WaterSlide-Map_Sonic)/2	; $57
