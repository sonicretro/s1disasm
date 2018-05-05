sega.pcm is a mono 8-bit unsigned PCM sample, which is played at roughly 16 kHz

The files with a '.dpcm' extension are also mono 8-bit unsigned PCM samples, but encoded in 4-bit DPCM format

DPCM samples are decoded using this table:

zDACDecodeTbl:
	db	   0,	 1,   2,   4,   8,  10h,  20h,  40h
	db	 80h,	-1,  -2,  -4,  -8, -10h, -20h, -40h

The DPCM samples play at the following speeds:
* Kick - Roughtly 8 kHz
* Snare - Roughtly 24 kHz
* Timpani - Roughtly 7.5 kHz (though this is altered to produce different pitches)
