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
    @IBOutlet weak var Outlet_Button_Refresh: NSButton!
    
    @IBOutlet weak var Outlet_TextField_SessionCode: NSTextField!
    @IBOutlet weak var Outlet_TextField_Name: NSTextField!
    @IBOutlet weak var Outlet_TextField_JoinPassword: NSTextField!
    @IBOutlet weak var Outlet_StandardText_StatusNotifier: NSTextField!
    @IBOutlet weak var Outlet_Button_BeginTest: NSButton!
    
    var TestURLInString: String!
    var stopAsyncLoop = false
    
    private func validateSessionWhenTextFieldsAreUpdated() {
        if Outlet_TextField_JoinPassword.stringValue.count > 0 && Outlet_TextField_SessionCode.stringValue.count > 0 && Outlet_TextField_Name.stringValue.count > 0 {
            Outlet_StandardText_StatusNotifier.stringValue = "Validating..."
            Outlet_TextField_SessionCode.isEnabled = false
            Outlet_TextField_JoinPassword.isEnabled = false
            DispatchQueue.main.async {
                let SessionValidation: SessionJoinManager = SessionJoinManager()
                if SessionValidation.verifySession(sessionCode: self.Outlet_TextField_SessionCode.stringValue, pass: self.Outlet_TextField_JoinPassword.stringValue, name: self.Outlet_TextField_Name.stringValue) {
                    self.Outlet_Button_BeginTest.isHidden = false
                    self.Outlet_StandardText_StatusNotifier.stringValue = "Session is valid."
                    self.Outlet_StandardText_StatusNotifier.textColor = .green
                }else{
                    self.Outlet_Button_BeginTest.isHidden = true
                    self.Outlet_StandardText_StatusNotifier.stringValue = "Invalid. Please try again."
                    self.Outlet_StandardText_StatusNotifier.textColor = .red
                    self.Outlet_TextField_SessionCode.isEnabled = true
                    self.Outlet_TextField_JoinPassword.isEnabled = true
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
        Outlet_TextField_SessionCode.isHidden = true
        Outlet_TextField_JoinPassword.isHidden = true
        Outlet_Button_BeginTest.isHidden = true
        Outlet_StandardText_StatusNotifier.isHidden = true
        Outlet_TextField_Name.isHidden = true
        
        Outlet_Button_AskQuestion.isEnabled = false
        realTestScreen(isHidden: false)
        let SessionManager: SessionJoinManager = SessionJoinManager()
        TestURLInString = SessionManager.getSessionURL(sessionCode: Outlet_TextField_SessionCode.stringValue, pass: Outlet_TextField_JoinPassword.stringValue)
        Outlet_WebView.allowsBackForwardNavigationGestures = false
        Outlet_WebView.allowsLinkPreview = false
        Outlet_WebView.allowsMagnification = true
        WebViewLoad(DestinationURL: TestURLInString)
        self.justInCaseOrtaReceivesShutDownCommand()
    }
    
    func WebViewLoad(DestinationURL: String) {
        let url = URL(string: DestinationURL)
        let request = URLRequest(url: url!)
        Outlet_WebView.load(request)
    }

    func realTestScreen(isHidden: Bool) {
        Outlet_Button_TestDone.isHidden = isHidden
        Outlet_Button_AskQuestion.isHidden = isHidden
        Outlet_TextField_Question.isHidden = isHidden
        Outlet_WebView.isHidden = isHidden
        Outlet_Button_Refresh.isHidden = isHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realTestScreen(isHidden: true)
        Outlet_Button_BeginTest.isHidden = true
        Outlet_TextField_SessionCode.isEnabled = true
        Outlet_TextField_JoinPassword.isEnabled = true
        Outlet_Button_Refresh.isHidden = true
    }
    
    func detectedOrtaShutdown() {
        // EDIT: REPORT TO PROCTOR SHOULD GO HERE
        DispatchQueue.main.async {
            let Graphics: GraphicComponents = GraphicComponents()
            Graphics.messageBox_errorMessage(title: "Suspicious Access Detected", contents: "Security program detected a malicious access to unlock system lockdown. This will be automatically reported to proctor, and the test client will be terminated right now.")
            exit(0)
        }
    }
    
    func justInCaseOrtaReceivesShutDownCommand() {
        let DetectionLoop = DispatchQueue(label: "ShutdownDetect")
        DetectionLoop.async {
            while !self.stopAsyncLoop {
                if NSSwiftUtils.readContents(of: "/tmp/HARTS/ortaos/vrootfs/emulated_corestorage/emulated0/emulated_cache/teletype_input").contains("test_done"){
                    self.detectedOrtaShutdown()
                }
                
                NSSwiftUtils.executeShellScript("sleep", "3")
            }
            self.stopAsyncLoop = false
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
        WebViewLoad(DestinationURL: TestURLInString)
    }
}

