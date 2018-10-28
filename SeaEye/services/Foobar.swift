//
//  Foobar.swift
//  SeaEye
//
//  Created by Conor Mongey on 20/11/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation

struct Foobar {
    var lastUpdateForProject: Date

    mutating func notify(project: Project, builds: [CircleCIBuild]) -> [CircleCIBuild] {
        let newBuilds = builds.filter { (build) -> Bool in
            return build.lastUpdateTime() > lastUpdateForProject
        }

        let sortedBuilds = newBuilds.sorted { $0.lastUpdateTime() > $1.lastUpdateTime() }

        let buildsUserCaresAbout = project.filter?.builds(sortedBuilds) ?? sortedBuilds

        if buildsUserCaresAbout.count > 0 {
            lastUpdateForProject = buildsUserCaresAbout[0].lastUpdateTime()
        }

        return buildsUserCaresAbout
    }
}
