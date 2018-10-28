//
//  AppDelegate.swift
//  SeaEye
//
//  Created by Eoin Nolan on 25/10/2014.
//  Copyright (c) 2014 Nolaneo. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    var statusBarItem: NSStatusItem = NSStatusItem()
    var statusBarIconViewController: SeaEyeIconController!

    func applicationDidFinishLaunching(_: Notification) {
        NSUserNotificationCenter.default.delegate = self

        let args = ProcessInfo.processInfo.arguments
        let resetArgs = args.filter({ $0 == "resetDefaults" }).count == 1
        if resetArgs {
            let defaults = UserDefaults.standard
            defaults.dictionaryRepresentation().keys.forEach(defaults.removeObject(forKey:))
        }

        initialSetup()
        statusBarItem = NSStatusBar.system.statusItem(withLength: -1)
        setupApplicationMenuViewController()
    }

    func setupApplicationMenuViewController() {
        statusBarIconViewController = SeaEyeIconController(nibName: "SeaEyeIconController", bundle: nil)
        statusBarItem.view = statusBarIconViewController.view
    }

    // MARK: - NSUserNotificationCenterDelegate

    func userNotificationCenter(_: NSUserNotificationCenter, shouldPresent _: NSUserNotification) -> Bool {
        return true
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        let userInfo = notification.userInfo

        if let url = userInfo!["url"] as? String {
            NSWorkspace.shared.open(URL(string: url)!)
        }
        center.removeDeliveredNotification(notification)
    }

    fileprivate func initialSetup() {
        // TODO: - Store this in the new Settings
        let userDefaults = UserDefaults.standard
        let firstSetupKey = "SeaEyePerformedFirstSetup"
        if userDefaults.bool(forKey: firstSetupKey) == false {
            userDefaults.set(true, forKey: "SeaEyeNotify")
            userDefaults.set(true, forKey: firstSetupKey)
            ApplicationStartupManager.toggleLaunchAtStartup()
        }
    }
}
