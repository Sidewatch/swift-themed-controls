//
//  ControlPalette.swift
//  ThemedControls
//
//  The colours and fonts every themed control reads, supplied by the host app's theme.
//
//  Created by David Sherlock on 9/5/26.
//

import AppKit

/// What a themed control needs to know about the current theme. The host installs one as
/// `ThemedControls.palette` and posts `ThemedControls.paletteDidChange` when it changes;
/// every control reads the palette live, so a theme switch is one repaint away.
public protocol ControlPalette: Sendable {
    /// Whether the theme is dark — picks scroller knob styles and blend directions.
    var isDark: Bool { get }
    var accent: NSColor { get }
    var foreground: NSColor { get }
    var selection: NSColor { get }
    var sidebarBackground: NSColor { get }
    var sidebarText: NSColor { get }
    var statusText: NSColor { get }
    var border: NSColor { get }
    var rowSeparator: NSColor { get }
    /// Text that should recede: placeholders, hints, a pop-up's secondary label.
    var mutedText: NSColor { get }
    /// The status bar's background, also used for table headers.
    var statusBackground: NSColor { get }
    /// The small UI font (captions, secondary buttons).
    var smallFont: NSFont { get }
    /// A surface lifted off the background: the foreground blended in by `dark` on a dark
    /// theme and by `light` on a light one (chips, fields, segment bars).
    func elevatedSurface(dark: CGFloat, light: CGFloat) -> NSColor
}
