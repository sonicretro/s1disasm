#!/usr/bin/env node

////////////////
// Settings ////
////////////////

// Set this to true to use a better compression algorithm for the DAC driver.
// Having this set to false will use an inferior compression algorithm that
// results in an accurate ROM being produced.
const improved_dac_driver_compression = false;

///////////////////////
// End of settings ////
///////////////////////

const common = require('./build_tools/node/common.js');

///////////////////////////////////////
// Actual build script begins here ////
///////////////////////////////////////

async function build() {
	// Produce PCM and DPCM data.
	common.convertPcmFilesInDirectory('sound/dac/pcm');
	common.convertDpcmFilesInDirectory('sound/dac/dpcm');

	// Build the ROM.
	await common.buildRomAndHandleFailure('sonic', 's1built', [], {
		padding_value: 0xFF,
		compressed_segments: [{
			starting_address: 0,
			compression: improved_dac_driver_compression ? 'kosinski-optimised' : 'kosinski',
			constant: 'Size_of_DAC_driver_guess',
			type: 'after',
		}],
	}, false);

	// Correct the ROM's header with a proper checksum and end-of-ROM value.
	common.fixHeader('s1built.bin');
}

module.exports = build;

if (require.main === module)
	build().then(common.exit);
