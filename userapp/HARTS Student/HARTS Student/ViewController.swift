//
//  ViewController.swift
//  HARTS Student
//
//  Created by Hoyoun Song on 2020/07/16.
//

import Cocoa
import WebKit

class ViewController: NSViewController {
    
//    @IBOutlet weak var Outlet_WebView: WKWebView!
    @IBOutlet var Outlet_WebView: WKWebView!
    @IBOutlet weak var Outlet_Button_TestDone: NSButton!
    @IBOutlet weak var Outlet_Button_AskQuestion: NSButton!
    @IBOutlet weak var Outlet_TextField_Question: NSTextField!
    @IBOutlet weak var Outlet_Button_Hide: NSButton!
    @IBOutlet weak var Outlet_Button_Refresh: NSButton!
    @IBOutlet weak var Outlet_StandardText_WebViewIsHidden: NSTextField!
    
    @IBOutlet weak var Outlet_TextField_SessionCode: NSTextField!
    @IBOutlet weak var Outlet_TextField_Name: NSTextField!
    @IBOutlet weak var Outlet_TextField_JoinPassword: NSTextField!
    @IBOutlet weak var Outlet_StandardText_StatusNotifier: NSTextField!
    @IBOutlet weak var Outlet_Button_BeginTest: NSButton!
    
    var TestURLInString: String!
    var stopAsyncLoop = false
    var isCommandKeyDown = false
    
    var doDebug = true;
    
    private func validateSessionWhenTextFieldsAreUpdated() {
        if Outlet_TextField_JoinPassword.stringValue.count > 0 && Outlet_TextField_SessionCode.stringValue.count > 0 && Outlet_TextField_Name.stringValue.count > 0 {
            Outlet_StandardText_StatusNotifier.textColor = .black
            Outlet_StandardText_StatusNotifier.stringValue = "Validating..."
            Outlet_TextField_SessionCode.isEnabled = false
            Outlet_TextField_Name.isEnabled = false
            Outlet_TextField_JoinPassword.isEnabled = false
            DispatchQueue.main.async {
                let SessionValidation: SessionManager = SessionManager()
                if SessionValidation.verifySession(sessionCode: self.Outlet_TextField_SessionCode.stringValue, pass: self.Outlet_TextField_JoinPassword.stringValue, name: self.Outlet_TextField_Name.stringValue) {
                    self.Outlet_Button_BeginTest.isHidden = false
                    self.Outlet_StandardText_StatusNotifier.stringValue = "Session is valid."
                    self.Outlet_StandardText_StatusNotifier.textColor = .green
                    NSSwiftUtils.writeData(to: "/tmp/HARTS/ortaos/vrootfs/emulated/0/username", content: self.Outlet_TextField_Name.stringValue)
                    let Graphics: GraphicComponents = GraphicComponents()
                    Graphics.messageBox_dialogue(title: "Resize Window", contents: "Please press the green button on the title bar to maximize the window. Otherwise you may have trouble taking the test, because the contents may seem too small.")
                }else{
                    self.Outlet_Button_BeginTest.isHidden = true
                    self.Outlet_StandardText_StatusNotifier.stringValue = "Invalid. Please try again."
                    self.Outlet_StandardText_StatusNotifier.textColor = .red
                    self.Outlet_TextField_SessionCode.isEnabled = true
                    self.Outlet_TextField_JoinPassword.isEnabled = true
                    self.Outlet_TextField_Name.isEnabled = true
                }
            }
        }else{
            Outlet_TextField_SessionCode.isEnabled = true
            Outlet_TextField_JoinPassword.isEnabled = true
        }
    }
    
    @IBAction func Action_TextField_OnSessionCodeFieldUpdate(_ sender: Any) {
        validateSessionWhenTextFieldsAreUpdated()
    }
    
    @IBAction func Action_TextField_OnUsernameFieldUpdate(_ sender: Any) {
        validateSessionWhenTextFieldsAreUpdated()
    }
    
    @IBAction func Action_TextField_OnJoinPasswordUpdate(_ sender: Any) {
        validateSessionWhenTextFieldsAreUpdated()
    }
    
