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

enum PermissionType {
    case camera
    case photoLibrary
    case microphone
    case contact
    case calendar
    case locationInUse
    case locationInAlways
    
}

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
        case .calendar:
            requestCalendarPermission(completion)
        case .locationInUse:
            requestLocationInUserPermission(completion)
        case .locationInAlways:
            requestLocationAlwaysPermission(completion)
            
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
    
    private func requestCalendarPermission(_ completion: @escaping PermissionCompletion) {
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
