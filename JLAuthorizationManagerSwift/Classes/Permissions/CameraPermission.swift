//
//  CameraPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import AVFoundation

public class CameraPermission: BasePermission {
    
    public override init() {
        super.init()
    }
}

// MARK: - Permission
extension CameraPermission: Permission {
    public var type: PermissionType {
        return .camera
    }
    
    public func authorizedStatus() -> AuthorizedStatus {
        
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
    
    public func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        let hasCameraKey: Bool = !Bundle.main.object(forInfoDictionaryKey: Constants.InfoPlistKeys.camera).isNil
        assert(hasCameraKey, Constants.InfoPlistKeys.locationWhenInUse + " not found in Info.plist.")
        
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                self.safeAync {
                    completion(granted)
                }
            }
        case .authorized:
            completion(true)
        default:
            completion(false)
        }
    }
}
