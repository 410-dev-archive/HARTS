//
//  ViewController.swift
//  HARTS Student
//
//  Created by Hoyoun Song on 2020/07/16.
//

import Cocoa
import WebKit

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}

class ViewController: NSViewController {
    
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
        Outlet_Button_TestDone.isHidden = false
        Outlet_Button_AskQuestion.isHidden = false
        Outlet_TextField_Question.isHidden = false
        
        Outlet_TextField_SessionCode.isHidden = true
        Outlet_TextField_JoinPassword.isHidden = true
        Outlet_Button_BeginTest.isHidden = true
        Outlet_StandardText_StatusNotifier.isHidden = true
        
        let WebView = WKWebView.init()
        WebView.frame = CGRect(x: 0, y: 20, width: 100, height: 100)
        WebView.load("http://google.com")
        self.view.addSubview(WebView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Outlet_Button_BeginTest.isHidden = true
        Outlet_TextField_SessionCode.isEnabled = true
        Outlet_TextField_JoinPassword.isEnabled = true
        
        Outlet_Button_TestDone.isHidden = true
        Outlet_Button_AskQuestion.isHidden = true
        Outlet_TextField_Question.isHidden = true
    }

}

