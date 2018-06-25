//
//  NotificationsForBuilds.swift
//  SeaEye
//
//  Created by Conor Mongey on 15/06/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation

struct MiniNotification {
    var name: Notification.Name
    var info: [String: Any]
}

struct NotificationsForBuild {
    var lastNotificationDate: Date

    init(date: Date = Date()) {
        self.lastNotificationDate = date
    }

    mutating func notificationForF(allBuilds: [CircleCIBuild]) -> MiniNotification? {
        var failures = 0
        var successes = 0
        var runningBuilds = 0
        var failedBuild: CircleCIBuild?
        var successfulBuild: CircleCIBuild?

        for build in allBuilds {
            if build.startTime.timeIntervalSince1970 > lastNotificationDate.timeIntervalSince1970 {
                switch build.status {
                case "failed": failures += 1; failedBuild = build
                case "timedout": failures += 1; failedBuild = build
                case "success": successes += 1; successfulBuild = build
                case "fixed": successes += 1; successfulBuild = build
                case "running": runningBuilds += 1
                default: break
                }
            }
        }
        var notification: MiniNotification?
        if failures > 0 {
            print("Has red build \(String(describing: failedBuild!.subject))")
            let info = ["build": failedBuild!, "count": failures] as [String: Any]
            notification = MiniNotification.init(name: SeaEyeNotifications.redBuild.notification, info: info)
        } else if successes > 0 {
            print("Has multiple successes")
            let info = ["build": successfulBuild!, "count": successes] as [String: Any]
            notification = MiniNotification.init(name: SeaEyeNotifications.greenBuild.notification, info: info)
        } else if runningBuilds > 0 {
            print("Has running builds")
            let info = ["build": nil, "count": runningBuilds] as [String : Any]
            notification = MiniNotification.init(name: SeaEyeNotifications.yellowBuild.notification, info: info)
        }

        self.lastNotificationDate = Date()
        return notification
    }
}
