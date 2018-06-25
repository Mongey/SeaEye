import Cocoa

extension NSButton {
    func setState(_ inp: Bool) {
        self.state = inp ? NSControl.StateValue.on : NSControl.StateValue.off
    }
}
