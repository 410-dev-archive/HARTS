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
        let ROOT = "/tmp/HARTS/"
        let OrtaOS_ParentDMGMntPoint = ROOT + "ortaos/venv"
        let OrtaOS_Vrootfs = ROOT + "ortaos/vrootfs/"
        let OrtaOS_Signing = "https://raw.githubusercontent.com/cfi3288/HARTS-Signing-Server/master/sgType1/orta512"
        
        System.createDirectoryWithParentsDirectories(to: OrtaOS_Vrootfs + "System")
        System.createDirectoryWithParentsDirectories(to: OrtaOS_ParentDMGMntPoint)
        System.executeShellScript("hdiutil", "attach", Bundle.main.resourcePath! + "/venv.dmg", "-mountpoint", OrtaOS_ParentDMGMntPoint)
        System.executeShellScript(Bundle.main.resourcePath! + "/shasum", OrtaOS_ParentDMGMntPoint + "/venv.dmg", ROOT + "thisshasum")
        System.executeShellScript("curl", "-Ls", OrtaOS_Signing, "-o", ROOT + "remoteshasum")
        let RemoteShasum = System.readContents(of: ROOT + "remoteshasum")
        print("Remote Checksum: " + RemoteShasum)
        let LocalShasum = System.readContents(of: ROOT + "thisshasum").components(separatedBy: " ")[0]
        System.deleteFile(at: ROOT + "thisshasum")
        System.deleteFile(at: ROOT + "remoteshasum")
        print("Local Checksum: " + LocalShasum)
        if RemoteShasum.elementsEqual(LocalShasum) || CommandLine.arguments.joined().contains("debug") {
            System.executeShellScript("hdiutil", "attach", OrtaOS_ParentDMGMntPoint + "/venv.dmg", "-mountpoint", OrtaOS_Vrootfs + "System")
            if CommandLine.arguments.joined().contains("debug") {
                System.writeData(to: ROOT + "/bootarg", content: "NO_SIGNING NO_VM_DETECTION")
            }
            System.executeShellScript(Bundle.main.resourcePath! + "/async-start", OrtaOS_Vrootfs + "System/boot/init")
            while true {
                if System.doesTheFileExist(at: OrtaOS_Vrootfs + "/emulated/0/bootdone") {
                    break
                }else if System.doesTheFileExist(at: ROOT + "orta-error"){
                    print("ERROR while starting OrtaOS: " + System.readContents(of: ROOT + "orta-error"))
                    let Graphics: GraphicComponents = GraphicComponents()
                    Graphics.messageBox_errorMessage(title: "Runtime Error", contents: "Unable to start security layer.\nOutput from agent: \(System.readContents(of: ROOT + "orta-error"))")
                    System.executeShellScript("hdiutil", "detach", OrtaOS_ParentDMGMntPoint, "-force")
                    System.removeDirectory(at: ROOT, ignoreSubContents: true)
                    break
                }
            }
            exit(0)
        }else{
            let Graphics: GraphicComponents = GraphicComponents()
            Graphics.messageBox_errorMessage(title: "Modified software", contents: "Unable to prepare virtual environment for safe test, because the software seems to be modified.")
            System.executeShellScript("hdiutil", "detach", OrtaOS_ParentDMGMntPoint, "-force")
            exit(0)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

