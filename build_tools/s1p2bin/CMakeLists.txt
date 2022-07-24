cmake_minimum_required(VERSION 3.20)

project(s1p2bin LANGUAGES C)

add_executable(s1p2bin 
	"s1p2bin.c"
	"memory_stream.c"
	"accurate-kosinski/kosinski_compress.c"
	"clownlzss/common.c"
	"clownlzss/kosinski.c"
)

target_include_directories(s1p2bin PRIVATE ".")
