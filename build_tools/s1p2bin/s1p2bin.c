#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "accurate-kosinski/kosinski_compress.h"
#include "clownlzss/kosinski.h"

const char* codeFileName = NULL;
const char* romFileName = NULL;
size_t compressedLength = 0;
bool accurate_compression;

unsigned char Z80_RAM_buffer[0x2000];
int current_Z80_size = 0;

void printUsage() { printf("usage: s1p2bin [-a | --accurate] inputcodefile.p outputromfile.bin sharefile.h\n\n  -a, --accurate    use weaker sound driver compression that's accurate to\n                    the original ROM"); }
bool buildRom(FILE* from, FILE* to);

int main(int argc, char *argv[])
{
//	for(int i = 0 ; i < argc ; i++)
//		printf("arg %d is %s\n", i, argv[i]);

	if(argc > 2)
		argc--, argv++; // skip the exe filename

	if(argc < 2)
		printUsage();

	while(argc)
	{
		char* arg = argv[0];
		argc--, argv++; // pop arg
		
		if(!strcmp(arg, "-h") || !strcmp(arg, "--help"))
			printUsage(), argc = 0;
		else if (!strcmp(arg, "-a") || !strcmp(arg, "--accurate"))
			accurate_compression = true;
		else if(!codeFileName)
			codeFileName = arg;
		else if(!romFileName)
			romFileName = arg;
	}

	if(codeFileName && romFileName)
	{
		printf("\ns1p2bin: generating %s from %s...", romFileName, codeFileName);

		FILE* from = fopen(codeFileName, "rb");
		if(from)
		{
			FILE* to = fopen(romFileName, "wb");
			if(to)
			{
				bool built = buildRom(from, to);
				fclose(to);
				fclose(from);
				if(built)
				{
					printf("\n...done.");
				}
				else
				{
					remove(romFileName); // error; delete the ROM because it's probably hosed
				}
			}
			else
				printf("\nERROR: Failed to access file \"%s\".", romFileName);
		}
		else
			printf("\nERROR: Failed to load file \"%s\".", codeFileName);
	}
	
	printf("\n");
//	system("PAUSE");
	return 0;
}

void CompressZ80Driver(FILE *to)
{
	unsigned char *compressed_buffer;

	if (accurate_compression)
		compressedLength = KosinskiCompress(Z80_RAM_buffer, current_Z80_size, &compressed_buffer);
	else
		compressed_buffer = ClownLZSS_KosinskiCompress(Z80_RAM_buffer, current_Z80_size, &compressedLength);

	fwrite(compressed_buffer, compressedLength, 1, to);
	free(compressed_buffer);
}

bool buildRom(FILE* from, FILE* to)
{
	if(fgetc(from) != 0x89) printf("\nWarning: First byte of a .p file should be $89");
	if(fgetc(from) != 0x14) printf("\nWarning: Second byte of a .p file should be $14");
	
	int cpuType = 0, segmentType = 0, granularity = 0;
	signed long start = 0, lastStart = 0;
	unsigned short length = 0, lastLength = 0;
	long maxpos = 0;
	static const int scratchSize = 4096;
	unsigned char scratch [scratchSize];
	bool lastSegmentCompressed = false;
	
	while(true)
	{
		unsigned char headerByte = fgetc(from);
		if(ferror(from) || feof(from) || headerByte == 0 /* "END" segment */)
			break;

		switch(headerByte)
		{
			case 0x80: // "entry point" segment
				fseek(from, 3, SEEK_CUR);
				continue;
			case 0x81:  // code or data segment
				cpuType = fgetc(from);
				segmentType = fgetc(from);
				granularity = fgetc(from);
				if(granularity != 1)
					{ printf("\nERROR: Unsupported granularity %d.", granularity); return false; }
				break;
			default:
				if(headerByte > 0x81)
					{ printf("\nERROR: Unsupported segment header $%02X", headerByte); return false; }
				cpuType = headerByte;
				break;
		}

		start = fgetc(from); // integers in AS .p files are always little endian
		start |= fgetc(from) << 8;
		start |= fgetc(from) << 16;
		start |= fgetc(from) << 24;
		length = fgetc(from);
		length |= fgetc(from) << 8;

		if(length == 0)
		{
			// error instead of warning because I had quite a bad freeze the one time I saw this warning go off
			printf("\nERROR: zero length segment ($%X).", length);
			return false;
		}

		if(start < 0)
		{
			printf("\nERROR: negative start address ($%lX).", start), start = 0;
			return false;
		}

		if(cpuType == 0x51 && start == 0) // 0x51 is the type for Z80 family (0x01 is for 68000)
		{
			// First Kosinski-compressed Z80 segment
			current_Z80_size = length;

			if (current_Z80_size > 0x2000)
			{
				printf("\nERROR: Compressed Z80 segment goes past end of Z80 RAM (segment ends at $%X, Z80 RAM ends at $2000).", current_Z80_size);
				return false;
			}

			fread(Z80_RAM_buffer, 1, length, from);

			lastSegmentCompressed = true;
			continue;
		}

		if(cpuType == 0x51 && start != 0 && lastSegmentCompressed)
		{
			// Following Kosinski-compressed Z80 segment
			if (start + length > current_Z80_size)
				current_Z80_size = start + length;

			if (current_Z80_size > 0x2000)
			{
				printf("\nERROR: Compressed Z80 segment goes past end of Z80 RAM (segment ends at $%X, Z80 RAM ends at $2000).", current_Z80_size);
				return false;
			}

			fread(Z80_RAM_buffer + start, 1, length, from);

			continue;
		}

		if(cpuType != 0x51 && lastSegmentCompressed)
		{
			// Compress all Z80 segments found
			CompressZ80Driver(to);
		}

		long cur = ftell(to);

		if(!lastSegmentCompressed)
		{
			if(start+3 < cur) // 3 bytes of leeway for instruction patching
				printf("\nWarning: overlapping allocation detected! $%lX < $%lX", start, ftell(to));
		}
		else
		{
			if(start < cur)
			{
				#ifdef __MINGW32__
				#define PRINTF __mingw_printf
				#else
				#define PRINTF printf
				#endif
				PRINTF("\nERROR: Compressed DAC driver might not fit.\nPlease increase your value of Size_of_DAC_driver_guess to at least $%zX and try again.", compressedLength);
				return false;
			}
			else
			{
				printf("\n  Compressed DAC driver size: $%zX\n  Set Size_of_DAC_driver_guess to this to save a little space.", compressedLength);
			}
		}

		// hack to make padding directives use 0xFF without breaking backwards orgs
		if (start < cur || start < maxpos)
			fseek(to, start, SEEK_SET);
		else
			while (cur < start)
			{
				int dif = start - cur;
				if (dif > scratchSize)
					dif = scratchSize;
				memset(scratch, lastSegmentCompressed ? 0 : -1, dif);
				fwrite(scratch, dif, 1, to);
				cur += dif;
			}

//		printf("copying $%X-$%X -> $%X-$%X\n", ftell(from), ftell(from)+length, start, start+length);
		while(length)
		{
			int copy = length;
			if(copy > scratchSize)
				copy = scratchSize;
			fread(scratch, copy, 1, from);
			fwrite(scratch, copy, 1, to);
			length -= copy;
		}

		cur = ftell(to);
		if (cur > maxpos)
			maxpos = cur;

		lastStart = start;
		lastLength = length;
		lastSegmentCompressed = false;
	}

	if (lastSegmentCompressed)
	{
		// Do this here too, just in case the last Z80 segment was at the end of the ROM
		CompressZ80Driver(to);
	}

	return true;
}
