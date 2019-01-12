//
//  AppleMusicPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import MediaPlayer

class AppleMusicPermission: BasePermission {

    override init() {
        super.init()
    }
}

// MARK: - Permission
extension AppleMusicPermission: Permission {
    var type: PermissionType {
        return .appleMusic
    }
    
    func authorizedStatus() -> AuthorizedStatus {
        
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
    
    func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        let hasAppleMusicKey: Bool = !Bundle.main.object(forInfoDictionaryKey: Constants.InfoPlistKeys.appleMusic).isNil
        assert(hasAppleMusicKey, Constants.InfoPlistKeys.appleMusic + " not found in Info.plist.")
        
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            MPMediaLibrary.requestAuthorization { aStatus in
                self.safeAync {
                    completion(aStatus == .authorized)
                }
            }
        default:
            completion(status == .authorized)
        }
    }
}
