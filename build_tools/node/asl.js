// Runs the WebAssembly build of the Macro Assembler AS.
//
// The assembler is a POSIX program, so it is given a POSIX filesystem: the
// repository is mounted at '/source', and the assembler's message catalogues at
// '/msg'. Emscripten's 'NODEFS' translates those paths back to real ones, which
// is what makes this work on Windows, where the assembler would otherwise
// produce paths like '/C:\path\to\file' and fail to open them.
//
// Each assembly is done in a child process, since the assembler is not designed
// to be ran more than once in the same process:
//   node build_tools/node/asl.js <root directory> -- <assembler arguments>

const path = require('path');
const {spawn} = require('child_process');

const wasm_directory = path.join(__dirname, 'wasm');
const message_directory = path.join(wasm_directory, 'msg');

const SOURCE_MOUNT_POINT = '/source';
const MESSAGE_MOUNT_POINT = '/msg';

// Runs the assembler in a child process, returning its exit code.
function assemble(root_directory, assembler_arguments) {
	return new Promise((resolve, reject) => {
		const child = spawn(process.execPath, [__filename, root_directory, '--', ...assembler_arguments], {stdio: 'inherit'});

		child.on('error', reject);
		child.on('close', resolve);
	});
}

async function assembleHere(root_directory, assembler_arguments) {
	const createASL = require('./wasm/asl.js');

	const asl = await createASL({
		locateFile: (url) => path.join(wasm_directory, url),
		print: (text) => process.stdout.write(text + '\n'),
		printErr: (text) => process.stderr.write(text + '\n'),
		preRun: [function (asl) {
			const filesystem = asl.FS;

			filesystem.mkdir(SOURCE_MOUNT_POINT);
			filesystem.mount(filesystem.filesystems.NODEFS, {root: path.resolve(root_directory)}, SOURCE_MOUNT_POINT);
			filesystem.chdir(SOURCE_MOUNT_POINT);

			// Tell the assembler where its message catalogues are.
			filesystem.mkdir(MESSAGE_MOUNT_POINT);
			filesystem.mount(filesystem.filesystems.NODEFS, {root: message_directory}, MESSAGE_MOUNT_POINT);
			asl.ENV.AS_MSGPATH = MESSAGE_MOUNT_POINT;
		}],
	});

	try {
		asl.callMain(assembler_arguments);
	} catch (e) {
		// Emscripten throws 'ExitStatus' when the program calls 'exit'.
		if (e.name !== 'ExitStatus')
			throw e;

		return e.status;
	}

	return 0;
}

module.exports = assemble;

if (require.main === module) {
	const root_directory = process.argv[2];
	const assembler_arguments = process.argv.slice(process.argv.indexOf('--') + 1);

	assembleHere(root_directory, assembler_arguments).then((exit_code) => {
		process.exitCode = exit_code;
	});
}
