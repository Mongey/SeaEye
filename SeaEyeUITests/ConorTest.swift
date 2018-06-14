//
//  ConorTest.swift
//  SeaEyeTests
//
//  Created by Conor Mongey on 08/06/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import XCTest

class ConorTest: XCTestCase {
    var app : XCUIApplication?
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app!.launch()

        // In UI tests it’s important to set the initial state required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//     //ss   let button = app?.buttons["IconButton"]
//        XCTAssertTrue(button?.exists)
//        button?.click()
//        app?.screenshot()
    }

}
