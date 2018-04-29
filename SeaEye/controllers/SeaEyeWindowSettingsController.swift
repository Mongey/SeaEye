//
//  SeaEyeWindowSettingsController.swift
//  SeaEye
//
//  Created by Conor Mongey on 26/11/2017.
//  Copyright © 2017 Nolaneo. All rights reserved.
//

import Cocoa

class SeaEyeWindowSettingsController : NSWindowController,NSWindowDelegate, NSTableViewDelegate,NSTableViewDataSource {
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
        getProjects(completion: { (r: Result<[CircleCIProject]>) -> Void in
            switch r {
            case .success(let projects):
                print(projects.count)
                self.projects = projects
                self.table.reloadData()
                break
                
            case .failure(let error):
                print("error: \(error.localizedDescription)")
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
        var result: NSTableCellView
        let column = (tableColumn?.identifier)!

        result  = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
        var txtValue = "hi"
        
//        if (column == "AutomaticTableColumnIdentifier.0") {
//            txtValue = self.blackListedProcessNames[row] // bundle identifier
//        }
        
        result.textField?.stringValue = txtValue
        return result
    }
}
