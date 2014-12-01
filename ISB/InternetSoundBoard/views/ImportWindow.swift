//
//  ImportWindow.swift
//  ISB
//
//  Created by Christopher Martin on 12/1/14.
//
//

import Foundation
import Cocoa

class ImportWindow: NSWindow {
    internal var importController: ImportController!
    
    @IBOutlet weak var urlTextField: NSTextField!
    @IBOutlet weak var importButton: NSButton!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    
    @IBAction func startImport(sender: NSButton) {
    }
}