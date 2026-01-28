//
//  AppDelegate.swift
//  OverPing
//
//  Created by Nevyn Bengtsson on 1/8/17.
//  Copyright © 2017 Nevyn Bengtsson. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Configure main window appearance for rounded corners and vibrancy-friendly content
        if let window = NSApp.windows.first {
            // Opt into full-size content view so content can extend under the titlebar
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.styleMask.insert(.fullSizeContentView)

            // Use a standard rounded corner radius
            window.isOpaque = false
            window.backgroundColor = .clear
            window.contentView?.wantsLayer = true
            window.contentView?.layer?.cornerRadius = 26
            window.contentView?.layer?.masksToBounds = true
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

