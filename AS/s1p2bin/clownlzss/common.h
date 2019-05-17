#pragma once

#include <stddef.h>

#include "memory_stream.h"

unsigned char* RegularWrapper(unsigned char *data, size_t data_size, size_t *compressed_size, void *user_data, void (*function)(unsigned char *data, size_t data_size, MemoryStream *output_stream, void *user_data));
unsigned char* ModuledCompressionWrapper(unsigned char *data, size_t data_size, size_t *compressed_size, void *user_data, void (*function)(unsigned char *data, size_t data_size, MemoryStream *output_stream, void *user_data), size_t module_size, size_t module_alignment);
