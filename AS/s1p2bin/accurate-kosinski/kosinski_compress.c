// Copyright (c) 2018 Clownacy

// Sega-accurate Kosinski compressor.
// Creates identical output to Sega's own compressor.

// Note that Sega's compressor was riddled with errors.
// Search 'Mistake' to find my reimplementations of them.

// Notably, Sega's compressor used the 'longest-match' algorithm.
// This doesn't give the best possible compression ratio, but it's fast,
// easy to implement, and can be done without loading the entire file into
// memory. The graph-theory-based algorithm Flamewing used might not have
// been feasible on late-80s PCs.

// Unfortunately, there's one bug I can't emulate: it seems the original
// compressor would accidentally read past the end of the uncompressed
// file, leading to the final match reading from an odd place in the
// dictionary. This would be because, instead of searching for 0FAE66,
// it would search for 0FAE6614 instead. Usually, the match has a 0 added
// to the end of it, but other times it's a different number entirely.

// Possible explanation for Mistake 5:

// "Hrm. I think I might have just figured out a quirk of Kosinski.

// I might just be talking out of my ass, but Kosinski has some reserved 'command'
// values: basically, if you try to do a long match with a length of 0, that marks
// the end of the file. Oddly enough, a long match with a length of 1 is also a
// reserved command, but it doesn't do anything.

// Notably, 1-length commands are inserted whenever the decompressed data so far
// passes 0xA000 bytes.

// At the time I didn't think much of it, but just earlier today I was being hassled
// by libsndfile. It's an audio decoder that doesn't have a function to give you the
// total decompressed size of the file. Likewise, Kosinski doesn't have a header to
// tell you that either.

// My problem with this was, I didn't know know big a buffer to allocate before
// calling libsndfile's decompressor. I eventually came up with the idea of allocating
// an 0x8000-byte buffer, and asking for a maximum of 0x8000 bytes. If I got 0x8000
// back, then I'd allocate another 0x8000-byte buffer, and ask for another 0x8000
// bytes, and so on.

// Kosinski decompression on the MD is notable because there's no bounds checking
// or anything. There's never a reserved Kosinski decompression buffer, and Sonic
// (obviously) doesn't use a memory allocation system. It just decompresses over the
// chunk table most of the time.

// So what if, the 1-length dummy command was actually for signalling to the original
// PC decompressor that its supposedly 0xA000-byte buffer wasn't gonna be big enough
// to hold the decompressed file, prompting it to allocate a larger buffer before
// continuing?"


#include "kosinski_compress.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "memory_stream.h"

#undef MIN
#undef MAX
#define MIN(a, b) (((a) < (b)) ? (a) : (b))
#define MAX(a, b) (((a) > (b)) ? (a) : (b))

#define MAX_MATCH_LENGTH 0xFD				// Mistake 1: This should be 0x100
#define MAX_MATCH_DISTANCE (0x2000 - MAX_MATCH_LENGTH)	// Mistake 2: This should just be 0x2000

#define TOTAL_DESCRIPTOR_BITS 16

#ifdef __MINGW32__
#define PRINTF __mingw_printf
#else
#define PRINTF printf
#endif

static MemoryStream *output_stream;
static MemoryStream *match_stream;

static unsigned short descriptor;
static unsigned int descriptor_bits_remaining;

static void FlushData(void)
{
	descriptor >>= descriptor_bits_remaining;

	// Descriptors are stored byte-swapped, so it's possible the
	// original compressor did this:
	//fwrite(&descriptor, 2, 1, output_file);
	MemoryStream_WriteByte(output_stream, descriptor & 0xFF);
	MemoryStream_WriteByte(output_stream, descriptor >> 8);

	const size_t match_buffer_size = MemoryStream_GetPosition(match_stream);
	unsigned char *match_buffer = MemoryStream_GetBuffer(match_stream);

	MemoryStream_WriteBytes(output_stream, match_buffer, match_buffer_size);
}

static void PutMatchByte(unsigned char byte)
{
	MemoryStream_WriteByte(match_stream, byte);
}

static void PutDescriptorBit(bool bit)
{
	descriptor >>= 1;

	if (bit)
		descriptor |= 1 << (TOTAL_DESCRIPTOR_BITS - 1);

	if (--descriptor_bits_remaining == 0)
	{
		FlushData();

		descriptor_bits_remaining = TOTAL_DESCRIPTOR_BITS;
		MemoryStream_Rewind(match_stream);
	}
}

