//  StatusItemController.swift
//  ISB
//
//  Created by Christopher Martin on 11/2/14.
//
//

import Foundation
import Cocoa
import AVFoundation

class StatusItemController: NSObject {
    let statusBarItem = NSStatusBar.systemStatusBar().statusItemWithLength(24.0)
    let soundController = SoundController()
    
    var importWindow: ImportWindow? = nil
    
    override init() {
        super.init()
        
        statusBarItem.menu = setupMenu()
        statusBarItem.image = NSImage(named: "BarIcon")
    }
    
    deinit {
        NSStatusBar.systemStatusBar().removeStatusItem(statusBarItem)
    }
    
    func setupMenu() -> NSMenu {
        let menu = NSMenu()
        
        func addItemToMenu(name: String, action: Selector, target: AnyObject) -> NSMenuItem {
            let item =  menu.addItemWithTitle(name, action: action, keyEquivalent: "")!
            item.target = target
            return item
        }
        
        addItemToMenu("Import...", Selector("showImportUi"), self)
        
        menu.addItem(NSMenuItem.separatorItem())
        
        addItemToMenu("Internet?", Selector("playInternet"), self)
        addItemToMenu("You are the ones", Selector("playYouAre"), self)
        addItemToMenu("Eat", Selector("playEat"), self)
        
        menu.addItem(NSMenuItem.separatorItem())
        
        let startupMenuItem = addItemToMenu("Launch on Startup", Selector("toggleStartupLaunch"), self)
        startupMenuItem.state = LoginItemController.appExistsAsLoginItem() ? NSOnState : NSOffState
        
        menu.addItem(NSMenuItem.separatorItem())
        
        addItemToMenu("Quit", Selector("quit"), self)
        
        return menu
    }
    
    func quit() {
        NSApplication.sharedApplication().terminate(self)
    }
    
    func playInternet() {
        soundController.playInternet()
    }
    
    func playYouAre() {
        soundController.playBalls()
    }
    
    func playEat() {
        soundController.playEat()
    }
    
    func toggleStartupLaunch() {
        let item = statusBarItem.menu?.itemWithTitle("Launch on Startup")
        
        if LoginItemController.appExistsAsLoginItem() {
            LoginItemController.removeAppFromLoginItems()
            item?.state = NSOffState
        } else {
            LoginItemController.addAppToLoginItems()
            item?.state = NSOnState
        }
    }

    func showImportUi() -> Void {
        var nibItems:NSArray? = nil

        let loadSucceded = NSBundle.mainBundle().loadNibNamed("ImportWindow", owner: self, topLevelObjects: &nibItems)

        if loadSucceded {
            if let things = nibItems {
                for thing in things {
                    //one of the items in the nib is the NSApplication instance, other is the window we want
                    //probably can fix this in the nib itself instead of the below trickery
                    if thing.isKindOfClass(ImportWindow) {
                        importWindow = thing as? ImportWindow
                        importWindow!.makeKeyAndOrderFront(self)
                        break
                    }
                }
            }
        } else {
            println("Could not load Import Window from xib")
        }
    }
}