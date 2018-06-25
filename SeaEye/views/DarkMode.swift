//
//  DarkMode.swift
//  SeaEye
//
//  Created by Conor Mongey on 17/06/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation

func isDarkModeEnabled() -> Bool {
    let dictionary  = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain)
    if let interfaceStyle = dictionary?["AppleInterfaceStyle"] as? NSString {
        return interfaceStyle.localizedCaseInsensitiveContains("dark")
    }
    return false
}
