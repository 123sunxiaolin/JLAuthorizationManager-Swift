//
//  PhotosPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import Photos

class PhotosPermission: BasePermission {
    
    override init() {
        super.init()
    }
}

// MARK: - Permission
extension PhotosPermission: Permission {
    var type: PermissionType {
        return .photoLibrary
    }
    
    func authorizedStatus() -> AuthorizedStatus {
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
    
    func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                self.safeAync {
                    completion(status == .authorized)
                }
            }
        case .authorized:
            completion(true)
        default:
            completion(false)
        }
    }
    
}
