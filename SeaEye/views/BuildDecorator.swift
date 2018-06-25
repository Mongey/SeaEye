//
//  BuildDecorator.swift
//  SeaEye
//
//  Created by Conor Mongey on 16/06/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation
import Cocoa

struct BuildDecorator {
    var build: CircleCIBuild
    let seperator = "|"
    let darkModeEnabled: Bool

    init(build: CircleCIBuild) {
        self.build = build
        self.darkModeEnabled = isDarkModeEnabled()
    }

    func statusAndSubject() -> String {
        var status = build.status.capitalized

        if build.status == "no_tests" {
            return "No tests"
        }
        if build.subject != nil {
            status += ": \(build.subject!)"
        } else {
            if let workflow = build.workflows {
                status += ": \(workflow.workflowName!) - \(workflow.jobName!)"
            }
        }

        return status
    }

    func statusColor() -> NSColor? {
        switch build.status {
        case "success": return greenColor()
        case "fixed": return greenColor()
        case "no_tests": return redColor()
        case "failed": return redColor()
        case "timedout": return redColor()
        case "running": return blueColor()
        case "canceled": return grayColor()
        case "retried": return grayColor()
        default:
            print("unknown status" + build.status)
            return nil
        }
    }

    func timeAndBuildNumber() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm MMM dd"
        var result = dateFormatter.string(from: build.startTime) + " \(seperator) Build #\(build.buildNum)"
        if build.authorName != nil {
            result += " \(seperator) By \(build.authorName!)"
        }
        return result
    }

    func branchName() -> String {
        return "\(build.branch) \(seperator) \(build.reponame)"
    }

    private func greenColor() -> NSColor {
        return NSColor.systemGreen
    }

    private func redColor() -> NSColor {
        return NSColor.systemRed
    }

    private func blueColor() -> NSColor {
        return NSColor.systemBlue
    }

    private func grayColor() -> NSColor {
        return NSColor.systemGray
    }
}
