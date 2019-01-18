//
//  MicrophonePermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import AVFoundation

public class MicrophonePermission: BasePermission {
    
    public override init() {
        super.init()
    }
}

// MARK: - Permission
extension MicrophonePermission: Permission {
    public var type: PermissionType {
        return .microphone
    }
    
    public func authorizedStatus() -> AuthorizedStatus {
        let status = AVAudioSession.sharedInstance().recordPermission
        switch status {
        case .granted:
            return .authorized
        case .denied:
            return .unAuthorized
        case .undetermined:
            return .notDetermined
        }
    }
    
    public func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        let hasMocrophoneKey: Bool = !Bundle.main.object(forInfoDictionaryKey: Constants.InfoPlistKeys.microphone).isNil
        assert(hasMocrophoneKey, Constants.InfoPlistKeys.microphone + " not found in Info.plist.")
        
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
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

