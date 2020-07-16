//
//  S3Controller.swift
//  HARTS Student
//
//  Created by Hoyoun Song on 2020/07/16.
//

import Foundation
class OrtaOSController {
    func push(_ ttycmd: String) -> Bool {
        NSSwiftUtils.writeData(to: "/tmp/HARTS/ortaos/vrootfs/emulated_corestorage/emulated0/emulated_cache/teletype_input", content: ttycmd)
        if NSSwiftUtils.readContents(of: "/tmp/HARTS/ortaos/vrootfs/emulated_corestorage/emulated0/emulated_cache/teletype_input").contains(ttycmd){
            return true
        }else{
            return false
        }
    }
    
    func pull() -> String {
        return NSSwiftUtils.readContents(of: "/tmp/HARTS/ortaos/vrootfs/emulated_corestorage/emulated0/emulated_cache/teletype_output")
    }
    
    func writeLongArguments(str: String) -> Bool {
        NSSwiftUtils.writeData(to: "/tmp/HARTS/ortaos/vrootfs/emulated_corestorage/emulated0/emulated_cache/teletype_longarg", content: str)
        if NSSwiftUtils.readContents(of: "/tmp/HARTS/ortaos/vrootfs/emulated_corestorage/emulated0/emulated_cache/teletype_longarg").contains(str){
            return true
        }else{
            return false
        }
    }
}
