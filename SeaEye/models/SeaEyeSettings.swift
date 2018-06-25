//
//  SeaEyeSettings.swift
//  SeaEye
//
//  Created by Conor Mongey on 16/06/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation

struct NewSettings: Codable {
    static let defaultsKey: String = "SeaEyeSettings2"

    var clients: [MiniClient]
}

struct MiniClient: Codable {
    let apiKey: String
    let url: String
    let projects: [Project]

    func client() -> CircleCIClient {
        let client = CircleCIClient.init()
        client.baseURL = url
        client.token = apiKey
        return client
    }
}

struct Settings: Codable {
    var apiKey: String?
    var organization: String?
    var projectsString: String?
    var branchFilter: String?
    var userFilter: String?
    var notify: Bool = true

    static func load(userDefaults: UserDefaults = UserDefaults.standard) -> Settings {
        var settings = Settings.init()
        if let settingsV2 = userDefaults.string(forKey: "SeaEyeSettings2") {
            let decoder = JSONDecoder.init()
            if let data = settingsV2.data(using: .utf8) {
                do {
                    settings = try decoder.decode(Settings.self, from: data)
                } catch let error{
                    print(error.localizedDescription)
                }
            }
        } else {
            settings = loadFromOldSettings(userDefaults: userDefaults)
        }
        return settings
    }

    static func loadFromOldSettings(userDefaults: UserDefaults = UserDefaults.standard) -> Settings {
        var settings = self.init()
        settings.apiKey = userDefaults.string(forKey: "SeaEyeAPIKey")
        settings.organization = userDefaults.string(forKey: "SeaEyeOrganization")
        settings.projectsString = userDefaults.string(forKey: "SeaEyeProjects")
        settings.branchFilter = userDefaults.string(forKey: "SeaEyeBranches")
        settings.userFilter = userDefaults.string(forKey: "SeaEyeUsers")
        settings.notify = userDefaults.bool(forKey: "SeaEyeNotify")
        settings.save(userDefaults: userDefaults)
        return settings
    }

    func save(userDefaults: UserDefaults) {
        let jsonEncoder = JSONEncoder()

        do {
            let jsonData = try jsonEncoder.encode(self)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            userDefaults.setValue(json, forKey: "SeaEyeSettings2")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func toNewSettings() -> NewSettings {
        let projectsArray: [String] = self.projectsString!.components(separatedBy: CharacterSet.whitespaces)
        let filter = Filter.init(userFilter: userFilter, branchFilter: branchFilter)
        let projects: [Project] = projectsArray.map { (name: String) -> Project in
            Project(name: name,
                    organisation: self.organization!,
                    filter: filter,
                    notify: self.notify,
                    vcsProvider: "github")
        }
        let client = MiniClient(apiKey: self.apiKey!,
                                url: "https://circleci.com",
                                projects: projects)

        return NewSettings(clients: [client])
    }

    func valid() -> Bool {
        return apiKey != nil && organization != nil && projectsString != nil
    }
}
