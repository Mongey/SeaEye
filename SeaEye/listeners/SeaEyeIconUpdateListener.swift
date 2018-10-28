//
//  SeaEyeIconUpdateListener.swift
//  SeaEye
//
//  Created by Conor Mongey on 20/11/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation

class SeaEyeIconUpdateListener: BuildUpdateListener {
    let icon: SeaEyeIcon?

    init(_ icon: SeaEyeIcon?) {
        self.icon = icon
    }

    func notify(project _: Project, builds: [CircleCIBuild]) {
        if let thing = BuildSummary.generate(builds: builds) {
            switch thing.status {
            case .running:
                print("Set the icon to yellow")
                icon?.set(SeaEyeIcon.Status.running)
                break
            case .failed:
                print("Set the icon to red")
                icon?.set(SeaEyeIcon.Status.failed)

                break
            case .success:
                print("Set the icon to green")
                icon?.set(SeaEyeIcon.Status.success)
                break
            }
        }
    }
}
