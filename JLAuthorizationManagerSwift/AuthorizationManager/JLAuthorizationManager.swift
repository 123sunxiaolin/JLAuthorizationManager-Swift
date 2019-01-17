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
import UserNotifications
import HealthKit

// General Usages
typealias PermissionCompletion = (Bool) -> Void

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
            requestLocationInUsePermission(completion)
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
            requestNotificationPermission(completion)
        case .health:
            assert(false, "please use requestHealthPermission() method")
        default:
            print("暂不处理")
        }
        
    }
    
    func requestHealthPermission(_ typesToShare: Set<HKSampleType>, typesToRead: Set<HKObjectType>, completion: @escaping PermissionCompletion) {
        
        let isSupportHealthKit = HKHealthStore.isHealthDataAvailable()
        assert(isSupportHealthKit, "unsupport health data!")
        
        let healthStore = HKHealthStore()
        
        var statusForHealth: [HKAuthorizationStatus] = []
        if typesToShare.count > 0 {
            for oneShare in typesToShare {
                let shareStatus = healthStore.authorizationStatus(for: oneShare)
                statusForHealth.append(shareStatus)
            }
        }
        
        if typesToRead.count > 0 {
            for oneRead in typesToRead {
                let readStatus = healthStore.authorizationStatus(for: oneRead)
                statusForHealth.append(readStatus)
            }
        }
        // priority: notDetermined > unAuthorized > authorized
        if statusForHealth.count > 0 {
            if statusForHealth.contains(.notDetermined) {
                
                healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { granted, _ in
                    self.safeAync {
                        completion(granted)
                    }
                }
                
            } else if statusForHealth.contains(.sharingDenied) {
                completion(false)
            } else {
                completion(true)
            }
        }
        
    }
    
    
    func authorizedStatus(_ type: PermissionType) -> AuthorizedStatus {
        
        switch type {
        case .camera:
            return cameraAuthorizedStatus()
        case .photoLibrary:
            return photosAuthortizedStatus()
        case .microphone, .audio:
            return microphoneAuthorizedStatus()
        case .contact:
            return contactAuthorizedStatus()
        case .events:
            return eventsAuthorizedStatus()
        case .reminder:
            return reminderAuthorizedStatus()
        case .locationInUse:
            return locationInUseAuthorizedStatus()
        case .locationInAlways:
            return locationAlwaysAuthorizedStatus()
        case .cellularNetwork:
            return cellularNetworkAuthorizedStatus()
        case .appleMusic:
            return appleMusicAuthorizedStatus()
        case .speechRecognizer:
            return speechRsecognizerAuthorizedStatus()
        case .siri:
            return siriAuthorizedStatus()
        default:
            print("other ")
            return .disabled
        }
    }
    
}

// MARK: - Private
extension JLAuthorizationManager {
    
