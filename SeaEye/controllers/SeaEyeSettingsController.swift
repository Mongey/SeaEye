//
//  SeaEyeSettingsController.swift
//  SeaEye
//
//  Created by Eoin Nolan on 26/10/2014.
//  Copyright (c) 2014 Nolaneo. All rights reserved.
//

import Cocoa

class SeaEyeSettingsController: NSViewController {
    @IBOutlet weak var runOnStartup: NSButton!
    @IBOutlet weak var showNotifications: NSButton!
    @IBOutlet weak var apiKeyField: NSTextField!
    @IBOutlet weak var organizationField: NSTextField!
    @IBOutlet weak var projectsField: NSTextField!
    @IBOutlet weak var usersField: NSTextField!
    @IBOutlet weak var branchesField: NSTextField!
    @IBOutlet weak var versionString: NSTextField!
    @IBOutlet var showSuccessBuilds: NSButton!
    @IBOutlet var ShowFailedBuilds: NSButton!
    @IBOutlet var showRunningBuilds: NSButton!
    var parentController: SeaEyePopoverController!
    var settings: Settings = Settings.load(userDefaults: UserDefaults.standard)

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?, parentController: SeaEyePopoverController) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.parentController = parentController
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVersionNumber()
        if VersionNumber.current().development{
            showSuccessBuilds.isHidden = false
            ShowFailedBuilds.isHidden = false
            showRunningBuilds.isHidden = false
        }
    }

    override func viewWillAppear() {
       setupInputFields()
    }

    @IBAction func openAPIPage(_ sender: NSButton) {
        NSWorkspace.shared.open(URL(string: "https://circleci.com/account/api")!)
        closePopover()
    }

    @IBAction func showFBuilds(_ sender: Any) {
        let builds: [CircleCIBuild] = [CircleCIBuild.init(branch: "master",
                                                          project: "foo",
                                                          status: "failed",
                                                          subject: "",
                                                          user: "homer",
                                                          buildNum: 123,
                                                          url: URL.init(string: "https://circleci.com")!,
                                                          date: Date().addingTimeInterval(TimeInterval.init().advanced(by: 1.0)))]

        var buildTracker: NotificationsForBuild = NotificationsForBuild.init()
        if let notification = buildTracker.notificationForF(allBuilds: builds){
            NotificationCenter.default.post(name: notification.name,
                                            object: nil,
                                            userInfo: notification.info)
        }
    }
    @IBAction func showSBuilds(_ sender: Any) {
        let builds: [CircleCIBuild] = [CircleCIBuild.init(branch: "master",
                                                          project: "foo",
                                                          status: "success",
                                                          subject: "",
                                                          user: "homer",
                                                          buildNum: 123,
                                                          url: URL.init(string: "https://circleci.com")!,
                                                          date: Date().addingTimeInterval(TimeInterval.init().advanced(by: 1.0)))]

        var buildTracker: NotificationsForBuild = NotificationsForBuild.init()
        if let notification = buildTracker.notificationForF(allBuilds: builds){
            NotificationCenter.default.post(name: notification.name,
                                        object: nil,
                                        userInfo: notification.info)
        }

    }

    @IBAction func showRunningBuilds(_ sender: Any) {
        let builds: [CircleCIBuild] = [CircleCIBuild.init(branch: "master",
                                                          project: "foo",
                                                          status: "running",
                                                          subject: "",
                                                          user: "homer",
                                                          buildNum: 123,
                                                          url: URL.init(string: "https://circleci.com")!,
                                                          date: Date().addingTimeInterval(TimeInterval.init().advanced(by: 1.0)))]

        var buildTracker: NotificationsForBuild = NotificationsForBuild.init()
        if let notification = buildTracker.notificationForF(allBuilds: builds){
            NotificationCenter.default.post(name: notification.name,
                                            object: nil,
                                            userInfo: notification.info)
        }

        let prefrencesWindow = PreferencesWindowController()
        if let w = prefrencesWindow.window as? PreferencesWindow {
            w.level = .floating
            w.center()
            w.makeKeyAndOrderFront(self)
            closePopover()
        }
    }

    @IBAction func saveUserData(_ sender: NSButton) {
        UserDefaults.standard.set(false, forKey: "SeaEyeError")

        settings.notify = showNotifications.state == .on
        settings.apiKey = apiKeyField.maybeStringValue()
        settings.organization = organizationField.maybeStringValue()
        settings.projectsString = projectsField.maybeStringValue()
        settings.branchFilter = branchesField.maybeStringValue()
        settings.userFilter = usersField.maybeStringValue()
        settings.save(userDefaults: UserDefaults.standard)

        NotificationCenter.default.post(name: SeaEyeNotifications.settingsChanged.notification, object: nil)
        self.dismiss(self)
        parentController.openBuilds(sender)
    }

    @IBAction func saveNotificationPreferences(_ sender: NSButton) {
        let notify = showNotifications.state == .on
        print("Notificaiton Preference: \(notify)")
        settings.notify = notify
    }

    @IBAction func saveRunOnStartupPreferences(_ sender: NSButton) {
        print("Changing launch on startup")
        ApplicationStartupManager.toggleLaunchAtStartup()
    }

    fileprivate func setupInputFields() {
        showNotifications.setState(settings.notify)
        runOnStartup.setState(ApplicationStartupManager.applicationIsInStartUpItems())
        apiKeyField.maybeSet(settings.apiKey)
        organizationField.maybeSet(settings.organization)
        projectsField.maybeSet(settings.projectsString)
        branchesField.maybeSet(settings.branchFilter)
        usersField.maybeSet(settings.userFilter)
    }

    fileprivate func setupVersionNumber() {
        versionString.stringValue = VersionNumber.current().description
    }
}
