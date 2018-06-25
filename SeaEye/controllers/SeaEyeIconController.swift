//
//  SeaEyeIconController.swift
//  SeaEye
//
//  Created by Eoin Nolan on 25/10/2014.
//  Copyright (c) 2014 Nolaneo. All rights reserved.
//

import Cocoa

class SeaEyeIconController: NSViewController {
    @IBOutlet var iconButton: NSButton!

    var model = CircleCIModel()
    var popover = NSPopover()
    var popoverController: SeaEyePopoverController?

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
        self.resetIcon()
        if let popoverController = SeaEyePopoverController(nibName: NSNib.Name(rawValue: "SeaEyePopoverController"), bundle: nil) as SeaEyePopoverController? {
            popoverController.model = self.model
            self.popoverController = popoverController
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: SeaEyeNotifications.alert.notification,
                                       object: nil,
                                       queue: OperationQueue.main,
                                       using: alert)
        notificationCenter.addObserver(forName: SeaEyeNotifications.redBuild.notification,
                                       object: nil,
                                       queue: OperationQueue.main,
                                       using: setRedBuildIcon)
        notificationCenter.addObserver(forName: SeaEyeNotifications.greenBuild.notification,
                                       object: nil,
                                       queue: OperationQueue.main,
                                       using: setGreenBuildIcon)
        notificationCenter.addObserver(forName: SeaEyeNotifications.yellowBuild.notification,
                                       object: nil,
                                       queue: OperationQueue.main,
                                       using: setYellowBuildIcon)
        notificationCenter.addObserver(forName: SeaEyeNotifications.closePopoverController.notification,
                                       object: nil,
                                       queue: OperationQueue.main,
                                       using: closePopover)

        NSEvent.addGlobalMonitorForEvents(
            matching: [.leftMouseUp, .rightMouseUp],
            handler: closePopover
        )
    }

    func alert(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let foo = userInfo as? [String: Any]{
                NSUserNotificationCenter.default.deliver(userNotification(foo))
            }
        }
    }

    func setGreenBuildIcon(notification: Notification) {
        if let userNotification = imageUserNotification(image: "circleci-success", notification: notification) {
            NSUserNotificationCenter.default.deliver(userNotification)
        }
    }

    func setRedBuildIcon(notification: Notification) {
        if let userNotification = imageUserNotification(image: "circleci-failed", notification: notification) {
            NSUserNotificationCenter.default.deliver(userNotification)
        }
    }

    func imageUserNotification(image: String, notification: Notification) -> NSUserNotification? {
        iconButton.image = NSImage(named: NSImage.Name(rawValue: image))

        if UserDefaults.standard.bool(forKey: "SeaEyeNotify") {
            if let build = notification.userInfo!["build"] as? CircleCIBuild{
                if let count = notification.userInfo!["count"] as? Int {
                    return buildNotification(build: build, count: count)
                }
            }
        }
        return nil
    }

    func setYellowBuildIcon(notification: Notification) -> Void {
        let imageFile = "circleci-pending"
        iconButton.image = NSImage(named: NSImage.Name(rawValue: imageFile))
    }

    func notifcationForBuild(build: CircleCIBuild) -> NSUserNotification {
        let notification = NSUserNotification()
        notification.setValue(false, forKey: "_identityImageHasBorder")
        notification.setValue(nil, forKey: "_imageURL")
        notification.userInfo = ["url": build.buildUrl.absoluteString]
        return notification
    }

    private func resetIcon() {
        iconButton.image = NSImage(named: NSImage.Name(rawValue: "circleci"))
    }

    @IBAction func openPopover(_ sender: NSButton) {
        if popover.isShown {
            popover.close()
        } else {
            resetIcon()
            popover.contentViewController = popoverController
            popover.show(relativeTo: self.view.frame, of: self.view, preferredEdge: NSRectEdge.minY)
        }
    }

    func closePopover(_ aEvent: Any? = nil) {
        if popover.isShown {
            popover.close()
        }
    }
}
