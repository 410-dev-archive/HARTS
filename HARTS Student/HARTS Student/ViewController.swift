//
//  ViewController.swift
//  HARTS Student
//
//  Created by Hoyoun Song on 2020/06/12.
//  Copyright © 2020 Hoyoun Song. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let thisWindow = NSWindow.init(contentViewController: self)
        thisWindow.zoom(thisWindow)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
