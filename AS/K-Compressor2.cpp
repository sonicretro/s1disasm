
// Modified for Sonic 1 DAC driver/Sonic & Knuckles sound driver compression.
// Such compression was already supported and correct, but did not exactly invert
// the decompression of the original data. Also, the function signature
// has been changed (and the function renamed to KComp3).
//
// Additionally, ALL of the library except this one C++ function has been deleted.
// The result should still qualify as a "library" as described in section 0 of the LGPL.

/*-----------------------------------------------------------------------------*\
|																				|
|	Kosinski.dll: Compression / Decompression of data in Kosinski format		|
|	Copyright © 2002-2004 The KENS Project Development Team						|
|																				|
|	This library is free software; you can redistribute it and/or				|
|	modify it under the terms of the GNU Lesser General Public					|
|	License as published by the Free Software Foundation; either				|
|	version 2.1 of the License, or (at your option) any later version.			|
|																				|
|	This library is distributed in the hope that it will be useful,				|
|	but WITHOUT ANY WARRANTY; without even the implied warranty of				|
|	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU			|
|	Lesser General Public License for more details.								|
|																				|
|	You should have received a copy of the GNU Lesser General Public			|
|	License along with this library; if not, write to the Free Software			|
|	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA	|
|																				|
\*-----------------------------------------------------------------------------*/

#include <stdio.h>

