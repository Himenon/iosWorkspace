//
//  AppDelegate.swift
//  Seal2Imag
//
//  Created by Himeno Kosei on 2017/01/03.
//  Copyright © 2017年 Kosei Himeno. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(theApplication: NSApplication!)
         -> Bool {
            return true
    }


}

