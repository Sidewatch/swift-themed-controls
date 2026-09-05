//
//  ThemedInputField.swift
//  ThemedControls
//
//  Shared theming for Settings text inputs.
//
//  Created by David Sherlock on 7/21/26.
//

import AppKit

/// Shared theming for Settings text inputs. The system `NSTextField` / `NSSecureTextField`
/// bezel ignores the app theme — it paints a system-tinted box that clashes with a warm
/// palette (the "brownish field" bug) — so these fields are **borderless** and draw their
/// own rounded `ThemedControls.palette.border` box over an elevated surface, with themed text + caret.
/// Mirrors `ThemedSearchField`'s approach; re-tints on `.themeDidChange`.
private enum ThemedInputStyle {
    public static func apply(_ field: NSTextField) {
        field.isBordered = false
        field.drawsBackground = false
        field.focusRingType = .none
        field.wantsLayer = true
        field.layer?.cornerRadius = 5
        field.layer?.borderWidth = 1
        refresh(field)
    }
    public static func refresh(_ field: NSTextField) {
        field.layer?.backgroundColor = ThemedControls.palette.elevatedSurface(dark: 0.07, light: 0.04).cgColor
        // `rowSeparator`, not `ThemedControls.palette.border`: these sit inside a settings card, so
        // the recessed page-edge colour drew a near-black rectangle on a lifted
        // surface. Same reasoning as the card's row dividers — see Theme+Surfaces.
        field.layer?.borderColor = ThemedControls.palette.rowSeparator.cgColor
        field.textColor = ThemedControls.palette.foreground
        // Caret + selection follow the THEME's light/dark mode, not the system's.
        field.appearance = NSAppearance(named: ThemedControls.palette.isDark ? .darkAqua : .aqua)
    }
}

/// Insets the text a few points so it doesn't hug the rounded border (a right-aligned
/// number would otherwise touch the edge). Drawing/editing rects only — no layout.
private final class PaddedFieldCell: NSTextFieldCell {
    private static let dx: CGFloat = 6
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        super.drawingRect(forBounds: rect.insetBy(dx: Self.dx, dy: 0))
    }
    override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText,
                       delegate: Any?, event: NSEvent?) {
        super.edit(withFrame: rect.insetBy(dx: Self.dx, dy: 0), in: controlView,
                   editor: textObj, delegate: delegate, event: event)
    }
    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText,
                         delegate: Any?, start: Int, length: Int) {
        super.select(withFrame: rect.insetBy(dx: Self.dx, dy: 0), in: controlView,
                     editor: textObj, delegate: delegate, start: start, length: length)
    }
}

/// Theme-aware single-line text input for the Settings panes.
open class ThemedInputField: NSTextField {
    public convenience init() { self.init(frame: .zero) }
    public override init(frame frameRect: NSRect) { super.init(frame: frameRect); setup() }
    @available(*, unavailable) public required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        let padded = PaddedFieldCell()
        padded.isEditable = true
        padded.isSelectable = true
        padded.isScrollable = true
        padded.usesSingleLineMode = true
        cell = padded
        ThemedInputStyle.apply(self)
        disableSystemTextIntelligence()
        NotificationCenter.default.addObserver(self, selector: #selector(reTheme),
                                               name: ThemedControls.paletteDidChange, object: nil)
    }
    deinit { NotificationCenter.default.removeObserver(self) }
    @objc private func reTheme() { ThemedInputStyle.refresh(self) }
}

/// Secure (password) counterpart — the Usage session-key field. Keeps the masking cell
/// (`NSSecureTextFieldCell`), so no padded cell here; only the themed chrome is applied.
public final class ThemedSecureInputField: NSSecureTextField {
    public convenience init() { self.init(frame: .zero) }
    public override init(frame frameRect: NSRect) { super.init(frame: frameRect); setup() }
    @available(*, unavailable) public required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        ThemedInputStyle.apply(self)
        disableSystemTextIntelligence()
        NotificationCenter.default.addObserver(self, selector: #selector(reTheme),
                                               name: ThemedControls.paletteDidChange, object: nil)
    }
    deinit { NotificationCenter.default.removeObserver(self) }
    @objc private func reTheme() { ThemedInputStyle.refresh(self) }
}
