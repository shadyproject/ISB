//
//  AppDelegate.swift
//  InternetSoundBoard
//
//  Created by Christopher Martin on 11/2/14.
//
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var statusItemController: StatusItemController!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusItemController = StatusItemController()
    }

    func applicationShouldTerminate(sender: NSApplication) -> NSApplicationTerminateReply {
        statusItemController = nil
        return NSApplicationTerminateReply.TerminateNow
    }
}

