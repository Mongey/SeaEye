import Cocoa
import Foundation

class PreferencesWindowController: NSWindowController {
    override var windowNibName: NSNib.Name {
        return "PreferencesWindow"
    }
    override func windowDidLoad() {
        print("Prefrences window opened")


        super.windowDidLoad()
    }
}
