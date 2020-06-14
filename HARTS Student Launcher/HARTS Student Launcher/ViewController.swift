//
//  ViewController.swift
//  HARTS Student Launcher
//
//  Created by Hoyoun Song on 2020/06/13.
//  Copyright © 2020 Hoyoun Song. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    // Quick Access to system utilities
    let System: NSSwiftUtils = NSSwiftUtils()
    
    // 숨겨진 옵션
    var doVerbose = false
    
    // 헬퍼 명령어 - 시스템 명령어 집합체
    let helperBin = ["async", "locker", "lockvf", "testdone", "base64decode", "base64encode", "launchdmgr-u", "launchdmgr-s", "autoreboot"]
    
    // 헬퍼 명령어 무결성 확인 - 기능 아직 추가 안됨
    //let helperBinExpectedHASH = ["", "", "", "", "", "", "", "", ""]
    
    // 인터페이스 연결
    @IBOutlet weak var SessionTokenField: NSTextField! // 토큰 입력 필드
    @IBOutlet weak var TestJoinButtonOutlet: NSButton! // 버튼 인터페이스
    @IBOutlet weak var BottomLabel: NSTextField! // 아래 레이블
    
    // 토큰 입력 필드에 변경이 감지될 경우 자동 실행
    @IBAction func OnTokenFieldModification(_ sender: Any) {
        // 필드 안의 값이 15글자 이상일 경우 참가 버튼을 활성화, 아닐 경우 비활성화
        if SessionTokenField.stringValue.count > 15 {
            TestJoinButtonOutlet.isEnabled = true
        }else{
            TestJoinButtonOutlet.isEnabled = false
        }
    }
    
    // 버튼이 눌렸을때 실행
    @IBAction func OnJoinButtonPressed(_ sender: Any) {
        verbose("Join button pressed.")
        verbose("Showing warning message...")
        
        // 경고 메시지
        print("MESSAGE: [NOTICE] - During the test, some of the process (including HARTS launcher) such as Finder may not respond. Please notice that it is part of testing protocol.")
        print("MESSAGE:          - When testing is complete, PLEASE USE \"Test Done\" button to quit HARTS Lockdown Browser. Otherwise, the system may remain in lockdown state.")
        let Graphics: GraphicComponents = GraphicComponents()
        Graphics.messageBox_dialogue(title: "Some process may not respond", contents: "During the test, some of the process (including HARTS launcher) such as Finder may not respond, or marked as not responding application. Please notice that it is part of testing protocol and should not quit process.\n\nWhen testing is complete, PLEASE USE \"Test Done\" button to quit HARTS Lockdown Browser. Otherwise, the system may remain in lockdown state.")
        BottomLabel.stringValue = "Joining..." // 레이블 값 변경
        verbose("Disabling inputs in launcher elements...")
        
        // 버튼 및 토큰 필드 변경 막기
        SessionTokenField.isEnabled = false
        TestJoinButtonOutlet.isEnabled = false
        
        verbose("Join token: \(SessionTokenField.stringValue)")
        verbose("Decrypting join key...")
        let bundlePath = Bundle.main.resourcePath! + "/"
        
        // 토큰을 Base64 에서 String 으로 디코드, /tmp/dlink.harts 에 디코드된 값 저장. 헬퍼 base64decode 모듈 이용. Array helperBin 에서 base64decode 값을 가져와서 실행.
        // 만약 헬퍼에서 0이 아닌 종료 코드를 반환할 경우 오류 메시지를 띄우고 종료코드 -12 를 반환.
        if System.executeShellScript(bundlePath + helperBin[helperBin.firstIndex(of: "base64decode")!], SessionTokenField.stringValue, "dlink.harts") != 0 {
            verbose("ERROR: Invalid token")
            Graphics.messageBox_errorMessage(title: "Invalid Token", contents: "The token seems invalid, therefore decryption failed.")
            exit(-12)
        }
        
        // 헬퍼에서 작성된 디코드 값을 불러와서 메모리에 저장
        let joinLink = System.readContents(of: "/tmp/dlink.harts").replacingOccurrences(of: "\n", with: "")
        System.executeShellScript("rm", "-f", "/tmp/dlink.harts") // 헬퍼에서 작성된 디코드 파일 삭제
        
        // 값 확인
        if joinLink.elementsEqual("returned:nofile") { // returned:nofile 일 경우 불러오기에 실패하였다고 판단, 오류를 표시. -11 을 종료코드로 반환.
            verbose("ERROR: No meaningful value returned.")
            Graphics.messageBox_errorMessage(title: "Unexpected Error", contents: "There was an error while starting client. Please report to developer.\nError code: Launcher.BaseDecryptor.FileNotFound\nPotential Culprit: Bash returned operation not permitted error")
            exit(-11)
        }else if joinLink.elementsEqual("") { // 값이 비어있을 경우 디코드 실패로 판단, 오류를 표시. -13 을 종료코드로 반환.
            verbose("ERROR: No meaningful value returned.")
            Graphics.messageBox_errorMessage(title: "Token Error", contents: "There was an error while decrypting token. Please check your token again.\nError code: Launcher.BaseDecryptor.EmptyToken\nPotential Culprit: Invalid character in input stream")
            exit(-13)
        }else if !joinLink.starts(with: "http://") && !joinLink.starts(with: "https://") { // 디코드 값이 http:// 또는 https:// 가 아닐 경우 토큰에 문제가 있다고 판단, 오류를 표시. -14 을 종료코드로 반환.
            verbose("ERROR: Decrypted token does not start with public protocol (http)")
            Graphics.messageBox_errorMessage(title: "Token Error", contents: "Unable to join the session. The token contains unsupported protocol.")
            exit(-14)
        }
        verbose("Join link: \(joinLink)")
        
        // 해쉬값을 이용해 헬퍼 무결성을 확인.
        // Add HASH verification here later!
        
        verbose("Starting client!")
        
        // 클라이언트를 시작.
        // (이 부분을 변경할 필요가 있음. 정상적으로 클라이언트가 실행되지 않음. async 가 아닌 open 을 이용해 실행이 필요. 헬퍼에 추가 필요 여부는 추후에 판단. stdin 방식 param input 은 /tmp/args-* 형태로 대체 할 수 있음.)
        System.executeShellScript(bundlePath + helperBin[helperBin.firstIndex(of: "async")!], bundlePath + "/HARTS Student.app/Contents/MacOS/HARTS Student", bundlePath, joinLink)
        exit(0) // 종료코드 0 반환. (정상 종료)
    }
    
    
    func verbose(_ toLog: String) {
        if doVerbose {
            print("[HARTS-Student] " + toLog) // doVerbose 값이 True 일 경우 CLI 화면에 메시지 출력
        }
    }
    
    override func viewDidLoad() {
        // 시작 크레딧
        print("HARTS [Home Anti-cheat Remote Testing System] Lockdown Browser")
        print("Written by: ")
        print("Backend - (Tom) Minseo Choi, Hoyoun Song")
        print("Frontend - Hoyoun Song")
        print("")
        super.viewDidLoad()
        
        // 환경 변수 HARTS_VERBOSE 가 1 일 경우 doVerbose 를 True 로 셋팅. 터미널에서 export HARTS_VERBOSE=1 로 설정 가능.
        if let verboseCheck = ProcessInfo.processInfo.environment["HARTS_VERBOSE"] {
            if verboseCheck.elementsEqual("1") {
                doVerbose = true
                verbose("Verbose mode enabled.")
            }
        }
        verbose("Running startup process...")
        verbose("Checking client in bundle...")
        
        // 클라이언트가 런쳐 리소스 안에 존재하는지 확인. 없을 경우 오류를 표시, 종료코드 -9를 반환.
        if !System.doesTheFileExist(at: Bundle.main.resourcePath! + "/HARTS Student.app/Contents/MacOS/HARTS Student") {
            verbose("ERROR: Client not found!")
            let Graphics: GraphicComponents = GraphicComponents()
            Graphics.messageBox_errorMessage(title: "Client Not Found", contents: "Lockdown browser client is not found in specified directory: \(Bundle.main.resourcePath! + "/HARTS Student.app/Contents/MacOS/HARTS Student") period.")
            exit(-9)
        }else{
            verbose("Client found.")
            
            // OS 가 작성한 Quarantine 데이터를 삭제하여 실행 가능하게 만듦
            verbose("Removing all extended attributes includeing com.apple.quarantine...")
            System.executeShellScript("xattr", "-xc", Bundle.main.resourcePath! + "/HARTS Student.app")
        }
        verbose("Checking helper binaries...")
        
        // 헬퍼 도구의 존재 여부 체크
        for binName in helperBin {
            verbose("Checking: \(binName)")
            if !System.doesTheFileExist(at: Bundle.main.resourcePath! + "/" + binName) {
                verbose("ERROR: \(binName) not found.")
                let Graphics: GraphicComponents = GraphicComponents()
                Graphics.messageBox_errorMessage(title: "Missing resource", contents: "Some core files are not found, unable to prepare for lockdown environment.")
                exit(-10)
            }else{
                verbose("Verified: \(binName)")
                verbose("Making runnable: \(binName)")
                System.executeShellScript("chmod", "+x", Bundle.main.resourcePath! + "/" + binName)
            }
        }
        verbose("Helper tools check complete.")
        verbose("Disabling join button...")
        TestJoinButtonOutlet.isEnabled = false // 버튼 비활성화
        verbose("System ready to launch.")
        verbose("Startup procedure complete.")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

