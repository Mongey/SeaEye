//
//  SeaEyeIconController.swift
//  SeaEye
//
//  Created by Eoin Nolan on 25/10/2014.
//  Copyright (c) 2014 Nolaneo. All rights reserved.
//

import Cocoa

class SeaEyeIconController: NSViewController {

    @IBOutlet weak var iconButton : NSButton!
    var model = CircleCIModel()
    var applicationStatus = SeaEyeStatus()
    var hasViewedBuilds = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMenuBarIcon()
        self.setupStyleNotificationObserver()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("alert:"),
            name: "SeaEyeAlert",
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("setRedBuildIcon:"),
            name: "SeaEyeRedBuild",
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("setGreenBuildIcon:"),
            name: "SeaEyeGreenBuild",
            object: nil
        )
    }
    
    func alert(notification: NSNotification) {
        if let message = notification.userInfo!["message"] as? String {
            var notification = NSUserNotification()
            notification.title = "SeaEye"
            notification.informativeText = message
            NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
        }
    }
    
    func setGreenBuildIcon(notification: NSNotification) {
        if hasViewedBuilds {
            if (self.isDarkModeEnabled()) {
                iconButton.image = NSImage(named: "circleci-success-alt")
            } else {
                iconButton.image = NSImage(named: "circleci-success")
            }
            if NSUserDefaults.standardUserDefaults().boolForKey("SeaEyeNotify") {
                let build = notification.userInfo!["build"] as Build!
                let count = notification.userInfo!["count"] as Int!
                showSuccessfulBuildNotification(build, count: count)
            }
        }
    }
    
    func setRedBuildIcon(notification: NSNotification) {
        hasViewedBuilds = false
        if (self.isDarkModeEnabled()) {
            iconButton.image = NSImage(named: "circleci-failed-alt")
        } else {
            iconButton.image = NSImage(named: "circleci-failed")
        }
        
        if NSUserDefaults.standardUserDefaults().boolForKey("SeaEyeNotify") {
            let build = notification.userInfo!["build"] as Build!
            let count = notification.userInfo!["count"] as Int!
            showFailedBuildNotification(build, count: count)
        }
    }
    
    private func showFailedBuildNotification(build: Build, count: Int) {
        var notification = NSUserNotification()
        notification.title = "SeaEye: Build Failed"
        if count > 1 {
            notification.subtitle = "You have \(count) failed builds"
        } else {
            notification.subtitle = build.subject
            notification.informativeText = build.user
        }
        let image = NSImage(named: "build-failed")
        notification.setValue(image, forKey: "_identityImage")
        notification.setValue(false, forKey: "_identityImageHasBorder")
        notification.setValue(nil, forKey:"_imageURL")
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
    }
    
    private func showSuccessfulBuildNotification(build: Build, count: Int) {
        var notification = NSUserNotification()
        notification.title = "SeaEye: Build Passed"
        if count > 1 {
            notification.subtitle = "You have \(count) successful builds"
        } else {
            notification.subtitle = build.subject
            notification.informativeText = build.user
        }
        let image = NSImage(named: "build-passed")
        notification.setValue(image, forKey: "_identityImage")
        notification.setValue(false, forKey: "_identityImageHasBorder")
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
    }
    
    private func setupMenuBarIcon() {
        hasViewedBuilds = true
        if (self.isDarkModeEnabled()) {
            iconButton.image = NSImage(named: "circleci-normal-alt")
        } else {
            iconButton.image = NSImage(named: "circleci-normal")
        }
    }
    
    private func setupStyleNotificationObserver() {
        NSDistributedNotificationCenter.defaultCenter()
            .addObserver(
                self,
                selector: Selector("alternateIconStyle"),
                name: "AppleInterfaceThemeChangedNotification",
                object: nil
        )
    }
    
    private func isDarkModeEnabled() -> Bool {
        let dictionary  = NSUserDefaults.standardUserDefaults().persistentDomainForName(NSGlobalDomain);
        if let interfaceStyle = dictionary?["AppleInterfaceStyle"] as? NSString {
            return interfaceStyle.localizedCaseInsensitiveContainsString("dark")
        } else {
            return false
        }
    }
    
    func alternateIconStyle() {
        var currentImage = iconButton.image
        if let imageName = currentImage?.name() {
            var alternateImageName : NSString
            if imageName.hasSuffix("-alt") {
                alternateImageName = imageName.stringByReplacingOccurrencesOfString(
                    "-alt",
                    withString: "",
                    options: nil,
                    range: nil
                )
            } else {
                alternateImageName = imageName.stringByAppendingString("-alt")
            }
            iconButton.image = NSImage(named: alternateImageName)
        }
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "SeaEyeOpenPopoverSegue" {
            self.setupMenuBarIcon()
            let popoverContoller = segue.destinationController as SeaEyePopoverController
            popoverContoller.model = self.model
        }
    }
}
