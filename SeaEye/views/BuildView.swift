//
//  BuildView.swift
//  SeaEye
//
//  Created by Eoin Nolan on 27/10/2014.
//  Copyright (c) 2014 Nolaneo. All rights reserved.
//

import Cocoa

class BuildView: NSTableCellView {
    @IBOutlet var statusColorBox : NSBox!
    @IBOutlet var statusAndSubject : NSTextField!
    @IBOutlet var branchName : NSTextField!
    @IBOutlet var timeAndBuildNumber : NSTextField!
    @IBOutlet var openURLButton : NSButton!
    var url : URL?
    
    func setupForBuild(build: CircleCIBuild) {
        url = build.build_url
        statusAndSubject.stringValue = build.status.capitalized

        if build.status == "no_tests" {
            statusAndSubject.stringValue = "No tests"
        }
        if build.subject != nil {
            statusAndSubject.stringValue += ": \(build.subject!)"
        }
        if let color = ColorForStatus(status: build.status) {
            setColors(color)
        }
        branchName.stringValue = "\(build.branch) | \(build.reponame)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm MMM dd"
        timeAndBuildNumber.stringValue = dateFormatter.string(from: build.start_time) + " | Build #\(build.build_num)"

        if build.author_name != nil {
            timeAndBuildNumber.stringValue = dateFormatter.string(from: build.start_time) + " | Build #\(build.build_num)" + " | By \(build.author_name!)"
        }
        if isDarkModeEnabled() {
            openURLButton.image = NSImage(named: NSImage.Name(rawValue: "open-alt"))
        }
    }
    
    @IBAction func openBuild(_ sender: AnyObject) {
        if url != nil {
            NSWorkspace.shared.open(url!)
        }
    }
    
    fileprivate func setColors(_ color: NSColor) {
        statusAndSubject.textColor = color
        statusColorBox.fillColor = color
    }
}
