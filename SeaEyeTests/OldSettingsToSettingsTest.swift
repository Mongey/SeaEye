//
//  OldSettingsToSettingsTest.swift
//  SeaEyeTests
//
//  Created by Conor Mongey on 20/11/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import XCTest

class OldSettingsToSettingsTest: XCTestCase {
    func testConvertingSettings() {
        let oldSettingsUD = UserDefaults.init()
        oldSettingsUD.set("abc123", forKey: OldSettings.Keys.apiKey.rawValue)
        oldSettingsUD.set("nolaneo", forKey: OldSettings.Keys.organisation.rawValue)
        oldSettingsUD.set("SeaEye wc2018", forKey: OldSettings.Keys.projects.rawValue)
        oldSettingsUD.set(nil, forKey: OldSettings.Keys.userFilter.rawValue)
        oldSettingsUD.set("master", forKey: OldSettings.Keys.branchFilter.rawValue)
        oldSettingsUD.set(true, forKey: OldSettings.Keys.notify.rawValue)

        let settings = OldSettings.loadFromOldSettings(userDefaults: oldSettingsUD)
        XCTAssertEqual(settings.clients.count, 1)

        let client = settings.clients[0]
        XCTAssertEqual(client.apiKey, "abc123")
        XCTAssertEqual(client.url, "https://circleci.com")

        XCTAssertEqual(client.projects.count, 2)
        XCTAssertEqual(client.projects[0].organisation, "nolaneo")
        XCTAssertEqual(client.projects[0].name, "SeaEye")
        XCTAssertEqual(client.projects[0].filter?.branchFilter, "master")

        XCTAssertEqual(client.projects[1].organisation, "nolaneo")
        XCTAssertEqual(client.projects[1].name, "wc2018")
        XCTAssertEqual(client.projects[1].filter?.branchFilter, "master")
    }
}
