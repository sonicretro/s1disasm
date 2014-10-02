
import os
import platform
from subprocess import call
import subprocess

# Paths to build tools, depending on OS

if platform.system() == "Windows":
	asBinary = "AS/Win32/asw.exe";
	s1p2binBinary = "AS/Win32/s1p2bin.exe";
	fixheaderBinary = "fixheader.exe";
	
elif platform.system() == "Darwin": # Osx
	asBinary = "AS/Osx/asl";
	s1p2binBinary = "AS/Osx/p2bin";
	print("Checksum calculation unavailable on your platform")
	
elif platform.system() == "Linux":
	# You'll need to find a linux version of the tools and set their file paths here
	# ...
	print("Linux not configured")
	
else:
	print("Unknown platform")


def delete(path):
	if os.path.isfile(path):
		os.remove(path);
	

def move(path1, path2):
	if os.path.isfile(path1):
		os.rename(path1, path2);
	

def run():

	if platform.system() == "Windows":
		os.environ["AS_MSGPATH"] = "AS/Win32";
		os.environ["USEANSI"] = "n";
	
	# Build ROM
		print("Building s1built");

	# Create full paths for all files
	romPath = "s1built.bin";	
	romPathPrev = "s1built.prev.bin";
	errorsPath = "sonic.log";
	outputPath = "_Output.txt";
	binaryOutputPath = "_BinaryOutput.txt";
	
	print("  Cleaning previous build");
	# Remove old output
	delete(romPathPrev);
	move(romPath, romPathPrev);
	delete(errorsPath);
	delete(outputPath);
	delete(binaryOutputPath);
	delete("sonic.p");
	
	assembleCommand = [asBinary, "-xx", "-n", "-q", "-A", "-L"];
	
	# Input asm file
	assembleCommand.append("sonic.asm");
	
	print("  Assembling .p file");
	
	assembleProcess = subprocess.Popen(assembleCommand, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	output, errors = assembleProcess.communicate()
	errorsFile = open(errorsPath, "w")
	errorsFile.write(errors)
	errorsFile.close()
	outputFile = open(outputPath, "w")
	outputFile.write(output)
	outputFile.close()
	
	# Create binary
	
	binaryCommand = [s1p2binBinary, "sonic.p", romPath];
	
	# Output file
	
	print("  Converting .p to .bin");
	
	binaryProcess = subprocess.Popen(binaryCommand, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	output, errors = binaryProcess.communicate()
	outputFile = open(binaryOutputPath, "w")
	outputFile.write(output)
	outputFile.close()
	
	# Fixing checksum

	if platform.system() == "Windows":
		print("  Calculating checksum");
		binaryCommand = [fixheaderBinary, "s1built.bin"];
		binaryProcess = subprocess.Popen(binaryCommand, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	
	print("  Removing temporary files");
	
	# delete working files
	delete("sonic.p");

	
	print("Finished!");
	
