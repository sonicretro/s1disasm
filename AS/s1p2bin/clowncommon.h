/*
	(C) 2021 Clownacy

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

#ifndef CLOWNCOMMON_H
#define CLOWNCOMMON_H

/* Boolean */
typedef unsigned char cc_bool_small;
typedef unsigned int cc_bool_fast;
enum
{
	CC_FALSE = 0,
	CC_TRUE = 1
};

/* Common macros */
#define CC_MIN(a, b) ((a) < (b) ? (a) : (b))
#define CC_MAX(a, b) ((a) > (b) ? (a) : (b))
#define CC_CLAMP(x, min, max) (CC_MIN((max), CC_MAX((min), (x))))
#define CC_COUNT_OF(array) (sizeof(array) / sizeof(*array))

#endif /* CLOWNCOMMON_H */
