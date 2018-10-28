//
//  UnfollowedProjectsController.swift
//  SeaEye
//
//  Created by Conor Mongey on 05/11/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Cocoa
import Foundation

class UnfollowedProjectsController: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    private let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "AddProjectName")

    private var client: MiniClient
    private var projects: [Project]
    private let tableView: NSTableView
    private let delegate: ProjectFollowedDelegate

    init(tableView: NSTableView, client: MiniClient, delegate: ProjectFollowedDelegate) {
        self.client = client
        projects = []
        self.delegate = delegate
        self.tableView = tableView
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
        reload()
    }

    func reload() {
        client.client().getProjects { response in
            switch response {
            case let .success(cip):
                self.projects = cip.map({ $0.toProject() })
                self.tableView.reloadData()
            case let .failure(err):
                print(err.localizedDescription)
            }
        }
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            if tableColumn == tableView.tableColumns[0] {
                if row < projects.count {
                    cell.textField?.stringValue = projects[row].description
                    cell.textField?.tag = row
                }
            }

            if tableColumn == tableView.tableColumns[1] {
                let button = NSButton(title: "Add project", target: self, action: #selector(addAProject))
                button.tag = row
                return button
            }
            return cell
        }

        return nil
    }

    func numberOfRows(in _: NSTableView) -> Int {
        return projects.count
    }

    @objc func addAProject(_ sender: NSButton) {
        let project = projects[sender.tag]
        delegate.addProject(project: project)
    }
}
