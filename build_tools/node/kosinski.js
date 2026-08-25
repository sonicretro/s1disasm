// Kosinski compression.
//
// 'authentic' is a port of 'accurate-kosinski/lib/kosinski-compress.c' from
// https://github.com/Clownacy/p2bin (Clownacy's reimplementation of Sega's own
// compressor). It must be bug-for-bug identical to the C version, or the ROM
// will not be byte-perfect with the original release.
//
// 'optimised' is a port of 'kosinski.c' and the shortest-path compressor in
// 'clownlzss.c', from https://github.com/Clownacy/clownlzss.

const TOTAL_DESCRIPTOR_BITS = 16;

const SLIDING_WINDOW_SIZE = 0x2000;
const MAX_MATCH_LENGTH_AUTHENTIC = 0xFD;                                             // Mistake 1: This should be 0x100
const MAX_MATCH_DISTANCE_AUTHENTIC = SLIDING_WINDOW_SIZE - MAX_MATCH_LENGTH_AUTHENTIC; // Mistake 2: This should just be SLIDING_WINDOW_SIZE

const EOF = -1;

// A direct translation of 'KosinskiCompress' from kosinski-compress.c.
function encodeAuthentic(input) {
	const output = [];
	const ring_buffer = new Uint8Array(SLIDING_WINDOW_SIZE + MAX_MATCH_LENGTH_AUTHENTIC - 1);
	let match_buffer = [];

	let input_position = 0;
	let output_position = 0;
	let descriptor = 0;
	let descriptor_bits_remaining = TOTAL_DESCRIPTOR_BITS;

	function readByte() {
		return input_position === input.length ? EOF : input[input_position++];
	}

	function flushData() {
		descriptor >>= descriptor_bits_remaining;

		// Descriptors are stored byte-swapped.
		for (let i = 0; i < TOTAL_DESCRIPTOR_BITS / 8; ++i)
			output.push((descriptor >> (i * 8)) & 0xFF);

		for (const byte of match_buffer)
			output.push(byte);

		output_position += TOTAL_DESCRIPTOR_BITS / 8 + match_buffer.length;
	}

	function putMatchByte(byte) {
		match_buffer.push(byte & 0xFF);
	}

	function putDescriptorBit(bit) {
		descriptor >>= 1;

		descriptor |= bit << (TOTAL_DESCRIPTOR_BITS - 1);

		if (--descriptor_bits_remaining === 0) {
			flushData();

			descriptor_bits_remaining = TOTAL_DESCRIPTOR_BITS;
			match_buffer = [];
		}
	}

	let write_index = 0;
	let read_index = 0;
	let dummy_counter = 0;

	// Initialise the ring buffer with data from the file. The remainder is left
	// as zero. We know that the original Kosinski compressor did this because of
	// Mistake 6.
	for (; write_index < MAX_MATCH_LENGTH_AUTHENTIC; ++write_index) {
		const byte = readByte();

		if (byte === EOF)
			break;

		ring_buffer[write_index] = byte;
	}

	while (read_index !== write_index) {
		const max_match_distance = Math.min(read_index, MAX_MATCH_DISTANCE_AUTHENTIC);

		// Search backwards for previous occurances of the current data.
		let longest_match_index = 0;
		let longest_match_length = 0;

		for (let backsearch_index = 1; backsearch_index < max_match_distance + 1; ++backsearch_index) {
			// Mistake 6: 'match_length' always counts up to 'MAX_MATCH_LENGTH', even if it means reading
			// past the end of the file. Because the ring buffer isn't updated once the end of the file is
			// reached, this results in leftover values from earlier in the file being read instead.
			let match_length = 0;
			const current_data = read_index % SLIDING_WINDOW_SIZE;
			const previous_data = (read_index - backsearch_index) % SLIDING_WINDOW_SIZE;

			while (match_length < MAX_MATCH_LENGTH_AUTHENTIC && ring_buffer[current_data + match_length] === ring_buffer[previous_data + match_length])
				++match_length;

			if (match_length > longest_match_length) {
				longest_match_index = backsearch_index;
				longest_match_length = match_length;
			}
		}

		// If the match is longer than the remainder of the file, reduce it to the proper size. See Mistake 6 for more info.
		longest_match_length = Math.min(longest_match_length, write_index - read_index);

		// Mistake 5: This is completely pointless.
		// For some reason, the original compressor would insert a dummy match
		// before the first match that starts after 0xA000.
		if (dummy_counter >= 0xA000) {
			dummy_counter %= 0xA000;

			// 0xA000 boundary match
			putDescriptorBit(0);
			putDescriptorBit(1);
			putMatchByte(0x00);
			putMatchByte(0xF0);
			putMatchByte(0x01);
		}

		// Select the optimal encoding for the current match.
		if (longest_match_length >= 2 && longest_match_length <= 5 && longest_match_index < 0x100) { // Mistake 3: This should be '<= 0x100'
			// Short distance, shortest length
			const length = longest_match_length - 2;

			putDescriptorBit(0);
			putDescriptorBit(0);
			putDescriptorBit((length & 2) !== 0 ? 1 : 0);
			putDescriptorBit((length & 1) !== 0 ? 1 : 0);
			putMatchByte(-longest_match_index & 0xFF);
		} else if (longest_match_length >= 3 && longest_match_length <= 9) {
			// Long distance, short length
			const distance = -longest_match_index;

			putDescriptorBit(0);
			putDescriptorBit(1);
			putMatchByte(distance & 0xFF);
			putMatchByte(((distance >> (8 - 3)) & 0xF8) | ((longest_match_length - 2) & 7));
		} else if (longest_match_length >= 3) {
			// Long distance, long length
			const distance = -longest_match_index;

			putDescriptorBit(0);
			putDescriptorBit(1);
			putMatchByte(distance & 0xFF);
			putMatchByte((distance >> (8 - 3)) & 0xF8);
			putMatchByte(longest_match_length - 1);
		} else {
			// Match was too small to encode; do a literal match instead.
			longest_match_length = 1;

			putDescriptorBit(1);
			putMatchByte(ring_buffer[read_index % SLIDING_WINDOW_SIZE]);
		}

		// Update the ring buffer with bytes from the file.
		for (let i = 0; i < longest_match_length; ++i) {
			const byte = readByte();

			if (byte === EOF) {
				break;
			} else {
				const ring_buffer_index = write_index++ % SLIDING_WINDOW_SIZE;

				ring_buffer[ring_buffer_index] = byte;

				// Read into a little spill buffer, so that string comparisons
				// don't have to wrap back around to the start of the ring buffer.
				if (ring_buffer_index < MAX_MATCH_LENGTH_AUTHENTIC - 1)
					ring_buffer[SLIDING_WINDOW_SIZE + ring_buffer_index] = byte;
			}
		}

		read_index += longest_match_length;
		dummy_counter += longest_match_length;
	}

	// Terminator match
	putDescriptorBit(0);
	putDescriptorBit(1);
	putMatchByte(0x00);
	putMatchByte(0xF0);
	putMatchByte(0x00);

	flushData();

	// Mistake 4: There's absolutely no reason to do this.
	// Pad to 0x10 bytes.
	while (output_position++ % 0x10 !== 0)
		output.push(0);

	return Buffer.from(output);
}

