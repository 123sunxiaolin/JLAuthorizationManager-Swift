//
//  EventsPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import EventKit

class EventsPermission: BasePermission {
    
    override init() {
        super.init()
    }
}

// MARK: - Permission
extension EventsPermission: Permission {
    var type: PermissionType {
        return .events
    }
    
    func authorizedStatus() -> AuthorizedStatus {
        
        let status = EKEventStore.authorizationStatus(for: .event)
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
        let hasEventsKey: Bool = !Bundle.main.object(forInfoDictionaryKey: Constants.InfoPlistKeys.events).isNil
        assert(hasEventsKey, Constants.InfoPlistKeys.contact + " not found in Info.plist.")
        
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            EKEventStore().requestAccess(to: .event) { (granted, _) in
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
