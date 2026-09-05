//
//  NSImage+Tinted.swift
//  ThemedControls
//
//  A copy of an image painted in one colour, for symbols drawn by hand.
//
//  Created by David Sherlock on 9/5/26.
//

import AppKit

extension NSImage {
    /// A copy painted in `color` — template symbols drawn by hand need this, since
    /// `contentTintColor` belongs to image views and buttons, not to draw calls.
    public func tinted(_ color: NSColor) -> NSImage {
        let out = NSImage(size: size, flipped: false) { rect in
            self.draw(in: rect)
            color.set()
            rect.fill(using: .sourceAtop)
            return true
        }
        out.isTemplate = false
        return out
    }
}
