//
//  JLAuthorizationManager.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/9.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import Contacts
import AddressBook
import EventKit
import CoreLocation
import CoreTelephony
import MediaPlayer
import Speech
import Intents
import CoreBluetooth
import Accounts

enum PermissionType {
    case camera
    case photoLibrary
    case microphone
    case contact
    case events
    case reminder
    case locationInUse
    case locationInAlways
    case cellularNetwork
    case appleMusic
    case speechRecognizer
    case siri
    
    
    // TODO
    case notification
    
    // 需要特殊处理的
    case health
    case motion
    case bluetooth
    
    // 社交分享
    case twitter
    case facebook
    case sinaWeibo
    case tencentWeibo

}

typealias PermissionCompletion = (Bool?) -> Void

class JLAuthorizationManager: NSObject {
    
    static let shared = JLAuthorizationManager()
    private override init() {
        super.init()
    }
    
    private var completion: PermissionCompletion?
    private lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        return lm
    }()
    
    func requestPermission(_ type: PermissionType, completion: @escaping PermissionCompletion) {
        
        switch type {
        case .camera:
            requestCameraPermission(completion)
        case .photoLibrary:
            requestPhotoLibraryPermission(completion)
        case .microphone:
            requestMicroPhonePermission(completion)
        case .contact:
            requestContactPermission(completion)
        case .events:
            requestEventsPermission(completion)
        case .reminder:
            requestReminderPermission(completion)
        case .locationInUse:
            requestLocationInUserPermission(completion)
        case .locationInAlways:
            requestLocationAlwaysPermission(completion)
        case .cellularNetwork:
            requestCellularNetworkPermission(completion)
        case .appleMusic:
            requestAppleMusicPermission(completion)
        case .speechRecognizer:
            requestSpeechRecognizerPermission(completion)
        case .siri:
            requestSiriPermission(completion)
        case .bluetooth:
            requestBluetoothPermission(completion)
        case .notification:
            print("需要单独处理！！")
        default:
            print("暂不处理")
        }
        
    }
    
}

// MARK: - Private
extension JLAuthorizationManager {
    
