//
//  BluetoothPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import CoreBluetooth

// please use singleton: `shared`
public class BluetoothPeripheralPermission: BasePermission {
    
    public static let shared = BluetoothPeripheralPermission()
    private var completion: AuthorizedCompletion?
    
    private lazy var defaults: UserDefaults = {
        return .standard
    }()
    
    private lazy var bluetoothManager: CBPeripheralManager = {
        return CBPeripheralManager(delegate: self, queue: nil, options:[CBPeripheralManagerOptionShowPowerAlertKey: false])
    }()
    
    /// wheather request bluetooth before or not
    private var isRequestedBluetooth: Bool {
        get {
            return defaults.bool(forKey: Constants.UserDefaultsKeys.requestedBluetooth)
        }
        
        set {
            defaults.set(isRequestedBluetooth, forKey: Constants.UserDefaultsKeys.requestedBluetooth)
            defaults.synchronize()
        }
    }

    /// wheather wait for user to enable or disable bluetooth access or not
    private var waitingForBluetooth: Bool = false
    
    private override init() {
        super.init()
    }
}

// MARK: - Permission
extension BluetoothPeripheralPermission: Permission {
    public var type: PermissionType {
        return .peripheralBluetooth
    }
    
    public func authorizedStatus() -> AuthorizedStatus {
        
        guard !isRequestedBluetooth else {
            return .notDetermined
        }
        
        // start requesting ...
        startUpdateBluetoothStatus()
        
        let state = (bluetoothManager.state, CBPeripheralManager.authorizationStatus())
        switch state {
        case (.unsupported, _), (.poweredOff, _):
            return .disabled
        case (.unauthorized, _), (_, .denied), (_, .restricted):
            return .unAuthorized
        case (.poweredOn, .authorized):
            return .authorized
        default:
            return .notDetermined
        }
    }
    
    public func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        
        guard bluetoothManager.state == .poweredOn else {
            completion(false)
            return
        }
        
        self.completion = completion
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            startUpdateBluetoothStatus()
        default:
            completion(status == .authorized)
        }
    }
}

// MARK: - Private
extension BluetoothPeripheralPermission {
    
    /// depend on user operation, start request bluetooth or not
    private func startUpdateBluetoothStatus() {
        guard !waitingForBluetooth
            && bluetoothManager.state == .unknown else {
            return
        }
        
        bluetoothManager.startAdvertising(nil)
        bluetoothManager.stopAdvertising()
        waitingForBluetooth = true
        isRequestedBluetooth = true
    }
}

// MARK: - CBPeripheralManagerDelegate
extension BluetoothPeripheralPermission: CBPeripheralManagerDelegate {
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        waitingForBluetooth = false
        if let completion = self.completion {
            completion(CBPeripheralManager.authorizationStatus() == .authorized)
        }
    }
}
