//
//  ApplicationSupport.swift
//  Voltage
//
//  Created by Ben Harold on 7/30/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

// Application Support Folder
//
// Instantiating this class will create a "Voltage" directory in the user's
// "~/Library/Application Support/" directory if it doesn't already exist. The
// resulting object includes a `url` URL object and a `path` String that both
// point to that directory.
class ApplicationSupportFolder {
    
    let root_path: URL = FileManager.default.urls(for: .applicationSupportDirectory,
                                                  in: .userDomainMask).first!
    let folder_name: String = "Voltage"
    let url: URL
    let path: String
    
    init() {
        self.url = URL(string: folder_name, relativeTo: root_path)!
        self.path = url.path
        if !folder_exists() { create_folder() }
    }
    
    private func create_folder() {
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            print("Created Voltage application support folder at: " + path)
        } catch {
            print("create_folder() error: \(error)")
        }
    }
    
    private func folder_exists() -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
}