    @IBAction func Action_Button_OnJoinButtonPressed(_ sender: Any) {
        let Orta: OrtaOSController = OrtaOSController()
        if !Orta.push("test_start") {
            let Graphics: GraphicComponents = GraphicComponents()
            Graphics.messageBox_errorMessage(title: "Unable to start", contents: "Failed starting lockdown procedure. Please try again later.")
            let _ = Orta.push("shutdown")
            exit(0)
        }
        Outlet_TextField_SessionCode.isHidden = true
        Outlet_TextField_JoinPassword.isHidden = true
        Outlet_Button_BeginTest.isHidden = true
        Outlet_StandardText_StatusNotifier.isHidden = true
        Outlet_TextField_Name.isHidden = true
        
        Outlet_Button_AskQuestion.isEnabled = false
        realTestScreen(isHidden: false)
        let SessionMgr: SessionManager = SessionManager()
        TestURLInString = SessionMgr.getSessionURL(name: Outlet_TextField_Name.stringValue)
        Outlet_WebView.allowsBackForwardNavigationGestures = false
        Outlet_WebView.allowsLinkPreview = false
        Outlet_WebView.allowsMagnification = true
        Orta.notifyUserWhenCommandEvent()
        WebViewLoad(DestinationURL: TestURLInString)
        self.justInCaseOrtaReceivesShutDownCommand()
    }
    
    func detectURLChange(DestinationURL: String) {
        var Direction = DestinationURL
        if Direction.hasPrefix("http") {
            Direction = Direction.components(separatedBy: "/")[1]
        }else{
            Direction = Direction.components(separatedBy: "/")[0]
        }
        DispatchQueue.global().async { [self] in
            while !stopAsyncLoop {
                sleep(5)
                if let currentURL = Outlet_WebView.url {
                    if !currentURL.absoluteString.contains(Direction) {
                        break
                    }
                }
            }
        }
        if !stopAsyncLoop {
            let Graphics: GraphicComponents = GraphicComponents()
            Graphics.messageBox_errorMessage(title: "Suspected Cheating", contents: "You are trying to escape from assigned URL. Lockdown browser will be stay on hold status until proctor allows the redirection. If proctor doesn't allow to do so, you will be redirected to the first page.")
            stayHoldUntilProctorAllowsRedirection()
        }
    }
    
    func stayHoldUntilProctorAllowsRedirection() {
        
    }
    
    func WebViewLoad(DestinationURL: String) {
        let url = URL(string: DestinationURL)
        let request = URLRequest(url: url!)
        Outlet_WebView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Safari/605.1.15"
        Outlet_WebView.load(request)
        detectURLChange(DestinationURL: DestinationURL)
    }

    func realTestScreen(isHidden: Bool) {
        Outlet_Button_TestDone.isHidden = isHidden
        Outlet_Button_AskQuestion.isHidden = isHidden
        Outlet_TextField_Question.isHidden = isHidden
        Outlet_WebView.isHidden = isHidden
        Outlet_Button_Refresh.isHidden = isHidden
        Outlet_Button_Hide.isHidden = isHidden
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == Keycode.command {
            isCommandKeyDown = true
        }else if isCommandKeyDown && (event.keyCode == Keycode.c){
            AppDelegate.showNotification(title: "Suspicious Key pressed", subtitle: "Copy key map detected.", informativeText: "This key map is not allowed. Your proctor will notice.")
            let clipboardContent = NSSwiftUtils.runCommand(cmd: "pbpaste", args: "").output.joined(separator: "\n")
            
        }
    }
    
