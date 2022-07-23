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

#include "common.h"

#include <stddef.h>
#include <stdlib.h>

#include "memory_stream.h"

unsigned char* RegularWrapper(const unsigned char *data, size_t data_size, size_t *compressed_size, void *user_data, void (*function)(const unsigned char *data, size_t data_size, MemoryStream *output_stream, void *user_data))
{
	MemoryStream output_stream;
	unsigned char *out_buffer;

	MemoryStream_Create(&output_stream, CC_FALSE);

	function(data, data_size, &output_stream, user_data);

	out_buffer = MemoryStream_GetBuffer(&output_stream);

	if (compressed_size != NULL)
		*compressed_size = MemoryStream_GetPosition(&output_stream);

	MemoryStream_Destroy(&output_stream);

	return out_buffer;
}

unsigned char* ModuledCompressionWrapper(const unsigned char *data, size_t data_size, size_t *out_compressed_size, void *user_data, void (*function)(const unsigned char *data, size_t data_size, MemoryStream *output_stream, void *user_data), size_t module_size, size_t module_alignment)
{
	size_t header;
	size_t compressed_size, i;
	unsigned char *out_buffer;

	MemoryStream output_stream;
	MemoryStream_Create(&output_stream, CC_FALSE);

	header = (data_size % module_size) | ((data_size / module_size) << 12);

	MemoryStream_WriteByte(&output_stream, (header >> 8) & 0xFF);
	MemoryStream_WriteByte(&output_stream, (header >> 0) & 0xFF);

	for (compressed_size = 0, i = 0; i < data_size; i += module_size)
	{
		size_t start;

		if (compressed_size % module_alignment != 0)
		{
			size_t j;

			for (j = 0; j < module_alignment - (compressed_size % module_alignment); ++j)
				MemoryStream_WriteByte(&output_stream, 0);
		}

		start = MemoryStream_GetPosition(&output_stream);
		function(data + i, module_size < data_size - i ? module_size : data_size - i, &output_stream, user_data);
		compressed_size = MemoryStream_GetPosition(&output_stream) - start;
	}

	out_buffer = MemoryStream_GetBuffer(&output_stream);

	if (out_compressed_size != NULL)
		*out_compressed_size = MemoryStream_GetPosition(&output_stream);

	MemoryStream_Destroy(&output_stream);

	return out_buffer;
}
