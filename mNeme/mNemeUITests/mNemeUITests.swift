//
//  mNemeUITests.swift
//  mNemeUITests
//
//  Created by Dennis Rudolph on 2/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest
@testable import mNeme

class mNemeUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGoogleSignIn() {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Sign In"].tap()
        app.buttons["GoogleLogin"].tap()
        
        addUIInterruptionMonitor(withDescription: "\"mNeme\" Wants to Use \"google.com\" to Sign In") { (alert) -> Bool in
            let alertButton = alert.buttons["Continue"]
            if alertButton.exists {
                alertButton.tap()
                return true
            }
            return false
        }
        app.tap()
        let label = app.staticTexts["Choose an account"]
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(label.exists)
    }
    
    func testFacebookLogin() {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Sign In"].tap()
        app.buttons["FacebookLogin"].tap()
        
        addUIInterruptionMonitor(withDescription: "\"mNeme\" Wants to Use \"google.com\" to Sign In") { (alert) -> Bool in
            let alertButton = alert.buttons["Continue"]
            if alertButton.exists {
                alertButton.tap()
                return true
            }
            return false
        }
        app.tap()
        let label = app.staticTexts["Log in With Facebook"]
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(label.exists)
    }

    func testSignInWithEmail() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Sign In"].tap()
        app.buttons["Email Button"].tap()
        let emailTF = app.textFields["EmailTF"]
        emailTF.tap()
        emailTF.typeText("dennisnar@gmail.com\n")
        let passwordTF = app.textFields["PasswordTF"]
        passwordTF.tap()
        passwordTF.typeText("DENNISNAR\n")
        app.buttons["EmailSignIn"].tap()
        
        let label = app.staticTexts["37"]
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssert(label.exists)
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
