--[[
 * This is free and unencumbered software released into the public domain.
 *
 * Anyone is free to copy, modify, publish, use, compile, sell, or
 * distribute this software, either in source code form or as a compiled
 * binary, for any purpose, commercial or non-commercial, and by any
 * means.
 *
 * In jurisdictions that recognize copyright laws, the author or authors
 * of this software dedicate any and all copyright interest in the
 * software to the public domain. We make this dedication for the benefit
 * of the public at large and to the detriment of our heirs and
 * successors. We intend this dedication to be an overt act of
 * relinquishment in perpetuity of all present and future rights to this
 * software under copyright law.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 * For more information, please refer to <https://unlicense.org>
]]

-- The variables in this file are named to match those described by RFC 1321

local function F(X, Y, Z)
	return (X & Y) | (~X & Z)
end

local function G(X, Y, Z)
	return (X & Z) | (Y & ~Z)
end

local function H(X, Y, Z)
	return X ~ Y ~ Z
end

local function I(X, Y, Z)
	return Y ~ (X | ~Z)
end

local function RotateLeft32Bit(value, bits_to_rotate_by)
	return (value << bits_to_rotate_by) | ((value & 0xFFFFFFFF) >> (32 - bits_to_rotate_by))
end

local function DoRound(a, b, c, d, x, s, ac, f)
	return b + RotateLeft32Bit((a + f(b, c, d) + x + ac), s)
end

