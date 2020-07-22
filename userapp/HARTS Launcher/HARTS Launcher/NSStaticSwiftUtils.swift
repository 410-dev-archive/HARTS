//
//  CoreLevelCompatibilityLayer.swift
//
//  Created by Hoyoun Song on 24/05/2019.
//

import Foundation
class NSSwiftUtils {
    @discardableResult
    public static func executeShellScript(_ args: String...) -> Int32 {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
    @discardableResult
    public static func executeShellScriptWithRootPrivilages(pass: String, _ args: String) -> Int32 {
        return pipeCommandline(primaryCommand: "echo#" + pass, execCommands: "sudo#-S#" + args)
    }
    
//    public func listFilesInDirectory(directoryPath: String) -> [String] {
//        let fileManager = FileManager.default
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        do {
//            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
//            return fileURLs
//        } catch {
//            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
//            return [""]
//        }
//    }
    
    public static func runCommand(cmd : String, args : String...) -> (output: [String], error: [String], exitCode: Int32) {

        var output : [String] = []
        var error : [String] = []

        let task = Process()
        task.launchPath = cmd
        task.arguments = args

        let outpipe = Pipe()
        task.standardOutput = outpipe
        let errpipe = Pipe()
        task.standardError = errpipe

        task.launch()

        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: outdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            output = string.components(separatedBy: "\n")
        }

        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: errdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            error = string.components(separatedBy: "\n")
        }

        task.waitUntilExit()
        let status = task.terminationStatus

        return (output, error, status)
    }
    
    @discardableResult
    public static func pipeCommandline(primaryCommand: String, execCommands: String) -> Int32 {
        let pipe = Pipe()
        let echo = Process()
        echo.launchPath = "/usr/bin/env"
        echo.arguments = primaryCommand.components(separatedBy: "#")
        echo.standardOutput = pipe
        let uniq = Process()
        uniq.launchPath = "/usr/bin/env"
        uniq.arguments = execCommands.components(separatedBy: "#")
        uniq.standardInput = pipe
        let out = Pipe()
        uniq.standardOutput = out
        echo.launch()
        uniq.launch()
        uniq.waitUntilExit()
        return uniq.terminationStatus
    }
    
    public static func doesTheFileExist(at: String) -> Bool {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: at) {
            return true
        } else {
            var isDir : ObjCBool = true
            if fileManager.fileExists(atPath: at, isDirectory:&isDir) {
                return true
            } else {
                return false
            }
        }
    }
    
    public static func isFile(at: String) -> Bool {
        var isDir : ObjCBool = false
        if FileManager.default.fileExists(atPath: at, isDirectory:&isDir) {
            return(isDir.boolValue ? false : true)
        } else {
            return false
        }
    }
    
    public static func getUsernameFromNSUsername() -> String? {
        return NSUserName()
    }
    
    public static func readContents(of: String) -> String {
        if !doesTheFileExist(at: of) {
            return "returned:nofile"
        }else{
            do{
                let filepath = URL.init(fileURLWithPath: of)
                let content = try String(contentsOf: filepath, encoding: .utf8)
                return content
            }catch{
                exit(1)
            }
        }
    }
    
    public static func readBinaryContents(of: String) -> String {
        if !doesTheFileExist(at: of) {
            return "returned:nofile"
        }else{
            do{
                let filepath = URL.init(fileURLWithPath: of)
                let content = try String(contentsOf: filepath, encoding: .ascii)
                return content
            }catch{
                exit(1)
            }
        }
    }
    
    public static func getFileSize(of: String) -> UInt64 {
        var fileSize : UInt64
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: of)
            fileSize = attr[FileAttributeKey.size] as! UInt64
            return fileSize
        } catch {
            print("Error: \(error)")
            return 0
        }
    }
    
    @discardableResult
    public static func writeData(to: String, content: String) -> Bool{
        let file = to
        let text = content
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                return true
            }catch {
                return false
            }
        }else{
            return false
        }
    }
    
    @discardableResult
    public static func deleteFile(at: String) -> Bool{
        if executeShellScript("rm", "-f", at) == 0 {
            return true
        }else{
            return false
        }
    }
    
    @discardableResult
    public static func createDirectoryWithParentsDirectories(to: String) -> Bool{
        if executeShellScript("mkdir", "-p", to) == 0 {
            return true
        }else{
            return false
        }
    }
    
    @discardableResult
    public static func removeDirectory(at: String, ignoreSubContents: Bool) -> Int32{
        // 0 = Successfully deleted
        // 1 = Unignored subcontents
        // 2 = Misc Errors
        if listFiles(at: at, withExtension: nil).count == 0 || ignoreSubContents{
            if executeShellScript("rm", "-rf", at) == 0 {
                return 0
            }else{
                return 2
            }
        }else{
            return 1
        }
    }
    
    public static func listFiles(at: String, withExtension: String?) -> [String]{
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: at)
            var list = [""]
            if !(withExtension?.isEmpty ?? true) {
                for count in 0..<files.count {
                    if files[count].hasSuffix(withExtension!) {
                        list.append(files[count])
                    }
                }
            }else{
                list = files
            }
            
            return list
        } catch {
            return ["ERROR!@#$%^&*()"]
        }
    }
    
    public static func getUsername() -> String {
        let user = ProcessInfo().environment["USER"]
        return user!.components(separatedBy: "\"")[1]
    }
    
    
    public static func getHomeDirectory() -> String{
        let fsutil = FileManager.default
        var homeurl = fsutil.homeDirectoryForCurrentUser.absoluteString
        if homeurl.contains("file://"){
            homeurl = homeurl.replacingOccurrences(of: "file://", with: "")
        }
        return homeurl
    }
    
    public static func printer(color: String, _ output: String, lineEnd: String) {
        let black = "\u{001B}[0;30m"
        let red = "\u{001B}[0;31m"
        let green = "\u{001B}[0;32m"
        let yellow = "\u{001B}[0;33m"
        let blue = "\u{001B}[0;34m"
        let magenta = "\u{001B}[0;35m"
        let cyan = "\u{001B}[0;36m"
        let white = "\u{001B}[0;37m"
        if color.elementsEqual("b") {
            print(black + output, terminator: lineEnd)
        }else if color.elementsEqual("r") {
            print(red + output, terminator: lineEnd)
        }else if color.elementsEqual("g") {
            print(green + output, terminator: lineEnd)
        }else if color.elementsEqual("y") {
            print(yellow + output, terminator: lineEnd)
        }else if color.elementsEqual("b") {
            print(blue + output, terminator: lineEnd)
        }else if color.elementsEqual("m") {
            print(magenta + output, terminator: lineEnd)
        }else if color.elementsEqual("c") {
            print(cyan + output, terminator: lineEnd)
        }else if color.elementsEqual("w") {
            print(white + output, terminator: lineEnd)
        }else{
            print(white + output, terminator: lineEnd)
        }
    }
    
}
