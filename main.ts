// Entry program for the make.fun bounty "gta6-clipper-01"
// ("Clip GTA 6 for the most YouTube views").
//
// The entry itself is the YouTube video named in VIDEO.json; this
// program's only job is to hand that file to the grader by copying it
// from the bot directory into the output directory. Node 22, standard
// library only, no network, prints nothing on success.
//
// Run it the way the grader does:
//   mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts

import { copyFileSync, mkdirSync, readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));

// In the grader the repository sits at /bot and results go to /output;
// the environment names both outside it. The source falls back to this
// file's own directory (the repository root), so a plain checkout run
// works too.
const botDir = process.env.MAKEFUN_BOT_DIR ?? here;
const outDir = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';

const source = join(botDir, 'VIDEO.json');
const target = join(outDir, 'VIDEO.json');

// Read the file before copying: the gate expects VIDEO.json to be a
// JSON object naming the video's url, so fail loudly here rather than
// hand a malformed file on.
const video = JSON.parse(readFileSync(source, 'utf8'));
if (typeof video.url !== 'string' || video.url.length === 0) {
  throw new Error('VIDEO.json does not name a video url');
}

mkdirSync(outDir, { recursive: true });
copyFileSync(source, target);
