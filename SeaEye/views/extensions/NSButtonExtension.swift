import Cocoa

extension NSButton {
    func setState(_ inp: Bool) {
        state = inp ? NSControl.StateValue.on : NSControl.StateValue.off
    }
}
