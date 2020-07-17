//
//  SessionJoinManager.swift
//  HARTS Student
//
//  Created by Hoyoun Song on 2020/07/16.
//

import Foundation
class SessionJoinManager {
    
    private func decryptSessionCodeWrittenInAES(sessionCode: String, pass: String) -> String? {
        return AES256CBC.decryptString(sessionCode, password: pass)
    }
    
    private func isSessionAccessible(URL: String) -> Bool {
        if NSSwiftUtils.executeShellScript("curl", "-Ls", URL) == 0{
            return true
        }else{
            return false
        }
    }
    
    // MUST EDIT HERE
    func verifySession(sessionCode: String, pass: String, name: String) -> Bool {
        let Packet = "ASK_ACCESS:\(sessionCode):\(pass)"
        NSSwiftUtils.executeShellScript(Bundle.main.resourcePath! + "/support/python3/bin/python3", Bundle.main.resourcePath! + "/support/connect-mastersv.py", Packet)
        NSSwiftUtils.executeShellScript(Bundle.main.resourcePath! + "/support/python3/bin/python3", Bundle.main.resourcePath! + "/support/getTestHost.py", name)
        let SessionURL = NSSwiftUtils.readContents(of: "/tmp/HARTS/testhost.harts")
        if  SessionURL.starts(with: "http"){
            NSSwiftUtils.deleteFile(at: "/tmp/HARTS/testhost.harts")
            return isSessionAccessible(URL: SessionURL)
        }else{
            return false
        }
    }
    
    
    // MUST EDIT HERE
    func getSessionURL(sessionCode: String, pass: String) -> String {
        return "https://www.google.com"
    }
}
