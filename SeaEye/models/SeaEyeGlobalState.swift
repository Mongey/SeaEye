//
//  CircleCIModel.swift
//  SeaEye
//
//  Created by Eoin Nolan on 27/10/2014.
//  Copyright (c) 2014 Nolaneo. All rights reserved.
//

import Cocoa

class SeaEyeGlobalState: NSObject {
    var hasValidUserSettings = false
    var allProjects: [Project]
    var allBuilds: [CircleCIBuild]
    var lastNotificationDate: Date!
    var updatesTimer: Timer!
    var settings: SeaEyeSettings
    
    override init() {
        self.allBuilds = []
        self.allProjects = []
        self.settings = SeaEyeSettings.init()
        
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(SeaEyeGlobalState.validateUserSettingsAndStartRequests),
            name: NSNotification.Name(rawValue: "SeaEyeSettingsChanged"),
            object: nil
        )
        self.validateUserSettingsAndStartRequests()
    }
    
    @objc func validateUserSettingsAndStartRequests() {
        if (self.settings.valid()) {
            allBuilds = []
            NotificationCenter.default.post(name: Notification.Name(rawValue: "SeaEyeUpdatedBuilds"), object: nil)
            resetAPIRequests()
        } else {
//            stopAPIRequests()
        }
    }
    
    func runModelUpdates() {
        objc_sync_enter(self)
        //Debounce the calls to this function
        if updatesTimer != nil {
            updatesTimer.invalidate()
            updatesTimer = nil
        }
        updatesTimer = Timer.scheduledTimer(
            timeInterval: TimeInterval(3),
            target: self,
            selector: #selector(SeaEyeGlobalState.updateBuilds),
            userInfo: nil,
            repeats: false
        )
        objc_sync_exit(self)
    }
    
    @objc func updateBuilds() {
        autoreleasepool {
            print("Update builds!")
            self.allBuilds = self.allBuilds.sorted {$0.start_time.timeIntervalSince1970 > $1.start_time.timeIntervalSince1970}
            self.calculateBuildStatus()
        }
    }
    
    func calculateBuildStatus() {
        if lastNotificationDate != nil {
            var failures = 0
            var successes = 0
            var failedBuild : CircleCIBuild?
            var successfulBuild : CircleCIBuild?
            for(build) in (allBuilds) {
                if build.start_time.timeIntervalSince1970 > lastNotificationDate.timeIntervalSince1970 {
                    switch build.status {
                        case "failed": failures += 1; failedBuild = build; break;
                        case "timedout": failures += 1; failedBuild = build; break;
                        case "success": successes += 1; successfulBuild = build; break;
                        case "fixed": successes += 1; successfulBuild = build; break;
                        default: break;
                    }
                }
            }
            
            if failures > 0 {
                print("Has red build \(String(describing: failedBuild!.subject))")
                let info = ["build": failedBuild!, "count": failures] as [String : Any]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "SeaEyeRedBuild"), object: nil, userInfo:info)
            } else if successes > 0 {
                print("Has multiple successes")
                let info = ["build": successfulBuild!, "count": successes] as [String : Any]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "SeaEyeGreenBuild"), object: nil, userInfo:info)
            }
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SeaEyeUpdatedBuilds"), object: nil)
        lastNotificationDate = Date()
    }

    
    fileprivate func validateKey(_ key : String) -> Bool {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: key) != nil
    }
    
    fileprivate func resetAPIRequests() {
        allProjects = []
        let client = CircleCIClient.init(apiToken: settings.apiKey!)
        
        for project in settings.followedProjects {
            client.getProject(project: project) { (r) in
               switch r {
                case .success(let builds):
                    print(builds)
                    self.allBuilds.append(contentsOf: builds)
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    }
}
