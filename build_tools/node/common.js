// Utilities shared by 'build.js' and 'chkbitperfect.js'.

const crypto = require('crypto');
const fs = require('fs');

const assemble = require('./asl.js');
const p2bin = require('./p2bin.js');
const wav = require('./wav.js');

const common = {};

// Set to false when something goes wrong, so that the build can report failure
// even if it managed to continue.
common.exit_code = 0;

// Pass '--listing' to have the assembler write a listing file ('sonic.lst'),
// for when you need to see what it made of the source. It is not produced
// otherwise: the listing is megabytes that nothing reads, and writing it costs
// a noticeable chunk of every build.
common.listing = process.argv.includes('--listing');

/////////////////////////
// General Utilities  ///
/////////////////////////

function exit() {
	process.exit(common.exit_code);
}

function handleFailure(message_printed, abort) {
	if (message_printed)
		common.exit_code = 1;

	if (abort)
		exit();
}

function fileExists(file_path) {
	return fs.existsSync(file_path);
}

function hashFile(file_path) {
	return crypto.createHash('md5').update(fs.readFileSync(file_path)).digest('hex');
}

function showFlashyMessage(message) {
	const width = 70;

	const full_line = '*'.repeat(width);
	const empty_line = '*' + ' '.repeat(width - 2) + '*';

	let left_padding = Math.floor((width - 2 - message.length) / 2);
	let right_padding = width - 2 - message.length - left_padding;

	if (left_padding < 0)
		left_padding = 0;

	if (right_padding < 0)
		right_padding = 0;

	const message_line = '*' + ' '.repeat(left_padding) + message + ' '.repeat(right_padding) + '*';

	console.log('\n' + [full_line, empty_line, message_line, empty_line, full_line].join('\n') + '\n');
}

/////////////////////////
// Directory Listing  ///
/////////////////////////

function getDirectoryContents(directory, extension) {
	const contents = fs.readdirSync(directory, {withFileTypes: true})
		.filter((entry) => entry.isFile())
		.map((entry) => entry.name)
		.sort();

	if (!extension)
		return contents;

	// AS treats everything after the first period as the file extension, so we do too.
	return contents
		.filter((filename) => filename.slice(filename.indexOf('.')) === extension)
		.map((filename) => filename.slice(0, filename.indexOf('.')));
}

// Determines which of a directory's files have been modified since the last
// build, so that only those files have to be processed again.
//
// A file is considered modified if its hash differs from the one recorded in
// 'hashes.json', if any of its generated files are missing, or if any of the
// given 'custom_hashes' (settings that affect every file) differ.
function getDirectoryContentsChanged(directory, base_extension, replacement_extensions, custom_hashes) {
	const hashes_file_path = directory + '/generated/hashes.json';

	let hashes;

	try {
		hashes = JSON.parse(fs.readFileSync(hashes_file_path, 'utf8'));
	} catch (e) {
		// 'hashes.json' does not exist or is corrupt: start over with an empty table.
		hashes = {};
	}

	let custom_hashes_differ = false;

	for (const key in custom_hashes)
		if (hashes[key] !== custom_hashes[key]) {
			hashes[key] = custom_hashes[key];
			custom_hashes_differ = true;
		}

	const filtered_contents = [];

	for (const filename of getDirectoryContents(directory, base_extension)) {
		const hash = hashFile(directory + '/' + filename + base_extension);
		const file_differs = hashes[filename] !== hash;

		hashes[filename] = hash;

		const output_file_missing = replacement_extensions.some(
			(replacement_extension) => !fileExists(directory + '/generated/' + filename + replacement_extension));

		if (custom_hashes_differ || file_differs || output_file_missing)
			filtered_contents.push(filename);
	}

	fs.writeFileSync(hashes_file_path, JSON.stringify(hashes, null, '\t') + '\n');

	return filtered_contents;
}

/////////////////////
// PCM Processing ///
/////////////////////

function convertWavFilesInDirectory(directory, extension, convert, custom_hashes) {
	for (const filename_stem of getDirectoryContentsChanged(directory, '.wav', [extension, '.inc'], custom_hashes)) {
		const input_file_path = directory + '/' + filename_stem + '.wav';
		const output_file_path = directory + '/generated/' + filename_stem + extension;
		const inc_file_path = directory + '/generated/' + filename_stem + '.inc';

		console.log("Converting WAV file '" + input_file_path + "'...");

		let audio;

		try {
			audio = wav.readWavFile(input_file_path);
			wav.convertAudioToU8(audio);
			fs.writeFileSync(output_file_path, convert(audio));
		} catch (e) {
			console.log("Failed to convert '" + input_file_path + "' to '" + output_file_path + "'. Error message was:\n\t" + e.message);
			handleFailure(true, true);
			continue;
		}

		fs.writeFileSync(inc_file_path,
			'.sample_rate = ' + audio.sample_rate + '\n'
			+ '.size = ' + fs.statSync(output_file_path).size + '\n'
			+ '\tbinclude "' + output_file_path + '"\n');
	}
}

function convertPcmFilesInDirectory(directory) {
	convertWavFilesInDirectory(directory, '.pcm', (audio) => wav.convertPcm(audio));
}

function convertDpcmFilesInDirectory(directory) {
	const deltas_file_path = directory + '/deltas.bin';

	// Gracefully handle a missing file here to prevent a total build failure.
	// Users of custom sound drivers may remove the file, and not need any of
	// this conversion logic.
	if (!fileExists(deltas_file_path)) {
		console.log('Skipping conversion of DPCM files!');
		return;
	}

	const deltas = fs.readFileSync(deltas_file_path);

	convertWavFilesInDirectory(directory, '.dpcm', (audio) => wav.convertDpcm(audio, deltas), {deltas: hashFile(deltas_file_path)});
}

