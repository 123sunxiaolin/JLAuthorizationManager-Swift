//
//  HealthPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import HealthKit

class HealthPermission: BasePermission {
    
    private lazy var healthStore: HKHealthStore = HKHealthStore()
    
    private var typesToShare: Set<HKSampleType> = []
    private var typesToRead: Set<HKObjectType> = []

    /// init permission object with options
    ///
    /// - Parameters:
    ///   - typesToShare: need to share set
    ///   - typesToRead: need to read set
    init(_ typesToShare: Set<HKSampleType>, typesToRead: Set<HKObjectType>) {
        self.typesToShare = typesToShare
        self.typesToRead = typesToRead
        super.init()
    }
}

// MARK: - Permission
extension HealthPermission: Permission {
    var type: PermissionType {
        return .health
    }
    
    func authorizedStatus() -> AuthorizedStatus {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            return .disabled
        }
        
        var statusForHealth: [HKAuthorizationStatus] = []
        if typesToShare.count > 0 {
            for oneShare in typesToShare {
                let shareStatus = healthStore.authorizationStatus(for: oneShare)
                statusForHealth.append(shareStatus)
            }
        }
        
        if typesToRead.count > 0 {
            for oneRead in typesToRead {
                let readStatus = healthStore.authorizationStatus(for: oneRead)
                statusForHealth.append(readStatus)
            }
        }
        // priority: notDetermined > unAuthorized > authorized
        if statusForHealth.count > 0 {
            if statusForHealth.contains(.notDetermined) {
                return .notDetermined
            } else if statusForHealth.contains(.sharingDenied) {
                return .unAuthorized
            } else {
                return .authorized
            }
            
        } else {
            return .disabled
        }
    }
    
    func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            healthStore.requestAuthorization(toShare: self.typesToShare, read: self.typesToRead) { granted, _ in
                self.safeAync {
                    completion(granted)
                }
            }
        default:
            completion(status == .authorized)
        }
    }
}
