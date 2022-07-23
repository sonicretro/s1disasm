/*
 * zlib License
 *
 * (C) 2018-2021 Clownacy
 *
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

// Sega-accurate Kosinski compressor.
// Creates identical output to Sega's own compressor.

// Note that Sega's compressor was riddled with errors.
// Search 'Mistake' to find my reimplementations of them with explanations.

// Notably, Sega's compressor used a greedy compression algorithm.
// This doesn't give the best possible compression ratio, but it's fast, easy to
// implement, and can be done without loading the entire file into memory.
// The graph-theory-based 'perfect' compression algorithm used by clownlzss and
// mdcomp would not have been feasible on late-80s PCs.


#include "kosinski_compress.h"

#include <stdbool.h>
#include <stddef.h>
#ifdef DEBUG
 #include <stdio.h>
#endif
#include <stdlib.h>
#include <string.h>

#include "memory_stream.h"

#undef MIN
#undef MAX
#define MIN(a, b) (((a) < (b)) ? (a) : (b))
#define MAX(a, b) (((a) > (b)) ? (a) : (b))

#define SLIDING_WINDOW_SIZE 0x2000

#define MAX_MATCH_LENGTH 0xFD                                       // Mistake 1: This should be 0x100
#define MAX_MATCH_DISTANCE (SLIDING_WINDOW_SIZE - MAX_MATCH_LENGTH) // Mistake 2: This should just be SLIDING_WINDOW_SIZE

#define TOTAL_DESCRIPTOR_BITS 16

static MemoryStream output_stream;
static MemoryStream match_stream;

static unsigned int descriptor;
static unsigned int descriptor_bits_remaining;

// Rather than load the entire file into memory, it appears that the original
// Kosinski compressor would stream data into a ring buffer, which matched the
// size of the LZSS sliding window.
// Okumura's 1989 LZSS compressor does this too, so it appears that this was a
// common technique back then.
static unsigned char ring_buffer[SLIDING_WINDOW_SIZE];

static void FlushData(void)
{
	descriptor >>= descriptor_bits_remaining;

	// Descriptors are stored byte-swapped, so it's possible that the original
	// compressor was designed for a little-endian CPU and that it did this:
	//fwrite(&descriptor, 2, 1, output_file);
	MemoryStream_WriteByte(&output_stream, (descriptor >> 0) & 0xFF);
	MemoryStream_WriteByte(&output_stream, (descriptor >> 8) & 0xFF);

	const size_t match_buffer_size = MemoryStream_GetPosition(&match_stream);
	const unsigned char *match_buffer = MemoryStream_GetBuffer(&match_stream);

	MemoryStream_Write(&output_stream, match_buffer, 1, match_buffer_size);
}

static void PutMatchByte(unsigned char byte)
{
	MemoryStream_WriteByte(&match_stream, byte);
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
		MemoryStream_Rewind(&match_stream);
	}
}

size_t KosinskiCompress(const unsigned char *file_buffer, size_t file_size, unsigned char **output_buffer_pointer)
{
	MemoryStream_Create(&output_stream, CC_FALSE);
	MemoryStream_Create(&match_stream, CC_TRUE);

	descriptor_bits_remaining = TOTAL_DESCRIPTOR_BITS;

	// Fill the ring buffer with zero. We know the original Kosinski compressor
	// did this because of Mistake 6.
	memset(ring_buffer, 0, sizeof(ring_buffer));

	// Initialise the ring buffer with data from the file
	for (size_t i = 0; i < MAX_MATCH_LENGTH; ++i)
		if (i < file_size)
			ring_buffer[i] = file_buffer[i];

	size_t file_index = 0;
	size_t last_src_file_index = 0;

	while (file_index < file_size)
	{
		// Mistake 5: This is completely pointless.
		// For some reason, the original compressor would insert a dummy match
		// before the first match that starts after 0xA000.
		// Perhaps this was intended for detecting corrupted data? Maybe the PC
		// Kosinski decompressor would expect this type of match to appear every
		// 0xA000 bytes, and if it didn't, then it would bail and print an error
		// message to the user telling them that the compressed data is corrupt.
		if (file_index / 0xA000 != last_src_file_index / 0xA000)
		{
		#ifdef DEBUG
			fprintf(stderr, "%zX - 0xA000 boundary flag: %zX\n", MemoryStream_GetPosition(&output_stream) + MemoryStream_GetPosition(&match_stream) + 2, file_index);
		#endif

			// 0xA000 boundary match
			PutDescriptorBit(false);
			PutDescriptorBit(true);
			PutMatchByte(0x00);
			PutMatchByte(0xF0);	// Honestly, I have no idea why this isn't just 0. I guess it's so you can spot it in a hex editor?
			PutMatchByte(0x01);
		}

		last_src_file_index = file_index;

		const size_t max_match_distance = MIN(file_index, MAX_MATCH_DISTANCE);

		size_t longest_match_index = 0;
		size_t longest_match_length = 0;
		for (size_t backsearch_index = 1; backsearch_index < max_match_distance + 1; ++backsearch_index)
		{
			// Mistake 6: `match_length` always counts up to `MAX_MATCH_LENGTH`, even if it means reading
			// past the end of the file. Because the ring buffer isn't updated once the end of the file is
			// reached, this results in leftover values from earlier in the file being read instead.
			// This bug causes the final match in the file to sometimes ignore suitable nearby data in
			// favour of data earlier in the file, even if it means using a larger match type. This is
			// because the chosen data just so happened to be followed by the same pattern of bytes that
			// the buggy search read from the ring buffer, while the nearby data did not.
			size_t match_length = 0;
			while (match_length < MAX_MATCH_LENGTH && ring_buffer[(file_index + match_length) % SLIDING_WINDOW_SIZE] == ring_buffer[(file_index - backsearch_index + match_length) % SLIDING_WINDOW_SIZE])
			{
				++match_length;
			}

			if (match_length > longest_match_length)
			{
				longest_match_index = backsearch_index;
				longest_match_length = match_length;
			}
		}

		// If the match is longer than the remainder of the file, reduce it to the proper size. See Mistake 6 for more info.
		longest_match_length = MIN(longest_match_length, file_size - file_index);

		if (longest_match_length >= 2 && longest_match_length <= 5 && longest_match_index < 0x100) // Mistake 3: This should be '<= 0x100'
		{
		#ifdef DEBUG
			fprintf(stderr, "%zX - Inline dictionary match found: %zX, %zX, %zX\n", MemoryStream_GetPosition(&output_stream) + MemoryStream_GetPosition(&match_stream) + 2, file_index, file_index - longest_match_index, longest_match_length);
		#endif

			const size_t length = longest_match_length - 2;

			PutDescriptorBit(false);
			PutDescriptorBit(false);
			PutDescriptorBit(length & 2);
			PutDescriptorBit(length & 1);
			PutMatchByte(-longest_match_index & 0xFF);
		}
		else if (longest_match_length >= 3 && longest_match_length <= 9)
		{
		#ifdef DEBUG
			fprintf(stderr, "%zX - Full match found: %zX, %zX, %zX\n", MemoryStream_GetPosition(&output_stream) + MemoryStream_GetPosition(&match_stream) + 2, file_index, file_index - longest_match_index, longest_match_length);
		#endif

			const size_t distance = -longest_match_index;
			PutDescriptorBit(false);
			PutDescriptorBit(true);
			PutMatchByte(distance & 0xFF);
			PutMatchByte(((distance >> (8 - 3)) & 0xF8) | ((longest_match_length - 2) & 7));
		}
		else if (longest_match_length >= 3)
		{
		#ifdef DEBUG
			fprintf(stderr, "%zX - Extended full match found: %zX, %zX, %zX\n", MemoryStream_GetPosition(&output_stream) + MemoryStream_GetPosition(&match_stream) + 2, file_index, file_index - longest_match_index, longest_match_length);
		#endif

			const size_t distance = -longest_match_index;
			PutDescriptorBit(false);
			PutDescriptorBit(true);
			PutMatchByte(distance & 0xFF);
			PutMatchByte((distance >> (8 - 3)) & 0xF8);
			PutMatchByte(longest_match_length - 1);
		}
		else
		{
		#ifdef DEBUG
			fprintf(stderr, "%zX - Literal match found: %X at %zX\n", MemoryStream_GetPosition(&output_stream) + MemoryStream_GetPosition(&match_stream) + 2, file_buffer[file_index], file_index);
		#endif

			longest_match_length = 1;

			PutDescriptorBit(true);
			PutMatchByte(file_buffer[file_index]);
		}

		// Update the ring buffer with bytes from the file
		for (size_t i = 0; i < longest_match_length; ++i)
			if (file_index + MAX_MATCH_LENGTH + i < file_size)
				ring_buffer[(file_index + MAX_MATCH_LENGTH + i) % SLIDING_WINDOW_SIZE] = file_buffer[file_index + MAX_MATCH_LENGTH + i];

		file_index += longest_match_length;
	}

#ifdef DEBUG
	fprintf(stderr, "%zX - Terminator: %zX\n", MemoryStream_GetPosition(&output_stream) + MemoryStream_GetPosition(&match_stream) + 2, file_index);
#endif

	// Terminator match
	PutDescriptorBit(false);
	PutDescriptorBit(true);
	PutMatchByte(0x00);
	PutMatchByte(0xF0);	// Honestly, I have no idea why this isn't just 0. I guess it's so you can spot it in a hex editor?
	PutMatchByte(0x00);

	FlushData();

	// Destroy match_buffer
	MemoryStream_Destroy(&match_stream);

	// Mistake 4: There's absolutely no reason to do this.
	// This might have been because the original compressor's ASM output could
	// only write exactly 0x10 values per dc.b instruction.

	// Pad to 0x10 bytes
	size_t bytes_remaining = -MemoryStream_GetPosition(&output_stream) & 0xF;
	for (size_t i = 0; i < bytes_remaining; ++i)
		MemoryStream_WriteByte(&output_stream, 0);

	const size_t output_buffer_size = MemoryStream_GetPosition(&output_stream);
	unsigned char *output_buffer = MemoryStream_GetBuffer(&output_stream);

	MemoryStream_Destroy(&output_stream);

	if (output_buffer_pointer != NULL)
		*output_buffer_pointer = output_buffer;

	return output_buffer_size;
}
