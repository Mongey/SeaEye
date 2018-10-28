import Cocoa
import Foundation

struct SelectedServerView {
    var apiServerApiPath: NSTextField!
    var apiServerAuthToken: NSTextField!
    var apiServerTestButton: NSButton!

    func fill(client: MiniClient) {
        apiServerApiPath.stringValue = client.url
        apiServerAuthToken.stringValue = client.apiKey
        apiServerTestButton.isEnabled = !client.apiKey.isEmpty
    }
}

protocol ProjectFollowedDelegate {
    func addProject(project: Project)
}

protocol ProjectUnfollowedDelegate {
    func removeProject(projectIndex: Int)
}

protocol ProjectUpdatedDelegate {
    func projectUpdated(projectIndex: Int, project: Project)
}

// This is a kind-of-controller, that is used to
class PreferencesWindow: NSWindow, NSTabViewDelegate, ProjectFollowedDelegate, ProjectUnfollowedDelegate, ProjectUpdatedDelegate {
    // Preferences window
    @IBOutlet var projectsTable: NSTableView!
    @IBOutlet var versionNumber: NSTextField!
    @IBOutlet var launchAtStartup: NSButton!
    @IBOutlet var knownProjectsTable: NSTableView!

    var serverListView: ServerTableController?
    var currentProjectsView: CurrentProjectsController!
    var unfollowedProjectsTableView: UnfollowedProjectsController?

    // Servers
    @IBOutlet var serverList: NSTableView!
    @IBOutlet var apiServerApiPath: NSTextField!
    @IBOutlet var apiServerAuthToken: NSTextField!
    @IBOutlet var apiServerTestButton: NSButton!
    @IBOutlet var apiServerDeleteButton: NSButton!

    var settings = Settings.load()

    @IBAction func toggleStartup(_ sender: Any) {
        print("Toggle Startup \(sender)")
        if let button = sender as? NSButton {
            print(button.state)
        }
    }
    
    override func awakeFromNib() {
        versionNumber.stringValue = VersionNumber.current().description
        let selectedServerView = SelectedServerView(apiServerApiPath: apiServerApiPath,
                                                    apiServerAuthToken: apiServerAuthToken,
                                                    apiServerTestButton: apiServerTestButton)

        serverListView = ServerTableController(tableView: serverList!,
                                               clients: settings.clients,
                                               view: selectedServerView)
        super.awakeFromNib()
    }

    func addProject(project: Project) {
        if let client = self.serverListView?.selectedClient() {
            print("Add \(project) to \(client)")

            if let index = self.serverListView?.selectedIndex {
                settings.clients[index].projects.append(project)
                settings.save()
                currentProjectsView.set(projects: settings.clients[index].projects)
                serverListView?.reloadFromSettings()
            }
        }
    }

    func removeProject(projectIndex: Int) {
        if var client = self.serverListView?.selectedClient() {
            print("Remove \(client.projects[projectIndex]) to \(client)")

            if let index = self.serverListView?.selectedIndex {
                settings.clients[index].projects.remove(at: projectIndex)
                settings.save()
                serverListView?.reloadFromSettings()
                currentProjectsView.set(projects: settings.clients[index].projects)
            }
        }
    }

    func projectUpdated(projectIndex: Int, project: Project) {
        if var client = self.serverListView?.selectedClient() {
            print("Update \(client.projects[projectIndex]) to \n \(project)")

            if let index = self.serverListView?.selectedIndex {
                settings.clients[index].projects[projectIndex] = project
                settings.save()
                currentProjectsView.set(projects: settings.clients[index].projects)
            }

        } else {}
    }

    func tabView(_: NSTabView, willSelect: NSTabViewItem?) {
        if let item = willSelect {
            if item.label == "Projects" {
                if let client = self.serverListView?.selectedClient() {
                    currentProjectsView = CurrentProjectsController(tableView: projectsTable,
                                                                    projects: client.projects,
                                                                    delegate: self,
                                                                    pUdelegate: self)

                    unfollowedProjectsTableView = UnfollowedProjectsController(tableView: knownProjectsTable,
                                                                               client: client,
                                                                               delegate: self)

                } else {
                    print("There's no clients  .... you can't select projects")
                }
                unfollowedProjectsTableView?.reload()
            }
        }
    }

    @IBAction func testApiServerSelected(_: NSButton) {
        print("test the api server")
        serverListView?.testServer()
    }

    @IBAction func addNewApiServerSelected(_: NSButton) {
        var url = ""
        var apiKey = ""

        if let urlV = apiServerApiPath.maybeStringValue() {
            url = urlV
        }

        if let apiKeyV = apiServerAuthToken.maybeStringValue() {
            apiKey = apiKeyV
        }
        let client = MiniClient(apiKey: apiKey,
                                url: url,
                                projects: [])

        print("Actually adding now")
        serverListView?.clients.append(client)
        settings.clients.append(client)
        settings.save(userDefaults: UserDefaults.standard)
        serverList.reloadData()
    }

    @IBAction func deleteButtonPressed(_: Any) {
//        print("Delete this server \(selectedClient)")
        let selected = serverList.selectedRow
        if selected >= 0 {
            settings.clients.remove(at: selected)
            settings.save()
            serverListView?.reloadFromSettings()
        }
    }
}
