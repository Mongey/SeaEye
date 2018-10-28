//
//  BuildDecoratorTest.swift
//  SeaEye
//
//  Created by Conor Mongey on 22/10/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import XCTest

class BuildDecoratorTest: XCTestCase {
    func testBuildWithNoTests() {
        let url = URL(string: "https://google.com")

        let db = BuildDecorator(build: CircleCIBuild(branch: "master",
                                                     project: "foo/bar",
                                                     status: .noTests,
                                                     subject: "Aint no tests",
                                                     user: "Homer",
                                                     buildNum: 100,
                                                     url: url!,
                                                     startTime: Date(),
                                                     queuedAt: nil,
                                                     stopTime: nil))
        XCTAssertEqual(db.statusAndSubject(), "No tests")
        XCTAssertEqual(db.statusColor(), NSColor.systemRed)
    }
}
