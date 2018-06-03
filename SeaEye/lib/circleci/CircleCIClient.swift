import Foundation


class CircleCIClient {
    var apiToken: String
    var baseURL: String
    init(apiToken: String){
        let apiVersion = "v1.1"
        self.baseURL = "https://circleci.com/api/\(apiVersion)"
        self.apiToken = apiToken
    }
    
//    func recentBuilds(completion:((Result<[CircleCIRecentBuild]>) -> Void)?){
//        HTTPRequest(get(path: "recent-builds"), of: [CircleCIRecentBuild].self, completion: completion)
//    }
    
    func getProject(project:CircleCIProject, completion: ((Result<[CircleCIBuild]>) -> Void)?) {
        HTTPRequest(get(path: "project/\(project.vcs_type)/\(project.username)/\(project.reponame)"), of: [CircleCIBuild].self, completion: completion)
    }
    
    func getProjects(completion:((Result<[CircleCIProject]>) -> Void)?){
        HTTPRequest(get(path: "projects"), of: [CircleCIProject].self, completion: completion)
    }
    func getMe(completion: (((Result<CircleCIUser>) -> Void)?)) {
        HTTPRequest(get(path: "me"), of: CircleCIUser.self, completion: completion)
    }
    
    private func get(path: String) -> URLRequest {
        var request = URLRequest(url: urlFor(path: path))
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        return request
    }
    
    private func urlFor(path: String) -> URL {
        return URL(string: "\(self.baseURL)/\(path)?circle-token=\(self.apiToken)")!
    }
}
