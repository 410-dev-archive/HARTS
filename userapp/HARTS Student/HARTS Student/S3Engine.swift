//
//  S3Controller.swift
//  HARTS Student
//
//  Created by Hoyoun Song on 2020/07/16.
//

import Foundation
class OrtaOSController {
    
    let cache = "/tmp/HARTS/ortaos/vrootfs/emulated_corestorage/emulated0/emulated_cache/"
    
    func push(_ ttycmd: String) -> Bool {
        NSSwiftUtils.writeData(to: cache + "teletype_input", content: ttycmd)
        if pull().contains(ttycmd){
            return true
        }else{
            return false
        }
    }
    
    func pull() -> String {
        return NSSwiftUtils.readContents(of: cache + "teletype_output")
    }
    
    func writeLongArguments(str: String) -> Bool {
        NSSwiftUtils.writeData(to: cache + "teletype_longarg", content: str)
        if NSSwiftUtils.readContents(of: cache + "teletype_longarg").contains(str){
            return true
        }else{
            return false
        }
    }
}
