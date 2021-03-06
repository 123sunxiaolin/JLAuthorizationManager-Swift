//
//  AudioPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import AVFoundation

public class AudioPermission: BasePermission {
    
    public override init() {
        super.init()
    }
}

// MARK: - Permission
extension AudioPermission: Permission {
    public var type: PermissionType {
        return .audio
    }
    
    public func authorizedStatus() -> AuthorizedStatus {
        
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
    
    public func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        let hasCameraKey: Bool = !Bundle.main.object(forInfoDictionaryKey: Constants.InfoPlistKeys.microphone).isNil
        assert(hasCameraKey, Constants.InfoPlistKeys.microphone + " not found in Info.plist.")
        
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { granted in
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
