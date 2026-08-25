// Converts a Macro Assembler AS '.p' code file to a ROM file, compressing
// consecutive Z80 segments in the process.
//
// A port of https://github.com/Clownacy/p2bin (main.c), limited to the
// compression formats that Sonic 1 needs.
//
// Documentation of AS's code file format can be found here:
// http://john.ccac.rwth-aachen.de:8000/as/as_EN.html#sect_5_1_

const fs = require('fs');

const kosinski = require('./kosinski.js');

const Z80_BUFFER_SIZE = 0x2000;
const PROCESSOR_FAMILY_Z80 = 0x51;

// A stand-in for the C version's output 'FILE', which is written to with seeks.
// Bytes that are never written are left as 0, matching the sparse file that the
// C version produces.
class OutputFile {
	constructor() {
		this.buffer = Buffer.alloc(0x400000);
		this.length = 0;
		this.position = 0;
	}

	seek(position) {
		this.position = position;
	}

	tell() {
		return this.position;
	}

	write(data, offset, total_bytes) {
		const end = this.position + total_bytes;

		if (end > this.buffer.length) {
			const bigger_buffer = Buffer.alloc(Math.max(end, this.buffer.length * 2));
			this.buffer.copy(bigger_buffer);
			this.buffer = bigger_buffer;
		}

		data.copy(this.buffer, this.position, offset, offset + total_bytes);
		this.position = end;

		if (end > this.length)
			this.length = end;
	}

	writeByte(byte) {
		this.write(Buffer.from([byte]), 0, 1);
	}

	contents() {
		return this.buffer.subarray(0, this.length);
	}
}

