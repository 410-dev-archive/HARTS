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
        return true
    }
    
    // MUST EDIT HERE
    func verifySession(sessionCode: String, pass: String) -> Bool {
        if let SessionURL = decryptSessionCodeWrittenInAES(sessionCode: sessionCode, pass: pass) {
            return isSessionAccessible(URL: SessionURL)
        }else{
//            return false
            return true
        }
    }
    
    
    // MUST EDIT HERE
    func getSessionURL(sessionCode: String, pass: String) -> String {
        return "https://www.google.com"
    }
}
