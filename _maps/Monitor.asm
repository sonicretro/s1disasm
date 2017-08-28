; ---------------------------------------------------------------------------
; Sprite mappings - monitors
; ---------------------------------------------------------------------------
Map_Monitor_internal:
		dc.w .static0-Map_Monitor_internal
		dc.w .static1-Map_Monitor_internal
		dc.w .static2-Map_Monitor_internal
		dc.w .eggman-Map_Monitor_internal
		dc.w .sonic-Map_Monitor_internal
		dc.w .shoes-Map_Monitor_internal
		dc.w .shield-Map_Monitor_internal
		dc.w .invincible-Map_Monitor_internal
		dc.w .rings-Map_Monitor_internal
		dc.w .s-Map_Monitor_internal
		dc.w .goggles-Map_Monitor_internal
		dc.w .broken-Map_Monitor_internal
.static0:	dc.b 1			; static monitor
		dc.b $EF, $F, 0, 0, $F0
.static1:	dc.b 2			; static monitor
		dc.b $F5, 5, 0,	$10, $F8
		dc.b $EF, $F, 0, 0, $F0
.static2:	dc.b 2			; static monitor
		dc.b $F5, 5, 0,	$14, $F8
		dc.b $EF, $F, 0, 0, $F0
.eggman:	dc.b 2			; Eggman monitor
		dc.b $F5, 5, 0,	$18, $F8
		dc.b $EF, $F, 0, 0, $F0
.sonic:		dc.b 2			; Sonic	monitor
		dc.b $F5, 5, 0,	$1C, $F8
		dc.b $EF, $F, 0, 0, $F0
.shoes:		dc.b 2			; speed	shoes monitor
		dc.b $F5, 5, 0,	$24, $F8
		dc.b $EF, $F, 0, 0, $F0
.shield:	dc.b 2			; shield monitor
		dc.b $F5, 5, 0,	$28, $F8
		dc.b $EF, $F, 0, 0, $F0
.invincible:	dc.b 2			; invincibility	monitor
		dc.b $F5, 5, 0,	$2C, $F8
		dc.b $EF, $F, 0, 0, $F0
.rings:		dc.b 2			; 10 rings monitor
		dc.b $F5, 5, 0,	$30, $F8
		dc.b $EF, $F, 0, 0, $F0
.s:		dc.b 2			; 'S' monitor
		dc.b $F5, 5, 0,	$34, $F8
		dc.b $EF, $F, 0, 0, $F0
.goggles:	dc.b 2			; goggles monitor
		dc.b $F5, 5, 0,	$20, $F8
		dc.b $EF, $F, 0, 0, $F0
.broken:	dc.b 1			; broken monitor
		dc.b $FF, $D, 0, $38, $F0
		even