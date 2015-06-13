/* -*- Mode: C++; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- */
/*
 * Copyright (C) Flamewing 2011-2013 <flamewing.sonic@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef _BITSTREAM_H_
#define _BITSTREAM_H_

#include <iosfwd>

template <typename T>
class bigendian {
public:
	size_t read(std::istream &src) {
		return BigEndian::ReadN<std::istream &, sizeof(T)>(src);
	}
	void write(std::ostream &dst, size_t c) {
		BigEndian::WriteN<std::ostream &, sizeof(T)>(dst, c);
	}
};

template <typename T>
class littleendian {
public:
	size_t read(std::istream &src) {
		return LittleEndian::ReadN<std::istream &, sizeof(T)>(src);
	}
	void write(std::ostream &dst, size_t c) {
		LittleEndian::WriteN<std::ostream &, sizeof(T)>(dst, c);
	}
};

template<typename T>
static T reverseBits(T val) {
	unsigned int sz = sizeof(T) * 8; // bit size; must be power of 2 
	T mask = ~0;
	while ((sz >>= 1) > 0) {
		mask ^= (mask << sz);
		val = ((val >> sz) & mask) | ((val << sz) & ~mask);
	}
	return val;
}

// This class allows reading bits from a stream.
// "EarlyRead" means, in this context, to read a new T as soon as the old one
// runs out of bits; the alternative is to read when a new bit is needed.
template <typename T, bool EarlyRead, bool LittleEndianBits = false,
          typename Reader = bigendian<T> >
class ibitstream {
private:
	std::istream &src;
	Reader r;
	int readbits;
	T bitbuffer;
	T read_bits() {
		T bits = r.read(src);
		return LittleEndianBits ? reverseBits(bits) : bits;
	}
	void check_buffer() {
		if (readbits)
			return;

		bitbuffer = read_bits();
		if (src.good())
			readbits = sizeof(T) * 8;
		else
			readbits = 16;
	}
public:
	ibitstream(std::istream &s) : src(s), readbits(sizeof(T) * 8) {
		bitbuffer = read_bits();
	}
	// Gets a single bit from the stream. Remembers previously read bits, and
	// gets a new T from the actual stream once all bits in the current T has
	// been used up.
	T pop() {
		if (!EarlyRead)
			check_buffer();
		--readbits;
		T bit = (bitbuffer >> readbits) & 1;
		bitbuffer ^= (bit << readbits);
		if (EarlyRead)
			check_buffer();
		return bit;
	}
	// Reads up to sizeof(T) * 8 bits from the stream. This remembers previously
	// read bits, and gets another T from the actual stream once all bits in the
	// current T have been read.
	T read(unsigned char cnt) {
		if (!EarlyRead)
			check_buffer();
		T bits;
		if (readbits < cnt) {
			int delta = (cnt - readbits);
			bits = bitbuffer << delta;
			bitbuffer = read_bits();
			readbits = (sizeof(T) * 8) - delta;
			T newbits = (bitbuffer >> readbits);
			bitbuffer ^= (newbits << readbits);
			bits |= newbits;
		} else {
			readbits -= cnt;
			bits = bitbuffer >> readbits;
			bitbuffer ^= (bits << readbits);
		}
		if (EarlyRead)
			check_buffer();
		return bits;
	}
	int have_waiting_bits() const {
		return readbits;
	}
};

// This class allows outputting bits into a stream.
template <typename T, bool LittleEndianBits = false,
         typename Writer = bigendian<T> >
class obitstream {
private:
	std::ostream &dst;
	Writer w;
	unsigned int waitingbits;
	T bitbuffer;
	void write_bits(T bits) {
		w.write(dst, LittleEndianBits ? reverseBits(bits) : bits);
	}
public:
	obitstream(std::ostream &d) : dst(d), waitingbits(0), bitbuffer(0) {
	}
	// Puts a single bit into the stream. Remembers previously written bits, and
	// outputs a T to the actual stream once there are at least sizeof(T) * 8
	// bits stored in the buffer.
	bool push(T data) {
		bitbuffer = (bitbuffer << 1) | (data & 1);
		if (++waitingbits >= sizeof(T) * 8) {
			write_bits(bitbuffer);
			waitingbits = 0;
			bitbuffer = 0;
			return true;
		}
		return false;
	}
	// Writes up to sizeof(T) * 8 bits to the stream. This remembers previously
	// written bits, and outputs a T to the actual stream once there are at
	// least sizeof(T) * 8 bits stored in the buffer.
	bool write(T data, unsigned char size) {
		if (waitingbits + size >= sizeof(T) * 8) {
			int delta = (sizeof(T) * 8 - waitingbits);
			waitingbits = (waitingbits + size) % (sizeof(T) * 8);
			T bits = (bitbuffer << delta) | (data >> waitingbits);
			write_bits(bits);
			bitbuffer = (data & (T(~0) >> (sizeof(T) * 8 - waitingbits)));
			return true;
		} else {
			bitbuffer = (bitbuffer << size) | data;
			waitingbits += size;
			return false;
		}
	}
	// Flushes remaining bits (if any) to the buffer, completing the byte by
	// padding with zeroes.
	bool flush() {
		if (waitingbits) {
			bitbuffer <<= ((sizeof(T) * 8) - waitingbits);
			write_bits(bitbuffer);
			waitingbits = 0;
			return true;
		}
		return false;
	}
	int have_waiting_bits() const {
		return waitingbits;
	}
};

#endif // _BITSTREAM_H_
