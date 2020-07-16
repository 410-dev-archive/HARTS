//
//  ViewController.swift
//  HARTS Student
//
//  Created by Hoyoun Song on 2020/07/16.
//

import Cocoa
import WebKit

class ViewController: NSViewController {
    @IBOutlet weak var Outlet_WebView: WKWebView!
    
    @IBOutlet weak var Outlet_Button_TestDone: NSButton!
    @IBOutlet weak var Outlet_Button_AskQuestion: NSButton!
    @IBOutlet weak var Outlet_TextField_Question: NSTextField!
    
    @IBOutlet weak var Outlet_TextField_SessionCode: NSTextField!
    @IBOutlet weak var Outlet_TextField_JoinPassword: NSTextField!
    @IBOutlet weak var Outlet_StandardText_StatusNotifier: NSTextField!
    @IBOutlet weak var Outlet_Button_BeginTest: NSButton!
    
    private func validateSessionWhenTextFieldsAreUpdated() {
        if Outlet_TextField_JoinPassword.stringValue.count > 0 && Outlet_TextField_SessionCode.stringValue.count > 0 {
            Outlet_StandardText_StatusNotifier.stringValue = "Validating..."
            Outlet_TextField_SessionCode.isEnabled = false
            Outlet_TextField_JoinPassword.isEnabled = false
            DispatchQueue.main.async {
                let SessionValidation: SessionJoinManager = SessionJoinManager()
                if SessionValidation.verifySession(sessionCode: self.Outlet_TextField_SessionCode.stringValue, pass: self.Outlet_TextField_JoinPassword.stringValue) {
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
    
    @IBAction func Action_TextField_OnJoinPasswordUpdate(_ sender: Any) {
        validateSessionWhenTextFieldsAreUpdated()
    }
    
    @IBAction func Action_Button_OnJoinButtonPressed(_ sender: Any) {
        Outlet_TextField_SessionCode.isHidden = true
        Outlet_TextField_JoinPassword.isHidden = true
        Outlet_Button_BeginTest.isHidden = true
        Outlet_StandardText_StatusNotifier.isHidden = true
        
        realTestScreen(isHidden: false)
        let SessionManager: SessionJoinManager = SessionJoinManager()
        WebViewLoad(DestinationURL: SessionManager.getSessionURL(sessionCode: Outlet_TextField_SessionCode.stringValue, pass: Outlet_TextField_JoinPassword.stringValue))
    }
    
    func WebViewLoad(DestinationURL: String) {
        var content: String! = nil
        do {
            content = try String(contentsOf: URL(string: DestinationURL)!)
        } catch {
            let Graphics: GraphicComponents = GraphicComponents()
            Graphics.messageBox_errorMessage(title: "Fatal Error", contents: "There was an error while joining session. Sorry.")
            exit(9)
        }
        Outlet_WebView.loadHTMLString(content, baseURL: nil)
        
    }
    
    func WebViewNavigate(DestinationURL: String){
        Outlet_WebView.load(URLRequest(url: URL(string: DestinationURL)!))
    }
    
    func realTestScreen(isHidden: Bool) {
        Outlet_Button_TestDone.isHidden = isHidden
        Outlet_Button_AskQuestion.isHidden = isHidden
        Outlet_TextField_Question.isHidden = isHidden
        Outlet_WebView.isHidden = isHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realTestScreen(isHidden: true)
        Outlet_Button_BeginTest.isHidden = true
        Outlet_TextField_SessionCode.isEnabled = true
        Outlet_TextField_JoinPassword.isEnabled = true
        
    }

}

