//
//  PopoverContollerBuildUpdateListener.swift
//  SeaEye
//
//  Created by Conor Mongey on 20/11/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation

class PopoverContollerBuildUpdateListener: BuildUpdateListener {
    let popoverController: SeaEyePopoverController
    var allKnownBuilds: [CircleCIBuild] = []

    init(popoverController: SeaEyePopoverController) {
        self.popoverController = popoverController
    }

    func notify(project: Project, builds: [CircleCIBuild]) {
        if builds.count > 0 {
            print("\(project) got \(builds.count) new builds")
        }

        if builds.count > 0 {
            allKnownBuilds = (builds + allKnownBuilds).sorted { $0.startTime > $1.startTime }

            print("Got \(builds.count) builds from \(project)!")
            print("Addding \(builds.count) We now have \(allKnownBuilds.count)")

            popoverController.setBuilds(allKnownBuilds)
        }
    }
}
