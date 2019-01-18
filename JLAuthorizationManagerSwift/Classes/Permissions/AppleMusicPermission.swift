//
//  AppleMusicPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import MediaPlayer

public class AppleMusicPermission: BasePermission {

    public override init() {
        super.init()
    }
}

// MARK: - Permission
extension AppleMusicPermission: Permission {
    public var type: PermissionType {
        return .appleMusic
    }
    
    public func authorizedStatus() -> AuthorizedStatus {
        
        if #available(iOS 9.3, *) {
            let status = MPMediaLibrary.authorizationStatus()
            switch status {
            case .authorized:
                return .authorized
            case .restricted, .denied:
                return .unAuthorized
            case .notDetermined:
                return .notDetermined
            }
            
        } else {
            return .disabled
        }
    }
    
    public func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        let hasAppleMusicKey: Bool = !Bundle.main.object(forInfoDictionaryKey: Constants.InfoPlistKeys.appleMusic).isNil
        assert(hasAppleMusicKey, Constants.InfoPlistKeys.appleMusic + " not found in Info.plist.")
        
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            if #available(iOS 9.3, *) {
                MPMediaLibrary.requestAuthorization { aStatus in
                    self.safeAync {
                        completion(aStatus == .authorized)
                    }
                }
            } else {
                completion(false)
            }
            
        default:
            completion(status == .authorized)
        }
    }
}
