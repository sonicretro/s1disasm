#ifndef _K_COMPRESSOR2_H_
#define _K_COMPRESSOR2_H_

#include <stdio.h>

long KComp3(unsigned char *srcBuffer, FILE *Dst, int SlideWin, int RecLen, int srcLen, bool Moduled);

#endif
