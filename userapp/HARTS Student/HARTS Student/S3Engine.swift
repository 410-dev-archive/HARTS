//
//  S3Controller.swift
//  HARTS Student
//
//  Created by Hoyoun Song on 2020/07/16.
//

import Foundation
class OrtaOSController {
    
    let cache = "/tmp/HARTS/ortaos/vrootfs/emulated/0/"
    
    func push(_ ttycmd: String) -> Bool {
        if NSSwiftUtils.doesTheFileExist(at: cache + "tty_in") {
            NSSwiftUtils.executeShellScript("rm", "-f", cache + "tty_in")
        }
        if NSSwiftUtils.pipeCommandline(primaryCommand: "echo#" + ttycmd, execCommands: "tee#" + cache + "tty_in") == 0 {
            return true
        }else{
            return false
        }
    }
    
    func pull() -> String {
        return NSSwiftUtils.readContents(of: cache + "tty_out")
    }
    
    func writeLongArguments(str: String) -> Bool {
        return NSSwiftUtils.writeData(to: cache + "tty_longarg", content: str)
    }
}
