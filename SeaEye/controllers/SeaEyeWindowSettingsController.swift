//
//  SeaEyeWindowSettingsController.swift
//  SeaEye
//
//  Created by Conor Mongey on 26/11/2017.
//  Copyright © 2017 Nolaneo. All rights reserved.
//

import Cocoa

class SeaEyeWindowSettingsController : NSWindowController,NSWindowDelegate, NSTableViewDelegate,NSTableViewDataSource {
    @IBOutlet var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var apiTokenField: NSTextField!
    @IBOutlet weak var table: NSTableView!
    @IBOutlet weak var branchRegex: NSTextField!
    @IBOutlet weak var userRegex: NSTextField!
    var projects: [CircleCIProject]?
    
    
    @IBAction func save(_ sender: Any) {
        if self.apiTokenField != nil {
            setUserDefaultsFromField(field: apiTokenField, key: "SeaEyeAPIKey")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "SeaEyeSettingsChanged"), object: nil)
        }
        setUserDefaultsFromField(field: branchRegex, key: "SeaEyeBranches")
        setUserDefaultsFromField(field: userRegex, key: "SeaEyeUsers")
        LoadTableData()
    }
    
    func setUserDefaultsFromField(field: NSTextField, key: String) {
        let userDefaults = UserDefaults.standard
        let fieldValue = field.stringValue
        if fieldValue.isEmpty {
            userDefaults.removeObject(forKey: key)
        } else {
            userDefaults.setValue(fieldValue, forKey: key)
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.progressIndicator.startAnimation(nil)
        setField(field: self.apiTokenField, key: "SeaEyeAPIKey")
        setField(field: self.branchRegex, key: "SeaEyeBranches")
        setField(field: self.userRegex, key: "SeaEyeUsers")
        self.table.allowsColumnSelection = true
        self.table.allowsColumnReordering = true
        self.table.delegate = self
        self.table.dataSource = self
        LoadTableData()
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
    }
    
    func setField(field: NSTextField, key: String) {
        if let f =  UserDefaults.standard.string(forKey: key) {
            field.stringValue = f
        }   
    }
    func LoadTableData() {
        var token = ""
        if let apiKey = UserDefaults.standard.string(forKey: "SeaEyeAPIKey") {
            token = apiKey
        }
        let client = CircleCIClient.init(apiToken: token)
        client.getProjects(completion: { (r: Result<[CircleCIProject]>) -> Void in
            switch r {
            case .success(let projects):
                print(projects.count)
                self.projects = projects
                self.table.reloadData()
                self.progressIndicator.isHidden = true
                break
                
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                self.progressIndicator.isHidden = true
            }
        })
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.projects == nil ? 0 : self.projects!.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return self.projects![row]
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView: ProjectView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "project"), owner: self) as! ProjectView
      //  cellView.checkout.stringValue = self.projects![row].description
        cellView.setUp(project: self.projects![row])
        return cellView;
    }
}
