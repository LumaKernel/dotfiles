#!/usr/bin/env -S deno run --allow-read --allow-env=HOME --allow-run=which --allow-write

import { parse as parseJsonc } from "jsr:@std/jsonc@1";
import { join } from "jsr:@std/path@1";

// ================================================================
// Pure Layer: Types
// ================================================================

type SettingsMap = Readonly<Record<string, unknown>>;

type Sections = {
  readonly builtin: string;
  readonly managed: string;
};

// ================================================================
// Pure Layer: Markers
// ================================================================

const MARKER = {
  builtinBegin: "// [dotfiles:builtin:begin]",
  builtinEnd: "// [dotfiles:builtin:end]",
  managedBegin: "// [dotfiles:managed:begin]",
  managedEnd: "// [dotfiles:managed:end]",
  commented: "// [dotfiles:commented] ",
} as const;

function parseSections(content: string): Sections | null {
  const lines = content.split("\n");
  const builtin: string[] = [];
  const managed: string[] = [];
  let region: "builtin" | "managed" | null = null;
  let hasBuiltin = false;
  let hasManaged = false;

  for (const line of lines) {
    const t = line.trim();
    if (t === MARKER.builtinBegin) {
      region = "builtin";
      continue;
    }
    if (t === MARKER.builtinEnd) {
      region = null;
      hasBuiltin = true;
      continue;
    }
    if (t === MARKER.managedBegin) {
      region = "managed";
      continue;
    }
    if (t === MARKER.managedEnd) {
      region = null;
      hasManaged = true;
      continue;
    }
    if (region === "builtin") builtin.push(line);
    if (region === "managed") managed.push(line);
  }

  if (!hasBuiltin || !hasManaged) return null;
  return { builtin: builtin.join("\n"), managed: managed.join("\n") };
}

// ================================================================
// Pure Layer: Text Utilities
// ================================================================

function extractBetween(
  text: string,
  open: string,
  close: string,
): string {
  const start = text.indexOf(open);
  const end = text.lastIndexOf(close);
  if (start < 0 || end < 0 || end <= start) return "";
  return text.slice(start + 1, end);
}

const extractObjectInner = (text: string): string =>
  extractBetween(text, "{", "}");

const extractArrayInner = (text: string): string =>
  extractBetween(text, "[", "]");

function ensureTrailingComma(text: string): string {
  const lines = text.split("\n");
  for (let i = lines.length - 1; i >= 0; i--) {
    const t = lines[i].trim();
    if (t === "" || t.startsWith("//")) continue;
    if (!t.endsWith(",")) {
      lines[i] = lines[i].trimEnd() + ",";
    }
    break;
  }
  return lines.join("\n");
}

// ================================================================
// Pure Layer: Settings
// ================================================================

function extractSettingsKeys(builtinInner: string): ReadonlySet<string> {
  try {
    const obj = parseJsonc(`{${builtinInner}}`);
    if (obj && typeof obj === "object" && !Array.isArray(obj)) {
      return new Set(Object.keys(obj as Record<string, unknown>));
    }
  } catch {
    // fall through
  }
  return new Set();
}

function mergeSettings(
  base: SettingsMap,
  override: SettingsMap,
): SettingsMap {
  return { ...base, ...override };
}

function formatManagedSettingsLines(
  managed: SettingsMap,
  builtinKeys: ReadonlySet<string>,
  isabelleKeys: ReadonlySet<string>,
): string {
  return Object.entries(managed)
    .map(([key, value]) => {
      const line = `${JSON.stringify(key)}: ${JSON.stringify(value)}`;
      if (builtinKeys.has(key) && !isabelleKeys.has(key)) {
        return `  ${MARKER.commented}${line}`;
      }
      return `  ${line},`;
    })
    .join("\n");
}

function generateSettingsFile(
  builtinInner: string,
  managed: SettingsMap,
  builtinKeys: ReadonlySet<string>,
  isabelleKeys: ReadonlySet<string>,
): string {
  const builtinSection = builtinInner.trim()
    ? ensureTrailingComma(builtinInner)
    : "";
  const managedSection = formatManagedSettingsLines(managed, builtinKeys, isabelleKeys);

  return [
    "{",
    `  ${MARKER.builtinBegin}`,
    ...(builtinSection ? [builtinSection] : []),
    `  ${MARKER.builtinEnd}`,
    "",
    `  ${MARKER.managedBegin}`,
    ...(managedSection ? [managedSection] : []),
    `  ${MARKER.managedEnd}`,
    "}",
    "",
  ].join("\n");
}

// ================================================================
// Pure Layer: Keybindings
// ================================================================

function trimBlankLines(text: string): string {
  return text.replace(/^\n+/, "").replace(/\n+$/, "");
}

function concatArrayContents(
  contents: readonly string[],
): string {
  const parts = contents
    .map((c) => trimBlankLines(extractArrayInner(c)))
    .filter((c) => c.trim().length > 0);

  if (parts.length === 0) return "";

  return parts
    .map((p) => ensureTrailingComma(p))
    .join("\n\n");
}

