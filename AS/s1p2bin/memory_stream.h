#pragma once 

#ifndef __cplusplus
#include <stdbool.h>
#endif
#include <stddef.h>

typedef struct MemoryStream MemoryStream;

enum MemoryStream_Origin
{
	MEMORYSTREAM_START,
	MEMORYSTREAM_CURRENT,
	MEMORYSTREAM_END
};

MemoryStream* MemoryStream_Create(size_t growth, bool free_buffer_when_destroyed);
void MemoryStream_Destroy(MemoryStream *memory_stream);
void MemoryStream_WriteByte(MemoryStream *memory_stream, unsigned char byte);
void MemoryStream_WriteBytes(MemoryStream *memory_stream, unsigned char *bytes, size_t byte_count);
unsigned char* MemoryStream_GetBuffer(MemoryStream *memory_stream);
size_t MemoryStream_GetPosition(MemoryStream *memory_stream);
void MemoryStream_SetPosition(MemoryStream *memory_stream, ptrdiff_t offset, enum MemoryStream_Origin origin);
void MemoryStream_Rewind(MemoryStream *memory_stream);
