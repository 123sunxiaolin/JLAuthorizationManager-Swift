//
//  BluetoothPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/14.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import CoreBluetooth

// please use singleton: `shared`
class BluetoothPermission: BasePermission {
    
    static let shared = BluetoothPermission()
    
    private var completion: AuthorizedCompletion?
    
    private lazy var centerManager: CBCentralManager = {
        return CBCentralManager(delegate: self, queue: nil)
    }()
    
    private override init() {
        super.init()
    }
}

// MARK: - Permission
extension BluetoothPermission: Permission {
    var type: PermissionType {
        return .bluetooth
    }
    
    func authorizedStatus() -> AuthorizedStatus {
        guard #available(iOS 10.0, *) else {
            return .disabled
        }
        
        switch self.centerManager.state {
        case .poweredOff, .unsupported:
            return .disabled
        case .unauthorized:
            return .unAuthorized
        case .unknown, .resetting:
            return .notDetermined
        case .poweredOn:
            return .authorized
        }
    }
    
    func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        
        self.completion = completion
        let status = authorizedStatus()
        completion(status == .authorized)
    }

}

// MARK: - CBCentralManagerDelegate
extension BluetoothPermission: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if let completion = self.completion {
            completion(central.state == .poweredOn)
        }
    }
}