    override func keyUp(with event: NSEvent) {
        if event.keyCode == Keycode.command {
            isCommandKeyDown = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {[weak self] in
            self?.keyDown(with: $0)
            return $0
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) {[weak self] in
            self?.keyUp(with: $0)
            return $0
        }
        
        NSSwiftUtils.executeShellScript("mkdir", "-p", "/tmp/HARTS")
        
        realTestScreen(isHidden: true)
        Outlet_Button_BeginTest.isHidden = true
        Outlet_TextField_SessionCode.isEnabled = true
        Outlet_TextField_JoinPassword.isEnabled = true
        Outlet_StandardText_WebViewIsHidden.stringValue = "You currently hided test screen. \nPress Unhide button to resume test."
        Outlet_StandardText_WebViewIsHidden.isHidden = true
        
        if !NSSwiftUtils.doesTheFileExist(at: "/tmp/HARTS/ortaos/vrootfs/emulated/0") && !doDebug {
            showError(title: "Invalid Launching", contents: "HARTS launched without proper security layer. Please use official launcher.")
            exit(0)
        }
    }
    
    func showError(title: String, contents: String) {
        let Graphics: GraphicComponents = GraphicComponents()
        Graphics.messageBox_errorMessage(title: title, contents: contents)
    }
    
    func justInCaseOrtaReceivesShutDownCommand() {
        let DetectionLoop = DispatchQueue(label: "ShutdownDetect")
        DetectionLoop.async {
            while !self.stopAsyncLoop {
                if NSSwiftUtils.readContents(of: "/tmp/HARTS/ortaos/vrootfs/emulated/0/tty_in").contains("test_done"){
                    // EDIT: REPORT TO PROCTOR SHOULD GO HERE
                    self.showError(title: "Suspicious Access Detected", contents: "Security program detected a malicious access to unlock system lockdown. This will be automatically reported to proctor, and the test client will be terminated right now.")
                    exit(0)
                }
                NSSwiftUtils.executeShellScript("sleep", "3")
            }
            self.stopAsyncLoop = false
        }
    }
    
    @IBAction func Action_Button_OnHideButtonPressed(_ sender: Any) {
        if Outlet_WebView.isHidden {
            Outlet_WebView.isHidden = false
            Outlet_StandardText_WebViewIsHidden.isHidden = true
            Outlet_Button_Hide.title = "Hide"
        }else{
            Outlet_WebView.isHidden = true
            Outlet_StandardText_WebViewIsHidden.isHidden = false
            Outlet_Button_Hide.title = "Unhide"
        }
    }
    
    @IBAction func Action_TextField_OnQuestionFieldUpdate(_ sender: Any) {
        if Outlet_TextField_Question.stringValue.count > 0 {
            Outlet_Button_AskQuestion.isEnabled = true
        }else{
            Outlet_Button_AskQuestion.isEnabled = false
        }
    }
    
    @IBAction func Action_Button_OnQuestionButtonPressed(_ sender: Any) {
        let OrtaController: OrtaOSController = OrtaOSController()
        if OrtaController.writeLongArguments(str: Outlet_TextField_Question.stringValue) {
            if OrtaController.push("sendQuestion") {
                
            }else{
                let Graphics: GraphicComponents = GraphicComponents()
                Graphics.messageBox_errorMessage(title: "Error", contents: "Failed sending message: Failed communicating to helper program.")
            }
        }else{
            let Graphics: GraphicComponents = GraphicComponents()
            Graphics.messageBox_errorMessage(title: "Error", contents: "Failed sending message: Preparation for sending failed.")
        }
    }
    
    @IBAction func Action_Button_OnTestDoneButtonPressed(_ sender: Any) {
        let SendLeavePacket: SessionManager = SessionManager()
        SendLeavePacket.leaveSession(sessionCode: Outlet_TextField_SessionCode.stringValue, pass: Outlet_TextField_JoinPassword.stringValue, name: Outlet_TextField_Name.stringValue)
        let OrtaController: OrtaOSController = OrtaOSController()
        stopAsyncLoop = true
        while stopAsyncLoop {}
        if OrtaController.push("test_done") {
            exit(0)
        }else{
            let Graphics: GraphicComponents = GraphicComponents()
            Graphics.messageBox_errorMessage(title: "Error", contents: "Failed to communicate with helper system. You may need to restart your computer.")
            exit(0)
        }
        
    }
    
    @IBAction func Action_Button_OnRefreshButtonPressed(_ sender: Any) {
        let Graphics: GraphicComponents = GraphicComponents()
        if Graphics.messageBox_ask(title: "Are you sure?", contents: "You may lose your test progress if you refresh the page.", firstButton: "Yes", secondButton: "No") {
            WebViewLoad(DestinationURL: TestURLInString)
        }
    }
}



struct Keycode {
    
    // Layout-independent Keys
    // eg.These key codes are always the same key on all layouts.
    static let returnKey                 : UInt16 = 0x24
    static let enter                     : UInt16 = 0x4C
    static let tab                       : UInt16 = 0x30
    static let space                     : UInt16 = 0x31
    static let delete                    : UInt16 = 0x33
    static let escape                    : UInt16 = 0x35
    static let command                   : UInt16 = 0x37
    static let shift                     : UInt16 = 0x38
    static let capsLock                  : UInt16 = 0x39
    static let option                    : UInt16 = 0x3A
    static let control                   : UInt16 = 0x3B
    static let rightShift                : UInt16 = 0x3C
    static let rightOption               : UInt16 = 0x3D
    static let rightControl              : UInt16 = 0x3E
    static let leftArrow                 : UInt16 = 0x7B
    static let rightArrow                : UInt16 = 0x7C
    static let downArrow                 : UInt16 = 0x7D
    static let upArrow                   : UInt16 = 0x7E
    static let volumeUp                  : UInt16 = 0x48
    static let volumeDown                : UInt16 = 0x49
    static let mute                      : UInt16 = 0x4A
    static let help                      : UInt16 = 0x72
    static let home                      : UInt16 = 0x73
    static let pageUp                    : UInt16 = 0x74
    static let forwardDelete             : UInt16 = 0x75
    static let end                       : UInt16 = 0x77
    static let pageDown                  : UInt16 = 0x79
    static let function                  : UInt16 = 0x3F
    static let f1                        : UInt16 = 0x7A
    static let f2                        : UInt16 = 0x78
    static let f4                        : UInt16 = 0x76
    static let f5                        : UInt16 = 0x60
    static let f6                        : UInt16 = 0x61
    static let f7                        : UInt16 = 0x62
    static let f3                        : UInt16 = 0x63
    static let f8                        : UInt16 = 0x64
    static let f9                        : UInt16 = 0x65
    static let f10                       : UInt16 = 0x6D
    static let f11                       : UInt16 = 0x67
    static let f12                       : UInt16 = 0x6F
    static let f13                       : UInt16 = 0x69
    static let f14                       : UInt16 = 0x6B
    static let f15                       : UInt16 = 0x71
    static let f16                       : UInt16 = 0x6A
    static let f17                       : UInt16 = 0x40
    static let f18                       : UInt16 = 0x4F
    static let f19                       : UInt16 = 0x50
    static let f20                       : UInt16 = 0x5A
    
