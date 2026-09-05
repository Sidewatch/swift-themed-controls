# Swift Themed Controls

AppKit controls that draw from **your app's palette** instead of the system's: a segment bar, pill button, search and input fields, table row views, a scroll view with a themed scroller, a checkbox and an empty-state view. The stock controls paint a system bezel and selection that ignore a custom theme; these read live from one `ControlPalette` and repaint on a notification, so a theme switch is one repaint away.

- Module `ThemedControls` in `Sources/ThemedControls`; tests in `Tests`; `swift test` is the whole check.
- Swift 6 language mode with main-actor default isolation, tools 6.2, macOS 14+, AppKit only.
- Part of the Sidewatch package family; every package follows the same layout and PR rules.

## Usage

```swift
import ThemedControls

// Once at launch: install your palette (a value type reading your theme live).
ThemedControls.palette = MyPalette()
// After every theme switch:
NotificationCenter.default.post(name: ThemedControls.paletteDidChange, object: nil)

let bar = ThemedSegmentBar(labels: ["All", "Prompts", "Commands"], symbols: ["square.grid.2x2", "text.bubble", "terminal"])
bar.fillsWidth = true
bar.target = self; bar.action = #selector(filterChanged)
```

`ControlPalette` is the whole contract: a handful of colours, the small font, and `elevatedSurface(dark:light:)`. `SystemPalette` (the macOS system colours) is installed until you replace it, so a control never draws blank.

## Controls

- `ThemedSegmentBar` — equal-width or hugging segments with SF Symbols; shortens or drops labels that do not fit; redraws while resized.
- `ThemedPillButton`, `ThemedCheckbox` — accent-filled controls (`open`, subclassable).
- `ThemedSearchField`, `ThemedInputField`, `ThemedSecureInputField` — fields with a themed border and placeholder.
- `ThemedRowView`, `ThemedSelectionRowView`, `ThemedGroupRowView` — `NSTableRowView`s with the palette's selection and separators.
- `ThemedScrollView` — overlay scrollers whose knob follows the palette's appearance.
- `EmptyStateView` — symbol, title, subtitle and up to two actions, centred.

## For agents

See `CLAUDE.md` for the module map and `CONTRIBUTING.md` for the rules a PR is held to.
