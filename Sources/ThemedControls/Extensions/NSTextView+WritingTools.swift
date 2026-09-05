//
//  NSTextView+WritingTools.swift
//  ThemedControls
//
//  Apple's Writing Tools OFF for every text surface, Xcode-style. An AI
//  rewrite menu inside a code-review cockpit is the "second steering wheel"
//  the product bans — the agent in the terminal is the only writer here.
//
//  Created by David Sherlock on 8/27/26.
//

import AppKit

extension NSTextView {
    /// Suppresses Writing Tools on this view (context menu + Edit menu entry).
    func disableWritingTools() {
        if #available(macOS 15.2, *) { writingToolsBehavior = .none }
    }
}
