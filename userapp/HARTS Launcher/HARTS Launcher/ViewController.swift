//
//  ViewController.swift
//  HARTS Launcher
//
//  Created by Hoyoun Song on 2020/07/17.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let System: NSSwiftUtils = NSSwiftUtils()
        System.createDirectoryWithParentsDirectories(to: "/tmp/HARTS/ortaos/vrootfs/System")
        System.createDirectoryWithParentsDirectories(to: "/tmp/HARTS/ortaos/venv")
        System.executeShellScript("hdiutil", "attach", Bundle.main.resourcePath! + "/venv.dmg", "-mountpoint", "/tmp/HARTS/ortaos/venv")
        System.executeShellScript(Bundle.main.resourcePath! + "/shasum", "/tmp/HARTS/ortaos/venv/venv.dmg", "/tmp/HARTS/ortaos/thisshasum")
        System.executeShellScript("curl", "-Ls", "https://raw.githubusercontent.com/cfi3288/HARTS-Signing-Server/master/sgType1/orta512", "-o", "/tmp/HARTS/ortaos/remoteshasum")
        let RemoteShasum = System.readContents(of: "/tmp/HARTS/ortaos/remoteshasum")
        let LocalShasum = System.readContents(of: "/tmp/HARTS/ortaos/thisshasum").components(separatedBy: " ")[0]
        if RemoteShasum.elementsEqual(LocalShasum) {
            System.executeShellScript("hdiutil", "attach", "/tmp/HARTS/ortaos/venv/venv.dmg", "-mountpoint", "/tmp/HARTS/ortaos/vrootfs/System")
            System.executeShellScript(Bundle.main.resourcePath! + "/async-start", "/tmp/HARTS/ortaos/vrootfs/System/boot/init")
            exit(0)
        }else{
            let Graphics: GraphicComponents = GraphicComponents()
            Graphics.messageBox_errorMessage(title: "Modified software", contents: "Unable to prepare virtual environment for safe test, because the software seems to be modified.")
            exit(0)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

