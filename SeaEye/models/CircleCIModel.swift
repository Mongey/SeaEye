//
//  CircleCIModel.swift
//  SeaEye
//
//  Created by Eoin Nolan on 27/10/2014.
//  Copyright (c) 2014 Nolaneo. All rights reserved.
//

import Cocoa

class CircleCIModel: NSObject {
    var hasValidUserSettings = false
    var allProjects: [OldProject] = []
    var allBuilds: [CircleCIBuild] = []
    var lastNotificationDate: Date = Date()
    var updatesTimer: Timer!
    var buildTracker: NotificationsForBuild = NotificationsForBuild.init()
    let settings: Settings = Settings.load()

    override init() {
        super.init()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(CircleCIModel.validateUserSettingsAndStartRequests),
            name: SeaEyeNotifications.settingsChanged.notification,
            object: nil
        )

        self.validateUserSettingsAndStartRequests()
    }

    func runModelUpdates() {
        objc_sync_enter(self)
        //Debounce the calls to this function
        if updatesTimer != nil {
            updatesTimer.invalidate()
            updatesTimer = nil
        }
        updatesTimer = Timer.scheduledTimer(
            timeInterval: TimeInterval(3),
            target: self,
            selector: #selector(CircleCIModel.updateBuilds),
            userInfo: nil,
            repeats: false
        )
        objc_sync_exit(self)
    }

    @objc func updateBuilds() {
        autoreleasepool {
            print("Updating builds!")
            var builds: [CircleCIBuild] = []
            for project in self.allProjects {
                builds += project.projectBuilds
            }
            self.allBuilds = builds.sorted {$0.startTime.timeIntervalSince1970 > $1.startTime.timeIntervalSince1970}
            self.calculateBuildStatus()

            NotificationCenter.default.post(name: SeaEyeNotifications.updatedBuilds.notification, object: nil)
        }
    }

    func calculateBuildStatus() {
        if let notification = buildTracker.notificationForF(allBuilds: self.allBuilds) {
            NotificationCenter.default.post(name: notification.name,
                                            object: nil,
                                            userInfo: notification.info)
        }
    }

    @objc func validateUserSettingsAndStartRequests() {
        if settings.valid() {
            allBuilds = []
            NotificationCenter.default.post(name: SeaEyeNotifications.updatedBuilds.notification, object: nil)

            allProjects = FollowedProjectsFromSettings.init(apiKey: settings.apiKey!,
                                                            organization: settings.organization!,
                                                            projects: settings.projectsString!,
                                                            branchFilter: settings.branchFilter,
                                                            userFilter: settings.userFilter).call(parent: self)
            resetAPIRequests()
        } else {
            stopAPIRequests()
        }
    }

    fileprivate func resetAPIRequests() {
        self.stopAPIRequests()
        self.startAPIRequests()
    }

    fileprivate func startAPIRequests() {
        for project in allProjects {
            project.reset()
        }
    }

    fileprivate func stopAPIRequests() {
        if updatesTimer != nil {
            updatesTimer.invalidate()
            updatesTimer = nil
        }
        for project in allProjects {
            project.stop()
        }
    }
}
