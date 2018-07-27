//
//  MainViewController.swift
//  Voltage
//
//  Created by Ben Harold on 6/20/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    @IBOutlet weak var reload_indicator: NSProgressIndicator!
    
    @IBAction func reload_button(_ sender: NSButton) {
        start_indicator()
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global(qos: .userInitiated).async {
            NotificationCenter.default.post(name: Notification.Name.reload, object: nil)
            group.leave()
        }
        
        group.notify(queue: .main) {
            DispatchQueue.main.async {
                self.stop_indicator()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listen_for_loading_start()
        listen_for_loading_finish()
    }
    
    func listen_for_loading_start() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MainViewController.start_indicator),
                                               name: Notification.Name.loading_start,
                                               object: nil)
    }
    
    func listen_for_loading_finish() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MainViewController.stop_indicator),
                                               name: Notification.Name.loading_finish,
                                               object: nil)
    }
    
    @objc func start_indicator() {
        reload_indicator.startAnimation(self)
    }
    
    @objc func stop_indicator() {
        reload_indicator.stopAnimation(self)
    }
}
