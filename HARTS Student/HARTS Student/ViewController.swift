//
//  ViewController.swift
//  HARTS Student
//
//  Created by Hoyoun Song on 2020/06/12.
//  Copyright © 2020 Hoyoun Song. All rights reserved.
//

import Cocoa
import Python
import WebKit

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}

class ViewController: NSViewController {
    
    @IBOutlet weak var UI_StartTest: NSButton!
    @IBOutlet weak var UI_TestDone: NSButton!
    @IBOutlet weak var UI_MainWebView: WKWebView!
    
    let CONST_VERSION = ""
    
    var BINARIES = ""
    var URL = ""
    
    let helperBin = ["async", "locker", "lockvf", "testdone", "base64decode", "base64encode", "launchdmgr-u", "launchdmgr-s", "autoreboot"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CommandLine.arguments.count == 2 && CommandLine.arguments[1].starts(with: "http") {
            BINARIES = CommandLine.arguments[0]
            URL = CommandLine.arguments[1]
        }else{
            let Graphics: GraphicComponents = GraphicComponents()
            Graphics.messageBox_errorMessage(title: "Invalid launching", contents: "Launch method was invalid. Please use official launcher.")
            exit(-1)
        }
        UI_TestDone.isEnabled = false
        let thisWindow = NSWindow.init(contentViewController: self)
        thisWindow.zoom(thisWindow)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func ACTION_StartTest(_ sender: Any) {
        UI_StartTest.isEnabled = false
        UI_TestDone.isEnabled = true
        let Graphics: GraphicComponents = GraphicComponents()
        Graphics.messageBox_dialogue(title: "Test will begin", contents: "Test protocol will now start. The system services will now be suspended and you cannot switch between applications. If system services does not resume after test is over, please restart your computer. ")
        // Webkit update
    }
    
    @IBAction func ACTION_TestDone(_ sender: Any) {
        let Graphics: GraphicComponents = GraphicComponents()
        if Graphics.messageBox_ask(title: "Confirmation", contents: "Did you finish your test? Pressing this button will not automatically submit the test, but will stop the browser. All of your progress will be lost if not submitted.", firstButton: "Yes, I am done.", secondButton: "No, not yet.") {
            UI_TestDone.isEnabled = true
            let System: NSSwiftUtils = NSSwiftUtils()
            System.executeShellScript(BINARIES + helperBin[helperBin.firstIndex(of: "testdone")!])
            System.executeShellScript(BINARIES + helperBin[helperBin.firstIndex(of: "launchdmgr-s")!])
            if Graphics.messageBox_ask(title: "System Services", contents: "Can you fully access to system services, such as Finder? If not, press reboot button. Otherwise, press dismiss.", firstButton: "Reboot", secondButton: "Dismiss") {
                System.executeShellScript(BINARIES + "autoreboot")
                exit(0)
            }
            exit(0)
        }
    }
}
