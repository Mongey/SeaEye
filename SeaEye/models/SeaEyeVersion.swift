//
//  SeaEyeVersion.swift
//  SeaEye
//
//  Created by Conor Mongey on 29/04/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation

struct SeaEyeVersion : Decodable {
    let latest_version: String
    let download_url: URL
    let changes: String
}
