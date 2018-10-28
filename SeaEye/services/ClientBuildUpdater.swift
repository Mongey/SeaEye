import Foundation

protocol BuildUpdateListener {
    mutating func notify(project: Project, builds: [CircleCIBuild])
}

protocol BuildClient {
    func getProject(name: String, completion: ((Result<[CircleCIBuild]>) -> Void)?)
}

// Notifies the listeners with *new* builds that the user cares about for a project, from a buildClient
class ClientBuildUpdater {
    var listeners: [BuildUpdateListener]
    let client: BuildClient
    let project: Project
    var buildFilter: Foobar

    init(listeners: [BuildUpdateListener], client: BuildClient, project: Project) {
        self.listeners = listeners
        self.client = client
        self.project = project
        buildFilter = Foobar(lastUpdateForProject: Date.distantPast)
    }

    @objc func getBuilds() {
        client.getProject(name: project.path(), completion: { (result: Result<[CircleCIBuild]>) -> Void in
            switch result {
            case let .success(builds):
                let filteredBuilds = self.buildFilter.notify(project: self.project, builds: builds)
                for var listener in self.listeners {
                    listener.notify(project: self.project, builds: filteredBuilds)
                }
                break
            case let .failure(error):
                print("error: \(error.localizedDescription) \(String(describing: self.project))")
            }
        })
    }
}
