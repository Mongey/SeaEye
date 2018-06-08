import Foundation

struct GithubRelease : Decodable {
    let url: URL
    let assets_url: URL
    let upload_url: URL
    let html_url: URL
    let id: Int
    let tag_name: String
    let body: String
}

func latestSeaEyeVersion(completion:((Result<SeaEyeVersion>) -> Void)?) {
    let r = URLRequest(url: (URL(string :"https://raw.githubusercontent.com/nolaneo/SeaEye/master/project_status.json"))!)
    
    HTTPRequest(r, of: SeaEyeVersion.self, completion: completion)
}

func latestSeaEeyeVersionFromReleases (completion:((Result<GithubRelease>) -> Void)?) {
    let url = "https://api.github.com/repos/nolaneo/seaeye/releases/latest"
    let r = URLRequest(url: (URL(string: url))!)
    HTTPRequest(r, of: GithubRelease.self, completion: completion)
}
