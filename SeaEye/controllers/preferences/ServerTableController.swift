import Cocoa
import Foundation

class ServerTableController: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "serverCell")
    var selectedIndex: Int = 0
    var clients: [MiniClient]
    var view: SelectedServerView
    var tableView: NSTableView

    init(tableView: NSTableView, clients: [MiniClient], view: SelectedServerView) {
        self.clients = clients
        self.view = view
        self.tableView = tableView
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
        selectFirstClient()
    }

    func testServer() {
        if let mclient = selectedClient() {
            let client = mclient.client()
            client.getMe { response in
                let alert = NSAlert()
                alert.addButton(withTitle: "OK")
                switch response {
                case let .success(user):
                    alert.messageText = "This API server seems OK!"
                    alert.informativeText = "\(user.name)"

                case let .failure(err):
                    alert.messageText = "The test failed for \(mclient.url)"
                    alert.informativeText = err.localizedDescription
                }

                alert.runModal()
            }
        }
    }

    func selectedClient() -> MiniClient? {
        reloadFromSettings()
        if clients.count > 0 && selectedIndex < clients.count {
            return clients[self.selectedIndex]
        }
        return nil
    }

    func selectFirstClient() {
        tableView.selectRowIndexes([0], byExtendingSelection: false)

        if let mclient = selectedClient() {
            if clients.count > 0 {
                view.fill(client: mclient)
            }
        }
    }

    func reloadFromSettings() {
        clients = Settings.load().clients
        tableView.reloadData()
    }

    func tableView(_ tableView: NSTableView, viewFor _: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = clients[row].url
            return cell
        }
        return nil
    }

    func tableView(_: NSTableView, shouldSelectRow row: Int) -> Bool {
        print("\(row) was \(clients[row])")
        view.fill(client: clients[row])
        return true
    }

    func numberOfRows(in _: NSTableView) -> Int {
        return clients.count
    }
}