const MAX_MATCH_LENGTH = 0x100;
const MAX_MATCH_DISTANCE = 0x2000;
const LITERAL_COST = 1 + 8; // Descriptor bit, byte

const DUMMY = -1;
const MAXIMUM_COST = Number.MAX_SAFE_INTEGER;

// A translation of 'GetMatchCost' from clownlzss/kosinski.c. A cost of zero
// means that the match cannot be encoded.
function getMatchCost(distance, length) {
	if (length >= 2 && length <= 5 && distance <= 0x100)
		return 2 + 2 + 8;  // Descriptor bits, length bits, offset byte
	else if (length >= 3 && length <= 9)
		return 2 + 16;     // Descriptor bits, offset/length bytes
	else if (length >= 3)
		return 2 + 16 + 8; // Descriptor bits, offset bytes, length byte
	else
		return 0;
}

// A translation of 'ClownLZSS_Compress' from clownlzss.c, with the parameters
// that Kosinski uses. Rather than compressing greedily, this finds the
// combination of matches that produces the smallest output, by treating the
// possible matches as a graph and finding the shortest path through it.
function compressData(data, callbacks) {
	const total_values = data.length;

	// String list stuff.
	const next = new Int32Array(MAX_MATCH_DISTANCE + 0x100).fill(DUMMY);
	const prev = new Int32Array(MAX_MATCH_DISTANCE).fill(DUMMY);
	const bytes = new Int32Array(MAX_MATCH_DISTANCE);

	// The edges of the LZSS graph.
	const cost = new Float64Array(total_values + 1).fill(MAXIMUM_COST); // +1 for the end-node
	const previous_node_index = new Int32Array(total_values + 1).fill(DUMMY);
	const next_node_index = new Int32Array(total_values + 1).fill(DUMMY);
	const match_length = new Int32Array(total_values + 1);
	const match_offset = new Int32Array(total_values + 1);

	cost[0] = 0;

	// Advance through the data one step at a time.
	for (let i = 0; i < total_values; ++i) {
		const string_list_head = MAX_MATCH_DISTANCE + data[i];
		const current_string = i % MAX_MATCH_DISTANCE;

		// 'string_list_head' points to a linked-list of strings in the LZSS sliding window that match at least
		// one byte with the current string: iterate over it and generate every possible match for this string.
		for (let match_string = next[string_list_head]; match_string !== DUMMY; match_string = next[match_string]) {
			const match_start = bytes[match_string];
			const maximum_length = Math.min(MAX_MATCH_LENGTH, total_values - i);

			for (let j = 1; j < maximum_length; ++j) {
				if (data[i + j] !== data[match_start + j]) {
					// No match: give up on the current run.
					break;
				} else {
					// Figure out how much it costs to encode the current run.
					const match_cost = getMatchCost(i - match_start, j + 1);

					// Figure out if the cost is lower than that of any other runs that end at the same value as this one.
					if (match_cost !== 0 && cost[i + j + 1] > cost[i] + match_cost) {
						// Record this new best run in the graph edge assigned to the value at the end of the run.
						cost[i + j + 1] = cost[i] + match_cost;
						previous_node_index[i + j + 1] = i;
						match_length[i + j + 1] = j + 1;
						match_offset[i + j + 1] = match_start;
					}
				}
			}
		}

		// If a literal match is more efficient than all runs assigned to this value, then use that instead.
		if (cost[i + 1] >= cost[i] + LITERAL_COST) {
			cost[i + 1] = cost[i] + LITERAL_COST;
			previous_node_index[i + 1] = i;
			match_length[i + 1] = 0;
		}

		// Replace the oldest string in the list with the new string, since it's about to be pushed out of the LZSS sliding window.

		// Detach the old node in this slot.
		if (prev[current_string] !== DUMMY) {
			next[prev[current_string]] = next[current_string];

			if (next[current_string] !== DUMMY)
				prev[next[current_string]] = prev[current_string];
		}

		// Replace the old node with this new one, and insert it at the start of its matching list.
		bytes[current_string] = i;
		prev[current_string] = string_list_head;
		next[current_string] = next[string_list_head];

		if (next[string_list_head] !== DUMMY)
			prev[next[string_list_head]] = current_string;

		next[string_list_head] = current_string;
	}

	// At this point, the edges will have formed a shortest-path from the start to the end:
	// You just have to start at the last edge, and follow it backwards all the way to the start.

	// Mark start/end nodes for the following loops.
	previous_node_index[0] = DUMMY;
	next_node_index[total_values] = DUMMY;

	// Reverse the direction of the edges, so we can parse the LZSS graph from start to end.
	for (let i = total_values; previous_node_index[i] !== DUMMY; i = previous_node_index[i])
		next_node_index[previous_node_index[i]] = i;

	// Go through our now-complete LZSS graph, and output the optimally-compressed file.
	for (let i = 0; next_node_index[i] !== DUMMY; i = next_node_index[i]) {
		const next_index = next_node_index[i];
		const length = match_length[next_index];

		if (length === 0)
			callbacks.literal(data[i]);
		else
			callbacks.match(length, i - match_offset[next_index]);
	}
}

