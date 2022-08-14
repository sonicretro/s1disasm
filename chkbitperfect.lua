#!/usr/bin/env lua

local clownmd5 = require "build_tools.lua.clownmd5"

-- Prevent build.lua's calls to os.exit from terminating the program.
local os_exit = os.exit
os.exit = coroutine.yield

-- Build the ROM.
local co = coroutine.create(function() dofile("build.lua") end)
assert(coroutine.resume(co))

-- Restore os.exit back to normal.
os.exit = os_exit

-- Hash the ROM.
local hash = clownmd5.HashFile("s1built.bin")

-- Verify the hash against known builds.
print "-------------------------------------------------------------"

if hash == "\x1B\xC6\x74\xBE\x03\x4E\x43\xC9\x6B\x86\x48\x7A\xC6\x9D\x92\x93" then
	print "ROM is bit-perfect with REV00."
elseif hash == "\x09\xDA\xDB\x50\x71\xEB\x35\x05\x00\x67\xA3\x24\x62\xE3\x9C\x5F" then
	print "ROM is bit-perfect with REV01."
elseif hash == "\xC6\xC1\x5A\xEA\x60\xBD\xA1\x0A\xE1\x1C\x6B\xC3\x75\x29\x61\x53" then
	print "ROM is bit-perfect with REVXB."
else
	print "ROM is not bit-perfect with REV00, REV01, or REVXB."
end