local function ProcessBlock(self, X)
	local A = self.A
	local B = self.B
	local C = self.C
	local D = self.D

	-- Round 1.
	A = DoRound(A, B, C, D, X[ 1],  7, 0xD76AA478, F)
	D = DoRound(D, A, B, C, X[ 2], 12, 0xE8C7B756, F)
	C = DoRound(C, D, A, B, X[ 3], 17, 0x242070DB, F)
	B = DoRound(B, C, D, A, X[ 4], 22, 0xC1BDCEEE, F)

	A = DoRound(A, B, C, D, X[ 5],  7, 0xF57C0FAF, F)
	D = DoRound(D, A, B, C, X[ 6], 12, 0x4787C62A, F)
	C = DoRound(C, D, A, B, X[ 7], 17, 0xA8304613, F)
	B = DoRound(B, C, D, A, X[ 8], 22, 0xFD469501, F)

	A = DoRound(A, B, C, D, X[ 9],  7, 0x698098D8, F)
	D = DoRound(D, A, B, C, X[10], 12, 0x8B44F7AF, F)
	C = DoRound(C, D, A, B, X[11], 17, 0xFFFF5BB1, F)
	B = DoRound(B, C, D, A, X[12], 22, 0x895CD7BE, F)

	A = DoRound(A, B, C, D, X[13],  7, 0x6B901122, F)
	D = DoRound(D, A, B, C, X[14], 12, 0xFD987193, F)
	C = DoRound(C, D, A, B, X[15], 17, 0xA679438E, F)
	B = DoRound(B, C, D, A, X[16], 22, 0x49B40821, F)

	-- Round 2.
	A = DoRound(A, B, C, D, X[ 2],  5, 0xF61E2562, G)
	D = DoRound(D, A, B, C, X[ 7],  9, 0xC040B340, G)
	C = DoRound(C, D, A, B, X[12], 14, 0x265E5A51, G)
	B = DoRound(B, C, D, A, X[ 1], 20, 0xE9B6C7AA, G)

	A = DoRound(A, B, C, D, X[ 6],  5, 0xD62F105D, G)
	D = DoRound(D, A, B, C, X[11],  9, 0x02441453, G)
	C = DoRound(C, D, A, B, X[16], 14, 0xD8A1E681, G)
	B = DoRound(B, C, D, A, X[ 5], 20, 0xE7D3FBC8, G)

	A = DoRound(A, B, C, D, X[10],  5, 0x21E1CDE6, G)
	D = DoRound(D, A, B, C, X[15],  9, 0xC33707D6, G)
	C = DoRound(C, D, A, B, X[ 4], 14, 0xF4D50D87, G)
	B = DoRound(B, C, D, A, X[ 9], 20, 0x455A14ED, G)

	A = DoRound(A, B, C, D, X[14],  5, 0xA9E3E905, G)
	D = DoRound(D, A, B, C, X[ 3],  9, 0xFCEFA3F8, G)
	C = DoRound(C, D, A, B, X[ 8], 14, 0x676F02D9, G)
	B = DoRound(B, C, D, A, X[13], 20, 0x8D2A4C8A, G)

	-- Round 3.
	A = DoRound(A, B, C, D, X[ 6],  4, 0xFFFA3942, H)
	D = DoRound(D, A, B, C, X[ 9], 11, 0x8771F681, H)
	C = DoRound(C, D, A, B, X[12], 16, 0x6D9D6122, H)
	B = DoRound(B, C, D, A, X[15], 23, 0xFDE5380C, H)

	A = DoRound(A, B, C, D, X[ 2],  4, 0xA4BEEA44, H)
	D = DoRound(D, A, B, C, X[ 5], 11, 0x4BDECFA9, H)
	C = DoRound(C, D, A, B, X[ 8], 16, 0xF6BB4B60, H)
	B = DoRound(B, C, D, A, X[11], 23, 0xBEBFBC70, H)

	A = DoRound(A, B, C, D, X[14],  4, 0x289B7EC6, H)
	D = DoRound(D, A, B, C, X[ 1], 11, 0xEAA127FA, H)
	C = DoRound(C, D, A, B, X[ 4], 16, 0xD4EF3085, H)
	B = DoRound(B, C, D, A, X[ 7], 23, 0x04881D05, H)

	A = DoRound(A, B, C, D, X[10],  4, 0xD9D4D039, H)
	D = DoRound(D, A, B, C, X[13], 11, 0xE6DB99E5, H)
	C = DoRound(C, D, A, B, X[16], 16, 0x1FA27CF8, H)
	B = DoRound(B, C, D, A, X[ 3], 23, 0xC4AC5665, H)

	-- Round 4.
	A = DoRound(A, B, C, D, X[ 1],  6, 0xF4292244, I)
	D = DoRound(D, A, B, C, X[ 8], 10, 0x432AFF97, I)
	C = DoRound(C, D, A, B, X[15], 15, 0xAB9423A7, I)
	B = DoRound(B, C, D, A, X[ 6], 21, 0xFC93A039, I)

	A = DoRound(A, B, C, D, X[13],  6, 0x655B59C3, I)
	D = DoRound(D, A, B, C, X[ 4], 10, 0x8F0CCC92, I)
	C = DoRound(C, D, A, B, X[11], 15, 0xFFEFF47D, I)
	B = DoRound(B, C, D, A, X[ 2], 21, 0x85845DD1, I)

	A = DoRound(A, B, C, D, X[ 9],  6, 0x6FA87E4F, I)
	D = DoRound(D, A, B, C, X[16], 10, 0xFE2CE6E0, I)
	C = DoRound(C, D, A, B, X[ 7], 15, 0xA3014314, I)
	B = DoRound(B, C, D, A, X[14], 21, 0x4E0811A1, I)

	A = DoRound(A, B, C, D, X[ 5],  6, 0xF7537E82, I)
	D = DoRound(D, A, B, C, X[12], 10, 0xBD3AF235, I)
	C = DoRound(C, D, A, B, X[ 3], 15, 0x2AD7D2BB, I)
	B = DoRound(B, C, D, A, X[10], 21, 0xEB86D391, I)

	self.A = self.A + A
	self.B = self.B + B
	self.C = self.C + C
	self.D = self.D + D
end

