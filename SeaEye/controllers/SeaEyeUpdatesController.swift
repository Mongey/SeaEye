//
//  SeaEyeUpdatesController.swift
//  SeaEye
//
//  Created by Eoin Nolan on 17/11/2014.
//  Copyright (c) 2014 Nolaneo. All rights reserved.
//

import Cocoa

class SeaEyeUpdatesController: NSViewController {
    var applicationStatus: SeaEyeStatus!

    @IBOutlet weak var versionLabel: NSTextField!
    @IBOutlet weak var changes: NSTextField!

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        if applicationStatus == nil {
            return
        }

        if let version = applicationStatus.version {
            changes.stringValue = version.changes
            versionLabel.stringValue = "Version \(version.latestVersion) Available"
        }
    }

    @IBAction func openUpdatesPage(_ sender: NSButton) {
        if applicationStatus == nil {
            return
        }
        if let version = applicationStatus.version {
            NSWorkspace.shared.open(version.downloadUrl)
        }
    }
}