function generateKeybindingsFile(
  builtinInner: string,
  managedContent: string,
): string {
  const builtinSection = builtinInner.trim()
    ? ensureTrailingComma(builtinInner)
    : "";

  return [
    "[",
    `  ${MARKER.builtinBegin}`,
    ...(builtinSection ? [builtinSection] : []),
    `  ${MARKER.builtinEnd}`,
    "",
    `  ${MARKER.managedBegin}`,
    ...(managedContent.trim() ? [managedContent] : []),
    `  ${MARKER.managedEnd}`,
    "]",
    "",
  ].join("\n");
}

// ================================================================
// Effect Layer
// ================================================================

async function commandExists(cmd: string): Promise<boolean> {
  try {
    const { success } = await new Deno.Command("which", {
      args: [cmd],
      stdout: "null",
      stderr: "null",
    }).output();
    return success;
  } catch {
    return false;
  }
}

async function detectVscodeDirs(): Promise<readonly string[]> {
  const home = Deno.env.get("HOME");
  if (!home) throw new Error("HOME is not set");

  const isabelleHome = join(home, ".isabelle");
  const results: string[] = [];

  try {
    for await (const entry of Deno.readDir(isabelleHome)) {
      if (!entry.isDirectory) continue;
      const userDir = join(
        isabelleHome,
        entry.name,
        "vscode",
        "user-data",
        "User",
      );
      try {
        if ((await Deno.stat(userDir)).isDirectory) {
          results.push(userDir);
        }
      } catch {
        // dir doesn't exist
      }
    }
  } catch {
    // ~/.isabelle doesn't exist
  }

  return results;
}

async function readText(path: string): Promise<string | null> {
  try {
    return await Deno.readTextFile(path);
  } catch {
    return null;
  }
}

function resolveBuiltinContent(
  existing: string | null,
  extractor: (text: string) => string,
): string {
  if (!existing) return "";
  const sections = parseSections(existing);
  return sections ? sections.builtin : extractor(existing);
}

// ================================================================
// Main
// ================================================================

async function main(): Promise<void> {
  if (!(await commandExists("isabelle"))) {
    console.error(
      "isabelle is not installed. Install with:\n  brew install --cask isabelle",
    );
    Deno.exit(1);
  }

  const targets = await detectVscodeDirs();
  if (targets.length === 0) {
    console.error("No Isabelle VSCode dirs found in ~/.isabelle/");
    console.error(
      "Run Isabelle at least once to create the directory structure.",
    );
    Deno.exit(1);
  }

  console.log(`Found ${targets.length} target(s):`);
  for (const t of targets) console.log(`  ${t}`);

  // Resolve dotfiles root from script location
  const dotfilesRoot = join(import.meta.dirname!, "..", "..");

  // Load source configs
  const vscodeSettingsSrc =
    (await readText(join(dotfilesRoot, "vscode", "user", "settings.json"))) ??
    "{}";
  const isabelleSettingsSrc =
    (await readText(
      join(dotfilesRoot, "isabelle", "codium", "settings.json"),
    )) ?? "{}";
  const vscodeKeybindingsSrc =
    (await readText(
      join(dotfilesRoot, "vscode", "user", "keybindings.json"),
    )) ?? "[]";
  const isabelleKeybindingsSrc =
    (await readText(
      join(dotfilesRoot, "isabelle", "codium", "keybindings.json"),
    )) ?? "[]";

  // Merge settings (isabelle overrides vscode)
  const isabelleSettings = (parseJsonc(isabelleSettingsSrc) ?? {}) as SettingsMap;
  const isabelleKeys: ReadonlySet<string> = new Set(Object.keys(isabelleSettings));
  const mergedSettings = mergeSettings(
    (parseJsonc(vscodeSettingsSrc) ?? {}) as SettingsMap,
    isabelleSettings,
  );

  // Merge keybindings (raw text to preserve comments)
  const mergedKeybindingsContent = concatArrayContents([
    vscodeKeybindingsSrc,
    isabelleKeybindingsSrc,
  ]);

  // Apply to each Isabelle version
  for (const targetDir of targets) {
    console.log(`\nProcessing: ${targetDir}`);

    // Settings
    const existingSettings = await readText(
      join(targetDir, "settings.json"),
    );
    const builtinSettingsInner = resolveBuiltinContent(
      existingSettings,
      extractObjectInner,
    );
    const builtinKeys = extractSettingsKeys(builtinSettingsInner);
    const settingsOutput = generateSettingsFile(
      builtinSettingsInner,
      mergedSettings,
      builtinKeys,
      isabelleKeys,
    );
    await Deno.writeTextFile(
      join(targetDir, "settings.json"),
      settingsOutput,
    );
    console.log("  settings.json updated");

    // Keybindings
    const existingKeybindings = await readText(
      join(targetDir, "keybindings.json"),
    );
    const builtinKeybindingsInner = resolveBuiltinContent(
      existingKeybindings,
      extractArrayInner,
    );
    const keybindingsOutput = generateKeybindingsFile(
      builtinKeybindingsInner,
      mergedKeybindingsContent,
    );
    await Deno.writeTextFile(
      join(targetDir, "keybindings.json"),
      keybindingsOutput,
    );
    console.log("  keybindings.json updated");
  }

  console.log("\nDone!");
}

main();
