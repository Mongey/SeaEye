import Cocoa

extension NSTextField {
    func maybeStringValue() -> String? {
        let fieldValue = stringValue
        if fieldValue.isEmpty {
            return nil
        }
        return fieldValue
    }

    func maybeSet(_ value: String?) {
        if let value = value {
            stringValue = value
        }
    }
}
