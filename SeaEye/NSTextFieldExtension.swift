import Cocoa

extension NSTextField {
    func maybeStringValue() -> String? {
        let fieldValue = self.stringValue
        if fieldValue.isEmpty {
            return nil
        }
        return fieldValue
    }
    func maybeSet(_ value: String?) {
        if value != nil {
            self.stringValue = value!
        }
    }
}
