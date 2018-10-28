import Foundation

struct FallbackView {
    let settings: Settings
    let builds: [CircleCIBuild]

    func description() -> String? {
        if settings.clients.count == 0 {
            return "You have not configured any clients"
        }

        if settings.numberOfProjects() == 0 {
            return "You have not added any projects"
        }

        if builds.count == 0 {
            return "No Recent Builds Found"
        }

        return nil
    }
}
