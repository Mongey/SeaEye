//
//  SeaEyeUpdatesController.swift
//  SeaEye
//
//  Created by Eoin Nolan on 17/11/2014.
//  Copyright (c) 2014 Nolaneo. All rights reserved.
//

import Cocoa

class SeaEyeUpdatesController: NSViewController {
    var version: ReleaseDescription!

    @IBOutlet var versionLabel: NSTextField!
    @IBOutlet var changes: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        if version == nil {
            return
        }

        changes.stringValue = version.changes
        versionLabel.stringValue = "Version \(version.latestVersion) Available"
    }

    @IBAction func openUpdatesPage(_: NSButton) {
        if version == nil {
            return
        }

        NSWorkspace.shared.open(version.downloadUrl)
    }
}
