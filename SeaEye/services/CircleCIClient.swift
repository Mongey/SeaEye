import Foundation

struct CircleCIProject: Decodable {
    let username: String
    let reponame: String
    let vcsUrl: String
    let following: Bool
    func description() -> String {
        return "\(username)/\(reponame)"
    }
}

struct Me: Decodable {
    let name: String
}

public class CircleCIClient {
    var baseURL: String = "https://circleci.com"
    var token: String = ""

    func getProjects(completion: ((Result<[CircleCIProject]>) -> Void)?) {
        request(get(path: "projects"), of: [CircleCIProject].self, completion: completion)
    }

    func getProject(name: String, completion: ((Result<[CircleCIBuild]>) -> Void)?) {
        request(get(path: "project/\(name)"), of: [CircleCIBuild].self, completion: completion)
    }

    func getMe(completion: (((Result<Me>) -> Void)?)) {
        request(get(path: "me"), of: Me.self, completion: completion)
    }

    private func get(path: String) -> URLRequest {
        var request = URLRequest(url: url(path: path))
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        return request
    }

    private func url(path: String) -> URL {
        return URL(string: "\(baseURL)/api/v1.1/\(path)?circle-token=\(self.token)")!
    }
}
