# Swift Themed Controls

AppKit controls drawn from a host-supplied palette. Module `ThemedControls`; `swift test` is the whole check.

- Swift 6 language mode with main-actor default isolation, tools 6.2, macOS 14+, AppKit only — no dependencies.
- Part of the Sidewatch package family; every package follows the same layout and PR rules.

## Module map

- `Protocols/` — protocols the module exposes: ControlPalette (what a control reads from the theme)
- `Core/` — the engine: ThemedControls (the installed palette and the paletteDidChange notification)
- `Controls/` — one control per file: ThemedSegmentBar, ThemedPillButton, ThemedCheckbox, ThemedSearchField, ThemedInputField, ThemedRowView, ThemedScrollView, EmptyStateView (secondary types alongside: ThemedInputStyle, PaddedFieldCell, ThemedSecureInputField, ThemedSelectionRowView, ThemedGroupRowView)
- `Support/` — pure helpers: SystemPalette (the macOS system colours as a palette)
- `Extensions/` — one extension per idiom: NSColor+Blend, NSImage+Tinted, NSTextView+SystemTextIntelligence, NSTextView+WritingTools

## Rules

@CONTRIBUTING.md

- A control reads `ThemedControls.palette` at draw time and observes `ThemedControls.paletteDidChange`; it never caches a colour across a theme switch.
- Classes the host may subclass are `open` with `open` overridable members; everything else is `public final`.
- Layout must degrade: a label that does not fit is shortened or dropped, never overlapped (`ThemedSegmentBar.content(for:width:)` is the model).
