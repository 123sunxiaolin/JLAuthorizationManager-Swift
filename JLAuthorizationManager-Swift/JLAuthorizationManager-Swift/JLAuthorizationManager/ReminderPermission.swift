//
//  ReminderPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import EventKit

class ReminderPermission: BasePermission {
    
    override init() {
        super.init()
    }
}

// MARK: - Permission
extension ReminderPermission: Permission {
    var type: PermissionType {
        return .reminder
    }
    
    func authorizedStatus() -> AuthorizedStatus {
        
        let status = EKEventStore.authorizationStatus(for: .reminder)
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
            EKEventStore().requestAccess(to: .reminder) { (granted, _) in
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