local function PushData(self, data)
	self.total_bits = self.total_bits + 16 * 4 * 8

	-- Unpack the bytes from a string to a table.
	ProcessBlock(self, {string.unpack("<I4<I4<I4<I4<I4<I4<I4<I4<I4<I4<I4<I4<I4<I4<I4<I4", data)})
end

local function PushFinalData(self, data, bits)
	self.total_bits = self.total_bits + bits

	local words = {}
	local position = 1

	local total_bytes = (bits + (8 - 1)) // 8

	-- Unpack the words from the string to a table.
	for i = 1, total_bytes // 4 do
		words[i], position = string.unpack("<I4", data, position)
	end

	-- Handle the string ending with a partial word.
	if (total_bytes & 3 ~= 0) then
		words[#words + 1] = string.unpack("<I" .. (total_bytes & 3), data, position)
	end

	-- If this is a full block, then process it and start from scratch with an empty block.
	if bits == 16 * 4 * 8 then
		ProcessBlock(self, words)
		bits = 0
	end

	local i = bits // 32

	-- Insert the termination bit at the end of the block's data.
	-- While we're doing this, pad to the next byte.
	if bits & 31 == 0 then
		words[1 + i] = 0x00000080 -- byteswap(0x80000000)
	else
		local function byteswap(value)
			return ((value & 0xFF000000) >> 24) | ((value & 0x00FF0000) >> 8) | ((value & 0x0000FF00) << 8) | ((value & 0x000000FF) << 24)
		end

		local or_mask = 0x80000000 >> (bits & 31)
		local and_mask = ~(or_mask - 1)

		words[1 + i] = words[1 + i] & byteswap(and_mask) -- Clear the spare bits.
		words[1 + i] = words[1 + i] | byteswap(or_mask) -- Set the first bit after the data.
	end

	i = i + 1

	-- If we're too close to the end of the block, then complete this one and then start a new one.
	if i > 16 - 2 then
		-- Fill the rest of the block with padding.
		while i < 16 do
			words[1 + i] = 0
			i = i + 1
		end

		-- Process the block.
		ProcessBlock(self, words)

		-- Start a new block.
		i = 0
	end

	-- "Step 1. Append Padding Bits"
	while i < 16 - 2 do
		words[1 + i] = 0
		i = i + 1
	end

	-- "Step 2. Append Length"
	for j = 0, 1 do
		words[1 + i] = (self.total_bits >> (32 * j)) & 0xFFFFFFFF
		i = i + 1
	end

	-- Process the final block.
	ProcessBlock(self, words)

	-- "Step 5. Output"
	return string.pack("<I4<I4<I4<I4", self.A & 0xFFFFFFFF, self.B & 0xFFFFFFFF, self.C & 0xFFFFFFFF, self.D & 0xFFFFFFFF)
end

-- The class holds the methods and metamethod. There is only one instance of the class, but many objects.
local class = {
	PushData = PushData,
	PushFinalData = PushFinalData
}

-- This lets us use the class as a metatable as well.
class.__index = class

local function CreateMD5Object()
	-- The object holds the state.
	local object = {
		-- Step 3. Initialise MD Buffer
		A = 0x67452301,
		B = 0xEFCDAB89,
		C = 0x98BADCFE,
		D = 0x10325476,

		total_bits = 0
	}

	-- Every object shares a single class metatable.
	setmetatable(object, class)

	return object
end

local function HashFile(filename)
	local file = io.open(filename, "rb")

	local hasher = CreateMD5Object()

	while true do
		local block_string = file:read(64)
		local bytes

		if block_string == nil then
			bytes = 0
		else
			bytes = block_string:len()
		end

		if bytes == 64 then
			-- All 64 bytes
			hasher:PushData(block_string)
		else
			-- 63 or fewer bytes
			file:close()

			return hasher:PushFinalData(block_string, bytes * 8)
		end
	end
end

return {
	new = CreateMD5Object,
	HashFile = HashFile
}
