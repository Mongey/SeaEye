//
//  SeaEyeSettings.swift
//  SeaEye
//
//  Created by Conor Mongey on 29/04/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation

class SeaEyeSettings {
    let apiKey: String?
    let userString: String?
    var userRegex: NSRegularExpression?
    let branchString: String?
    var branchRegex: NSRegularExpression?
    let followedProjects: [CircleCIProject]
    
    init(){
        let userDefaults = UserDefaults.standard
        self.apiKey = userDefaults.string(forKey: "SeaEyeAPIKey")
        self.branchString = UserDefaults.standard.string(forKey: "SeaEyeBranches")
        self.userString = UserDefaults.standard.string(forKey: "SeaEyeUsers")
        self.userRegex = nil
        self.branchRegex = nil
        
        if userString != nil {
            self.userRegex = try? NSRegularExpression(pattern: userString!, options: NSRegularExpression.Options.caseInsensitive)
        }
        
        if branchString != nil {
            self.branchRegex = try? NSRegularExpression(pattern: branchString!, options: NSRegularExpression.Options.caseInsensitive)
        }
        self.followedProjects = projectsFromOldSettings(userDefaults: userDefaults)
    }
    
    func valid() -> Bool{
        //bad regex
        if userString != nil && userRegex == nil {
            return false
        }
        if branchString != nil && branchRegex == nil {
            return false
        }
        if apiKey == nil {
            return false
        }
        return true
    }
}

// support for SeaEye settings from <0.5
func projectsFromOldSettings(userDefaults: UserDefaults) -> [CircleCIProject] {
    let organization = userDefaults.string(forKey: "SeaEyeOrganization") as String?
    let projectsString = userDefaults.string(forKey: "SeaEyeProjects") as String?
    let ps = projectsString!.components(separatedBy: CharacterSet.whitespaces)
    var res: [CircleCIProject] = []
    for project in ps {
        res.append(CircleCIProject.init(username: organization!,
                                        reponame: project,
                                        vcs_type: "github",
                                        following: true))
    }
    return res
}
