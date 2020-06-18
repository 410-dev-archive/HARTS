//
//  ViewController.swift
//  HARTS Student
//
//  Created by Hoyoun Song on 2020/06/12.
//  Copyright © 2020 Hoyoun Song. All rights reserved.
//

import Cocoa
import Python
import WebKit

// WKWebView 객체에 load 명령어 추가. URL 을 직접 pass 하여 WKWebView 에서 로드 가능하게 만듦.
extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}

class ViewController: NSViewController {
    
    // 인터페이스 연결
    @IBOutlet weak var UI_StartTest: NSButton!
    @IBOutlet weak var UI_TestDone: NSButton!
    @IBOutlet weak var UI_MainWebView: WKWebView!
    
    // 소프트웨어 버전 선언
    let CONST_VERSION = "1.0 Alpha"
    
    // 런쳐로부터 받아온 parameter 저장공간
    var BINARIES = "" // 바이너리 저장 공간, 또는 헬퍼가 있는 공간, String 으로 초기화
    var URL = "" // 테스트 사이트 주소, String 으로 초기화
    var SESSION_TOKEN = "" // 토큰. URL 확인 후 다시 base64encode 활용.
    var USERNAME = "" // 사용자 이름, String 으로 초기화
    
    // 헬퍼 바이너리
    let helperBin = ["async", "locker", "lockvf", "testdone", "base64decode", "base64encode", "launchdmgr-u", "launchdmgr-s", "autoreboot"]
    
    // 애플리케이션 시작시 자동 실행
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // stdin 방식으로 pass 된 parameter 를 확인함으로서 런쳐를 이용하였는지 확인. 런쳐는 무결성 확인 용도이므로 필수.
        // param 의 개수는 2개인지 확인 한 후, 두번째 parameter 가 http 로 시작하는지 확인. (https 또한 http 로 시작하므로 중복 가능)
        let System: NSSwiftUtils = NSSwiftUtils()
        BINARIES = System.readContents(of: "/tmp/args-binloc.harts").replacingOccurrences(of: "\n", with: "")
        URL = System.readContents(of: "/tmp/args-url.harts").replacingOccurrences(of: "\n", with: "")
        
        if !BINARIES.contains("/") || !URL.starts(with: "http") {
            // 위 조건중 하나라도 참일 경우 (값이 맞지 않다는 조건이 참일 경우), -1 을 종료 코드로 반환.
            let Graphics: GraphicComponents = GraphicComponents()
            Graphics.messageBox_errorMessage(title: "Invalid launching", contents: "Launch method was invalid. Please use official launcher.")
//            exit(-1)
        }
        
        // 세션 조인을 위해 Base64 로 URL 인코드.
        System.executeShellScript(BINARIES + helperBin[5], URL, "/tmp/base64e.harts")
        SESSION_TOKEN = System.readContents(of: "/tmp/base64e.harts").replacingOccurrences(of: "\n", with: "")
        
        // 인코드 값 확인
        if SESSION_TOKEN.starts(with: "returned:") {
            // 인코드 실패 또는 파일 접근 실패, -2 반환
            let Graphics: GraphicComponents = GraphicComponents()
            Graphics.messageBox_errorMessage(title: "Session Prepare Failed", contents: "There was an error while generating session request.\nError code: Client.BaseEncryptor.NoFile\nPotential Culprit: Too many reasons")
            exit(-2)
        }else if SESSION_TOKEN.elementsEqual(""){
            // 파일을 읽었으나 비어있음, -3 반환
            let Graphics: GraphicComponents = GraphicComponents()
            Graphics.messageBox_errorMessage(title: "Session Prepare Failed", contents: "There was an error while generating session request.\nError code: Client.BaseEncryptor.EmptyToken\nPotential Culprit: Invalid character in input stream")
            exit(-3)
        }
        
        // 테스트 종료 버튼을 비활성화
        UI_TestDone.isEnabled = false
        
        // 창 크기를 화면에 맞게 조정. 수정 필요함.
        let thisWindow = NSWindow.init(contentViewController: self)
        thisWindow.zoom(thisWindow)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // 시험 시작 버튼을 누르면 실행.
    @IBAction func ACTION_StartTest(_ sender: Any) {
        
        // 시험 시작 버튼을 비활성화 시켜서 중복을 방지, 그리고 시험 완료 버튼을 활성화.
        UI_StartTest.isEnabled = false
        UI_TestDone.isEnabled = true
        
        // 경고 메시지
        let Graphics: GraphicComponents = GraphicComponents()
        Graphics.messageBox_dialogue(title: "Test will begin", contents: "Test protocol will now start. The system services will now be suspended and you cannot switch between applications. If system services does not resume after test is over, please restart your computer. ")
        
        // 락다운 헬퍼 실행 코드. 웹킷 및 실행 무결성, 파이썬 결합이 성공적으로 이루어지면 락다운 코드 활성화.
//        let System: NSSwiftUtils = NSSwiftUtils()
//        System.executeShellScript(BINARIES + helperBin[6]) // launchdmgr-u
//        System.executeShellScript(BINARIES + helperBin[1]) // locker
//        System.executeShellScript(BINARIES + helperBin[2]) // lockvf
        
        // Python 으로 세션 조인 코드 실행. (여기에 작성)
        
        
        // WkWebView 에 시험 화면을 띄워주는 코드를 작성해야함.
        // Webkit update
    }
    
    // 시험 완료 버튼을 누르면 실행.
    @IBAction func ACTION_TestDone(_ sender: Any) {
        // 확인 메시지를 보냄
        let Graphics: GraphicComponents = GraphicComponents()
        if Graphics.messageBox_ask(title: "Confirmation", contents: "Did you finish your test? Pressing this button will not automatically submit the test, but will stop the browser. All of your progress will be lost if not submitted.", firstButton: "Yes, I am done.", secondButton: "No, not yet.") {
            
            // Yes I am done 이 눌렸을 경우 testdone 과 launchdmgr-s 헬퍼를 이용해 잠긴 시스템을 품.
            let System: NSSwiftUtils = NSSwiftUtils()
            
            // 현재 락다운을 활성화 하지 않았으므로 실행하지 않음.
//            System.executeShellScript(BINARIES + helperBin[helperBin.firstIndex(of: "testdone")!])
//            System.executeShellScript(BINARIES + helperBin[helperBin.firstIndex(of: "launchdmgr-s")!])
            
            // 혹시라도 락다운이 정상적으로 풀리지 않을 경우 시스템 재시작을 통해 락다운 해제. autoreboot 헬퍼를 이용.
            if Graphics.messageBox_ask(title: "System Services", contents: "Can you fully access to system services, such as Finder? If not, press reboot button. Otherwise, press dismiss.", firstButton: "Reboot", secondButton: "Dismiss") {
                
                // Reboot 버튼이 눌릴 경우 autoreboot 코드를 실행.
                System.executeShellScript(BINARIES + "autoreboot")
                exit(0)
            }
            
            // Dismiss 버튼이 눌릴 경우 0 을 반환 (정상종료)
            exit(0)
        }
    }
}
