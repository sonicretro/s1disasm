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

#include "memory_stream.h"

#include <assert.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#include "clowncommon.h"

static cc_bool_fast ResizeIfNeeded(MemoryStream *memory_stream, size_t minimum_needed_size)
{
	if (minimum_needed_size > memory_stream->size)
	{
		unsigned char *buffer;

		size_t new_size = 1;
		while (new_size < minimum_needed_size)
			new_size <<= 1;

		buffer = (unsigned char*)realloc(memory_stream->buffer, new_size);

		if (buffer == NULL)
			return CC_FALSE;

		memory_stream->buffer = buffer;
		memset(memory_stream->buffer + memory_stream->size, 0, new_size - memory_stream->size);
		memory_stream->size = new_size;
	}

	if (minimum_needed_size > memory_stream->end)
		memory_stream->end = minimum_needed_size;

	return CC_TRUE;
}

void MemoryStream_Create(MemoryStream *memory_stream, cc_bool_fast free_buffer_when_destroyed)
{
	memory_stream->buffer = NULL;
	memory_stream->position = 0;
	memory_stream->end = 0;
	memory_stream->size = 0;
	memory_stream->free_buffer_when_destroyed = free_buffer_when_destroyed;
}

void MemoryStream_Destroy(MemoryStream *memory_stream)
{
	if (memory_stream->free_buffer_when_destroyed)
		free(memory_stream->buffer);
}

cc_bool_fast MemoryStream_WriteByte(MemoryStream *memory_stream, unsigned int byte)
{
	assert(byte < 0x100);

	if (!ResizeIfNeeded(memory_stream, memory_stream->position + 1))
		return CC_FALSE;

	memory_stream->buffer[memory_stream->position++] = byte;

	return CC_TRUE;
}

cc_bool_fast MemoryStream_Write(MemoryStream *memory_stream, const void *data, size_t size, size_t count)
{
	if (!ResizeIfNeeded(memory_stream, memory_stream->position + size * count))
		return CC_FALSE;

	memcpy(&memory_stream->buffer[memory_stream->position], data, size * count);
	memory_stream->position += size * count;

	return CC_TRUE;
}

size_t MemoryStream_Read(MemoryStream *memory_stream, void *output, size_t size, size_t count)
{
	const size_t elements_remaining = (memory_stream->end - memory_stream->position) / size;

	if (count > elements_remaining)
		count = elements_remaining;

	memcpy(output, &memory_stream->buffer[memory_stream->position], size * count);
	memory_stream->position += size * count;

	return count;
}

unsigned char* MemoryStream_GetBuffer(MemoryStream *memory_stream)
{
	return memory_stream->buffer;
}

size_t MemoryStream_GetPosition(MemoryStream *memory_stream)
{
	return memory_stream->position;
}

cc_bool_fast MemoryStream_SetPosition(MemoryStream *memory_stream, ptrdiff_t offset, enum MemoryStream_Origin origin)
{
	switch (origin)
	{
		case MEMORYSTREAM_START:
			memory_stream->position = (size_t)offset;
			break;

		case MEMORYSTREAM_CURRENT:
			memory_stream->position = (size_t)(memory_stream->position + offset);
			break;

		case MEMORYSTREAM_END:
			memory_stream->position = (size_t)(memory_stream->end + offset);
			break;

		default:
			return CC_FALSE;
	}

	return CC_TRUE;
}

void MemoryStream_Rewind(MemoryStream *memory_stream)
{
	memory_stream->position = 0;
}

void ROMemoryStream_Create(ROMemoryStream *ro_memory_stream, const void *data, size_t size)
{
	ro_memory_stream->memory_stream.buffer = (unsigned char*)data;
	ro_memory_stream->memory_stream.position = 0;
	ro_memory_stream->memory_stream.end = size;
	ro_memory_stream->memory_stream.size = size;
	ro_memory_stream->memory_stream.free_buffer_when_destroyed = CC_FALSE;
}

void ROMemoryStream_Destroy(ROMemoryStream *ro_memory_stream)
{
	MemoryStream_Destroy(&ro_memory_stream->memory_stream);
}

size_t ROMemoryStream_Read(ROMemoryStream *ro_memory_stream, void *output, size_t size, size_t count)
{
	return MemoryStream_Read(&ro_memory_stream->memory_stream, output, size, count);
}

size_t ROMemoryStream_GetPosition(ROMemoryStream *ro_memory_stream)
{
	return MemoryStream_GetPosition(&ro_memory_stream->memory_stream);
}

cc_bool_fast ROMemoryStream_SetPosition(ROMemoryStream *ro_memory_stream, ptrdiff_t offset, enum MemoryStream_Origin origin)
{
	return MemoryStream_SetPosition(&ro_memory_stream->memory_stream, offset, origin);
}

void ROMemoryStream_Rewind(ROMemoryStream *ro_memory_stream)
{
	MemoryStream_Rewind(&ro_memory_stream->memory_stream);
}
