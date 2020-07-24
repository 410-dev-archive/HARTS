//
//  SessionJoinManager.swift
//  HARTS Student
//
//  Created by Hoyoun Song on 2020/07/16.
//

import Foundation
class SessionManager {
    
    private func isSessionAccessible(URL: String) -> Bool {
        print("[*] Validating link...")
        if NSSwiftUtils.executeShellScript("curl", "-Ls", URL, "-o", "/dev/null") == 0{
            return true
        }else{
            return false
        }
    }
    
    func dummyverifySession(sessionCode: String, pass: String, name: String) -> Bool {
        return true
    }
    
    func verifySession(sessionCode: String, pass: String, name: String) -> Bool {
        let PyPath = NSSwiftUtils.getHomeDirectory() + "Library/HARTS/python3/"
        let Packet = "ASK_ACCESS:\(sessionCode):\(pass)"
        print("[*] Getting IP for direct connection...")
        NSSwiftUtils.executeShellScript(PyPath + "bin/python3", "/tmp/HARTS/ortaos/vrootfs/System/Orta/server-master.py", Packet)
        print("[*] Getting Host for test...")
        NSSwiftUtils.executeShellScript(PyPath + "bin/python3", "/tmp/HARTS/ortaos/vrootfs/System/Orta/server-host.py", "JOIN:" + name)
        print("[*] Subprocess task complete.")
        let SessionURL = NSSwiftUtils.readContents(of: "/tmp/HARTS/testhost.harts")
        if  SessionURL.starts(with: "http"){
            NSSwiftUtils.deleteFile(at: "/tmp/HARTS/testhost.harts")
            return isSessionAccessible(URL: SessionURL)
        }else{
            return false
        }
    }
    
    func leaveSession(sessionCode: String, pass: String, name: String) {
        let PyPath = NSSwiftUtils.getHomeDirectory() + "Library/HARTS/python3/"
//        let Packet = "ASK_ACCESS:\(sessionCode):\(pass)"
//        print("[*] Getting IP for direct connection...")
//        NSSwiftUtils.executeShellScript(PyPath + "bin/python3", Bundle.main.resourcePath! + "/support/connect-mastersv.py", Packet)
        print("[*] Getting Host for test...")
        NSSwiftUtils.executeShellScript(PyPath + "bin/python3", "/tmp/HARTS/ortaos/vrootfs/System/Orta/server-host.py", "LEAVE:" + name)
    }
    
    func getSessionURL(name: String) -> String {
        print("[*] Getting Host for session URL...")
        NSSwiftUtils.executeShellScript(NSSwiftUtils.getHomeDirectory() + "Library/HARTS/python3/bin/python3", "/tmp/HARTS/ortaos/vrootfs/System/Orta/server-host.py", "ASK_URL:" + name)
        print("[*] Subprocess task complete.")
        let SessionURL = NSSwiftUtils.readContents(of: "/tmp/HARTS/testhost.harts")
        if  SessionURL.starts(with: "http"){
            NSSwiftUtils.deleteFile(at: "/tmp/HARTS/testhost.harts")
            return SessionURL
        }else{
            return ""
        }
    }
}
