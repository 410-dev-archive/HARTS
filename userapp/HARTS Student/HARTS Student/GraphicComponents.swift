//
//  CoreLevelCompatibilityLayer.swift
//
//  Created by Hoyoun Song on 24/05/2019.
//

import Foundation
import Cocoa

class GraphicComponents {
    @discardableResult
    public func messageBox_errorMessage(title: String, contents: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = contents
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Dismiss")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    // Info Message Box
    @discardableResult
    public func messageBox_dialogue(title: String, contents: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = contents
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Dismiss")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    public func messageBox_warning(title: String, contents: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = contents
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "No")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    public func messageBox_ask(title: String, contents: String, firstButton: String, secondButton: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = contents
        alert.alertStyle = .informational
        alert.addButton(withTitle: firstButton)
        alert.addButton(withTitle: secondButton)
        return alert.runModal() == .alertFirstButtonReturn // True when first button is pressed
    }
    
    @discardableResult
    public func messageBox_unexpectedCriticalErrorMessage(errorType: String, errorCode: String, errorClass: String, errorLine: String, errorMethod: String, errorMessage: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = "Critical Error"
        alert.informativeText = "Critical Error: " + errorCode + "\nError Code: " + errorCode + "\nError Class: " + errorClass + "\nError Line: " + errorLine + "\nError Method: " + errorMethod + "\nError Message: " + errorMessage
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Dismiss")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
}

class KeyCodeTranslator {
    func translate (_ args: [String] ) -> String {
        var output = ""
        var loop = 0
        while loop < args.count {
            output += convertKeySwitch(Int(args[loop]) ?? 0)
            loop += 1
        }
        return output
    }
    
    func convertKeySwitch (_ a: Int) -> String {
        switch a {
        case 0:
            return "a"
        case 11:
            return "b"
        case 8:
            return "c"
        case 2:
            return "d"
        case 14:
            return "e"
        case 3:
            return "f"
        case 5:
            return "g"
        case 4:
            return "h"
        case 34:
            return "i"
        case 38:
            return "j"
        case 40:
            return "k"
        case 37:
            return "l"
        case 46:
            return "m"
        case 45:
            return "n"
        case 31:
            return "o"
        case 35:
            return "p"
        case 12:
            return "q"
        case 15:
            return "r"
        case 1:
            return "s"
        case 17:
            return "t"
        case 32:
            return "u"
        case 9:
            return "v"
        case 13:
            return "w"
        case 7:
            return "x"
        case 16:
            return "y"
        case 6:
            return "z"
        case 18:
            return "1"
        case 19:
            return "2"
        case 20:
            return "3"
        case 21:
            return "4"
        case 23:
            return "5"
        case 22:
            return "6"
        case 26:
            return "7"
        case 28:
            return "8"
        case 25:
            return "9"
        case 29:
            return "0"
        case 47:
            return "."
        case 24:
            return "="
        default:
            return "///"
        }
    }
}

// Key Code usage
//        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
//            if self.myKeyDown(with: $0) {
//                return nil
//            } else {
//                return $0
//            }
//        }
