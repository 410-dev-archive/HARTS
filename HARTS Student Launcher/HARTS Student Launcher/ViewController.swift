//
//  ViewController.swift
//  HARTS Student Launcher
//
//  Created by Hoyoun Song on 2020/06/13.
//  Copyright © 2020 Hoyoun Song. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let System: NSSwiftUtils = NSSwiftUtils()
    
    var doVerbose = false
    let helperBin = ["async", "locker", "lockvf", "testdone", "base64decode", "base64encode", "launchdmgr-u", "launchdmgr-s"]
    //let helperBinExpectedHASH = ["", "", "", "", "", "", "", ""]
    
    @IBOutlet weak var SessionTokenField: NSTextField!
    @IBOutlet weak var TestJoinButtonOutlet: NSButton!
    @IBOutlet weak var BottomLabel: NSTextField!
    
    @IBAction func OnTokenFieldModification(_ sender: Any) {
        if SessionTokenField.stringValue.count > 15 {
            TestJoinButtonOutlet.isEnabled = true
        }else{
            TestJoinButtonOutlet.isEnabled = false
        }
    }
    
    @IBAction func OnJoinButtonPressed(_ sender: Any) {
        verbose("Join button pressed.")
        verbose("Showing warning message...")
        print("MESSAGE: [NOTICE] - During the test, some of the process (including HARTS launcher) such as Finder may not respond. Please notice that it is part of testing protocol.")
        print("MESSAGE:          - When testing is complete, PLEASE USE \"Test Done\" button to quit HARTS Lockdown Browser. Otherwise, the system may remain in lockdown state.")
        let Graphics: GraphicComponents = GraphicComponents()
        Graphics.messageBox_dialogue(title: "Some process may not respond", contents: "During the test, some of the process (including HARTS launcher) such as Finder may not respond, or marked as not responding application. Please notice that it is part of testing protocol and should not quit process.\n\nWhen testing is complete, PLEASE USE \"Test Done\" button to quit HARTS Lockdown Browser. Otherwise, the system may remain in lockdown state.")
        BottomLabel.stringValue = "Joining..."
        verbose("Disabling inputs in launcher elements...")
        SessionTokenField.isEnabled = false
        TestJoinButtonOutlet.isEnabled = false
        verbose("Join token: \(SessionTokenField.stringValue)")
        verbose("Decrypting join key...")
        let bundlePath = Bundle.main.resourcePath! + "/"
        System.executeShellScript(bundlePath + helperBin[helperBin.firstIndex(of: "base64decode")!], SessionTokenField.stringValue, "/tmp/dlink.harts")
        let joinLink = System.readContents(of: "/tmp/dlink.harts")
        System.executeShellScript("rm", "-f", "/tmp/dlink.harts")
        verbose("Join link: \(joinLink)")
        
        // Add HASH verification here later!
        
        verbose("Starting client!")
        System.executeShellScript(Bundle.main.resourcePath! + "/HARTS Student.app/Contents/MacOS/HARTS Student")
        verbose("Client terminated.")
        verbose("Restarting system services...")
        System.executeShellScript(bundlePath + helperBin[helperBin.firstIndex(of: "testdone")!])
        System.executeShellScript(bundlePath + helperBin[helperBin.firstIndex(of: "launchdmgr-s")!])
        verbose("Goodbye!")
        exit(0)
    }
    
    
    func verbose(_ toLog: String) {
        if doVerbose {
            print("[HARTS-Student] " + toLog)
        }
    }
    
    override func viewDidLoad() {
        print("HARTS [Home Anti-cheat Remote Testing System] Lockdown Browser")
        print("Written by: ")
        print("Backend - (Tom) Minseo Choi, Hoyoun Song")
        print("Frontend - Hoyoun Song")
        print("")
        super.viewDidLoad()
        if let verboseCheck = ProcessInfo.processInfo.environment["HARTS_VERBOSE"] {
            if verboseCheck.elementsEqual("1") {
                doVerbose = true
                verbose("Verbose mode enabled.")
            }
        }
        verbose("Running startup process...")
        verbose("Checking client in bundle...")
        if !System.doesTheFileExist(at: Bundle.main.resourcePath! + "/HARTS Student.app/Contents/MacOS/HARTS Student") {
            verbose("ERROR: Client not found!")
            let Graphics: GraphicComponents = GraphicComponents()
            Graphics.messageBox_errorMessage(title: "Client Not Found", contents: "Lockdown browser client is not found in specified directory: \(Bundle.main.resourcePath! + "/HARTS Student.app/Contents/MacOS/HARTS Student") period.")
            exit(-9)
        }else{
            verbose("Client found.")
            verbose("Removing all extended attributes includeing com.apple.quarantine...")
            System.executeShellScript("xattr", "-xc", Bundle.main.resourcePath! + "/HARTS Student.app")
        }
        verbose("Checking helper binaries...")
        for binName in helperBin {
            verbose("Checking: \(binName)")
            if !System.doesTheFileExist(at: Bundle.main.resourcePath! + "/" + binName) {
                verbose("ERROR: \(binName) not found.")
                let Graphics: GraphicComponents = GraphicComponents()
                Graphics.messageBox_errorMessage(title: "Missing resource", contents: "Some core files are not found, unable to prepare for lockdown environment.")
                exit(-10)
            }else{
                verbose("Verified: \(binName)")
                verbose("Making runnable: \(binName)")
                System.executeShellScript("chmod", "+x", Bundle.main.resourcePath! + "/" + binName)
            }
        }
        verbose("Helper tools check complete.")
        verbose("Disabling join button...")
        TestJoinButtonOutlet.isEnabled = false
        verbose("System ready to launch.")
        verbose("Startup procedure complete.")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

