//
//  Project.swift
//  SeaEye
//
//  Created by Conor Mongey on 17/06/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation

struct Project: Codable {
    let name: String
    let organisation: String
    let filter: Filter?
    let notify: Bool
    let vcsProvider: String

    func path() -> String {
        return "\(vcsProvider)/\(organisation)/\(name)"
    }

    func description() -> String {
        return "\(organisation)/\(name)"
    }
}
