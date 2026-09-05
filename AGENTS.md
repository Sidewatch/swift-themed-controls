# Swift Themed Controls

A tiny, dependency-free editor **theme model** + a robust **VS Code theme importer**. Import real-world `.json` color themes (including JSONC ones with comments) into a flat, `Codable` `ThemePalette`, or use the bundled built-in palettes. Pure Foundation, zero dependencies.

- Module `ThemedControls` in `Sources/ThemedControls`; tests in `Tests`; `swift test` is the whole check.
- Swift 6 language mode, tools 6.2, macOS 14+, no dependencies unless the README says so.
- Part of the Sidewatch package family; every package follows the same layout and PR rules.

## Module map

- `Support/` — VSCodeTokenRules (scope → foreground, last rule wins), VSCodeUIColors (the colors map)
- `Core/` — the engine: BuiltInThemes, VSCodeThemeImporter
- `Models/` — value types — the shape of a thing, nothing else: ANSIColors, ThemePalette

## Rules

Read `CONTRIBUTING.md` before changing anything: it is the layout and PR rulebook for this package.