// 'compressed_segment' describes the '-z' option: {starting_address, compression, type}.
// 'compression' is one of 'uncompressed', 'kosinski', 'kosinski-optimised'.
// 'type' is 'before' (S&K) or 'after' (S1, S2).
// Returns the size of the compressed Z80 data, or 0 if there was none.
module.exports = function p2bin(input_filename, output_filename, header_filename, options) {
	const input = fs.readFileSync(input_filename);
	const output = new OutputFile();
	const padding_value = options.padding_value === undefined ? 0 : options.padding_value;
	const compressed_segments = options.compressed_segments || [];

	let input_position = 0;
	let maximum_address = 0;
	let last_z80_segment_end = -1;
	let previous_68k_segment_start = 0, previous_68k_segment_length = 0;
	let current_compressed_segment = null;
	let z80_buffer = Buffer.alloc(Z80_BUFFER_SIZE);
	let z80_write_index = 0;
	let compressed_z80_code_size_total = 0;

	function fail(message) {
		throw new Error(message);
	}

	function ReadByte() {
		if (input_position >= input.length)
			fail('File ended prematurely.');

		return input[input_position++];
	}

	function ReadInteger(total_bytes) {
		let value = 0;

		for (let i = 0; i < total_bytes; ++i)
			value += ReadByte() * 2 ** (i * 8);

		return value;
	}

	function NotEnoughSpace(compressed_segment, compressed_z80_code_size) {
		fail("Space reserved for the compressed Z80 segments is too small. Set '" + compressed_segment.constant + "' to at least $" + compressed_z80_code_size.toString(16).toUpperCase() + '.');
	}

	function EmitCompressedZ80Code() {
		if (current_compressed_segment === null)
			return 0;

		// Rewind to the start of the previous segment.
		if (current_compressed_segment.type === 'before')
			output.seek(previous_68k_segment_start);

		const start_address = output.tell();
		const uncompressed = z80_buffer.subarray(0, z80_write_index);

		switch (current_compressed_segment.compression) {
			case 'uncompressed':
				output.write(uncompressed, 0, uncompressed.length);
				break;

			case 'kosinski': {
				const compressed = kosinski.compressAuthentic(uncompressed);
				output.write(compressed, 0, compressed.length);

				// Kosinski-compressed data is always padded to 0x10 bytes.
				for (let i = -(output.tell() - start_address) & 0xF; i !== 0; --i)
					output.writeByte(0);

				break;
			}

			case 'kosinski-optimised': {
				const compressed = kosinski.compressOptimised(uncompressed);
				output.write(compressed, 0, compressed.length);
				break;
			}

			default:
				fail("Unsupported compression format ('" + current_compressed_segment.compression + "').");
		}

		const end_address = output.tell();

		if (end_address > maximum_address)
			maximum_address = end_address;

		const compressed_z80_code_size = end_address - start_address;

		// Check if we fit within the previous segment.
		if (current_compressed_segment.type === 'before' && compressed_z80_code_size > previous_68k_segment_length)
			NotEnoughSpace(current_compressed_segment, compressed_z80_code_size);

		current_compressed_segment = null;

		return compressed_z80_code_size;
	}

	function ProcessSegment(processor_family) {
		const start_address = ReadInteger(4);
		const length = ReadInteger(2);
		const end_address = start_address + length;
		let matching_compressed_segment = null;
		const is_continued_compressed_segment = processor_family === PROCESSOR_FAMILY_Z80 && current_compressed_segment !== null && start_address === last_z80_segment_end;

		if (processor_family === PROCESSOR_FAMILY_Z80)
			for (const compressed_segment of compressed_segments)
				if (start_address === compressed_segment.starting_address) {
					matching_compressed_segment = compressed_segment;
					break;
				}

		// Sound driver Z80 code must be compressed.
		// The telltale sign of compressable Z80 code is that its first segment has an address of 0.
		if (matching_compressed_segment !== null || is_continued_compressed_segment) {
			// What we do is read as many consecutive Z80 segments as possible into a buffer and then
			// compress and emit it when we encounter a non-Z80 segment or the end of the code file.

			// If we encounter an eligible segment that doesn't continue directly
			// after the last one, then begin a new compressed chunk.
			if (!is_continued_compressed_segment) {
				EmitCompressedZ80Code();

				current_compressed_segment = matching_compressed_segment;
				z80_write_index = 0;
			}

			last_z80_segment_end = end_address;

			if (z80_write_index + length > z80_buffer.length)
				fail('Compressed Z80 segment is too large.');

			input.copy(z80_buffer, z80_write_index, input_position, input_position + length);
			input_position += length;
			z80_write_index += length;
		} else {
			// If a compressed Z80 segment is in-progress, then output it.
			if (current_compressed_segment !== null) {
				const compressed_segment = current_compressed_segment;
				const compressed_z80_code_size = EmitCompressedZ80Code();

				// If the segment after the compressed data overlaps it, then not enough space was allocated for it.
				if (compressed_segment.type === 'after' && start_address < output.tell())
					NotEnoughSpace(compressed_segment, compressed_z80_code_size);

				compressed_z80_code_size_total = compressed_z80_code_size;

				if (header_filename) {
					// Output the size of the compressed data to the header file for the build script to amend the ROM with.
					const header_file = fs.openSync(header_filename, 'r+');
					fs.writeSync(header_file, 'comp_z80_size 0x' + compressed_z80_code_size.toString(16).toUpperCase() + ' ', 0);
					fs.closeSync(header_file);
				}
			}

			if (start_address > maximum_address) {
				// Set padding bytes between segments.
				const padding_length = start_address - maximum_address;

				output.seek(maximum_address);
				output.write(Buffer.alloc(padding_length, padding_value), 0, padding_length);
			} else {
				output.seek(start_address);
			}

			output.write(input, input_position, length);
			input_position += length;

			if (end_address > maximum_address)
				maximum_address = end_address;

			previous_68k_segment_start = start_address;
			previous_68k_segment_length = length;
		}
	}

	// Read and check the header's magic number.
	if (input.length < 2 || input[0] !== 0x89 || input[1] !== 0x14)
		fail('Invalid header magic value.\nInput file is either corrupt or not a valid AS code file.');

	input_position = 2;

	for (;;) {
		const record_header = ReadByte();

		if (record_header === 0) {
			// Creator string. This marks the end of the file.

			// Emit the Z80 code here too, just in case it's the last segment in the file.
			EmitCompressedZ80Code();
			break;
		} else if (record_header === 0x80) {
			// Entry point. We don't care about this.
			ReadInteger(4);
		} else if (record_header === 0x81) {
			// Arbitrary segment.
			const processor_family = ReadByte();
			ReadByte(); // Segment. We don't care about this.
			const granularity = ReadByte();

			if (granularity !== 1)
				fail('Unsupported granularity of ' + granularity + ' (only 1 is supported).');

			ProcessSegment(processor_family);
		} else if (record_header > 0x80) {
			fail('Unrecognised record header value (0x' + record_header.toString(16) + ').');
		} else {
			// Legacy CODE segment.
			ProcessSegment(record_header);
		}
	}

	fs.writeFileSync(output_filename, output.contents());

	return compressed_z80_code_size_total;
};
