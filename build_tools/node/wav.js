// Converts WAV files to the raw PCM and DPCM formats that the sound driver uses.

const fs = require('fs');

// Division, matching the behaviour of Lua's floor division.
function divideRoundUp(dividend, divisor) {
	return Math.floor((dividend + (divisor - 1)) / divisor);
}

function divideRoundDown(dividend, divisor) {
	return Math.floor(dividend / divisor);
}

function divideRoundHalfUp(dividend, divisor) {
	return divideRoundDown(dividend + divideRoundDown(divisor, 2), divisor);
}

function divideRoundHalfDown(dividend, divisor) {
	return divideRoundUp(dividend - divideRoundDown(divisor, 2), divisor);
}

function divideRoundHalfAwayFromZero(dividend, divisor) {
	if (dividend < 0)
		return divideRoundHalfDown(dividend, divisor);
	else
		return divideRoundHalfUp(dividend, divisor);
}

// Reads a WAV file, returning its audio data.
// Throws an error if the file is not a WAV file that we can understand.
function readWavFile(input_file_path) {
	const file = fs.readFileSync(input_file_path);
	const audio = {channels: 1, sample_rate: 8000, bytes_per_sample: 1, samples: []};

	if (file.length < 12 || file.toString('latin1', 0, 4) !== 'RIFF')
		throw new Error('FOURCC check failed; this is not a valid WAV file!');

	if (file.toString('latin1', 8, 12) !== 'WAVE')
		throw new Error('RIFF format check failed; this is not a valid WAV file!');

	let position = 12;

	while (position + 8 <= file.length) {
		const chunk_id = file.toString('latin1', position, position + 4);
		const chunk_size = file.readUInt32LE(position + 4);
		const chunk_start = position + 8;

		if (chunk_id === 'fmt ') {
			if (chunk_size < 16)
				throw new Error('Format chunk was smaller than expected (' + chunk_size + ' instead of 16)!');

			const format = file.readUInt16LE(chunk_start);
			audio.channels = file.readUInt16LE(chunk_start + 2);
			audio.sample_rate = file.readUInt32LE(chunk_start + 4);
			audio.bytes_per_sample = divideRoundUp(file.readUInt16LE(chunk_start + 14), 8);

			if (format !== 1)
				throw new Error("Unsupported sample format '" + format + "' (only '1' is supported)!");
		} else if (chunk_id === 'data') {
			for (let i = 0; i < chunk_size; i += audio.bytes_per_sample) {
				const sample_start = chunk_start + i;

				if (audio.bytes_per_sample === 1)
					// 8-bit is unsigned.
					audio.samples.push(file.readUInt8(sample_start) - 0x80);
				else
					// Everything else is signed.
					audio.samples.push(file.readIntLE(sample_start, audio.bytes_per_sample));
			}
		}

		position = chunk_start + chunk_size;
	}

	return audio;
}

// Downsamples the audio to unsigned 8-bit mono.
function convertAudioToU8(audio) {
	function readSample(samples, sample_index) {
		// Downsample to 8-bit.
		const sample = divideRoundHalfAwayFromZero(samples[sample_index], 1 << 8 * (audio.bytes_per_sample - 1));

		// Convert to unsigned.
		return sample + 0x80;
	}

	function readFrame(samples, sample_index) {
		// Downsample to mono by averaging the samples.
		let accumulator = 0;

		for (let i = sample_index; i < sample_index + audio.channels; i++)
			accumulator += readSample(samples, i);

		return divideRoundHalfAwayFromZero(accumulator, audio.channels);
	}

	const old_samples = audio.samples;
	audio.samples = [];

	for (let i = 0; i < old_samples.length; i += audio.channels)
		audio.samples.push(readFrame(old_samples, i));

	audio.channels = 1;
	audio.bytes_per_sample = 1;
}

function convertPcm(audio) {
	return Buffer.from(audio.samples);
}

function convertDpcm(audio, deltas) {
	function findClosestDelta(sample, previous_sample) {
		let best_error = Infinity;
		let best_index;

		for (let delta_index = 0; delta_index < deltas.length; delta_index++) {
			const approximated_sample = (previous_sample + deltas[delta_index]) & 0xFF;
			const error = Math.abs(sample - approximated_sample);

			if (best_error > error) {
				best_error = error;
				best_index = delta_index;
			}
		}

		return best_index;
	}

	const output = [];
	let previous_sample = 0x80;
	let accumulator = 0;
	let flip_flop = false;

	for (const sample of audio.samples) {
		const index = findClosestDelta(sample, previous_sample);

		previous_sample = previous_sample + deltas[index];

		accumulator &= 0xF;
		accumulator <<= 4;
		accumulator |= index;

		if (flip_flop === true)
			output.push(accumulator);

		flip_flop = !flip_flop;
	}

	return Buffer.from(output);
}

module.exports = {
	readWavFile: readWavFile,
	convertAudioToU8: convertAudioToU8,
	convertPcm: convertPcm,
	convertDpcm: convertDpcm,
};
