//
//  AuthorizationManagerViewController.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/15.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import UIKit
import HealthKit

class AuthorizationManagerViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        tableView.estimatedRowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var items: [PermissionType] = [.camera,
                                           .audio,
                                           .notification,
                                           .photoLibrary,
                                           .cellularNetwork,
                                           .microphone,
                                           .contact,
                                           .events,
                                           .reminder,
                                           .locationInUse,
                                           .locationInAlways,
                                           .appleMusic,
                                           .speechRecognizer,
                                           .siri,
                                           .motion,
                                           .bluetooth,
                                           .peripheralBluetooth,
                                           .health]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "AuthorizationManager"
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
}

// MARK: - UITableViewDataSource
extension AuthorizationManagerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "authorizationTest")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "authorizationTest")
        }
        
        cell?.textLabel?.text = items[indexPath.row].title
        
        return cell!
    }
}

// MARK: - UITableViewDelegate
extension AuthorizationManagerViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < items.count else { return }
        
        let type = items[indexPath.row]
        if type == .health {
            
            let runningType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
            let runningSampleType = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)
            var typesToShare: Set<HKSampleType> = []
            var typesToRead: Set<HKObjectType> = []
            if let aRunningType = runningType,
                //let aStepCountType = stepCountType,
                let aRunningSampleType = runningSampleType {
                //let aStepCountSampleType = stepCountSampleType {
                typesToRead.insert(aRunningType)
                //typesToRead.insert(aStepCountType)
                typesToShare.insert(aRunningSampleType)
                //typesToShare.insert(aStepCountSampleType)
            }
            
            JLAuthorizationManager.shared.requestHealthPermission(typesToShare, typesToRead: typesToRead) { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
            
        } else {
            JLAuthorizationManager.shared.requestPermission(type) { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        }
    }
}
