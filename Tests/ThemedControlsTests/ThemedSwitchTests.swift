//
//  ThemedSwitchTests.swift
//  ThemedControlsTests
//
//  The switch's contract: the stock footprint, toggle fires once, a set state is silent, the
//  painted track is the palette accent when on.
//
//  Created by David Sherlock on 9/19/26.
//

import XCTest
@testable import ThemedControls

/// Tests for `ThemedSwitch`: footprint, action firing, silent state set, disabled, and the
/// pixels of the track under a red-accent palette.
@MainActor
final class ThemedSwitchTests: XCTestCase {
    private struct RedAccent: ControlPalette {
        var isDark: Bool { true }
        var accent: NSColor { .red }
        var foreground: NSColor { .white }
        var selection: NSColor { .blue }
        var sidebarBackground: NSColor { .black }
        var sidebarText: NSColor { .gray }
        var statusText: NSColor { .gray }
        var border: NSColor { .gray }
        var rowSeparator: NSColor { .gray }
        var mutedText: NSColor { .gray }
        var statusBackground: NSColor { .black }
        var smallFont: NSFont { .systemFont(ofSize: 9) }
        func elevatedSurface(dark: CGFloat, light: CGFloat) -> NSColor { .darkGray }
    }

    private final class Counter: NSObject {
        var fired = 0
        @objc func toggled(_ sender: Any?) { fired += 1 }
    }

    func testTheFootprintIsTheStockSwitchs() {
        XCTAssertEqual(ThemedSwitch().intrinsicContentSize, NSSwitch().intrinsicContentSize)
    }

    func testToggleFlipsAndFiresOnceAndASetStateIsSilent() {
        let sw = ThemedSwitch()
        let counter = Counter()
        sw.target = counter; sw.action = #selector(Counter.toggled(_:))
        sw.toggle()
        XCTAssertEqual(sw.state, .on)
        XCTAssertEqual(counter.fired, 1)
        sw.state = .off
        XCTAssertEqual(counter.fired, 1, "setting the state programmatically does not fire the action")
        sw.isEnabled = false
        sw.toggle()
        XCTAssertEqual(sw.state, .off, "a disabled switch ignores the click")
        XCTAssertEqual(counter.fired, 1)
    }

    /// Renders the switch on and off and reads the track where the knob is not.
    func testTheTrackPaintsTheAccentWhenOnAndNotWhenOff() throws {
        ThemedControls.palette = RedAccent()
        defer { ThemedControls.palette = SystemPalette() }
        let sw = ThemedSwitch(frame: NSRect(origin: .zero, size: NSSwitch().intrinsicContentSize))
        func redShare(_ side: CGFloat) throws -> Double {
            let rep = try XCTUnwrap(sw.bitmapImageRepForCachingDisplay(in: sw.bounds))
            sw.cacheDisplay(in: sw.bounds, to: rep)
            let scale = CGFloat(rep.pixelsWide) / sw.bounds.width
            var reds = 0, samples = 0
            for px in stride(from: Int(sw.bounds.width * (side - 0.08) * scale), to: Int(sw.bounds.width * (side + 0.08) * scale), by: 1) {
                guard let c = rep.colorAt(x: px, y: rep.pixelsHigh / 2)?.usingColorSpace(.sRGB) else { continue }
                samples += 1
                if c.redComponent > 0.6, c.greenComponent < 0.35, c.blueComponent < 0.35 { reds += 1 }
            }
            return Double(reds) / Double(max(samples, 1))
        }
        sw.state = .on      // knob at the right → sample the LEFT of the track
        XCTAssertGreaterThan(try redShare(0.22), 0.8, "on: the track is the palette accent")
        sw.state = .off     // knob at the left → sample the RIGHT
        XCTAssertLessThan(try redShare(0.78), 0.1, "off: a lifted surface, not the accent")
    }
}
