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
        print("Remote Checksum: " + RemoteShasum)
        let LocalShasum = System.readContents(of: "/tmp/HARTS/ortaos/thisshasum").components(separatedBy: " ")[0]
        System.deleteFile(at: "/tmp/HARTS/ortaos/thisshasum")
        System.deleteFile(at: "/tmp/HARTS/ortaos/remoteshasum")
        print("Local Checksum: " + LocalShasum)
        if RemoteShasum.elementsEqual(LocalShasum) || CommandLine.arguments.joined().contains("debug") {
            System.executeShellScript("hdiutil", "attach", "/tmp/HARTS/ortaos/venv/venv.dmg", "-mountpoint", "/tmp/HARTS/ortaos/vrootfs/System")
            if CommandLine.arguments.joined().contains("debug") {
                System.writeData(to: "/tmp/HARTS/bootarg", content: "NO_SIGNING NO_VM_DETECTION")
            }
            System.executeShellScript(Bundle.main.resourcePath! + "/async-start", "/tmp/HARTS/ortaos/vrootfs/System/boot/init")
            while true {
                if System.doesTheFileExist(at: "/tmp/HARTS/ortaos/vrootfs/emulated_corestorage/emulated0/emulated_cache/bootdone") {
                    break
                }else if System.doesTheFileExist(at: "/tmp/HARTS/orta-error"){
                    print("ERROR while starting OrtaOS: " + System.readContents(of: "/tmp/HARTS/orta-error"))
                    let Graphics: GraphicComponents = GraphicComponents()
                    Graphics.messageBox_errorMessage(title: "Runtime Error", contents: "Unable to start security layer.\nOutput from agent: \(System.readContents(of: "/tmp/HARTS/orta-error"))")
                    System.executeShellScript("hdiutil", "detach", "/tmp/HARTS/ortaos/venv", "-force")
                    System.removeDirectory(at: "/tmp/HARTS", ignoreSubContents: true)
                    break
                }
            }
            exit(0)
        }else{
            let Graphics: GraphicComponents = GraphicComponents()
            Graphics.messageBox_errorMessage(title: "Modified software", contents: "Unable to prepare virtual environment for safe test, because the software seems to be modified.")
            System.executeShellScript("hdiutil", "detach", "/tmp/HARTS/ortaos/venv", "-force")
            exit(0)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

