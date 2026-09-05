//
//  PaletteTests.swift
//  ThemedControlsTests
//
//  Tests for the installed palette and the system default.
//
//  Created by David Sherlock on 9/5/26.
//

import XCTest
@testable import ThemedControls

@MainActor
final class PaletteTests: XCTestCase {

    private struct Loud: ControlPalette {
        var isDark: Bool { true }
        var accent: NSColor { .red }
        var foreground: NSColor { .white }
        var selection: NSColor { .blue }
        var sidebarBackground: NSColor { .black }
        var sidebarText: NSColor { .gray }
        var statusText: NSColor { .gray }
        var border: NSColor { .gray }
        var rowSeparator: NSColor { .gray }
        var smallFont: NSFont { .systemFont(ofSize: 9) }
        func elevatedSurface(dark: CGFloat, light: CGFloat) -> NSColor { dark > light ? .darkGray : .lightGray }
    }

    func testTheSystemPaletteIsInstalledByDefaultAndCanBeReplaced() {
        XCTAssertTrue(ThemedControls.palette is SystemPalette)
        ThemedControls.palette = Loud()
        defer { ThemedControls.palette = SystemPalette() }
        XCTAssertEqual(ThemedControls.palette.accent, .red)
        XCTAssertEqual(ThemedControls.palette.elevatedSurface(dark: 0.1, light: 0.05), .darkGray)
    }

    func testTheSystemPaletteLiftsASurfaceTowardTheForeground() {
        let p = SystemPalette()
        XCTAssertNotEqual(p.elevatedSurface(dark: 0.2, light: 0.2), NSColor.windowBackgroundColor, "blended, not the raw background")
        XCTAssertEqual(p.smallFont.pointSize, NSFont.smallSystemFontSize)
    }
}
