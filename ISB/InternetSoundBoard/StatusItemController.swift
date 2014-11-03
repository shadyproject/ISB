//
//  StatusItemController.swift
//  ISB
//
//  Created by Christopher Martin on 11/2/14.
//
//

import Foundation
import Cocoa

class StatusItemController: NSObject {
    let statusBarItem = NSStatusBar.systemStatusBar().statusItemWithLength(24.0)
    
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
        
        func addItemToMenu(name: String, action: Selector, target: AnyObject) {
            menu.addItemWithTitle(name, action: action, keyEquivalent: "")?.target = target
        }
        
        addItemToMenu("Internet?", Selector("playInternet"), self)
        addItemToMenu("You are the ones", Selector("playYouAre"), self)
        addItemToMenu("Eat", Selector("playEat"), self)
        
        menu.addItem(NSMenuItem.separatorItem())
        
        addItemToMenu("Quit", Selector("quit"), self)
        
        return menu
    }
    
    func quit() {
        NSApplication.sharedApplication().terminate(self)
    }
    
    func playInternet() {
        println("What the fuck is the internet?")
    }
    
    func playYouAre() {
        println("You are the ones who are the ball lickers")
    }
    
    func playEat() {
        println("We're going to make them eat our shit etc etc")
    }
}