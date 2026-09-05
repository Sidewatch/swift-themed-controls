//
//  NSColor+Blend.swift
//  Sidewatch
//
//  This color (normalized to sRGB) blended `fraction` of the way toward `other`.
//
//  Created by David Sherlock on 7/10/26.
//

import AppKit

extension NSColor {
    /// This color (normalized to sRGB) blended `fraction` of the way toward `other`.
    /// Falls back to `self` if the blend can't be computed. Used to lift a surface
    /// off the editor background for panels, popovers, and inline boxes.
    func blended(_ fraction: CGFloat, toward other: NSColor) -> NSColor {
        let a = usingColorSpace(.sRGB) ?? self
        let b = other.usingColorSpace(.sRGB) ?? other
        return a.blended(withFraction: fraction, of: b) ?? self
    }
}