    // MARK: - Camera
    private func cameraAuthorizedStatus() -> AuthorizedStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            return .authorized
        case .restricted, .denied:
            return .unAuthorized
        case .notDetermined:
            return .notDetermined
        }
    }
    
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
    
    // MARK: - Photos
    private func photosAuthortizedStatus() -> AuthorizedStatus {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            return .authorized
        case .restricted, .denied:
            return .unAuthorized
        case .notDetermined:
            return .notDetermined
        }
    }
    
    private func requestPhotoLibraryPermission(_ completion: @escaping PermissionCompletion) {
        let authorizedStatus = PHPhotoLibrary.authorizationStatus()
        if authorizedStatus == .notDetermined {
            
            PHPhotoLibrary.requestAuthorization { status in
                self.safeAync {
                    completion(status == .authorized)
                }
            }
        } else {
            completion(authorizedStatus == .authorized)
        }
    }
    
    // MARK: - Microphone
    private func microphoneAuthorizedStatus() -> AuthorizedStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .authorized:
            return .authorized
        case .restricted, .denied:
            return .unAuthorized
        case .notDetermined:
            return .notDetermined
        }
    }
    
    private func requestMicroPhonePermission(_ completion: @escaping PermissionCompletion) {
        let authorizedStatus = AVAudioSession.sharedInstance().recordPermission
        if authorizedStatus == .undetermined {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                self.safeAync {
                    completion(granted)
                }
            }
        } else {
            completion(authorizedStatus == .granted)
        }
    }
    
    // MARK: - Contact
    private func contactAuthorizedStatus() ->AuthorizedStatus {
        if #available(iOS 9.0, *) {
            let status = CNContactStore.authorizationStatus(for: .contacts)
            switch status {
            case .authorized:
                return .authorized
            case .restricted, .denied:
                return .unAuthorized
            case .notDetermined:
                return .notDetermined
            }
        } else {
            let status = ABAddressBookGetAuthorizationStatus()
            switch status {
            case .authorized:
                return .authorized
            case .restricted, .denied:
                return .unAuthorized
            case .notDetermined:
                return .notDetermined
            }
        }
    }
    
    private func requestContactPermission(_ completion: @escaping PermissionCompletion) {
        let status = contactAuthorizedStatus()
        switch status {
        case .notDetermined:
            if #available(iOS 9.0, *) {
                CNContactStore().requestAccess(for: .contacts) { (granted, _) in
                    self.safeAync {
                        completion(granted)
                    }
                }
            } else {
                ABAddressBookRequestAccessWithCompletion(nil) { (granted, _) in
                    self.safeAync {
                        completion(granted)
                    }
                }
            }
        default:
            completion(status == .authorized)
        }
    }
    
    // MARK: - Events
    private func eventsAuthorizedStatus() -> AuthorizedStatus {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .authorized:
            return .authorized
        case .restricted, .denied:
            return .unAuthorized
        case .notDetermined:
            return .notDetermined
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
    
    // MARK: - Reminder
    private func reminderAuthorizedStatus() -> AuthorizedStatus {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .authorized:
            return .authorized
        case .restricted, .denied:
            return .unAuthorized
        case .notDetermined:
            return .notDetermined
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
    
    // MARK: - LocationInUse
    private func locationInUseAuthorizedStatus() -> AuthorizedStatus {
        guard CLLocationManager.locationServicesEnabled() else { return .disabled }
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return .authorized
        case .restricted, .denied:
            return .unAuthorized
        case .notDetermined:
            return .notDetermined
        }
    }
    
    private func requestLocationInUsePermission(_ completion: @escaping PermissionCompletion) {
        
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
    
    // MARK: - LocationAlways
    private func locationAlwaysAuthorizedStatus() -> AuthorizedStatus {
        guard CLLocationManager.locationServicesEnabled() else { return .disabled }
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways:
            return .authorized
        case .authorizedWhenInUse:
            return .notDetermined
        case .restricted, .denied:
            return .unAuthorized
        case .notDetermined:
            return .notDetermined
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
    
    // MARK: - CellularNetwork
    private func cellularNetworkAuthorizedStatus() -> AuthorizedStatus {
        
        let status = CTCellularData().restrictedState
        switch status {
        case .notRestricted:
            return .authorized
        case .restricted:
            return .unAuthorized
        case .restrictedStateUnknown:
            return .notDetermined
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
    
    // MARK: - AppleMusic
    private func appleMusicAuthorizedStatus() -> AuthorizedStatus {
        
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .authorized:
            return .authorized
        case .restricted, .denied:
            return .unAuthorized
        case .notDetermined:
            return .notDetermined
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
    
    // MARK: - SpeechRecognizer
    private func speechRsecognizerAuthorizedStatus() -> AuthorizedStatus {
        
        let status = SFSpeechRecognizer.authorizationStatus()
        switch status {
        case .authorized:
            return .authorized
        case .restricted, .denied:
            return .unAuthorized
        case .notDetermined:
            return .notDetermined
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
    
    // MARK: - Siri
    private func siriAuthorizedStatus() -> AuthorizedStatus {
        
        guard  #available(iOS 10.0, *) else {
            return .disabled
        }
        
        let status = INPreferences.siriAuthorizationStatus()
        switch status {
        case .authorized:
            return .authorized
        case .restricted, .denied:
            return .unAuthorized
        case .notDetermined:
            return .notDetermined
        }
    }
    
    private func requestSiriPermission(_ completion: @escaping PermissionCompletion) {
        guard #available(iOS 10.0, *) else {
            completion(false)
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
    
    @available(iOS 10.0, *)
    private func requestNotificationPermission(_ completion: @escaping PermissionCompletion) {
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            if setting.authorizationStatus == .notDetermined {
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound], completionHandler: { granted, _ in
                    self.safeAync {
                        completion(granted)
                    }
                })
            } else {
                self.safeAync {
                    
                }
            }
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
