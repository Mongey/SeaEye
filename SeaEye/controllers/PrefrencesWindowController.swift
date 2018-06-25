//
//  PreferencesWindowController.swift
//  SeaEye
//
//  Created by Conor Mongey on 01/07/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//
import Cocoa
import Foundation

class PreferencesWindowController: NSWindowController {
    override var windowNibName : NSNib.Name {
        return NSNib.Name(rawValue: "PreferencesWindow")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        reload()
    }

    func reload() {
        let client = Settings.load().toNewSettings().clients[0].client()
        client.getProjects { (r) in
            switch r {
            case .success(let p):
                self.window()?.knownProjects = p
                self.window()?.reset()
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    func window() -> PreferencesWindow? {
        if self.window != nil {
            if let pwindow = self.window as? PreferencesWindow {
                return pwindow
            }
        }
        return nil
    }
}
