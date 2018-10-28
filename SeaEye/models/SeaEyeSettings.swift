import Foundation

struct Settings: Codable {
    private static let defaultsKey: String = "SeaEyeSettings2"

    var clients: [MiniClient]

    static func load(userDefaults: UserDefaults = UserDefaults.standard) -> Settings {
        var settings = Settings(clients: [])
        if let settingsString = userDefaults.string(forKey: self.defaultsKey) {
            let decoder = JSONDecoder()
            if let data = settingsString.data(using: .utf8) {
                do {
                    settings = try decoder.decode(Settings.self, from: data)
                    return settings
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        return settings
    }

    func save(userDefaults: UserDefaults = UserDefaults.standard) {
        for client in clients {
            print("Saving \(client)")
        }

        let jsonEncoder = JSONEncoder()

        do {
            let jsonData = try jsonEncoder.encode(self)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            userDefaults.setValue(json, forKey: Settings.defaultsKey)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func numberOfProjects() -> Int {
        return clients.compactMap { $0.projects.count }.reduce(0, { $0 + $1 })
    }
}

struct OldSettings: Codable {
    enum Keys: String {
        case apiKey = "SeaEyeAPIKey"
        case organisation = "SeaEyeOrganization"
        case projects = "SeaEyeProjects"
        case branchFilter = "SeaEyeBranches"
        case userFilter = "SeaEyeUsers"
        case notify = "SeaEyeNotify"
    }

    var apiKey: String?
    var organization: String?
    var projectsString: String?
    var branchFilter: String?
    var userFilter: String?
    var notify: Bool = true

    static func loadFromOldSettings(userDefaults: UserDefaults = UserDefaults.standard) -> Settings {
        var settings = self.init()
        settings.apiKey = userDefaults.string(forKey: Keys.apiKey.rawValue)
        settings.organization = userDefaults.string(forKey: Keys.organisation.rawValue)
        settings.projectsString = userDefaults.string(forKey: Keys.projects.rawValue)
        settings.branchFilter = userDefaults.string(forKey: Keys.branchFilter.rawValue)
        settings.userFilter = userDefaults.string(forKey: Keys.userFilter.rawValue)
        settings.notify = userDefaults.bool(forKey: Keys.notify.rawValue)

        return settings.toNewSettings()
    }

    private func toNewSettings() -> Settings {
        let projectsArray: [String] = projectsString!.components(separatedBy: CharacterSet.whitespaces)
        let filter = Filter(userFilter: userFilter, branchFilter: branchFilter)
        let projects: [Project] = projectsArray.map { (name: String) -> Project in
            Project(vcsProvider: "github",
                    organisation: self.organization!,
                    name: name,
                    filter: filter,
                    notify: self.notify)
        }
        let client = MiniClient(apiKey: apiKey!,
                                url: "https://circleci.com",
                                projects: projects)

        return Settings(clients: [client])
    }

    func valid() -> Bool {
        return apiKey != nil && organization != nil && projectsString != nil
    }
}
