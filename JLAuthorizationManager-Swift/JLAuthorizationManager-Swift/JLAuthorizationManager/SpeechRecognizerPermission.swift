//
//  SpeechRecognizerPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import UIKit
import Speech

class SpeechRecognizerPermission: BasePermission {

    override init() {
        super.init()
    }
}

// MARK: - Permission
extension SpeechRecognizerPermission: Permission {
    var type: PermissionType {
        return .appleMusic
    }
    
    func authorizedStatus() -> AuthorizedStatus {
        
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
    
    func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            SFSpeechRecognizer.requestAuthorization { aStatus in
                self.safeAync {
                    completion(status == .authorized)
                }
            }
        default:
            completion(status == .authorized)
        }
    }
}
