//
//  BuildStatusUpdate.swift
//  SeaEye
//
//  Created by Conor Mongey on 29/04/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation

class BuildUpdate{
    var builds: [CircleCIBuild]
//    private var failedBuilds: [CircleCIBuild]
//    private var successfulBuilds: [CircleCIBuild]
//
    init(builds: [CircleCIBuild]) {
        self.builds = builds
//        classifyBuilds()
    }
    
    private func classifyBuilds() {
//        for(b) in (self.builds) {
//            switch b.status {
//            case "failed": self.failedBuilds.append(b); break;
//            case "timedout": self.failedBuilds.append(b); break;
//            case "success": self.successfulBuilds.append(b); break;
//            case "fixed": self.successfulBuilds.append(b); break;
//            default: break;
//            }
//        }
    }
//    func failures() -> Int {
////        return self.failedBuilds.count
//    }
//    func successes() -> Int {
//        return self.successfulBuilds.count
//    }
}

func foo(lastNotificationDate: Date?, allBuilds: [CircleCIBuild]) {
//    if lastNotificationDate != nil {
//        let newBuilds = allBuilds.filter { (b) -> Bool in
//            b.start_time.timeIntervalSince1970 > lastNotificationDate!.timeIntervalSince1970
//        }
//        let bu = BuildUpdate.init(builds: newBuilds)
//        
//        if bu.failures() > 0 {
////            print("Has red build \(String(describing: failedBuild!.subject))")
//            let info = ["build": failedBuild!, "count": failures] as [String : Any]
//            NotificationCenter.default.post(name: Notification.Name(rawValue: "SeaEyeRedBuild"), object: nil, userInfo:info)
//        } else if successes > 0 {
//            let info = ["build": successfulBuild!, "count": successes] as [String : Any]
//            NotificationCenter.default.post(name: Notification.Name(rawValue: "SeaEyeGreenBuild"), object: nil, userInfo:info)
//        }
//    }
//    
//    NotificationCenter.default.post(name: Notification.Name(rawValue: "SeaEyeUpdatedBuilds"), object: nil)
//    lastNotificationDate = Date()
    
}
