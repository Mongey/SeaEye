//
//  Filter.swift
//  SeaEye
//
//  Created by Conor Mongey on 16/06/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation

struct Filter: Codable {
    let userFilter: String?
    let branchFilter: String?

    init(userFilter: String?, branchFilter: String?) {
        self.userFilter = userFilter
        self.branchFilter = branchFilter
    }

    func branchRegex() -> NSRegularExpression? {
        if branchFilter != nil {
            return try? NSRegularExpression(pattern: branchFilter!,
                                            options: NSRegularExpression.Options.caseInsensitive)
        }
        return nil
    }
    
    func userRegex() -> NSRegularExpression? {
        if userFilter != nil {
            return try? NSRegularExpression(pattern: userFilter!,
                                            options: NSRegularExpression.Options.caseInsensitive)
        }
        return nil
    }
}
