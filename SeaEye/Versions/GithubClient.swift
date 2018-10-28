//
//  GithubClient.swift
//  SeaEye
//
//  Created by Conor Mongey on 15/06/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation

class GithubClient {
    static func latestRelease(completion: ((Result<GithubRelease>) -> Void)?) {
        request(get(path: "releases/latest"), of: GithubRelease.self, completion: completion)
    }

    private static func get(path: String) -> URLRequest {
        let baseURL = "api.github.com/repos/nolaneo/SeaEye"
        let url = URL(string: "https://\(baseURL)/\(path)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        return request
    }
}

struct GithubRelease: Decodable {
    let tagName: String
    let prerelease: Bool
    let draft: Bool
    let htmlUrl: String
    let name: String
    let body: String

    func version() -> VersionNumber {
        return tagName.versionNumber()
    }

    func toSeaEye() -> ReleaseDescription {
        return ReleaseDescription(latestVersion: tagName,
                                  downloadUrl: URL(string: htmlUrl)!,
                                  changes: body)
    }
}
