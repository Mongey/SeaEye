import Cocoa
import Foundation

// Delivers a NSUserNotification for a project
class NotificationListener: BuildUpdateListener {
    let notificationCenter = NSUserNotificationCenter.default

    func notify(project: Project, builds: [CircleCIBuild]) {
        if project.notify {
            if let summary = BuildSummary.generate(builds: builds) {
                switch summary.status {
                case .running:
                    print("Running build ... skipping notify")
                case .failed:
                    print("Notify of a failed build")

                    let notification = BuildsNotification(summary.build!, count: summary.count).toNotification()
                    notificationCenter.deliver(notification)
                case .success:
                    print("Notifiy of a success build")

                    let notification = BuildsNotification(summary.build!, count: summary.count).toNotification()
                    notificationCenter.deliver(notification)
                }
            }
        }
    }
}
