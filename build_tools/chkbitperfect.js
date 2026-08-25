#!/usr/bin/env node

const build = require('../build.js');
const common = require('./node/common.js');

// The hashes of the ROMs that the original releases were built from.
const known_builds = {
	'1bc674be034e43c96b86487ac69d9293': 'REV00',
	'09dadb5071eb35050067a32462e39c5f': 'REV01',
	'c6c15aea60bda10ae11c6bc375296153': 'REVXB',
};

build().then(function () {
	// Verify the ROM's hash against the known builds.
	const revision = known_builds[common.hashFile('s1built.bin')];

	console.log('-------------------------------------------------------------');

	if (revision !== undefined)
		console.log('ROM is bit-perfect with ' + revision + '.');
	else
		console.log('ROM is NOT bit-perfect with REV00, REV01, or REVXB!');

	common.exit();
});
