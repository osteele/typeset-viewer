import { readdir } from "node:fs/promises";
import { join } from "node:path";

interface ScreenshotAsset {
	id: string;
	output: string;
	width: number;
	height: number;
	fixture?: string;
}

interface ScreenshotManifest {
	schemaVersion: number;
	assets: ScreenshotAsset[];
}

const repoRoot = new URL("../", import.meta.url).pathname;
const manifest = (await Bun.file(
	join(repoRoot, "screenshots/manifest.json"),
).json()) as ScreenshotManifest;
const html = await Bun.file(join(repoRoot, "site/index.html")).text();
const referenced = new Set(
	[
		...html.matchAll(
			/(?:src|srcset|content)="(?:https:\/\/typeset\.osteele\.com\/)?(assets\/[^" ]+\.png)/g,
		),
	].map((match) => `site/${match[1]}`),
);
const declared = new Map(manifest.assets.map((asset) => [asset.output, asset]));
const failures: string[] = [];

if (manifest.schemaVersion !== 1)
	failures.push(`unsupported manifest schema ${manifest.schemaVersion}`);

for (const path of referenced) {
	if (!declared.has(path))
		failures.push(`referenced image is missing from manifest: ${path}`);
}

const assetFiles = (await readdir(join(repoRoot, "site/assets")))
	.filter((name) => name.endsWith(".png"))
	.map((name) => `site/assets/${name}`);
for (const path of assetFiles) {
	if (!referenced.has(path)) failures.push(`unreferenced image: ${path}`);
}

for (const asset of manifest.assets) {
	if (!(await Bun.file(join(repoRoot, asset.output)).exists())) {
		failures.push(`missing image: ${asset.output}`);
		continue;
	}
	if (
		asset.fixture &&
		!(await Bun.file(join(repoRoot, asset.fixture)).exists())
	) {
		failures.push(`missing fixture: ${asset.fixture}`);
	}
	const result = Bun.spawnSync([
		"sips",
		"-g",
		"pixelWidth",
		"-g",
		"pixelHeight",
		join(repoRoot, asset.output),
	]);
	const dimensions = result.stdout.toString();
	if (
		!dimensions.includes(`pixelWidth: ${asset.width}`) ||
		!dimensions.includes(`pixelHeight: ${asset.height}`)
	) {
		failures.push(
			`dimension mismatch for ${asset.output}; expected ${asset.width}x${asset.height}`,
		);
	}
}

if (failures.length > 0) {
	for (const failure of failures) console.error(`error: ${failure}`);
	process.exit(1);
}

console.log(`Checked ${manifest.assets.length} screenshot assets.`);
