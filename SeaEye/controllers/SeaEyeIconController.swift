//
//  SeaEyeIconController.swift
//  SeaEye
//
//  Created by Eoin Nolan on 25/10/2014.
//  Copyright (c) 2014 Nolaneo. All rights reserved.
//

import Cocoa

class SeaEyeIconController: NSViewController {
    @IBOutlet var iconButton: SeaEyeIcon!
    let secondsToRefreshBuilds = 60

    var popover = NSPopover()
    var settings = Settings.load()
    var buildUpdateListeners: NSMutableArray = NSMutableArray()
    var buildUpdate: NSMutableArray = NSMutableArray()
    var timers: [Timer] = []

    var popoverController: SeaEyePopoverController!

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        popover.behavior = NSPopover.Behavior.transient
        popover.setAccessibilityIdentifier("popoverController")

        if let popoverController = SeaEyePopoverController(nibName: SeaEyePopoverController.NibName, bundle: nil) as SeaEyePopoverController? {
            self.popoverController = popoverController
            popover.contentViewController = popoverController
        }

        loadApplicationFromSettings()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadApplicationFromSettings()
    }

    // gets all the clients, gets builds every 30 seconds, updating the popoverController
    private func loadApplicationFromSettings() {
        resetStuff()

        let popoverControllerBuildListener = PopoverContollerBuildUpdateListener(popoverController: popoverController)
        let buildNotificationListener = NotificationListener()
        let iconListener = SeaEyeIconUpdateListener(iconButton)
        let clientBuildUpdateListeners = clientBuildUpdateListenersFromSettings(listeners: [buildNotificationListener, popoverControllerBuildListener, iconListener])

        for cbul in clientBuildUpdateListeners {
            cbul.getBuilds()
        }

        timers = clientBuildUpdateListeners.map { (cbul) -> Timer in
            return Timer.scheduledTimer(
                timeInterval: TimeInterval(secondsToRefreshBuilds),
                target: cbul,
                selector: #selector(cbul.getBuilds),
                userInfo: nil,
                repeats: true
            )
        }
    }

    private func clientBuildUpdateListenersFromSettings(listeners: [BuildUpdateListener]) -> [ClientBuildUpdater] {
        let clients = Settings.load().clients
        return clients.flatMap { (client) -> [ClientBuildUpdater] in
            client.projects.map({
                ClientBuildUpdater(listeners: listeners,
                                   client: client.client(),
                                   project: $0)
            })
        }
    }

    private func resetStuff() {
        resetTimers()
        buildUpdate.removeAllObjects()
        buildUpdateListeners.removeAllObjects()
    }

    private func resetTimers() {
        for timer in timers { timer.invalidate() }
    }

    @IBAction func openPopover(_: NSButton) {
        iconButton.reset()
        popover.show(relativeTo: view.frame, of: view, preferredEdge: NSRectEdge.minY)
    }
}
