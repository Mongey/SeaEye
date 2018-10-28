import Foundation

struct MiniClient: Codable {
    let apiKey: String
    let url: String
    var projects: [Project]

    func client() -> CircleCIClient {
        let client = CircleCIClient()
        client.baseURL = url
        client.token = apiKey
        return client
    }
}
