//
//  ThemedSegmentBarTests.swift
//  ThemedControlsTests
//
//  Tests for the segment bar's content plan: what fits in a segment of a given width.
//
//  Created by David Sherlock on 9/5/26.
//

import XCTest
@testable import ThemedControls

/// Tests for `ThemedSegmentBar.content(for:width:)`: wide segments show symbol and text, narrow
/// ones degrade to the symbol, and the bar redraws while resized.
@MainActor
final class ThemedSegmentBarTests: XCTestCase {

    private let font = NSFont.systemFont(ofSize: 11, weight: .medium)
    private func width(_ s: String) -> CGFloat { ceil((s as NSString).size(withAttributes: [.font: font]).width) }

    func testTheBarRedrawsWhileResized() {
        XCTAssertEqual(ThemedSegmentBar(labels: ["A"]).layerContentsRedrawPolicy, .duringViewResize)
    }

    func testWideSegmentsShowSymbolAndText() {
        let bar = ThemedSegmentBar(labels: ["All", "Prompts", "Commands"], symbols: ["square.grid.2x2", "text.bubble", "terminal"])
        let plan = bar.content(for: 2, width: 140)
        XCTAssertEqual(plan.symbol, "terminal"); XCTAssertEqual(plan.text, "Commands")
    }

    func testNarrowSegmentsKeepTheSymbolAndDropTheText() {
        let bar = ThemedSegmentBar(labels: ["All", "Prompts", "Commands"], symbols: ["square.grid.2x2", "text.bubble", "terminal"])
        let plan = bar.content(for: 2, width: 60)
        XCTAssertEqual(plan.symbol, "terminal"); XCTAssertEqual(plan.text, "")
        XCTAssertEqual(bar.content(for: 0, width: 60).text, "All", "a short label still fits")
    }

    func testTextOnlySegmentsTruncateWithAnEllipsis() {
        let bar = ThemedSegmentBar(labels: ["Today", "This week", "This month"])
        let plan = bar.content(for: 2, width: 50)
        XCTAssertTrue(plan.text.hasSuffix("…")); XCTAssertLessThanOrEqual(width(plan.text), 50 - 12)
    }

    func testEveryPlanFitsItsSegment() {
        let bar = ThemedSegmentBar(labels: ["All", "Prompts", "Commands"], symbols: ["square.grid.2x2", "text.bubble", "terminal"])
        for w in stride(from: 20, through: 200, by: 10) {
            for i in 0..<3 {
                let plan = bar.content(for: i, width: CGFloat(w))
                let need = width(plan.text) + (plan.symbol == nil ? 0 : (plan.text.isEmpty ? 14 : 18))
                XCTAssertLessThanOrEqual(need, CGFloat(w) - 12 + 0.5, "width \(w) segment \(i): \(plan)")
            }
        }
    }

    func testEqualWidthFramesSpanTheBar() {
        let bar = ThemedSegmentBar(labels: ["A", "B", "C"]); bar.fillsWidth = true
        bar.frame = NSRect(x: 0, y: 0, width: 300, height: 28)
        let frames = bar.frames()
        XCTAssertEqual(frames.map(\.width), [100, 100, 100]); XCTAssertEqual(frames.last?.maxX, 300)
    }
}
