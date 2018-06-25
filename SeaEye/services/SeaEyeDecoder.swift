import Foundation

class SeaEyeDecoder: JSONDecoder {
    override init() {
        super.init()
        self.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        self.keyDecodingStrategy = .convertFromSnakeCase
    }
}
