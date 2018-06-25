//
//  ProjectsFromSettings.swift
//  SeaEye
//
//  Created by Conor Mongey on 15/06/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation

struct FollowedProjectsFromSettings {
    var apiKey: String = ""
    var organization: String
    var projectsArray: [String]
    var filter: Filter

    init(apiKey: String, organization: String, projects: String, branchFilter: String?, userFilter: String?) {
        self.apiKey = apiKey
        self.organization = organization
        self.projectsArray = projects.components(separatedBy: CharacterSet.whitespaces)
        self.filter = Filter.init(userFilter: userFilter, branchFilter: branchFilter)
    }

    func call(parent: CircleCIModel) -> [OldProject] {
        return projectsArray.map { (projectName) -> OldProject in
          OldProject(name: projectName,
                    organization: self.organization,
                    key: self.apiKey,
                    parentModel: parent,
                    vcs: "github",
                    filter: self.filter)
        }
    }
}
