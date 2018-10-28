import Cocoa
import Foundation

func downloadAvailableNotification(url: String, version: String) -> NSUserNotification {
    let message = "A new version of SeaEye is available: \(version)"
    let notification = NSUserNotification()
    notification.title = "SeaEye"
    notification.informativeText = message
    notification.setValue(true, forKey: "_showsButtons")
    notification.hasActionButton = true
    notification.actionButtonTitle = "Download"
    notification.userInfo = ["url": url]
    return notification
}

struct BuildsNotification {
    let title: String
    let subtitle: String
    let informativeText: String?
    let url: String

    private let build: CircleCIBuild

    init(_ build: CircleCIBuild, count: Int) {
        let endTitle = build.status == .success ? "Sucess" : "Failed"
        let plural = build.status == .success ? "successful" : "failed"
        self.build = build
        self.title = "SeaEye: Build \(endTitle)"
        self.subtitle = count > 1 ? "You have \(count) \(plural) builds" : (build.subject ?? "")
        self.url = build.buildUrl.absoluteString
        self.informativeText = build.authorName
    }

    func toNotification() -> NSUserNotification {
        let notification = NSUserNotification()

        notification.setValue(false, forKey: "_identityImageHasBorder")
        notification.setValue(nil, forKey: "_imageURL")

        notification.setValue(image(), forKey: "_identityImage")
        notification.userInfo = ["url": self.url]
        notification.informativeText = informativeText
        notification.title = title
        notification.subtitle = subtitle

        return notification
    }

    private func image() -> NSImage? {
        let imageFile = build.status == .success ? "build-passed" : "build-failed"
        return NSImage(named: imageFile)
    }
}
