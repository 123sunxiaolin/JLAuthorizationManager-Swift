//
//  MotionPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import CoreMotion

// please use singleton: `shared`
public class MotionPermission: BasePermission {

    public static let shared = MotionPermission()
    private var completion: AuthorizedCompletion?
    
    private lazy var defaults: UserDefaults = {
        return .standard
    }()
    
    private lazy var motionManager:CMMotionActivityManager = {
        return CMMotionActivityManager()
    }()
    
    /// wheather request motion before or not
    private var isRequestedMotion: Bool {
        get {
            return defaults.bool(forKey: Constants.UserDefaultsKeys.requestedMotion)
        }
        
        set {
            defaults.set(isRequestedMotion, forKey: Constants.UserDefaultsKeys.requestedMotion)
            defaults.synchronize()
        }
    }
    
    /// Default status for Core Motion Activity
    private var motionPermissionStatus: AuthorizedStatus = .notDetermined
    
    private override init() {
        super.init()
    }
}

// MARK: - Permission
extension MotionPermission: Permission {
    public var type: PermissionType {
        return .motion
    }
    
    public func authorizedStatus() -> AuthorizedStatus {
        guard CMMotionActivityManager.isActivityAvailable() else {
            return .disabled
        }
        
        if #available(iOS 11.0, *) {
            let status = CMMotionActivityManager.authorizationStatus()
            switch status {
            case .authorized:
                return .authorized
            case .restricted, .denied:
                return .unAuthorized
            case .notDetermined:
                return .notDetermined
            }
        } else {
            if isRequestedMotion {
                startUpdateMotionStatus()
            }
            
            return motionPermissionStatus
        }
        
    }
    
    public func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            self.completion = completion
            startUpdateMotionStatus()
        default:
            completion(status == .authorized)
        }
    }
}

// MARK: - Private
extension MotionPermission {
    private func startUpdateMotionStatus() {
        
        let tmpMotionPermissionStatus = motionPermissionStatus
        requestMotion { [weak self] status in
            
            self?.motionPermissionStatus = status
            if tmpMotionPermissionStatus != self?.motionPermissionStatus {
                if let completion = self?.completion {
                    completion(self?.motionPermissionStatus == .authorized)
                }
            }
        }
        
        isRequestedMotion = true
    }
    
    private func requestMotion(_ completion: @escaping (AuthorizedStatus) -> Void) {
        let hasAppleMusicKey: Bool = !Bundle.main.object(forInfoDictionaryKey: Constants.InfoPlistKeys.motion).isNil
        assert(hasAppleMusicKey, Constants.InfoPlistKeys.motion + " not found in Info.plist.")
        
        let today = Date()
        motionManager.queryActivityStarting(from: today, to: today, to: .main) { [weak self] (_, error) in
            
            self?.motionManager.stopActivityUpdates()
            
            var status: AuthorizedStatus
            
            if let err = error {
                if err._code == CMErrorMotionActivityNotAuthorized.rawValue {
                    status = .unAuthorized
                } else if err._code == CMErrorMotionActivityNotAvailable.rawValue {
                    status = .disabled
                } else {
                    status = .authorized
                }
            } else {
                status = .authorized
            }
            
            self?.safeAync {
                completion(status)
            }
        }
    }
}