//-----------------------------------------------------------------------------------------------
// Name: KComp3(char *SrcFile, char *DstFile, int SlideWin, int RecLen, bool Moduled)
// Desc: Compresses the data using the Kosinski compression format
//-----------------------------------------------------------------------------------------------
long KComp3(FILE *Src, FILE *Dst, int SlideWin, int RecLen, int srcStart, int srcLen, bool Moduled)
{

// Pre-write infos
	unsigned short BITFIELD;
	unsigned char BFP;
	unsigned char Data[64];
	unsigned char DS;

// Buffer Infos
	unsigned char *Buffer;
	int BSize;
	int BPointer;
	int dstBytesWritten = 0;
	
// Count and Offest
	int ICount = 0;
	int IOffset = 0;

// Temp Info and Offest for writing
	unsigned short Info;
	unsigned short Off;

// Counters
	int i, imax, j=0, k;

// Moduled infos
	int FullSize;
	int CompBytes = 0;
	unsigned char High, Low;

//----------------------------------------------------------------------------------------------------------------

	if (Src==NULL) return 0;
	BSize=srcLen;
	Buffer = new unsigned char[BSize];
	if (Buffer==NULL) { return 0; }
	fseek(Src, srcStart, SEEK_SET);
	fread(Buffer,BSize,1,Src);

	BITFIELD=1;
	BFP=1;
	Data[0]=Buffer[0];
	BPointer=1;
	DS=1;

	if (Moduled)
	{
		if (BSize>65535) { fclose(Dst); return 0; }
		FullSize=BSize;
		if (BSize>0x1000) BSize=0x1000;
		High = (unsigned char)(FullSize >> 8);
		Low = (unsigned char)(FullSize & 0xFF);
		fwrite(&High,1,1,Dst);
		fwrite(&Low,1,1,Dst);
	}

//----------------------------------------------------------------------------------------------------------------

start:
	ICount=RecLen; if (BSize-BPointer<RecLen) { ICount=BSize; ICount-=BPointer; }
	k=1;
	imax = BPointer; imax-=SlideWin; if (imax<0) imax=0;
	i=BPointer; --i;

	do {
		j=0;
		while ( Buffer[i+j] == Buffer[BPointer+j] ) { if(++j>=ICount) break; }
		if (j>k) { k=j; IOffset=i; }
	} while (i-->imax);
	ICount=k;

//----------------------------------------------------------------------------------------------------------------

write:
	if (ICount==1)
	{
		BITFIELD|=1<<BFP; // 2^BFP
		if (++BFP==16) { fwrite(&BITFIELD,2,1,Dst); fwrite(&Data,DS,1,Dst); dstBytesWritten += 2+DS; BITFIELD=BFP=DS=0; }	
		
		Data[DS]=Buffer[BPointer];
		DS+=1;
	}

	else if ( (ICount==2) & (BPointer-IOffset>=256) )
	{
		BITFIELD|=1<<BFP; // 2^BFP
		if (++BFP==16) { fwrite(&BITFIELD,2,1,Dst); fwrite(&Data,DS,1,Dst); dstBytesWritten += 2+DS; BITFIELD=BFP=DS=0; }

		Data[DS]=Buffer[BPointer];
		DS+=1;

		--ICount;
	}

	else if ( (ICount < 6) & (BPointer-IOffset<256) )
	{
		if (++BFP==16) { fwrite(&BITFIELD,2,1,Dst); fwrite(&Data,DS,1,Dst); dstBytesWritten += 2+DS; BITFIELD=BFP=DS=0; }

		if (++BFP==16) { fwrite(&BITFIELD,2,1,Dst); fwrite(&Data,DS,1,Dst); dstBytesWritten += 2+DS; BITFIELD=BFP=DS=0; }

		if ( ((ICount-2) & 0x02) == 0x02) BITFIELD|=1<<BFP; // 2^BFP
		if (++BFP==16) { fwrite(&BITFIELD,2,1,Dst); fwrite(&Data,DS,1,Dst); dstBytesWritten += 2+DS; BITFIELD=BFP=DS=0; }

		if ( ((ICount-2) & 0x01) == 0x01) BITFIELD|=1<<BFP; // 2^BFP
		if (++BFP==16) { fwrite(&BITFIELD,2,1,Dst); fwrite(&Data,DS,1,Dst); dstBytesWritten += 2+DS; BITFIELD=BFP=DS=0; }

		Data[DS]=static_cast<char>(~(BPointer-IOffset-1));
		DS+=1;
	}

	else
	{
		if (++BFP==16) { fwrite(&BITFIELD,2,1,Dst); fwrite(&Data,DS,1,Dst); dstBytesWritten += 2+DS; BITFIELD=BFP=DS=0; }

		BITFIELD|=1<<BFP; // 2^BFP
		if (++BFP==16) { fwrite(&BITFIELD,2,1,Dst); fwrite(&Data,DS,1,Dst); dstBytesWritten += 2+DS; BITFIELD=BFP=DS=0; }

		if (ICount-2<8)
		{
			Off = static_cast<short>(BPointer-IOffset-1);
			Info = static_cast<short>( ( ~( (Off << 8) | (Off >> 5) ) & 0xFFF8 ) | static_cast<char>(ICount - 2)  );
			Data[DS] = static_cast<char>( Info >> 8 );
			Data[DS+1] = static_cast<char>( Info & 0x00FF );
			DS+=2;
		}
		else
		{
			Off = static_cast<short>(BPointer-IOffset-1);
			Info = static_cast<short>( ~( (Off << 8) | (Off >> 5) ) & 0xFFF8 );
			Data[DS] = static_cast<char>( Info >> 8 );
			Data[DS+1] = static_cast<char>( Info & 0x00FF );
			Data[DS+2] = static_cast<char>(ICount - 1);
			DS+=3;
		}
	}

//----------------------------------------------------------------------------------------------------------------

	BPointer+=ICount;
	if (BPointer<BSize) goto start;

//----------------------------------------------------------------------------------------------------------------
	if (++BFP==16) { fwrite(&BITFIELD,2,1,Dst); fwrite(&Data,DS,1,Dst); dstBytesWritten += 2+DS; BITFIELD=BFP=DS=0; }

	BITFIELD|=1<<BFP; // 2^BFP
	if (++BFP==16) { fwrite(&BITFIELD,2,1,Dst); fwrite(&Data,DS,1,Dst); dstBytesWritten += 2+DS; BITFIELD=BFP=DS=0; }

	Data[DS] = 0x00;
	Data[DS+1] = 0xF0;
	Data[DS+2] = 0x00;
	DS+=3;

	fwrite(&BITFIELD,2,1,Dst); fwrite(&Data,DS,1,Dst); dstBytesWritten += 2+DS; BITFIELD=BFP=DS=0;

	if (Moduled)
	{
		fseek(Dst, (16-(ftell(Dst)-2)%16)&0xF, SEEK_CUR);
		CompBytes+=BSize;
		Buffer+=BSize;
		if (CompBytes<FullSize)
		{
			BSize=0x1000;
			if (FullSize-CompBytes<0x1000) BSize=FullSize-CompBytes;
			BITFIELD=1;
			BFP=1;
			Data[0]=Buffer[0];
			BPointer=1;
			DS=1;
			goto start;
		}
	}

	if (Moduled) Buffer-=FullSize;
	delete[] Buffer;

	return dstBytesWritten;
}
