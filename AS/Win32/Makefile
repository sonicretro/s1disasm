CXXFLAGS := -O3 --static

all: s1p2bin.exe s1p2bin_plus.exe

s1p2bin.exe: ../s1p2bin.cpp ../KENSKosComp/K-Compressor2.cpp
	$(CXX) $(CXXFLAGS) -o $@ $^

s1p2bin_plus.exe: ../s1p2bin.cpp ../FW_KENSC/kosinski.cc
	$(CXX) $(CXXFLAGS) -DS1P2BIN_PLUS -o $@ $^
