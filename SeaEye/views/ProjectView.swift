//
//  SimpleModificationsTableCellView.swift
//  SeaEye
//
//  Created by Conor Mongey on 12/03/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Cocoa

class ProjectView: NSTableCellView {
    @IBOutlet var something: NSButton!
    
    @IBAction func checked(_ sender: Any) {
        print("Something happened")
    }
    func setUp(project: CircleCIProject) {
        print("Setting up for \(project.description)")
        something.stringValue = project.description
        something.title = project.description
        something.isEnabled = project.following
    }
}