/////////////////////
// ROM Patching   ///
/////////////////////

// Correct the ROM's header with a proper checksum and end-of-ROM value.
function fixHeader(filename) {
	const rom = fs.readFileSync(filename);

	// Write the end-of-ROM value to the ROM header.
	rom.writeUInt32BE(rom.length - 1, 0x1A4);

	// Calculate the checksum.
	let checksum = 0;

	for (let i = 0x200; i < rom.length; i += 2)
		if (i + 2 <= rom.length)
			checksum += rom.readUInt16BE(i);
		else
			checksum += rom.readUInt8(i) << 8;

	// Write the checksum to the ROM header.
	rom.writeUInt16BE(checksum & 0xFFFF, 0x18E);

	fs.writeFileSync(filename, rom);
}

/////////////////
// Assembling ///
/////////////////

// Produce a binary from an assembly file.
// Returns whether a message was printed, and whether the build process should
// be aborted.
async function assembleFile(input_filename, output_filename, assembler_arguments, p2bin_options, create_header_file) {
	async function assembleFileInner() {
		// AS substitutes everything after the first period.
		const input_filename_before_first_period = input_filename.slice(0, input_filename.indexOf('.'));

		const object_filename = input_filename_before_first_period + '.p';
		const header_filename = input_filename_before_first_period + '.h';
		const log_filename = input_filename_before_first_period + '.log';

		// Delete the object and log files, so that we can use their presence to detect a successful build later on.
		fs.rmSync(object_filename, {force: true});
		fs.rmSync(log_filename, {force: true});

		// Assemble the ROM, producing an object file.
		// '-xx'  - shows the most detailed error output
		// '-q'   - shuts up AS
		// '-A'   - gives us a small speedup
		// '-U'   - forces case-sensitivity
		// '-E'   - output errors to a file (*.log)
		// '-i .' - allows (b)include paths to be absolute
		// '-c'   - outputs a shared file (*.h)
		// '-L'   - writes a listing file (*.lst), only when asked for
		await assemble('.', ['-xx', '-n', '-q', '-A', '-U', '-E', '-i', '.']
			.concat(create_header_file ? ['-c'] : [])
			.concat(common.listing ? ['-L'] : [])
			.concat(assembler_arguments)
			.concat([input_filename]));

		// If the assembler encountered an error, then the object file will not exist.
		if (!fileExists(object_filename))
			return fileExists(log_filename) ? {result: 'error', log_filename: log_filename} : {result: 'crash'};

		// Convert the object file to a flat binary.
		try {
			p2bin(object_filename, output_filename, create_header_file ? header_filename : null, p2bin_options);
		} catch (e) {
			console.log('p2bin: ' + e.message);
			fs.rmSync(output_filename, {force: true});
		}

		// Remove the object file, since we no longer need it.
		fs.rmSync(object_filename, {force: true});

		if (!fileExists(output_filename))
			return {result: 'failure'};
		else if (fileExists(log_filename))
			return {result: 'warning', log_filename: log_filename};

		return {};
	}

	const {result, log_filename} = await assembleFileInner();

	if (log_filename !== undefined)
		process.stdout.write(fs.readFileSync(log_filename, 'utf8'));

	if (result === 'failure') {
		showFlashyMessage('Build failed. See above for more details.');
		return [true, true]; // Error message, abort.
	} else if (result === 'crash') {
		showFlashyMessage('The assembler crashed. See above for more details.');
		return [true, true]; // Error message, abort.
	} else if (result === 'error') {
		showFlashyMessage('There were build errors. See ' + log_filename + ' for more details.');
		return [true, true]; // Error message, abort.
	} else if (result === 'warning') {
		showFlashyMessage('There were build warnings. See ' + log_filename + ' for more details.');
		return [true, false]; // Warning message, continue.
	}

	return [false, false]; // No message, continue.
}

async function assembleFileAndHandleFailure(...args) {
	handleFailure(...await assembleFile(...args));
}

function buildRom(input_filename, output_filename, assembler_arguments, p2bin_options, create_header_file) {
	// Delete old ROM.
	fs.rmSync(output_filename + '.prev.bin', {force: true});

	// Backup the most recent ROM.
	if (fileExists(output_filename + '.bin'))
		fs.renameSync(output_filename + '.bin', output_filename + '.prev.bin');

	// Assemble the ROM.
	return assembleFile(input_filename + '.asm', output_filename + '.bin', assembler_arguments, p2bin_options, create_header_file);
}

async function buildRomAndHandleFailure(...args) {
	handleFailure(...await buildRom(...args));
}

common.exit = exit;
common.handleFailure = handleFailure;
common.fileExists = fileExists;
common.hashFile = hashFile;
common.showFlashyMessage = showFlashyMessage;
common.getDirectoryContents = getDirectoryContents;
common.getDirectoryContentsChanged = getDirectoryContentsChanged;
common.convertPcmFilesInDirectory = convertPcmFilesInDirectory;
common.convertDpcmFilesInDirectory = convertDpcmFilesInDirectory;
common.fixHeader = fixHeader;
common.assembleFile = assembleFile;
common.assembleFileAndHandleFailure = assembleFileAndHandleFailure;
common.buildRom = buildRom;
common.buildRomAndHandleFailure = buildRomAndHandleFailure;
module.exports = common;
