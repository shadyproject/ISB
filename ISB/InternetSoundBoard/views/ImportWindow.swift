//
//  ImportWindow.swift
//  ISB
//
//  Created by Christopher Martin on 12/1/14.
//
//

import Foundation
import Cocoa

class ImportWindow: NSWindow, ImportControllerDelegate {
    var importController:ImportController? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        importController = ImportController(delegate: self)
    }
    
    //crashes if we don't implement this , but it's not marked as required.  fun.
    override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, defer: flag)
        importController = ImportController(delegate: self)
    }
    
    @IBOutlet weak var urlTextField: NSTextField!
    @IBOutlet weak var importButton: NSButton!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    
    @IBAction func startImport(sender: NSButton) {
        let url = NSURL(string: urlTextField.stringValue)!
        println("Starting import from URL: \(url)")
        importController?.startImport(url)
    }
    
    func status(status:ImportStatus) -> Void {
        handleImportStatus(status)
    }
    
    func didStart(status:ImportStatus) -> Void {
        handleImportStatus(status)
    }
    
    func didFinish(status:ImportStatus) -> Void {
        let data = handleImportStatus(status)
        println("Got Data: \(data)")
    }
    
    func handleImportStatus(status:ImportStatus) -> NSData? {
        switch status {
        case let .Failed(error):
            println("Import failed with error: \(error)")
            return nil
            
        case let .Running(percentComplete):
            println("Import is \(percentComplete)% complete")
            return nil
            
        case .NotStarted:
            println("Import has not yet started")
            return nil
            
        case let .Succeeded(data):
            println("Import succeeded")
            return data
        }
    }
}