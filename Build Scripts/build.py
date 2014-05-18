
import os
import platform
from subprocess import call
import subprocess

# Paths to build tools, depending on OS

if platform.system() == "Windows":
	asBinary = "AS/Win32/asw.exe";
	s3p2binBinary = "AS/Win32/p2bin.exe";
	
elif platform.system() == "Darwin": # Osx
	asBinary = "AS/Osx/asl";
	s3p2binBinary = "AS/Osx/p2bin";
	
elif platform.system() == "Linux":
	# You'll need to find a linux version of the tools and set their file paths here
	# ...
	print("Linux not configured")
	
else:
	print("Unknown platform")


def delete(path):
	if os.path.isfile(path):
		os.remove(path);


def makeDir(path):
	if not os.path.isdir(path):
		os.mkdir(path);


def build(targetName, def0, def1):
	
	print("Building "+targetName);

	# Create full paths for all files
	romPath = targetName + ".bin";	
	errorsPath = "Build/" + targetName + "Errors.txt";
	outputPath = "Build/" + targetName + "Output.txt";
	binaryOutputPath = "Build/" + targetName + "BinaryOutput.txt";
	
	print("  Cleaning previous build");
	# Remove old output
	delete(romPath);
	delete(errorsPath);
	delete(outputPath);
	delete(binaryOutputPath);
	delete("sonic3k.p");
	
	assembleCommand = [asBinary, "-x", "-xx", "-n", "-c", "-E", errorsPath, "-A"];
	
	assembleCommand.append(def0);
	assembleCommand.append(def1);
	
	# Input asm file
	assembleCommand.append("sonic3k.asm");
	
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
	
	binaryCommand = [s3p2binBinary, "sonic3k.p", romPath, "sonic3k.h"];
	
	# Output file
	
	print("  Converting .p to .bin");
	
	binaryProcess = subprocess.Popen(binaryCommand, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	output, errors = binaryProcess.communicate()
	outputFile = open(binaryOutputPath, "w")
	outputFile.write(output)
	outputFile.close()
	
	print("  Removing temporary files");
	
	# delete working files
	delete("sonic3k.p");
	delete("sonic3k.h");
	

def compare(filePath1, filePath2):

	print("  Comparing '"+filePath1+"' with '"+filePath2+"'");
	
	size1 = os.stat(filePath1).st_size;
	size2 = os.stat(filePath2).st_size;
	
	if size1 != size2:
		print("  Different file sizes!");
		return False;
	
	file1 = open(filePath1, "rb");
	file2 = open(filePath2, "rb");
	try:
		while True:
			byte1 = file1.read(1);
			if byte1 == "":
				break;
			byte2 = file2.read(1);
			
			if byte2 == "":
				break;
				
			if byte1 != byte2:
				print("  Files are different!");
				return False;
	finally:
		file1.close()
		file2.close()
    
	print("  s&k rom verified ok");
	return True;
	

def run(build3k, buildSK, verifySK):

	# Navigate to base dir
	os.chdir("..");
	
	if platform.system() == "Windows":
		os.environ["AS_MSGPATH"] = "AS/Win32";
		os.environ["USEANSI"] = "n";
	
	# Create build dir
	makeDir("Build");
	
	# Build Sonic3&K Complete rom
	if build3k:
		build("sonic3k", "-D", "Sonic3_Complete=1");
	
	# Build S&K rom
	if buildSK:
		build("skbuilt", "-D", "Sonic3_Complete=0");
	
	# Compare the newly built s&k rom with the actual rom to make sure it's byte-identical
	if verifySK:
		compare("skbuilt.bin", "Build Scripts/sk.bin");
	
	print("Finished!");
	
