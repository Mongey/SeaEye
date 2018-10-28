//
//  SeaEyePopoverController.swift
//  SeaEye
//
//  Created by Eoin Nolan on 25/10/2014.
//  Copyright (c) 2014 Nolaneo. All rights reserved.
//

import Cocoa

class SeaEyePopoverController: NSViewController {
    static let NibName = "SeaEyePopoverController"
    @IBOutlet var subcontrollerView: NSView!
    @IBOutlet var openSettingsButton: NSButton!
    @IBOutlet var openBuildsButton: NSButton!
    @IBOutlet var openUpdatesButton: VersionButton!
    @IBOutlet var shutdownButton: NSButton!

    var buildsViewController: SeaEyeBuildsController!
    var updatesViewController: SeaEyeUpdatesController!

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupNibControllers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setup()
    }

    private func setup() {
        checkForUpdateAndNotify()
    }

    func setBuilds(_ builds: [CircleCIBuild]) {
        buildsViewController?.builds = builds.sorted { $0.startTime.timeIntervalSince1970 > $1.startTime.timeIntervalSince1970 }
        buildsViewController?.reloadBuilds()
        if buildsViewController == nil {
            print("There's no build contoller")
        }
    }

    fileprivate func setupViewControllers() {
        openBuildsButton.isHidden = true
        subcontrollerView.addSubview(buildsViewController.view)
    }

    fileprivate func setupNibControllers() {
        buildsViewController = SeaEyeBuildsController(nibName: "SeaEyeBuildsController",
                                                      bundle: nil)
        updatesViewController = SeaEyeUpdatesController(nibName: "SeaEyeUpdatesController",
                                                        bundle: nil)
    }

    @IBAction func openSettings(_: NSButton) {
        let prefrencesWindowVC = PreferencesWindowController()
        prefrencesWindowVC.showWindow(self)
    }

    @IBAction func openBuilds(_: NSButton) {
        checkForUpdateAndNotify()
        openBuildsButton.isHidden = true
        shutdownButton.isHidden = false
        openSettingsButton.isHidden = false
        updatesViewController.view.removeFromSuperview()
        subcontrollerView.addSubview(buildsViewController.view)
    }

    @IBAction func openUpdates(_: NSButton) {
        openUpdatesButton.isHidden = true
        openSettingsButton.isHidden = true
        shutdownButton.isHidden = true
        openBuildsButton.isHidden = false
        buildsViewController.view.removeFromSuperview()
        subcontrollerView.addSubview(updatesViewController.view)
    }

    @IBAction func shutdownApplication(_: NSButton) {
        NSApplication.shared.terminate(self)
    }

    fileprivate func checkForUpdateAndNotify() {
        GithubClient.latestRelease { result in
            switch result {
            case let .success(latestRelease):
                self.newVersionOfSeaEye(latestRelease)
            case .failure:
                print("Failed to get version")
            }
        }
    }

    private func newVersionOfSeaEye(_ latestRelease: GithubRelease) {
        let updateAvailable = VersionNumber.current() < latestRelease.version()
        print("Update: \(updateAvailable). Current \(VersionNumber.current()) |  \(latestRelease.version())")

        if updateAvailable {
            openUpdatesButton.version = latestRelease.version().description
            updatesViewController.version = latestRelease.toSeaEye()
            let notification = downloadAvailableNotification(url: latestRelease.htmlUrl, version: latestRelease.version().description)
            NSUserNotificationCenter.default.deliver(notification)
        }
    }
}
