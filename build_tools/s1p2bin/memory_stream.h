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

#ifndef MEMORY_STREAM_H
#define MEMORY_STREAM_H

#include <stddef.h>

#include "clowncommon.h"

typedef struct MemoryStream
{
	unsigned char *buffer;
	size_t position;
	size_t end;
	size_t size;
	cc_bool_small free_buffer_when_destroyed;
} MemoryStream;

typedef struct ROMemoryStream
{
	MemoryStream memory_stream;
} ROMemoryStream;

enum MemoryStream_Origin
{
	MEMORYSTREAM_START,
	MEMORYSTREAM_CURRENT,
	MEMORYSTREAM_END
};

#ifdef __cplusplus
extern "C" {
#endif

void MemoryStream_Create(MemoryStream *memory_stream, cc_bool_fast free_buffer_when_destroyed);
void MemoryStream_Destroy(MemoryStream *memory_stream);
cc_bool_fast MemoryStream_WriteByte(MemoryStream *memory_stream, unsigned int byte);
cc_bool_fast MemoryStream_Write(MemoryStream *memory_stream, const void *data, size_t size, size_t count);
size_t MemoryStream_Read(MemoryStream *memory_stream, void *output, size_t size, size_t count);
unsigned char* MemoryStream_GetBuffer(MemoryStream *memory_stream);
size_t MemoryStream_GetPosition(MemoryStream *memory_stream);
cc_bool_fast MemoryStream_SetPosition(MemoryStream *memory_stream, ptrdiff_t offset, enum MemoryStream_Origin origin);
void MemoryStream_Rewind(MemoryStream *memory_stream);

void ROMemoryStream_Create(ROMemoryStream *ro_memory_stream, const void *data, size_t size);
void ROMemoryStream_Destroy(ROMemoryStream *ro_memory_stream);
size_t ROMemoryStream_Read(ROMemoryStream *ro_memory_stream, void *output, size_t size, size_t count);
size_t ROMemoryStream_GetPosition(ROMemoryStream *ro_memory_stream);
cc_bool_fast ROMemoryStream_SetPosition(ROMemoryStream *ro_memory_stream, ptrdiff_t offset, enum MemoryStream_Origin origin);
void ROMemoryStream_Rewind(ROMemoryStream *ro_memory_stream);

#ifdef __cplusplus
}
#endif

#endif /* MEMORY_STREAM_H */
