//
//  UITest.swift
//  SeaEyeTests
//
//  Created by Conor Mongey on 16/10/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import XCTest

class UITest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments = ["resetDefaults"]
        app.launch()

        // In UI tests it’s important to set the initial state required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()

        let popover = openSeaEye().firstMatch
        let foo = XCUIApplication().children(matching: .menuBar).element(boundBy: 1)
            let icon = foo.children(matching: .statusItem)
        icon.element.click()
        XCUIApplication().children(matching: .menuBar).element(boundBy: 1).children(matching: .statusItem).element.click()
        XCTAssert(app.popovers["popoverView"].exists)

        //73a9b00a8f678d7ee5635c03d9d5d0f00a1f65e2
        for children in icon.children(matching: .any).allElementsBoundByIndex {
            print("+++++++++++++++")
            print(children.description)
            print(children.debugDescription)
            print("===============")
        }

        let bar = XCUIApplication().children(matching: .menuBar).element(boundBy: 1).children(matching: .statusItem).element
        bar.click()
        print(bar.debugDescription)
        print(app.popovers.textFields.description)

        XCTAssertEqual(app.popovers.allElementsBoundByIndex.count, 1)
        XCTAssert(app.popovers.textViews.softMatching(substring: "SeaEye").count != 0)
        XCTAssertEqual(popover.textFields["FallbackView"].label, "You have not configured any clients")

    }

    private func openSeaEye() -> XCUIElementQuery {
        let app = XCUIApplication()
        let menuBarsQuery = app.statusItems
        menuBarsQuery.firstMatch.click()
        return menuBarsQuery.firstMatch.popovers
    }

}
extension XCUIElementQuery {

    func softMatching(substring: String) -> [XCUIElement] {

        return self.allElementsBoundByIndex.filter { $0.label.contains(substring) }
    }
}
