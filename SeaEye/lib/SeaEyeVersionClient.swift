//
//  SeaEyeVersionClient.swift
//  SeaEye
//
//  Created by Conor Mongey on 29/04/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation

func latestSeaEyeVersion(completion:((Result<SeaEyeVersion>) -> Void)?) {
    let r = URLRequest(url: (URL(string :"https://raw.githubusercontent.com/nolaneo/SeaEye/master/project_status.json"))!)
    
    HTTPRequest(r, of: SeaEyeVersion.self, completion: completion)
}
