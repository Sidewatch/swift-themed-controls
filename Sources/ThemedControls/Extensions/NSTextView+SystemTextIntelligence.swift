//
//  NSTextView+SystemTextIntelligence.swift
//  ThemedControls
//
//  One configured field editor per window (AppKit expects the same instance back for a window,
//  and never retains it — the table holds it, keyed weakly by window).
//
//  Created by David Sherlock on 9/5/26.
//

import AppKit

extension NSTextView {
    /// Writing Tools, autocorrect, smart substitutions, spelling/grammar overlays,
    /// data/link detection and inline predictive text — all off. Idempotent.
    func disableSystemTextIntelligence() {
        disableWritingTools()
        isAutomaticQuoteSubstitutionEnabled = false
        isAutomaticDashSubstitutionEnabled = false
        isAutomaticTextReplacementEnabled = false
        isAutomaticSpellingCorrectionEnabled = false
        isAutomaticTextCompletionEnabled = false   // inline predictive text rides this
        isContinuousSpellCheckingEnabled = false
        isGrammarCheckingEnabled = false
        isAutomaticDataDetectionEnabled = false
        isAutomaticLinkDetectionEnabled = false
    }
}

extension NSTextField {
    /// The two switches that live on the FIELD, not the editor: inline predictive text
    /// (`isAutomaticTextCompletionEnabled`) and Writing Tools (`allowsWritingTools`,
    /// macOS 15.2). AppKit copies both onto the field editor when editing begins, so a
    /// window-level editor with them off is overruled by a field with them on. Every
    /// text field calls this once; the window's editor policy covers the rest.
    func disableSystemTextIntelligence() {
        isAutomaticTextCompletionEnabled = false
        if #available(macOS 15.2, *) { allowsWritingTools = false }
    }
}

/// One configured field editor per window (AppKit expects the same instance back
/// for a window, and never retains it — the table holds it, keyed weakly by window).
enum FieldEditorPolicy {
    private static let editors = NSMapTable<NSWindow, NSTextView>.weakToStrongObjects()

    /// The field editor `window` should lend its text fields.
    static func editor(for window: NSWindow) -> NSTextView {
        if let existing = editors.object(forKey: window) { return existing }
        let editor = NSTextView()
        editor.isFieldEditor = true
        editor.disableSystemTextIntelligence()
        editors.setObject(editor, forKey: window)
        return editor
    }
}
