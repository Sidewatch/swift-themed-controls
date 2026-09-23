# Audit log

Last full audit: **17 Sep 2026** — every source file covered by the MECHANICAL checks below (build warnings, tests,
dead-code and risk-pattern scans, docs drift); line-by-line logic review was targeted at the areas changed since
5 Sep 2026, not the whole tree. Nothing needs re-scanning unless it changed after that date. Add a dated line under *History* when you audit again, and keep the
*Known non-issues* list current so the next pass skips them.

## What a full audit checks

1. `swift build` warnings (none allowed except those listed under known non-issues) and `swift test` green.
2. Dead code: every `func`/type/property declared once and referenced nowhere in the app or the family
   (`grep -w` across `*.swift` AND non-Swift files — selectors and MCP names live in strings). Protocol
   requirements, `override`s, `@objc` actions and public API are NOT dead because Sidewatch does not call them.
3. Risky patterns: `Timer` without `invalidate`, `addObserver(forName:)` without `removeObserver`, `as!`, `try!`
   outside literal regexes, `fatalError` outside `init?(coder:)`, `print(` outside harnesses, TODO/FIXME left behind.
4. Docs drift: every name in CLAUDE.md's module map exists; AGENTS.md mirrors CLAUDE.md; README Usage matches the API.

## Result on 17 Sep 2026

- Build: clean. Tests: green.
- Fixed: `AGENTS.md` was a copy of swift-theme-model's; it now mirrors CLAUDE.md.
- Fixed: `ThemedTableHeaderCell` added (band, hairlines, title inset + centring, pressed state, sort indicator) with pixel tests.

## Logic review — 18 Sep 2026 (every source and test file, line by line)

Nothing to fix. Checked: `ThemedSegmentBar` (the divider is skipped beside the selected pill, the
ellipsis plan never exceeds its segment, a click fires the action once and never for the current
segment), `ThemedPillButton` (`attributedTitle` set from `applyTheme` does not re-enter the `title`
observer), `ThemedTableHeaderCell` (the column-rect test, the pressed flag dropped around
`drawInterior`, the indicator read from the table's own descriptors), `ThemedScrollView.tile()`'s
`!=` guard, `ThemedSearchField`'s placeholder applied at the end of init, `EmptyStateView`'s fixed
wrap width, `FieldEditorPolicy`'s weak-keyed table, `SystemPalette`.

## Known non-issues (do not "fix" these again)

- `ThemedCheckbox.allowsVibrancy` shows as unreferenced — it is an `NSView` override AppKit reads.
- Pixel tests sample in POINTS (backing scale) and compare against the palette colour rendered through the same path — never against its hex.

## History

- 17 Sep 2026 — full audit (app + all 20 libraries), Claude with David.
- 18 Sep 2026 — logic review (every source and test file, line by line), Claude with David.
- 18 Sep 2026 — `ThemedSlider` (filled track = palette accent) and a visible disabled state on `ThemedPillButton` (40%); both tested. For the app's database view and Settings sliders, which still wore system chrome.
- 19 Sep 2026 — `ThemedSwitch`: NSSwitch has no tint API, so a gold or teal theme showed blue switches; tested incl. the painted track.
- 23 Sep 2026 — `ThemedSwitch.controlSize`: small and mini are the regular footprint scaled (0.78, 0.62) — `NSSwitch` reports one intrinsic size for every controlSize on macOS 27, so nothing can be read from it; test. The first commit of this (8823c87) went out with that test red: commit only on a green run.
