import Cocoa
import Foundation

class VersionButton: NSButton {
    var version: String?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    override func viewWillDraw() {
        if version == nil {
            isHidden = true
        } else {
            isHidden = false
            attributedTitle = redString(version!)
        }
    }

    private func redString(_ version: String) -> NSMutableAttributedString {
        let range = NSRange(location: 0, length: version.count)
        let str = NSMutableAttributedString(string: version)
        str.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: NSColor.red,
            range: range
        )
        return str
    }
}
