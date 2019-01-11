//
//  CellularNetworkPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import CoreTelephony

class CellularNetworkPermission: BasePermission {
    override init() {
        super.init()
    }
}

// MARK: - Permission
extension CellularNetworkPermission: Permission {
    var type: PermissionType {
        return .cellularNetwork
    }
    
    func authorizedStatus() -> AuthorizedStatus {
        
        let status = CTCellularData().restrictedState
        switch status {
        case .notRestricted:
            return .authorized
        case .restricted:
            return .unAuthorized
        case .restrictedStateUnknown:
            return .notDetermined
        }
    }
    
    func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            CTCellularData().cellularDataRestrictionDidUpdateNotifier = { state in
                self.safeAync {
                    completion(state == .notRestricted)
                }
            }
        default:
            completion(status == .authorized)
        }
    }
}
