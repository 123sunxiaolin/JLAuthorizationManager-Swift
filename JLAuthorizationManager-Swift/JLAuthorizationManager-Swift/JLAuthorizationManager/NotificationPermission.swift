//
//  NotificationPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import UIKit

class NotificationPermission: BasePermission {

    override init() {
        super.init()
    }
}

// MARK: - Permission
extension NotificationPermission: Permission {
    var type: PermissionType {
        return .notification
    }
    
    func authorizedStatus() -> AuthorizedStatus {
        
        return .notDetermined
    }
    
    func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        
    }
    
    
}

