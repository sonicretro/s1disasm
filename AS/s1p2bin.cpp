#include <string.h>
#include <stdio.h>
#include <unistd.h> // for unlink

const char* codeFileName = NULL;
const char* romFileName = NULL;
int compressedLength = 0;

void printUsage() { printf("usage: s1p2bin.exe inputcodefile.p outputromfile.bin\n"); }
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
		
		if(!strcasecmp(arg, "-h") || !strcasecmp(arg, "--help"))
			printUsage(), argc = 0;
		else if(!codeFileName)
			codeFileName = arg;
		else if(!romFileName)
			romFileName = arg;
	}

	if(codeFileName && romFileName)
	{
		printf("\ns1p2bin.exe: generating %s from %s", romFileName, codeFileName);
		
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
					printf(" ... done.");
				}
				else
				{
					unlink(romFileName); // error; delete the ROM because it's probably hosed
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

long KComp3(FILE *Src, FILE *Dst, int SlideWin, int RecLen, int srcStart, int srcLen, bool Moduled);

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
		if(ferror(from) || feof(from))
			break;

		switch(headerByte)
		{
			case 0x00: // "END" segment
				return true;
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
			printf("\nERROR: negative start address ($%X).", start), start = 0;
			return false;
		}

		if(cpuType == 0x51 && start != 0 && lastSegmentCompressed)
		{
			printf("\nERROR: The compressed Z80 code (z80.asm) must all be in one segment. That means no ORG/ALIGN/CNOP/EVEN or memory reservation commands in the Z80 code and the size must be < 65535 bytes. The offending new segment starts at address $%X relative to the start of the Z80 code.", start);
			return false;
		}

		if(cpuType == 0x51 && start == 0) // 0x51 is the type for Z80 family (0x01 is for 68000)
		{
			// Kosinski-compressed Z80 segment
			start = lastStart + lastLength;
			int srcStart = ftell(from);
			compressedLength = KComp3(from, to, 8192, 256, srcStart, length, false);
			fseek(from, srcStart + length, SEEK_SET);
			lastSegmentCompressed = true;
			continue;
		}

		long cur = ftell(to);

		if(!lastSegmentCompressed)
		{
			if(start+3 < cur) // 3 bytes of leeway for instruction patching
				printf("\nWarning: overlapping allocation detected! $%X < $%X", start, ftell(to));
		}
		else
		{
			if(start < cur)
			{
				printf("\nERROR: Compressed DAC driver might not fit.\nPlease increase your value of Size_of_DAC_driver_guess to at least $%X and try again.", compressedLength);
				return false;
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

	return true;
}
