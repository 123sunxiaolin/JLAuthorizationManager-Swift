//
//  BasePermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation

public protocol Permission where Self: BasePermission {
    
    /// Permission type
    var type: PermissionType { get }
    
    /// Current authorized status
    func authorizedStatus() -> AuthorizedStatus
    
    /// Request current permission
    func requestPermission(_ completion: @escaping AuthorizedCompletion)
    
}

public typealias AuthorizedCompletion = (Bool?) -> Void

class BasePermission: NSObject {
    
}

// MARK: - safeThread
extension BasePermission {
    
    public func safeAync(_ block: @escaping () -> Void) {
        
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
