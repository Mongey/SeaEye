import Cocoa
import Foundation

class PreferencesWindow : NSWindow, NSWindowDelegate, NSTableViewDelegate, NSTableViewDataSource, NSTabViewDelegate {
	private var serversDirty = false
    var knownProjects: [CircleCIProject] = []

    func reset() {
		projectsTable.reloadData()
        knownProjectsTable.reloadData()
	}
    @objc func addproject() {
        print("Should add a project now")
    }

	// Preferences window
	@IBOutlet weak var projectsTable: NSTableView!
	@IBOutlet weak var versionNumber: NSTextField!
	@IBOutlet weak var launchAtStartup: NSButton!

	@IBOutlet weak var checkForUpdatesAutomatically: NSButton!
	@IBOutlet weak var checkForUpdatesLabel: NSTextField!
	@IBOutlet weak var checkForUpdatesSelector: NSStepper!
	@IBOutlet weak var logActivityToConsole: NSButton!

    @IBOutlet var knownProjectsTable: NSTableView!
    
    // Servers
	@IBOutlet weak var serverList: NSTableView!
	@IBOutlet weak var apiServerApiPath: NSTextField!
	@IBOutlet weak var apiServerAuthToken: NSTextField!
	@IBOutlet weak var apiServerSelectedBox: NSBox!
	@IBOutlet weak var apiServerTestButton: NSButton!
	@IBOutlet weak var apiServerDeleteButton: NSButton!

	// Misc
	@IBOutlet weak var repeatLastExportAutomatically: NSButton!
	@IBOutlet weak var lastExportReport: NSTextField!
	@IBOutlet weak var dumpApiResponsesToConsole: NSButton!
	@IBOutlet weak var defaultOpenApp: NSTextField!
	@IBOutlet weak var defaultOpenLinks: NSTextField!

    // Tabs
	@IBOutlet weak var tabs: NSTabView!

    @IBAction func testApiServerSelected(_ sender: NSButton) {
        sender.isEnabled = false
        let apiServer = selectedClient!
        let client = apiServer.client()

        client.getMe { (r) in
            let alert = NSAlert()
            alert.addButton(withTitle: "OK")
            switch r {
            case .success(let user):
                alert.messageText = "This API server seems OK!"
                alert.informativeText = "\(user.name)"

            case .failure(let err):
                alert.messageText = "The test failed for \(apiServer.url)"
                alert.informativeText = err.localizedDescription

            }
            alert.runModal()
        }
    }

    @IBAction func addNewApiServerSelected(_ sender: NSButton) {
        let a = MiniClient.init(apiKey: "",
                                url: "https://circleci.com",
                                projects: [])

        //        Settings.load().toNewSettings().clients.append(a)
        serverList.reloadData()
        let index = Settings.load().toNewSettings().clients.endIndex
        serverList.selectRowIndexes(IndexSet(integer: index), byExtendingSelection: false)
        fillServerApiFormFromSelectedServer()
    }

	override func awakeFromNib() {
		super.awakeFromNib()
		delegate = self
        self.versionNumber.stringValue = VersionNumber.current().description
        projectsTable.delegate = self
        serverList.delegate = self
	}

    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView === serverList {
            return Settings.load().toNewSettings().clients.count
        } else if tableView == projectsTable {
            return totalProjects()
        } else if tableView == knownProjectsTable {
            return knownProjects.count
        }
        return 0
    }


    func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
        return false
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return nil
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = "unknown"

        if tableView === serverList {
            print("Hello servers")
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "serverCell"), owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = "https://circleci.com"
                return cell
            } else {
                print("Not a NSTableVCellView")
            }
            
        }
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "projectCell"), owner: nil) as?NSTableCellView {
//            print("\(row) -> \(followedProjects().count) \(tableColumn)")
            if let p = Project(atRow: row) {
                if (tableColumn == tableView.tableColumns[0]){
                    text = p.description()
                }
                if (tableColumn == tableView.tableColumns[1]){
                    text = p.filter?.branchFilter ?? "*"
                }
                if (tableColumn == tableView.tableColumns[2]){
                    text = p.filter?.userFilter ?? "*"
                }
                if (tableColumn == tableView.tableColumns[3]){
                    let button = NSButton.init(checkboxWithTitle: "", target: self, action: #selector(addproject))
                    button.setState(p.notify)
                    return button
                }
            }

            cell.textField?.stringValue = text
            return cell
        }

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AddProjectName"), owner: nil) as? NSTableCellView {
            if(tableColumn == tableView.tableColumns[0]) {
                let button = NSButton.init(title: "Add project", target: nil, action: nil)
                return button
            }
            if (tableColumn == tableView.tableColumns[1]){
                if row < knownProjects.count {
                    let p = knownProjects[row]
                    text = p.description()
                }
            cell.textField?.stringValue = text
            }
            return cell
        }


        return nil
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        if let o = notification.object as? NSTableView {
            if serverList === o {
                fillServerApiFormFromSelectedServer()
            }
        }
    }

    private func fillServerApiFormFromSelectedServer() {
        if let client = selectedClient {
            apiServerApiPath.stringValue = client.url
            apiServerAuthToken.stringValue = client.apiKey
            apiServerTestButton.isEnabled = !client.apiKey.isEmpty
        }
    }

    private var selectedClient: MiniClient? {
        let selected = serverList.selectedRow
        if selected >= 0 {
            return Settings.load().toNewSettings().clients[selected]
        }
        return nil
    }

    func followedProjects() -> [Project] {
        let settings = Settings.load().toNewSettings()
        return settings.clients.flatMap { (mc) -> [Project] in
            return mc.projects
        }
    }

    func Project(atRow: Int) -> Project? {
        let p = followedProjects()
        if atRow < p.count {
            return p[atRow]
        }
        return nil
    }

    func totalProjects() -> Int {
        let settings = Settings.load().toNewSettings()
        return settings.clients.map { (mc) -> Int in
            return mc.projects.count
            }.reduce(0) { (acc, c) -> Int in
                acc + c
        }
    }
}
