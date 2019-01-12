//
//  ViewController.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/9.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import UIKit

import HealthKit

extension PermissionType {
    var title: String {
        switch self {
        case .camera:
            return "相机/Camera"
        case .audio:
            return "音频/Audio"
        case .notification:
            return "通知/Notification"
        case .photoLibrary:
            return "相册/PhotoLibrary"
        case .cellularNetwork:
            return "蜂窝网络/CellularNetwork"
        case .microphone:
            return "麦克风/Microphone"
        case .contact:
            return "通讯录/Contact"
        case .events:
            return "日历事件/Events"
        case .reminder:
            return "提醒事项/Reminder"
        case .locationInUse:
            return "使用时请求定位权限/LocationInUse"
        case .locationInAlways:
            return "一直请求定位权限/LocationInAlways"
        case .appleMusic:
            return "媒体资料库/AppleMusic"
        case .speechRecognizer:
            return "语音识别/SpeechRecognizer"
        case .siri:
            return "Siri"
        case .motion:
            return "加速仪与陀螺仪/Motion"
        case .bluetooth:
            return "蓝牙/Bluetooth"
        case .health:
            return "健康数据/Health"
        }
    }
}

class ViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
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
                                           .health]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "权限集锦"
        view.addSubview(tableView)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
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
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < items.count else { return }
        let type = items[indexPath.row]
        switch type {
        case .camera:
            let permission = CameraPermission()
            print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        case .audio:
            let permission = AudioPermission()
            print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        case .notification:
            let permission = NotificationPermission()
            print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.asyncFetchAuthorizedStatus { staus in
                print("\(type.title) -> async fetch status:\(permission.authorizedStatus())")
            }
            
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        case .photoLibrary:
            let permission = PhotosPermission()
            print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        case .cellularNetwork:
            let permission = CellularNetworkPermission()
            print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        case .microphone:
            let permission = MicrophonePermission()
            print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        case .contact:
            let permission = ContactPermission()
            print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        case .events:
            let permission = EventsPermission()
            print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        case .reminder:
            let permission = ReminderPermission()
            print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        case .locationInUse:
            let permission = LocationInUsePermission()
            //print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        case .locationInAlways:
            let permission = LocationAlwaysPermission()
            print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        case .appleMusic:
            let permission = AppleMusicPermission()
            print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        case .speechRecognizer:
            let permission = SpeechRecognizerPermission()
            print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        case .siri:
            let permission = SiriPermission()
            print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        case .motion:
            let permission = MotionPermission()
            print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        case .bluetooth:
            let permission = BluetoothPermission()
            print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        case .health:
            let runningType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
            //let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)
            let runningSampleType = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)
            //let stepCountSampleType = HKSampleType.quantityType(forIdentifier: .stepCount)
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
            
            let permission = HealthPermission(typesToShare, typesToRead: typesToRead)
            print("\(type.title) -> status:\(permission.authorizedStatus())")
            permission.requestPermission { granted in
                print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
            }
        }
        
    }
}

