//
//  PingWindow.swift
//  OverPing
//
//  Created by Nevyn Bengtsson on 1/15/17.
//  Copyright © 2017 Nevyn Bengtsson. All rights reserved.
//

import Cocoa

class PingWindow: NSWindow {

    open override func sendEvent(_ event: NSEvent)
    {
        if(
            // Allow dragging even on top of controls (since nothing is clickable)
            event.type == .leftMouseDown &&
            // But don't interfere with window resizing
            self.self.contentView!.bounds.insetBy(dx: 5, dy: 5).contains(event.locationInWindow)
        ) {
            performDrag(with: event)
        } else {
            super.sendEvent(event)
        }
    }
}
