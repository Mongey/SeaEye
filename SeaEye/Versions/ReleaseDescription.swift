//
//  SeaEyeVersion.swift
//  SeaEye
//
//  Created by Conor Mongey on 20/11/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation

struct ReleaseDescription: Decodable {
    let latestVersion: String
    let downloadUrl: URL
    let changes: String
}
