//
//  SiriPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import UIKit
import Intents

class SiriPermission: BasePermission {

    override init() {
        super.init()
    }
}

// MARK: - Permission
extension SiriPermission: Permission {
    var type: PermissionType {
        return .siri
    }
    
    func authorizedStatus() -> AuthorizedStatus {
        
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
    
    func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        
        guard #available(iOS 10.0, *) else {
            assert(false, "unsupport for this API!")
            return
        }
        
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            INPreferences.requestSiriAuthorization { aStatus in
                self.safeAync {
                    completion(aStatus == .authorized)
                }
            }
        default:
            completion(status == .authorized)
        }
    }
}