// A translation of 'ClownLZSS_KosinskiCompress' from clownlzss/kosinski.c.
function encodeOptimised(data) {
	const output = [];
	let descriptor_position = 0;
	let descriptor = 0;
	let descriptor_bits_remaining = TOTAL_DESCRIPTOR_BITS;

	function beginDescriptorField() {
		// Log the placement of the descriptor field, and insert a placeholder.
		descriptor_position = output.length;
		output.push(0, 0);
	}

	function finishDescriptorField() {
		output[descriptor_position + 0] = (descriptor >> (8 * 0)) & 0xFF;
		output[descriptor_position + 1] = (descriptor >> (8 * 1)) & 0xFF;
	}

	function putDescriptorBit(bit) {
		--descriptor_bits_remaining;

		descriptor >>= 1;

		if (bit)
			descriptor |= 1 << (TOTAL_DESCRIPTOR_BITS - 1);

		if (descriptor_bits_remaining === 0) {
			descriptor_bits_remaining = TOTAL_DESCRIPTOR_BITS;

			finishDescriptorField();
			beginDescriptorField();
		}
	}

	// Begin first descriptor field.
	beginDescriptorField();

	// Produce Kosinski-formatted data.
	compressData(data, {
		literal: function (value) {
			putDescriptorBit(1);
			output.push(value);
		},
		match: function (length, distance) {
			if (length >= 2 && length <= 5 && distance <= 0x100) {
				putDescriptorBit(0);
				putDescriptorBit(0);
				putDescriptorBit((length - 2) & 2 ? 1 : 0);
				putDescriptorBit((length - 2) & 1 ? 1 : 0);
				output.push(-distance & 0xFF);
			} else if (length >= 3 && length <= 9) {
				putDescriptorBit(0);
				putDescriptorBit(1);
				output.push(-distance & 0xFF);
				output.push(((-distance >> (8 - 3)) & 0xF8) | ((length - 2) & 7));
			} else {
				putDescriptorBit(0);
				putDescriptorBit(1);
				output.push(-distance & 0xFF);
				output.push((-distance >> (8 - 3)) & 0xF8);
				output.push(length - 1);
			}
		},
	});

	// Add the terminator match.
	putDescriptorBit(0);
	putDescriptorBit(1);
	output.push(0x00);
	output.push(0xF0);
	output.push(0x00);

	// The descriptor field may be incomplete, so move the bits into their proper place.
	descriptor >>= descriptor_bits_remaining;

	// Finish last descriptor field.
	finishDescriptorField();

	return Buffer.from(output);
}

// The compressor that the original game used, complete with its bugs.
function compressAuthentic(data) {
	return encodeAuthentic(data);
}

// A modern compressor which produces smaller data, at the cost of accuracy.
function compressOptimised(data) {
	return encodeOptimised(data);
}

module.exports = {
	compressAuthentic: compressAuthentic,
	compressOptimised: compressOptimised,
};
