; ---------------------------------------------------------------------------
; Sonic start location array
; ---------------------------------------------------------------------------

		binclude	"startpos/ghz1.bin"
		binclude	"startpos/ghz2.bin"
		binclude	"startpos/ghz3.bin"
		dc.w	$80,$A8

		binclude	"startpos/lz1.bin"
		binclude	"startpos/lz2.bin"
		binclude	"startpos/lz3.bin"
		binclude	"startpos/sbz3.bin"

		binclude	"startpos/mz1.bin"
		binclude	"startpos/mz2.bin"
		binclude	"startpos/mz3.bin"
		dc.w	$80,$A8

		binclude	"startpos/slz1.bin"
		binclude	"startpos/slz2.bin"
		binclude	"startpos/slz3.bin"
		dc.w	$80,$A8

		binclude	"startpos/syz1.bin"
		binclude	"startpos/syz2.bin"
		binclude	"startpos/syz3.bin"
		dc.w	$80,$A8

		binclude	"startpos/sbz1.bin"
		binclude	"startpos/sbz2.bin"
		binclude	"startpos/fz.bin"
		dc.w	$80,$A8

		binclude	"startpos/end1.bin"
		binclude	"startpos/end2.bin"
		dc.w	$80,$A8
		dc.w	$80,$A8

		even
		zonewarning StartLocArray,$10
