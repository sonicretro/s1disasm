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

#ifndef CLOWNLZSS_KOSINSKI_H
#define CLOWNLZSS_KOSINSKI_H

#include <stddef.h>

unsigned char* ClownLZSS_KosinskiCompress(const unsigned char *data, size_t data_size, size_t *compressed_size);
unsigned char* ClownLZSS_ModuledKosinskiCompress(const unsigned char *data, size_t data_size, size_t *compressed_size, size_t module_size);

#endif /* CLOWNLZSS_KOSINSKI_H */
