//
//  SeaEyeBuildsController.swift
//  SeaEye
//
//  Created by Eoin Nolan on 26/10/2014.
//  Copyright (c) 2014 Nolaneo. All rights reserved.
//

import Cocoa

class SeaEyeBuildsController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    var builds: [CircleCIBuild] = []

    @IBOutlet var fallbackView: NSTextField!
    @IBOutlet var buildsTable: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFallBackViews()
        showBuildsOrFallbackString()
    }

    override func viewDidAppear() {
        showBuildsOrFallbackString()
    }

    func reloadBuilds(_: Any? = nil) {
        print("Reload builds!")
        buildsTable?.reloadData()
        if fallbackView != nil {
            setupFallBackViews()
            showBuildsOrFallbackString()
        }
    }

    private func setupFallBackViews() {
        if let fallbackString = fallbackString() {
            fallbackView.stringValue = fallbackString
        }
    }

    private func showBuildsOrFallbackString() {
        if fallbackString() != nil {
            showFallbackView()
        } else {
            showBuildsView()
        }
    }

    private func fallbackString() -> String? {
        return FallbackView(settings: Settings.load(), builds: builds).description()
    }

    private func showBuildsView() {
        fallbackView.isHidden = true
        buildsTable.isHidden = false
    }

    private func showFallbackView() {
        fallbackView.isHidden = false
        buildsTable.isHidden = true
    }

    // MARK: - NSTableViewDataSource

    func numberOfRows(in _: NSTableView) -> Int {
        return builds.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cellView = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? BuildTableCellView {
            cellView.setupForBuild(build: builds[row])
            return cellView
        }
        return nil
    }

    func selectionShouldChange(in _: NSTableView) -> Bool {
        return false
    }
}