size_t AccurateKosinskiCompress(unsigned char *file_buffer, size_t file_size, unsigned char **p_output_buffer)
{
	output_stream = MemoryStream_Create(0x100, false);
	match_stream = MemoryStream_Create(0x10, true);

	descriptor_bits_remaining = TOTAL_DESCRIPTOR_BITS;

	size_t file_index = 0;
	unsigned long last_src_file_index = 0;

	while (file_index < file_size)
	{
		// Mistake 5: This is completely pointless.
		// For some reason, the original compressor would insert a dummy match
		// before the first match that starts after 0xA000.
		// Update: I actually might have figured out what these are for: the
		// original PC decompressor might have had a 0xA000-byte decompression
		// buffer, and these commands were for signalling that it's about to
		// run out of room, and to allocate a bigger buffer.
		// Still though, this is pointless to the Mega Drive.
		if (file_index / 0xA000 != last_src_file_index / 0xA000)
		{
			#ifdef DEBUG
			PRINTF("%zX - 0xA000 boundary flag: %tX\n", MemoryStream_GetPosition(output_stream) + MemoryStream_GetPosition(match_stream) + 2, file_index);
			#endif

			// 0xA000 boundary match
			PutDescriptorBit(false);
			PutDescriptorBit(true);
			PutMatchByte(0x00);
			PutMatchByte(0xF0);	// Honestly, I have no idea why this isn't just 0. I guess it's so you can spot it in a hex editor?
			PutMatchByte(0x01);
		}

		last_src_file_index = file_index;

		const unsigned int max_match_distance = MIN(file_index, MAX_MATCH_DISTANCE);
		const unsigned int max_match_length = MIN(file_size - file_index, MAX_MATCH_LENGTH);

		unsigned int longest_match_index;
		unsigned int longest_match_length = 0;
		for (unsigned int backsearch_index = 1; backsearch_index < max_match_distance + 1; ++backsearch_index)
		{

			unsigned int match_length = 0;
			while (match_length < max_match_length && file_buffer[file_index + match_length] == file_buffer[file_index - backsearch_index + match_length])
			{
				++match_length;
			}

			if (match_length > longest_match_length)
			{
				longest_match_index = backsearch_index;
				longest_match_length = match_length;
			}
		}

		if (longest_match_length >= 2 && longest_match_length <= 5 && longest_match_index < 256)	// Mistake 3: This should be '<= 256'
		{
			#ifdef DEBUG
			PRINTF("%zX - Inline dictionary match found: %tX, %tX, %X\n", MemoryStream_GetPosition(output_stream) + MemoryStream_GetPosition(match_stream) + 2, file_index, file_index - longest_match_index, longest_match_length);
			#endif

			const unsigned int length = longest_match_length - 2;

			PutDescriptorBit(false);
			PutDescriptorBit(false);
			PutDescriptorBit(length & 2);
			PutDescriptorBit(length & 1);
			PutMatchByte(-longest_match_index);

			file_index += longest_match_length;
		}
		else if (longest_match_length >= 3 && longest_match_length <= 9)
		{
			#ifdef DEBUG
			PRINTF("%zX - Full match found: %tX, %tX, %X\n", MemoryStream_GetPosition(output_stream) + MemoryStream_GetPosition(match_stream) + 2, file_index, file_index - longest_match_index, longest_match_length);
			#endif

			const unsigned int distance = -longest_match_index;
			PutDescriptorBit(false);
			PutDescriptorBit(true);
			PutMatchByte(distance & 0xFF);
			PutMatchByte(((distance >> (8 - 3)) & 0xF8) | ((longest_match_length - 2) & 7));

			file_index += longest_match_length;
		}
		else if (longest_match_length >= 3)
		{
			#ifdef DEBUG
			PRINTF("%zX - Extended full match found: %tX, %tX, %X\n", MemoryStream_GetPosition(output_stream) + MemoryStream_GetPosition(match_stream) + 2, file_index, file_index - longest_match_index, longest_match_length);
			#endif

			const unsigned int distance = -longest_match_index;
			PutDescriptorBit(false);
			PutDescriptorBit(true);
			PutMatchByte(distance & 0xFF);
			PutMatchByte((distance >> (8 - 3)) & 0xF8);
			PutMatchByte(longest_match_length - 1);

			file_index += longest_match_length;
		}
		else
		{
			#ifdef DEBUG
			PRINTF("%zX - Literal match found: %X at %tX\n", MemoryStream_GetPosition(output_stream) + MemoryStream_GetPosition(match_stream) + 2, file_buffer[file_index], file_index);
			#endif

			PutDescriptorBit(true);
			PutMatchByte(file_buffer[file_index++]);
		}
	}

	#ifdef DEBUG
	PRINTF("%zX - Terminator: %tX\n", MemoryStream_GetPosition(output_stream) + MemoryStream_GetPosition(match_stream) + 2, file_index);
	#endif

	// Terminator match
	PutDescriptorBit(false);
	PutDescriptorBit(true);
	PutMatchByte(0x00);
	PutMatchByte(0xF0);	// Honestly, I have no idea why this isn't just 0. I guess it's so you can spot it in a hex editor?
	PutMatchByte(0x00);

	FlushData();

	// Destory match_buffer
	MemoryStream_Destroy(match_stream);

	// Mistake 4: There's absolutely no reason to do this.
	// This might have been because the original compressor's ASM output could only write
	// exactly 0x10 values per dc.b instruction.

	// Pad to 0x10
	size_t bytes_remaining = -MemoryStream_GetPosition(output_stream) & 0xF;
	for (unsigned int i = 0; i < bytes_remaining; ++i)
		MemoryStream_WriteByte(output_stream, 0);

	const size_t output_buffer_size = MemoryStream_GetPosition(output_stream);
	unsigned char *output_buffer = MemoryStream_GetBuffer(output_stream);

	MemoryStream_Destroy(output_stream);

	if (p_output_buffer)
		*p_output_buffer = output_buffer;

	return output_buffer_size;
}
