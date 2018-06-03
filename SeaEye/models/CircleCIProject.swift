import Foundation

struct CircleCIProject: Decodable {
    let username: String
    let reponame: String
    var vcs_type: String = "github"
    let following: Bool
    
    public var description: String {
        return "\(username)/\(reponame)"
    }
}
