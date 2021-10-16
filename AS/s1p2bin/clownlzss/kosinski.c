/*
	(C) 2018-2021 Clownacy

	This software is provided 'as-is', without any express or implied
	warranty.  In no event will the authors be held liable for any damages
	arising from the use of this software.

	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute it
	freely, subject to the following restrictions:

	1. The origin of this software must not be misrepresented; you must not
	   claim that you wrote the original software. If you use this software
	   in a product, an acknowledgment in the product documentation would be
	   appreciated but is not required.
	2. Altered source versions must be plainly marked as such, and must not be
	   misrepresented as being the original software.
	3. This notice may not be removed or altered from any source distribution.
*/

#include "kosinski.h"

#include <assert.h>
#include <stddef.h>

#include "clowncommon.h"

#include "clownlzss.h"
#include "common.h"
#include "memory_stream.h"

#define TOTAL_DESCRIPTOR_BITS 16

typedef struct KosinskiInstance
{
	MemoryStream *output_stream;
	MemoryStream match_stream;

	unsigned int descriptor;
	unsigned int descriptor_bits_remaining;
} KosinskiInstance;

static void FlushData(KosinskiInstance *instance)
{
	size_t match_buffer_size;
	unsigned char *match_buffer;

	MemoryStream_WriteByte(instance->output_stream, (instance->descriptor >> 0) & 0xFF);
	MemoryStream_WriteByte(instance->output_stream, (instance->descriptor >> 8) & 0xFF);

	match_buffer_size = MemoryStream_GetPosition(&instance->match_stream);
	match_buffer = MemoryStream_GetBuffer(&instance->match_stream);

	MemoryStream_Write(instance->output_stream, match_buffer, 1, match_buffer_size);
}

static void PutMatchByte(KosinskiInstance *instance, unsigned int byte)
{
	MemoryStream_WriteByte(&instance->match_stream, byte);
}

static void PutDescriptorBit(KosinskiInstance *instance, cc_bool_fast bit)
{
	assert(bit == 0 || bit == 1);

	--instance->descriptor_bits_remaining;

	instance->descriptor >>= 1;

	if (bit)
		instance->descriptor |= 1 << (TOTAL_DESCRIPTOR_BITS - 1);

	if (instance->descriptor_bits_remaining == 0)
	{
		FlushData(instance);

		instance->descriptor_bits_remaining = TOTAL_DESCRIPTOR_BITS;
		MemoryStream_Rewind(&instance->match_stream);
	}
}

static void DoLiteral(const unsigned char *value, void *user)
{
	KosinskiInstance *instance = (KosinskiInstance*)user;

	PutDescriptorBit(instance, 1);
	PutMatchByte(instance, value[0]);
}

static void DoMatch(size_t distance, size_t length, size_t offset, void *user)
{
	KosinskiInstance *instance = (KosinskiInstance*)user;

	(void)offset;

	if (length >= 2 && length <= 5 && distance <= 0x100)
	{
		PutDescriptorBit(instance, 0);
		PutDescriptorBit(instance, 0);
		PutDescriptorBit(instance, !!((length - 2) & 2));
		PutDescriptorBit(instance, !!((length - 2) & 1));
		PutMatchByte(instance, -distance & 0xFF);
	}
	else if (length >= 3 && length <= 9)
	{
		PutDescriptorBit(instance, 0);
		PutDescriptorBit(instance, 1);
		PutMatchByte(instance, -distance & 0xFF);
		PutMatchByte(instance, ((-distance >> (8 - 3)) & 0xF8) | ((length - 2) & 7));
	}
	else /*if (length >= 3)*/
	{
		PutDescriptorBit(instance, 0);
		PutDescriptorBit(instance, 1);
		PutMatchByte(instance, -distance & 0xFF);
		PutMatchByte(instance, (-distance >> (8 - 3)) & 0xF8);
		PutMatchByte(instance, length - 1);
	}
}

static size_t GetMatchCost(size_t distance, size_t length, void *user)
{
	(void)user;

	if (length >= 2 && length <= 5 && distance <= 0x100)
		return 2 + 2 + 8;  /* Descriptor bits, length bits, offset byte */
	else if (length >= 3 && length <= 9)
		return 2 + 16;     /* Descriptor bits, offset/length bytes */
	else if (length >= 3)
		return 2 + 16 + 8; /* Descriptor bits, offset bytes, length byte */
	else
		return 0;          /* In the event a match cannot be compressed */
}

static void FindExtraMatches(const unsigned char *data, size_t data_size, size_t offset, ClownLZSS_GraphEdge *node_meta_array, void *user)
{
	(void)data;
	(void)data_size;
	(void)offset;
	(void)node_meta_array;
	(void)user;
}

static CLOWNLZSS_MAKE_COMPRESSION_FUNCTION(CompressData, 1, 0x100, 0x2000, FindExtraMatches, 1 + 8, DoLiteral, GetMatchCost, DoMatch)

static void KosinskiCompressStream(const unsigned char *data, size_t data_size, MemoryStream *output_stream, void *user)
{
	KosinskiInstance instance;

	(void)user;

	instance.output_stream = output_stream;
	MemoryStream_Create(&instance.match_stream, CC_TRUE);
	instance.descriptor = 0;
	instance.descriptor_bits_remaining = TOTAL_DESCRIPTOR_BITS;

	CompressData(data, data_size, &instance);

	/* Terminator match */
	PutDescriptorBit(&instance, 0);
	PutDescriptorBit(&instance, 1);
	PutMatchByte(&instance, 0x00);
	PutMatchByte(&instance, 0xF0);
	PutMatchByte(&instance, 0x00);

	instance.descriptor >>= instance.descriptor_bits_remaining;
	FlushData(&instance);

	MemoryStream_Destroy(&instance.match_stream);
}

unsigned char* ClownLZSS_KosinskiCompress(const unsigned char *data, size_t data_size, size_t *compressed_size)
{
	return RegularWrapper(data, data_size, compressed_size, NULL, KosinskiCompressStream);
}

unsigned char* ClownLZSS_ModuledKosinskiCompress(const unsigned char *data, size_t data_size, size_t *compressed_size, size_t module_size)
{
	return ModuledCompressionWrapper(data, data_size, compressed_size, NULL, KosinskiCompressStream, module_size, 0x10);
}
