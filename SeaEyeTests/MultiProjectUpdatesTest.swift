//
//  MultiProjectUpdatesTest.swift
//  SeaEyeUITests
//
//  Created by Conor Mongey on 31/10/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import XCTest

class FoobarTest: XCTestCase {
    func testOnlyNewBuildsAreReturned() {
        let project = sampleProject()
        var sut = Foobar(lastUpdateForProject: Date.distantPast)

        let firstRun = sut.notify(project: project, builds: [])
        XCTAssertEqual(firstRun.count, 0)

        let builds2: [CircleCIBuild] = [CircleCIBuild(branch: "master",
                                                      project: "foo",
                                                      status: .failed,
                                                      subject: "",
                                                      user: "homer",
                                                      buildNum: 123,
                                                      url: URL(string: "https://circleci.com")!,
                                                      startTime: Date(),
                                                      queuedAt: nil,
                                                      stopTime: nil)]
        let secondRun: [CircleCIBuild] = sut.notify(project: project, builds: builds2)
        XCTAssertEqual(secondRun.count, builds2.count)
        let thirdRun: [CircleCIBuild] = sut.notify(project: project, builds: builds2)
        XCTAssertEqual(thirdRun.count, 0)
    }

    func testBuildsThatAreQueuedOrFinishedComeThrough () {
        let project = sampleProject()

        var sut = Foobar(lastUpdateForProject: Date.distantPast)
        let startTime = Date()

        let builds = [CircleCIBuild(branch: "master",
                                  project: "foo",
                                  status: .failed,
                                  subject: "",
                                  user: "homer",
                                  buildNum: 123,
                                  url: URL(string: "https://circleci.com")!,
                                  startTime: startTime,
                                  queuedAt: nil,
                                  stopTime: nil)]

        let firstRun = sut.notify(project: project, builds: builds)
        XCTAssertEqual(firstRun.count, 1)

        let queued = [CircleCIBuild(branch: "master",
                                    project: "foo",
                                    status: .failed,
                                    subject: "",
                                    user: "homer",
                                    buildNum: 123,
                                    url: URL(string: "https://circleci.com")!,
                                    startTime: startTime,
                                    queuedAt: startTime.addingTimeInterval(1),
                                    stopTime: nil)]
        let secondRun = sut.notify(project: project, builds: queued)

        XCTAssertEqual(secondRun.count, 1, "A queued build should update")
        let stopped = [CircleCIBuild(branch: "master",
                                    project: "foo",
                                    status: .failed,
                                    subject: "",
                                    user: "homer",
                                    buildNum: 123,
                                    url: URL(string: "https://circleci.com")!,
                                    startTime: startTime,
                                    queuedAt: startTime.addingTimeInterval(1),
                                    stopTime: startTime.addingTimeInterval(2))]

        let thirdRun = sut.notify(project: project, builds: stopped)

        XCTAssertEqual(thirdRun.count, 1, "A queued build should update")

    }

    func testBuildsAreFiltered() {
        let project = sampleProject(filter: Filter(userFilter: "^nolaneo",
                                                   branchFilter: nil))
        var sut = Foobar(lastUpdateForProject: Date.distantPast)

        let firstRun = sut.notify(project: project, builds: [])
        XCTAssertEqual(firstRun.count, 0)

        let homerBuild = buildForUser("homer")
        let nolaneoBuild = buildForUser("nolaneo")

        let secondRun: [CircleCIBuild] = sut.notify(project: project, builds: [homerBuild, nolaneoBuild])

        XCTAssertEqual(secondRun.count, 1)
    }

    func buildForUser(_ user: String) -> CircleCIBuild {
        return CircleCIBuild(branch: "master",
                             project: "foo",
                             status: .failed,
                             subject: "",
                             user: user,
                             buildNum: 123,
                             url: URL(string: "https://circleci.com")!,
                             startTime: Date(),
                             queuedAt: nil,
                             stopTime: nil)
    }

    func sampleProject(filter: Filter? = nil) -> Project {
        let filter = filter != nil ? filter! : Filter(userFilter: nil, branchFilter: nil)

        return Project(
            vcsProvider: "github",
            organisation: "nolaneo",
            name: "SeaEye",
            filter: filter,
            notify: true
        )
    }
}
