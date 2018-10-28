//
//  FallbackViewTest.swift
//  SeaEyeUITests
//
//  Created by Conor Mongey on 30/10/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import XCTest

class FallbackViewTest: XCTestCase {
    func testWhenThereAreNoBuilds() {
        let settings = Settings(clients: [])

        struct TestCase {
            let expectedResult: String?
            let builds: [CircleCIBuild]
            let settings: Settings
        }

        let testCases: [TestCase] = [
            TestCase(expectedResult: "You have not configured any clients",
                     builds: [],
                     settings: settings),
        ]
        for testCase in testCases {
            let sut = FallbackView(settings: testCase.settings, builds: testCase.builds)
            XCTAssertEqual(testCase.expectedResult, sut.description())
        }
    }
}
