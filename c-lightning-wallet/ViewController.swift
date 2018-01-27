//
//  ViewController.swift
//  c-lightning-wallet
//
//  Created by Ben Harold on 1/25/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var label_value: NSTextField!
    
    @IBOutlet weak var which_lncli_value: NSTextField!
    
    @IBOutlet weak var payments_table_view: NSTableView!
    
    var payment_list: [Payment]!
    
    @IBAction func talk(_ sender: Any) {
        let path = "/usr/bin/say"
        let arguments = ["--voice=Kanya", "Hello World"]
        
        Process.launchedProcess(launchPath: path, arguments: arguments)
        self.label_value.stringValue = "my cool text"
        
        let end_result = runCommand(cmd:"/usr/bin/which", args:"lncli")
        print(end_result)
        self.which_lncli_value.stringValue = end_result.output[0]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        payment_list = []
        for _ in 1...25 {
            payment_list.append(Payment.fake())
        }
        //print(payment_list)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return self.payment_list.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?
    {
        var key = ""
        key = tableColumn!.identifier.rawValue
        
        if (key == "id") {
            return payment_list[row].id
        } else if (key == "payment_hash") {
            return payment_list[row].payment_hash
        } else if (key == "status") {
            return payment_list[row].status
        } else if (key == "created") {
            let date = Date(timeIntervalSince1970: TimeInterval(payment_list[row].created_at))
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            dateFormatter.timeZone = TimeZone(abbreviation: "EST")
            dateFormatter.locale = NSLocale.current
            //dateFormatter.dateFormat = "yyyy-MM-dd"
            let strDate = dateFormatter.string(from: date)
            return strDate
        } else if (key == "msatoshi") {
            return payment_list[row].msatoshi / 1000
        } else if (key == "destination") {
            return payment_list[row].destination
        }

        return nil
    }
    
    func runCommand(cmd : String, args : String...) -> (output: [String], error: [String], exitCode: Int32) {
        
        var output : [String] = []
        var error : [String] = []
        
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
            output = string.components(separatedBy: "\n")
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

