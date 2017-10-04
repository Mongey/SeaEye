//
//  SimpleModificationsTableCellView.swift
//  SeaEye
//
//  Created by Conor Mongey on 12/03/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Cocoa

class SimpleModificationsTableCellView : NSTableCellView {
    
    func setupForProject(project: CircleCIProject) {
        print(project.reponame)
        self.textField?.stringValue = "hello"
    }
}