    private func requestCameraPermission(_ completion: @escaping PermissionCompletion) {
        let authorizedStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authorizedStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                self.safeAync {
                    completion(granted)
                }
            }
        } else {
            completion(authorizedStatus == .authorized)
        }
    }
    
    private func requestPhotoLibraryPermission(_ completion: @escaping PermissionCompletion) {
        let authorizedStatus = PHPhotoLibrary.authorizationStatus()
        if authorizedStatus == .notDetermined {
            
            PHPhotoLibrary.requestAuthorization { (status) in
                self.safeAync {
                    completion(status == .authorized)
                }
            }
        } else {
            completion(authorizedStatus == .authorized)
        }
    }
    
    private func requestMicroPhonePermission(_ completion: @escaping PermissionCompletion) {
        let authorizedStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        if authorizedStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: .audio) { (granted) in
                self.safeAync {
                    completion(granted)
                }
            }
        } else {
            completion(authorizedStatus == .authorized)
        }
    }
    
    @available(iOS 9.0, *)
    private func requestContactPermission(_ completion: @escaping PermissionCompletion) {
        let authorizedStatus = CNContactStore.authorizationStatus(for: .contacts)
        if authorizedStatus == .notDetermined {
            let contactStore = CNContactStore()
            contactStore.requestAccess(for: .contacts) { (granted, _) in
                self.safeAync {
                    completion(granted)
                }
            }
        } else {
            completion(authorizedStatus == .authorized)
        }
    }
    
    private func requestEventsPermission(_ completion: @escaping PermissionCompletion) {
        let authorizedStatus = EKEventStore.authorizationStatus(for: .event)
        if authorizedStatus == .notDetermined {
            EKEventStore().requestAccess(to: .event) { (granted, _) in
                self.safeAync {
                    completion(granted)
                }
            }
        } else {
            completion(authorizedStatus == .authorized)
        }
    }
    
    private func requestReminderPermission(_ completion: @escaping PermissionCompletion) {
        let authorizedStatus = EKEventStore.authorizationStatus(for: .reminder)
        if authorizedStatus == .notDetermined {
            EKEventStore().requestAccess(to: .event) { (granted, _) in
                self.safeAync {
                    completion(granted)
                }
            }
        } else {
            completion(authorizedStatus == .authorized)
        }
    }
    
    private func requestLocationInUserPermission(_ completion: @escaping PermissionCompletion) {
        
        guard CLLocationManager.locationServicesEnabled() else {
            print("未提供GPS支持")
            return
        }
        
        let authorizedStatus = CLLocationManager.authorizationStatus()
        if authorizedStatus == .notDetermined {
            self.completion = completion
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            completion(authorizedStatus == .authorizedWhenInUse)
        }
    }
    
    private func requestLocationAlwaysPermission(_ completion: @escaping PermissionCompletion) {
        
        guard CLLocationManager.locationServicesEnabled() else {
            print("未提供GPS支持")
            return
        }
        
        let authorizedStatus = CLLocationManager.authorizationStatus()
        if authorizedStatus == .notDetermined {
            self.completion = completion
            self.locationManager.requestAlwaysAuthorization()
        } else {
            completion(authorizedStatus == .authorizedAlways)
        }
    }
    
    private func requestCellularNetworkPermission(_ completion: @escaping PermissionCompletion) {
        let cellularData = CTCellularData()
        let authorizedState = cellularData.restrictedState
        if authorizedState == .restrictedStateUnknown {
            cellularData.cellularDataRestrictionDidUpdateNotifier = { state in
                self.safeAync {
                    completion(state == .notRestricted)
                }
            }
        } else {
            completion(authorizedState == .notRestricted)
        }
    }
    
    private func requestAppleMusicPermission(_ completion: @escaping PermissionCompletion) {
        let authorizedStatus = MPMediaLibrary.authorizationStatus()
        if authorizedStatus == .notDetermined {
            MPMediaLibrary.requestAuthorization { status in
                self.safeAync {
                    completion(status == .authorized)
                }
            }
        } else {
            completion(authorizedStatus == .authorized)
        }
        
    }
    
    private func requestSpeechRecognizerPermission(_ completion: @escaping PermissionCompletion) {
        let authorizedStatus = SFSpeechRecognizer.authorizationStatus()
        if authorizedStatus == .notDetermined {
            SFSpeechRecognizer.requestAuthorization { status in
                self.safeAync {
                    completion(status == .authorized)
                }
            }
        } else {
            completion(authorizedStatus == .authorized)
        }
    }
    
    private func requestSiriPermission(_ completion: @escaping PermissionCompletion) {
        guard #available(iOS 10.0, *) else {
            completion(nil)
            print("系统版本暂不支持该API")
            return
        }
    
        let authorizedStatus = INPreferences.siriAuthorizationStatus()
        if authorizedStatus == .notDetermined {
            INPreferences.requestSiriAuthorization { status in
                self.safeAync {
                    completion(status == .authorized)
                }
            }
        } else {
            completion(authorizedStatus == .authorized)
        }
    }
    
    private func requestBluetoothPermission(_ completion: @escaping PermissionCompletion) {
        let authorizedStatus = CBPeripheralManager.authorizationStatus()
        if authorizedStatus == .notDetermined {
            let cbManager = CBCentralManager()
            cbManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            completion(authorizedStatus == .authorized)
        }
    }
    
}

// MARK: - CLLocationManagerDelegate
extension JLAuthorizationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let completion = self.completion {
            completion(status == .authorizedWhenInUse || status == .authorizedAlways)
        }
    }
}

// MARK: - safeThread
extension JLAuthorizationManager {
    
    private func safeAync(_ block: @escaping () -> Void) {
        
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
