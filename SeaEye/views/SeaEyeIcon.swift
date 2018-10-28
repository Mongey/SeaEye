//
//  SeaEyeIcon.swift
//  SeaEye
//
//  Created by Conor Mongey on 25/10/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Cocoa
import Foundation

class SeaEyeIcon: NSButton {
    enum Status {
        case failed
        case running
        case success
        case idle
    }

    private var iconState: Status = .idle

    func set(_ state: Status) {
        iconState = state
        image = NSImage(named: imageForState())
        needsDisplay = true
    }

    func reset() {
        set(.idle)
    }

    private func imageForState() -> String {
        switch iconState {
        case .failed:
            return "circleci-failed"
        case .success:
            return "circleci-success"
        case .running:
            return "circleci-pending"
        default:
            return "circleci"
        }
    }
}
