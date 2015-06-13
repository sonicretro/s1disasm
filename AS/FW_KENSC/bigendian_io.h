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

#ifndef _BIGENDIAN_IO_H_
#define _BIGENDIAN_IO_H_

#include <iosfwd>
#include <iterator>
#include <string>

#ifdef UNUSED
#elif defined(__GNUC__)
#	define UNUSED(x) UNUSED_ ## x __attribute__((unused))
#elif defined(__LCLINT__)
#	define UNUSED(x) /*@unused@*/ x
#elif defined(__cplusplus)
#	define UNUSED(x)
#else
#	define UNUSED(x) x
#endif

inline size_t Read1(std::istream &in) {
	size_t c = static_cast<unsigned char>(in.get());
	return c;
}

inline size_t Read1(char const *& in) {
	size_t c = static_cast<unsigned char>(*in++);
	return c;
}

inline size_t Read1(unsigned char const *& in) {
	size_t c = *in++;
	return c;
}

inline size_t Read1(std::istream_iterator<unsigned char>& in) {
	size_t c = *in++;
	return c;
}

inline void Write1(std::ostream &out, size_t c) {
	out.put(static_cast<char>(c & 0xff));
}

inline void Write1(char *&out, size_t c) {
	*out++ = static_cast<char>(c & 0xff);
}

inline void Write1(unsigned char *&out, size_t c) {
	*out++ = static_cast<char>(c & 0xff);
}

inline void Write1(std::string &out, size_t c) {
	out.push_back(static_cast<char>(c & 0xff));
}

inline void Write1(std::ostream_iterator<unsigned char>&out, size_t c) {
	*out++ = static_cast<char>(c & 0xff);
}

namespace BigEndian {
	template <typename T>
	inline size_t Read2(T &in) {
		size_t c = Read1(in) << 8;
		c |= Read1(in);
		return c;
	}

	template <typename T>
	inline size_t Read4(T &in) {
		size_t c = Read1(in) << 24;
		c |= Read1(in) << 16;
		c |= Read1(in) << 8;
		c |= Read1(in);
		return c;
	}

	template <typename T, int N>
	inline size_t ReadN(T &in) {
		size_t c = 0;
		for (size_t i = 0; i < N; i++)
			c = (c << 8) | Read1(in);
		return c;
	}

	template <typename T>
	inline void Write2(T &out, size_t c) {
		Write1(out, (c & 0xff00) >> 8);
		Write1(out, c & 0xff);
	}

	template <typename T>
	inline void Write4(T &out, size_t c) {
		Write1(out, (c & 0xff000000) >> 24);
		Write1(out, (c & 0x00ff0000) >> 16);
		Write1(out, (c & 0x0000ff00) >> 8);
		Write1(out, (c & 0x000000ff));
	}

	template <typename T, int N>
	inline void WriteN(T &out, size_t c) {
		for (int i = 8 * (N - 1); i >= 0; i -= 8)
			Write1(out, (c >> i) & 0xff);
	}
}

namespace LittleEndian {
	template <typename T>
	inline size_t Read2(T &in) {
		size_t c = Read1(in);
		c |= Read1(in) << 8;
		return c;
	}

	template <typename T>
	inline size_t Read4(T &in) {
		size_t c = Read1(in);
		c |= Read1(in) << 8;
		c |= Read1(in) << 16;
		c |= Read1(in) << 24;
		return c;
	}

	template <typename T, int N>
	inline size_t ReadN(T &in) {
		size_t c = 0;
		for (size_t i = 0; i < 8 * N; i += 8)
			c = c | (Read1(in) << i);
		return c;
	}

	template <typename T>
	inline void Write2(T &out, size_t c) {
		Write1(out, c & 0xff);
		Write1(out, (c & 0xff00) >> 8);
	}

	template <typename T>
	inline void Write4(T &out, size_t c) {
		Write1(out, (c & 0x000000ff));
		Write1(out, (c & 0x0000ff00) >> 8);
		Write1(out, (c & 0x00ff0000) >> 16);
		Write1(out, (c & 0xff000000) >> 24);
	}

	template <typename T, int N>
	inline void WriteN(T &out, size_t c) {
		for (size_t i = 0; i < 8 * N; i += 8)
			Write1(out, (c >> i) & 0xff);
	}
}

#endif
