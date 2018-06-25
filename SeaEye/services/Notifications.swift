//
//  Notifications.swift
//  SeaEye
//
//  Created by Conor Mongey on 16/06/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Cocoa
import Foundation

enum SeaEyeNotifications: String {
    case closePopoverController = "SeaEyeClosePopoverController"
    case updatedBuilds = "SeaEyeUpdatedBuilds"
    case alert = "SeaEyeAlert"
    case redBuild = "SeaEyeRedBuild"
    case greenBuild = "SeaEyeGreenBuild"
    case yellowBuild = "SeaEyeYellowBuild"
    case settingsChanged = "SeaEyeSettingsChanged"
    
    var notification : Notification.Name  {
        return Notification.Name(rawValue: self.rawValue )
    }
}

func userNotification(_ userInfo: [String: Any]) -> NSUserNotification {
    let notification = NSUserNotification()
    notification.title = "SeaEye"
    if let message = userInfo["message"] as? String {
        notification.informativeText = message
    }
    if let url = userInfo["url"] as? String {
        notification.setValue(true, forKey: "_showsButtons")
        notification.hasActionButton = true
        notification.actionButtonTitle = "Download"
        notification.userInfo = ["url": url]
    }
    return notification
}

func notifcationForBuild(build: CircleCIBuild) -> NSUserNotification {
    let notification = NSUserNotification()
    notification.setValue(false, forKey: "_identityImageHasBorder")
    notification.setValue(nil, forKey: "_imageURL")
    notification.userInfo = ["url": build.buildUrl.absoluteString]
    return notification
}

func buildNotification(build: CircleCIBuild, count: Int) -> NSUserNotification {
    let notification = notifcationForBuild(build: build)
    let endTitle = build.status == "success" ? "Sucess" : "Failed"
    let plural = build.status == "success" ?  "successful" : "failed"
    let imageFile = build.status == "success" ? "build-passed" : "build-failed"

    notification.title = "SeaEye: Build \(endTitle)"
    if count > 1 {
        notification.subtitle = "You have \(count) \(plural) builds"
    } else {
        notification.subtitle = build.subject
        notification.informativeText = build.authorName
    }

    let image = NSImage(named: NSImage.Name(rawValue: imageFile))
    notification.setValue(image, forKey: "_identityImage")
    return notification
}

func closePopover() {
    NotificationCenter.default.post(name: SeaEyeNotifications.closePopoverController.notification,
                                    object: nil)
}
