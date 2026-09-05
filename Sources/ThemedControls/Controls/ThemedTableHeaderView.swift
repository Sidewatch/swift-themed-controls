//
//  ThemedTableHeaderView.swift
//  ThemedControls
//
//  ThemedTableHeaderView.
//
//  Created by David Sherlock on 9/5/26.
//

import AppKit

public final class ThemedTableHeaderView: NSTableHeaderView {
    public override func draw(_ dirtyRect: NSRect) {
        ThemedControls.palette.statusBackground.setFill()
        dirtyRect.fill()
        super.draw(dirtyRect)   // then the cells, which draw themselves below
    }
}
