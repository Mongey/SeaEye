//
//  Project.swift
//  SeaEye
//
//  Created by Eoin Nolan on 04/11/2014.
//  Copyright (c) 2014 Nolaneo. All rights reserved.
//

import Cocoa

class OldProject: NSObject {
    let project: Project
    var circleCIClient: CircleCIClient

    var timer: Timer!
    var projectBuilds: [CircleCIBuild]
    var parent: CircleCIModel

    init(name: String, organization: String, key: String, parentModel: CircleCIModel, vcs: String, filter: Filter) {
        projectBuilds = []
        project = Project(name: name, organisation: organization, filter: filter, notify: true, vcsProvider: vcs)
        parent = parentModel
        circleCIClient = CircleCIClient.init()
        circleCIClient.token = key
    }

    func reset() {
        self.stop()
        self.getBuildData()
        if #available(OSX 10.12, *) {
            timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(30),
                                         repeats: true,
                                         block: self.getBuildData(_:))
        } else {
            timer = Timer.scheduledTimer(
                        timeInterval: TimeInterval(30),
                        target: self,
                        selector: #selector(OldProject.getBuildData),
                        userInfo: nil,
                        repeats: true)
        }
    }

    func stop() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }

    @objc func getBuildData(_: Any? = nil) {
        circleCIClient.getProject(name: project.path(), completion: { (result: Result<[CircleCIBuild]>) -> Void in
            switch result {
                case .success(let builds):
                    self.projectBuilds = buildsForUser(builds: builds,
                                                       userRegex: self.project.filter?.userRegex(),
                                                       branchRegex: self.project.filter?.branchRegex())
                    self.parent.runModelUpdates()
                    break
                case .failure(let error):
                    print("error: \(error.localizedDescription) \(self.project)")
                }
        })
    }
}
