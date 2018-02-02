//
//  ViewController.swift
//  Voltage
//
//  Created by Ben Harold on 1/25/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func alert(message: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = message
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Dang")
        
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func runCommand(cmd: String, args: String...) -> (output: [String], error: [String], exitCode: Int32) {
        var output: [String] = []
        var error: [String] = []
        
        let task = Process()
        task.launchPath = cmd
        task.arguments = args
        
        let outpipe = Pipe()
        task.standardOutput = outpipe
        let errpipe = Pipe()
        task.standardError = errpipe
        
        task.launch()
        
        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: outdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            output = string.components(separatedBy: "")
        }
        
        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: errdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            error = string.components(separatedBy: "\n")
        }
        
        task.waitUntilExit()
        let status = task.terminationStatus
        
        return (output, error, status)
    }
}