    // US-ANSI Keyboard Positions
    // eg. These key codes are for the physical key (in any keyboard layout)
    // at the location of the named key in the US-ANSI layout.
    static let a                         : UInt16 = 0x00
    static let b                         : UInt16 = 0x0B
    static let c                         : UInt16 = 0x08
    static let d                         : UInt16 = 0x02
    static let e                         : UInt16 = 0x0E
    static let f                         : UInt16 = 0x03
    static let g                         : UInt16 = 0x05
    static let h                         : UInt16 = 0x04
    static let i                         : UInt16 = 0x22
    static let j                         : UInt16 = 0x26
    static let k                         : UInt16 = 0x28
    static let l                         : UInt16 = 0x25
    static let m                         : UInt16 = 0x2E
    static let n                         : UInt16 = 0x2D
    static let o                         : UInt16 = 0x1F
    static let p                         : UInt16 = 0x23
    static let q                         : UInt16 = 0x0C
    static let r                         : UInt16 = 0x0F
    static let s                         : UInt16 = 0x01
    static let t                         : UInt16 = 0x11
    static let u                         : UInt16 = 0x20
    static let v                         : UInt16 = 0x09
    static let w                         : UInt16 = 0x0D
    static let x                         : UInt16 = 0x07
    static let y                         : UInt16 = 0x10
    static let z                         : UInt16 = 0x06

    static let zero                      : UInt16 = 0x1D
    static let one                       : UInt16 = 0x12
    static let two                       : UInt16 = 0x13
    static let three                     : UInt16 = 0x14
    static let four                      : UInt16 = 0x15
    static let five                      : UInt16 = 0x17
    static let six                       : UInt16 = 0x16
    static let seven                     : UInt16 = 0x1A
    static let eight                     : UInt16 = 0x1C
    static let nine                      : UInt16 = 0x19
    
    static let equals                    : UInt16 = 0x18
    static let minus                     : UInt16 = 0x1B
    static let semicolon                 : UInt16 = 0x29
    static let apostrophe                : UInt16 = 0x27
    static let comma                     : UInt16 = 0x2B
    static let period                    : UInt16 = 0x2F
    static let forwardSlash              : UInt16 = 0x2C
    static let backslash                 : UInt16 = 0x2A
    static let grave                     : UInt16 = 0x32
    static let leftBracket               : UInt16 = 0x21
    static let rightBracket              : UInt16 = 0x1E
    
    static let keypadDecimal             : UInt16 = 0x41
    static let keypadMultiply            : UInt16 = 0x43
    static let keypadPlus                : UInt16 = 0x45
    static let keypadClear               : UInt16 = 0x47
    static let keypadDivide              : UInt16 = 0x4B
    static let keypadEnter               : UInt16 = 0x4C
    static let keypadMinus               : UInt16 = 0x4E
    static let keypadEquals              : UInt16 = 0x51
    static let keypad0                   : UInt16 = 0x52
    static let keypad1                   : UInt16 = 0x53
    static let keypad2                   : UInt16 = 0x54
    static let keypad3                   : UInt16 = 0x55
    static let keypad4                   : UInt16 = 0x56
    static let keypad5                   : UInt16 = 0x57
    static let keypad6                   : UInt16 = 0x58
    static let keypad7                   : UInt16 = 0x59
    static let keypad8                   : UInt16 = 0x5B
    static let keypad9                   : UInt16 = 0x5C
}
