//
//  ReminderPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import EventKit

public class ReminderPermission: BasePermission {
    
    public override init() {
        super.init()
    }
}

// MARK: - Permission
extension ReminderPermission: Permission {
    public var type: PermissionType {
        return .reminder
    }
    
    public func authorizedStatus() -> AuthorizedStatus {
        
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
    
    public func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        let hasReminderKey: Bool = !Bundle.main.object(forInfoDictionaryKey: Constants.InfoPlistKeys.reminder).isNil
        assert(hasReminderKey, Constants.InfoPlistKeys.reminder + " not found in Info.plist.")
        
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
